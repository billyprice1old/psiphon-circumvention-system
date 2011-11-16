import socket
import struct
import urllib2
import zipfile
import os, os.path
import StringIO 
import csv


GEO_DATA_ROOT = os.path.join(os.path.abspath('..'), 'Data', 'GeoData')
GEO_ZIP_FILENAME = 'maxmind_data.zip'
GEO_ZIP_PATH = os.path.join(GEO_DATA_ROOT, GEO_ZIP_FILENAME)
GEO_ROUTES_ROOT = os.path.join(GEO_DATA_ROOT, 'Routes')

def recache_geodata(url):
    # getting the file age
    last_modified_file =  '%s.%s' % (GEO_ZIP_PATH, 'last_modified')
    if os.path.exists(last_modified_file) and os.path.exists(GEO_ZIP_PATH):
        with open(last_modified_file) as f:
            current_last_modified = f.read().strip()
        headers = {'If-Modified-Since': current_last_modified}
    else:
        headers = {}
        current_last_modified = None

    request = urllib2.Request(url, headers=headers)

    # checking for new version of the data
    try:
        url = urllib2.urlopen(request, timeout=5)
        last_modified = url.headers.get('Last-Modified')
    except urllib2.HTTPError, e:
        if e.getcode() != 304:
            raise Exception('HTTP error %i requesting geodata file' % e.getcode())
        # Not-Modified 304 returned
        last_modified = current_last_modified
    except urllib2.URLError:
        raise Exception('URLError')
        # timeout error
        last_modified = None

    if last_modified is not None and current_last_modified != last_modified:
        # we need to download new version
        print("Geodata file has been modified since last fetch. Fetching new")
        content = url.read()
        with open(GEO_ZIP_PATH, 'wb') as f:
            f.write(content)

        with open(last_modified_file, 'w') as f:
            f.write(last_modified)
    else:
        print("The geodata file is not modified, using cached version")

def consume_line(start_ip, end_ip, country_code):
    start = ip2int(start_ip)
    end = ip2int(end_ip)

    #check if all values are valid
    if not start or not end or len(country_code) != 2:
        return False

    base = start
    step = 0
    while base <= end:
        step =0
        while base | (1 << step) != base:
            if (base | (((~0) & 0xffffffff) >> (31-step))) > end:
                break
            step += 1

        # In case CIDR is needed 
        #cidr = 32 - step
        bitmask = 0xffffffff ^ (1 << step) - 1
        filename = os.path.join(GEO_ROUTES_ROOT, '%s.route' % country_code)
        with open(filename, 'a') as f:
            f.write( "%s\t%s\n" % (int2ip(base), int2ip(bitmask)))
        base += 1 << step

def ip2int(ip):
    try:
        val = socket.inet_aton(ip) 
    except socket.error:
        return False
    return struct.unpack('!I', val)[0]

def int2ip(ip):
    val = struct.pack('!I', ip)
    try:
        return socket.inet_ntoa(val)
    except socket.error:
        return False



def make_routes():
    # create the directories
    if not os.path.exists(GEO_DATA_ROOT):
        os.makedirs(GEO_DATA_ROOT)
    if not os.path.exists(GEO_ROUTES_ROOT):
        os.makedirs(GEO_ROUTES_ROOT)

    # TODO: get url from psi_db
    url='http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip'
    recache_geodata(url)

    if not os.path.exists(GEO_ZIP_PATH):
        raise Exception('Geodata file does not exist')

    fh=open(GEO_ZIP_PATH, 'rb')
    zf = zipfile.ZipFile(fh)
    names=zf.namelist()
    for name in names:
        _, fileExtension = os.path.splitext(name)
        if fileExtension == '.csv':
            print "CSV found: %s" % name
            break
    
    if not name:
        raise Exception('CSV not found in the %s' % GEO_ZIP_PATH)

    data = StringIO.StringIO(zf.read(name))
    if not data:
        raise Exception('Can not read from the %s' % GEO_ZIP_PATH)
    
    #delete current routing files
    for root, dirs, files in os.walk(GEO_ROUTES_ROOT):
        for name in files:
            os.remove(os.path.join(root, name))

    myreader = csv.reader(data, delimiter=',', quotechar='"')
    for row in myreader:
        if len(row) == 6:
            ip1 = row[0]
            ip2 = row[1]
            country_code = row[4]
            consume_line(ip1, ip2, country_code)

if __name__ == "__main__":
    make_routes()


