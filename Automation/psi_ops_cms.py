#!/usr/bin/python
#
# Copyright (c) 2011, Psiphon Inc.
# All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import os
import sys
import subprocess
import shlex
import tempfile
import jsonpickle


if os.path.isfile('psi_data_config.py'):
    import psi_data_config
    sys.path.insert(0, psi_data_config.DATA_ROOT)
    import psi_ops_config


def unlock_document():
    cmd = 'CipherShareScriptingClient.exe \
            UnlockDocument \
            -UserName %s -Password %s \
            -OfficeName %s -DatabasePath "%s" -ServerHost %s -ServerPort %s \
            -Document "%s"' \
         % (psi_ops_config.CIPHERSHARE_USERNAME,
            psi_ops_config.CIPHERSHARE_PASSWORD,
            psi_ops_config.CIPHERSHARE_OFFICENAME,
            psi_ops_config.CIPHERSHARE_DATABASEPATH,
            psi_ops_config.CIPHERSHARE_SERVERHOST,
            psi_ops_config.CIPHERSHARE_SERVERPORT,
            psi_ops_config.CIPHERSHARE_PSI_OPS_DOCUMENT_PATH)
    
    proc = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = proc.communicate()
    
    if proc.returncode != 0:
        raise Exception('CipherShare unlock failed: ' + str(output))


def lock_document():
    cmd = 'CipherShareScriptingClient.exe \
            LockDocument \
            -UserName %s -Password %s \
            -OfficeName %s -DatabasePath "%s" -ServerHost %s -ServerPort %s \
            -Document "%s"' \
         % (psi_ops_config.CIPHERSHARE_USERNAME,
            psi_ops_config.CIPHERSHARE_PASSWORD,
            psi_ops_config.CIPHERSHARE_OFFICENAME,
            psi_ops_config.CIPHERSHARE_DATABASEPATH,
            psi_ops_config.CIPHERSHARE_SERVERHOST,
            psi_ops_config.CIPHERSHARE_SERVERPORT,
            psi_ops_config.CIPHERSHARE_PSI_OPS_DOCUMENT_PATH)
    
    proc = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = proc.communicate()
    
    if proc.returncode != 0:
        raise Exception('CipherShare lock failed: ' + str(output))


def export_document(dest_filename):
    cmd = 'CipherShareScriptingClient.exe \
            ExportDocument \
            -UserName %s -Password %s \
            -OfficeName %s -DatabasePath "%s" -ServerHost %s -ServerPort %s \
            -SourceDocument "%s" \
            -TargetFile "%s"' \
         % (psi_ops_config.CIPHERSHARE_USERNAME,
            psi_ops_config.CIPHERSHARE_PASSWORD,
            psi_ops_config.CIPHERSHARE_OFFICENAME,
            psi_ops_config.CIPHERSHARE_DATABASEPATH,
            psi_ops_config.CIPHERSHARE_SERVERHOST,
            psi_ops_config.CIPHERSHARE_SERVERPORT,
            psi_ops_config.CIPHERSHARE_PSI_OPS_DOCUMENT_PATH,
            dest_filename)
    
    proc = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = proc.communicate()
    
    if proc.returncode != 0:
        raise Exception('CipherShare export failed: ' + str(output))


def import_document(source_filename):
    cmd = 'CipherShareScriptingClient.exe \
            ImportDocument \
            -UserName %s -Password %s \
            -OfficeName %s -DatabasePath "%s" -ServerHost %s -ServerPort %s \
            -SourceFile "%s" \
            -TargetDocument "%s" \
            -ShareGroup "%s" \
            -Description "%s" \
            -AddVersionIfExists \
            -KeepLocked \
            -IgnoreKeyTrust' \
         % (psi_ops_config.CIPHERSHARE_USERNAME,
            psi_ops_config.CIPHERSHARE_PASSWORD,
            psi_ops_config.CIPHERSHARE_OFFICENAME,
            psi_ops_config.CIPHERSHARE_DATABASEPATH,
            psi_ops_config.CIPHERSHARE_SERVERHOST,
            psi_ops_config.CIPHERSHARE_SERVERPORT,
            source_filename,
            psi_ops_config.CIPHERSHARE_PSI_OPS_DOCUMENT_PATH,
            psi_ops_config.CIPHERSHARE_SHAREGROUP,
            psi_ops_config.CIPHERSHARE_PSI_OPS_DOCUMENT_DESCRIPTION)
    
    proc = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = proc.communicate()
    
    if proc.returncode != 0:
        raise Exception('CipherShare import failed: ' + str(output))


# Adapted from:
# http://code.activestate.com/recipes/521901-upgradable-pickles/

class PersistentObject(object):

    class_version = '0.0'

    def __init__(self):
        self.version = self.__class__.class_version
        self.is_locked = False

    def release(self):
        if self.is_locked:
            unlock_document()
            self.is_locked = False

    def save(self):
        with tempfile.NamedTemporaryFile(delete=False) as file:
            file.write(jsonpickle.encode(self))
        import_document(file.name)
        os.remove(file.name)

    @staticmethod
    def load_from_file(filename):
        with open(filename) as file:
            obj = jsonpickle.decode(file.read())
            if not hasattr(obj, 'version'):
                obj.version = '0.0'
            if obj.version != obj.class_version:
                obj.upgrade()
        return obj

    @staticmethod
    def load():
        obj = None
        file = tempfile.NamedTemporaryFile(delete=False)
        file.close()
        lock_document()
        export_document(file.name)
        obj = PersistentObject.load_from_file(file.name)
        os.remove(file.name)
        obj.is_locked = True
        return obj

    def upgrade(self):
        pass 
