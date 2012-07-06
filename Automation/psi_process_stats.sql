-- Table: processed_logs

-- DROP TABLE processed_logs;

CREATE TABLE processed_logs
(
  host_id text,
  last_timestamp text,
  CONSTRAINT processed_logs_pkey PRIMARY KEY (host_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE processed_logs OWNER TO postgres;
GRANT ALL ON TABLE processed_logs TO postgres;
GRANT ALL ON TABLE processed_logs TO psiphon3;

-- Table: connected

-- DROP TABLE connected;

CREATE TABLE connected
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  session_id text,
  processed integer NOT NULL DEFAULT 0,
  id bigserial NOT NULL,
  CONSTRAINT connected_pkey PRIMARY KEY (id),
  CONSTRAINT connected_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol, session_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE connected OWNER TO postgres;
GRANT ALL ON TABLE connected TO postgres;
GRANT ALL ON TABLE connected TO psiphon3;

-- Table: disconnected

-- DROP TABLE disconnected;

CREATE TABLE disconnected
(
  "timestamp" timestamp with time zone,
  host_id text,
  relay_protocol text,
  session_id text,
  processed integer NOT NULL DEFAULT 0,
  id bigserial NOT NULL,
  CONSTRAINT disconnected_pkey PRIMARY KEY (id),
  CONSTRAINT disconnected_unique UNIQUE ("timestamp", host_id, relay_protocol, session_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE disconnected OWNER TO postgres;
GRANT ALL ON TABLE disconnected TO postgres;
GRANT ALL ON TABLE disconnected TO psiphon3;

-- Table: discovery

-- DROP TABLE discovery;

CREATE TABLE discovery
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  discovery_server_id text,
  client_unknown text,
  id bigserial NOT NULL,
  CONSTRAINT discovery_pkey PRIMARY KEY (id),
  CONSTRAINT discovery_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol, discovery_server_id, client_unknown)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE discovery OWNER TO postgres;
GRANT ALL ON TABLE discovery TO postgres;
GRANT ALL ON TABLE discovery TO psiphon3;

-- Table: download

-- DROP TABLE download;

CREATE TABLE download
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  id bigserial NOT NULL,
  CONSTRAINT download_pkey PRIMARY KEY (id),
  CONSTRAINT download_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE download OWNER TO postgres;
GRANT ALL ON TABLE download TO postgres;
GRANT ALL ON TABLE download TO psiphon3;

-- Table: failed

-- DROP TABLE failed;

CREATE TABLE failed
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  error_code text,
  id bigserial NOT NULL,
  CONSTRAINT failed_pkey PRIMARY KEY (id),
  CONSTRAINT failed_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol, error_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE failed OWNER TO postgres;
GRANT ALL ON TABLE failed TO postgres;
GRANT ALL ON TABLE failed TO psiphon3;

-- Table: handshake

-- DROP TABLE handshake;

CREATE TABLE handshake
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  id bigserial NOT NULL,
  CONSTRAINT handshake_pkey PRIMARY KEY (id),
  CONSTRAINT handshake_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE handshake OWNER TO postgres;
GRANT ALL ON TABLE handshake TO postgres;
GRANT ALL ON TABLE handshake TO psiphon3;

-- Table: started

-- DROP TABLE started;

CREATE TABLE started
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  id bigserial NOT NULL,
  CONSTRAINT started_pkey PRIMARY KEY (id),
  CONSTRAINT started_unique UNIQUE ("timestamp", host_id, server_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE started OWNER TO postgres;
GRANT ALL ON TABLE started TO postgres;
GRANT ALL ON TABLE started TO psiphon3;

-- Table: status

-- DROP TABLE status;

CREATE TABLE status
(
  "timestamp" timestamp with time zone,
  host_id text,
  relay_protocol text,
  session_id text,
  processed integer NOT NULL DEFAULT 0,
  id bigserial NOT NULL,
  CONSTRAINT status_pkey PRIMARY KEY (id),
  CONSTRAINT status_unique UNIQUE ("timestamp", host_id, relay_protocol, session_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE status OWNER TO postgres;
GRANT ALL ON TABLE status TO postgres;
GRANT ALL ON TABLE status TO psiphon3;

-- Table: bytes_transferred

-- DROP TABLE bytes_transferred;

CREATE TABLE bytes_transferred
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  bytes integer NOT NULL,
  id bigserial NOT NULL,
  CONSTRAINT bytes_transferred_pkey PRIMARY KEY (id),
  CONSTRAINT bytes_transferred_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol, bytes)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bytes_transferred OWNER TO postgres;
GRANT ALL ON TABLE bytes_transferred TO postgres;
GRANT ALL ON TABLE bytes_transferred TO psiphon3;

-- Table: page_views

-- DROP TABLE page_views;

CREATE TABLE page_views
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  pagename text,
  viewcount integer NOT NULL,
  id bigserial NOT NULL,
  CONSTRAINT page_views_pkey PRIMARY KEY (id),
  CONSTRAINT page_views_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol, pagename, viewcount)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE page_views OWNER TO postgres;
GRANT ALL ON TABLE page_views TO postgres;
GRANT ALL ON TABLE page_views TO psiphon3;

-- Table: https_requests

-- DROP TABLE https_requests;

CREATE TABLE https_requests
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  "domain" text,
  count integer NOT NULL,
  id bigserial NOT NULL,
  CONSTRAINT https_requests_pkey PRIMARY KEY (id),
  CONSTRAINT https_requests_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol, "domain", count)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE https_requests OWNER TO postgres;
GRANT ALL ON TABLE https_requests TO postgres;
GRANT ALL ON TABLE https_requests TO psiphon3;

-- Table: speed

-- DROP TABLE speed;

CREATE TABLE speed
(
  "timestamp" timestamp with time zone,
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  "operation" text,
  info text,
  milliseconds integer,
  "size" integer,
  id bigserial NOT NULL,
  CONSTRAINT speed_pkey PRIMARY KEY (id),
  CONSTRAINT speed_unique UNIQUE ("timestamp", host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol, "operation", info, milliseconds, "size")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE speed OWNER TO postgres;
GRANT ALL ON TABLE speed TO postgres;
GRANT ALL ON TABLE speed TO psiphon3;

-- Table: "session"

-- DROP TABLE "session";

CREATE TABLE "session"
(
  host_id text,
  server_id text,
  client_region text,
  propagation_channel_id text,
  sponsor_id text,
  client_version text,
  client_platform text,
  relay_protocol text,
  session_id text,
  session_start_timestamp timestamp with time zone,
  session_end_timestamp timestamp with time zone,
  id bigserial NOT NULL,
  connected_id bigint NOT NULL,
  CONSTRAINT session_pkey PRIMARY KEY (id),
  CONSTRAINT connected_id FOREIGN KEY (connected_id)
      REFERENCES connected (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT session_host_id_key UNIQUE (host_id, server_id, client_region, propagation_channel_id, sponsor_id, client_version, client_platform, relay_protocol, session_id, session_start_timestamp, session_end_timestamp)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "session" OWNER TO postgres;
GRANT ALL ON TABLE "session" TO postgres;
GRANT ALL ON TABLE "session" TO psiphon3;

-- Session reconstruction

CREATE INDEX connected_unprocessed_index ON connected (processed) WHERE processed = 0;

CREATE INDEX disconnected_session_reconstruction_index
  ON disconnected
  (processed, session_id, relay_protocol, host_id, "timestamp");    

CREATE INDEX status_session_reconstruction_index
  ON status
  (processed, session_id, relay_protocol, host_id, "timestamp")

-- Finds the /disconnected record that matches the given /connected record.
-- Returns NULL (empty record) if not found.
-- Has the side effect of marking earlier matching /disconnected records as processed.
-- (But not the record being returned.) This is because they will never be 
-- returned from this function, so it's faster to completely exclude them.
CREATE OR REPLACE FUNCTION findMatchingDisconnect(connected_record connected) 
RETURNS disconnected AS $$
DECLARE
  result disconnected%ROWTYPE;
BEGIN

  -- Select the *nearest* matching disconnected entry (youngest that's older).
  SELECT * INTO result 
    FROM disconnected 
    WHERE processed = 0
      AND session_id = connected_record.session_id 
      AND relay_protocol = connected_record.relay_protocol
      AND host_id = connected_record.host_id
      -- And it has the closest following timestamp to the given connected record
      AND timestamp > connected_record.timestamp
    ORDER BY timestamp ASC
    LIMIT 1;

  -- Did we find a match?
  IF result IS NOT NULL THEN
    -- Mark any earlier matching /disconnected records as processed, since 
    -- they'll never be used again.
    UPDATE disconnected 
      SET processed = 1
      WHERE processed = 0
        AND session_id = result.session_id 
        AND relay_protocol = result.relay_protocol
        AND host_id = result.host_id
        -- Strictly-less-than means it won't match result.
        AND timestamp < result.timestamp;

    -- Also mark any matching /status records as processed, since they'll never
    -- be used either.
    UPDATE status 
      SET processed = 1
      WHERE processed = 0
        AND session_id = result.session_id 
        AND relay_protocol = result.relay_protocol
        AND host_id = result.host_id
        AND timestamp <= result.timestamp;

    RETURN result;
  END IF;

  RETURN NULL;

END;
$$ LANGUAGE plpgsql;

-- Finds the latest /status record that matches the given /connected record.
-- Returns NULL (empty record) if not found.
-- Has the side effect of marking earlier matching /status records as processed.
-- (But not the record being returned.) This is because they will never be 
-- returned from this function, so it's faster to completely exclude them.
CREATE OR REPLACE FUNCTION findMatchingStatus(connected_record connected) 
RETURNS status AS $$
DECLARE
  result status%ROWTYPE;
BEGIN

  -- Select the *oldest* matching status entry.
  SELECT * INTO result 
    FROM status 
    WHERE processed = 0
      AND session_id = connected_record.session_id 
      AND relay_protocol = connected_record.relay_protocol
      AND host_id = connected_record.host_id
      -- And it has the closest following timestamp to the given connected record
      AND timestamp > connected_record.timestamp
    ORDER BY timestamp DESC
    LIMIT 1;

  -- Did we find a match?
  IF result IS NOT NULL THEN
    -- Mark the earlier matching /status record and any earlier matching /status
    -- records as processed, since they'll never be used again.
    UPDATE status
      SET processed = 1
      WHERE processed = 0
        AND session_id = result.session_id 
        AND relay_protocol = result.relay_protocol
        AND host_id = result.host_id
        -- Strictly-less-than means it won't match result.
        AND timestamp < result.timestamp;

    RETURN result;
  END IF;

  RETURN NULL;

END;
$$ LANGUAGE plpgsql;

-- Reconstruct sessions from /connected, /disconnected, and /status records.
CREATE OR REPLACE FUNCTION doSessionReconstruction() RETURNS integer AS $$
DECLARE
  connected_record connected%ROWTYPE;
  disconnected_record disconnected%ROWTYPE;
  status_record status%ROWTYPE;
  result integer := 0;
  disconnected_count integer := 0;
  status_count integer := 0;
  expired_count integer := 0;
  nomatch_count integer := 0;
  session_end timestamptz;
BEGIN

  FOR connected_record IN
      SELECT * FROM connected
        WHERE processed = 0
        ORDER BY connected.timestamp ASC LOOP
    result := result + 1;
    session_end := NULL;

    -- Look for a matching /disconnected entry.
    SELECT * INTO disconnected_record FROM findMatchingDisconnect(connected_record);
    IF disconnected_record IS NOT NULL THEN
      -- Matching /disconnected entry found.
      disconnected_count := disconnected_count + 1;

      -- Setting this value will cause a session insert below
      session_end := disconnected_record.timestamp;

      -- Mark the connected and disconnected records as processed.
      UPDATE connected SET processed = 1 WHERE id = connected_record.id;
      UPDATE disconnected SET processed = 1 WHERE id = disconnected_record.id;
    ELSE
      -- No matching disconnected entry; look for a matching /status entry.
      SELECT * INTO status_record FROM findMatchingStatus(connected_record);
      IF status_record IS NOT NULL THEN
        -- Matching /status entry found. Check if it's old enough that we should
        -- close the session.
        IF (NOW() - status_record.timestamp) > '24 hours'::interval THEN
          status_count := status_count + 1;

          -- Setting this value will cause a session insert below
          session_end := status_record.timestamp;

          -- Mark the connected and status records as processed.
          UPDATE connected SET processed = 1 WHERE id = connected_record.id;
          UPDATE status SET processed = 1 WHERE id = status_record.id;
        END IF;
      ELSE
        -- No matching /disconnected or /status entry found.
        -- If this /connected entry is old, give up on it: mark it as processed
        -- so we don't have to keep checking it.
        -- And create a zero-duration session for it.

        IF (NOW() - connected_record.timestamp) > '24 hours'::interval THEN

          -- Setting this value will cause a session insert below
          session_end := connected_record.timestamp;

          -- Mark /connected record as expired.
          UPDATE connected 
            SET processed = 2
            WHERE id = connected_record.id;

          expired_count := expired_count + 1;
        ELSE
          -- No matching /disconnected or /status, but not too old to expire it.
          nomatch_count := nomatch_count + 1;
        END IF;
      END IF;
    END IF;

    IF session_end IS NOT NULL THEN
      INSERT INTO session 
        (host_id, server_id, client_region, propagation_channel_id,
         sponsor_id, client_version, client_platform, relay_protocol, session_id,
         session_start_timestamp, session_end_timestamp, connected_id)
      VALUES
        (connected_record.host_id, connected_record.server_id, 
         connected_record.client_region, connected_record.propagation_channel_id,
         connected_record.sponsor_id, connected_record.client_version, 
         connected_record.client_platform, connected_record.relay_protocol, 
         connected_record.session_id, connected_record.timestamp, 
         session_end, connected_record.id);
    END IF;

  END LOOP;

  RETURN result;

END;
$$ LANGUAGE plpgsql;

-- Table: propagation_channel

-- DROP TABLE propagataion_channel;

CREATE TABLE propagation_channel
(
  id text,
  name text,
  CONSTRAINT propagation_channel_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE propagation_channel OWNER TO postgres;
GRANT ALL ON TABLE propagation_channel TO postgres;
GRANT ALL ON TABLE propagation_channel TO psiphon3;

-- Table: sponsor

-- DROP TABLE sponsor;

CREATE TABLE sponsor
(
  id text,
  name text,
  CONSTRAINT sponsor_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sponsor OWNER TO postgres;
GRANT ALL ON TABLE sponsor TO postgres;
GRANT ALL ON TABLE sponsor TO psiphon3;

CREATE OR REPLACE VIEW psiphon_discovery AS
SELECT
  discovery."timestamp",
  discovery.host_id,
  discovery.server_id,
  discovery.client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  discovery.client_version,
  discovery.client_platform,
  discovery.relay_protocol,
  discovery.discovery_server_id,
  discovery.client_unknown,
  discovery.id
FROM discovery
JOIN propagation_channel ON propagation_channel.id = discovery.propagation_channel_id
JOIN sponsor ON  sponsor.id = discovery.sponsor_id;

ALTER VIEW psiphon_discovery OWNER TO postgres;
GRANT ALL ON psiphon_discovery TO postgres;
GRANT ALL ON psiphon_discovery TO psiphon3;

CREATE OR REPLACE VIEW psiphon_download AS
SELECT
  download."timestamp",
  download.host_id,
  download.server_id,
  download.client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  download.client_version,
  download.client_platform,
  download.id
FROM download
JOIN propagation_channel ON propagation_channel.id = download.propagation_channel_id
JOIN sponsor ON  sponsor.id = download.sponsor_id;

ALTER VIEW psiphon_download OWNER TO postgres;
GRANT ALL ON psiphon_download TO postgres;
GRANT ALL ON psiphon_download TO psiphon3;

CREATE OR REPLACE VIEW psiphon_failed AS
SELECT
  failed."timestamp",
  failed.host_id,
  failed.server_id,
  failed.client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  failed.client_version,
  failed.client_platform,
  failed.relay_protocol,
  failed.error_code,
  failed.id
FROM failed
JOIN propagation_channel ON propagation_channel.id = failed.propagation_channel_id
JOIN sponsor ON  sponsor.id = failed.sponsor_id;

ALTER VIEW psiphon_failed OWNER TO postgres;
GRANT ALL ON psiphon_failed TO postgres;
GRANT ALL ON psiphon_failed TO psiphon3;

CREATE OR REPLACE VIEW psiphon_handshake AS
SELECT
  handshake."timestamp",
  handshake.host_id,
  handshake.server_id,
  handshake.client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  handshake.client_version,
  handshake.client_platform,
  handshake.relay_protocol,
  handshake.id
FROM handshake
JOIN propagation_channel ON propagation_channel.id = handshake.propagation_channel_id
JOIN sponsor ON  sponsor.id = handshake.sponsor_id;

ALTER VIEW psiphon_handshake OWNER TO postgres;
GRANT ALL ON psiphon_handshake TO postgres;
GRANT ALL ON psiphon_handshake TO psiphon3;

CREATE OR REPLACE VIEW psiphon_bytes_transferred AS
SELECT
  bytes_transferred."timestamp",
  bytes_transferred.host_id,
  bytes_transferred.server_id,
  bytes_transferred.client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  bytes_transferred.client_version,
  bytes_transferred.client_platform,
  bytes_transferred.relay_protocol,
  bytes_transferred.bytes,
  bytes_transferred.id
FROM bytes_transferred
JOIN propagation_channel ON propagation_channel.id = bytes_transferred.propagation_channel_id
JOIN sponsor ON  sponsor.id = bytes_transferred.sponsor_id;

ALTER VIEW psiphon_bytes_transferred OWNER TO postgres;
GRANT ALL ON psiphon_bytes_transferred TO postgres;
GRANT ALL ON psiphon_bytes_transferred TO psiphon3;

CREATE OR REPLACE VIEW psiphon_page_views AS
SELECT
  page_views."timestamp",
  page_views.host_id,
  page_views.server_id,
  page_views.client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  page_views.client_version,
  page_views.client_platform,
  page_views.relay_protocol,
  page_views.pagename,
  page_views.viewcount,
  page_views.id
FROM page_views
JOIN propagation_channel ON propagation_channel.id = page_views.propagation_channel_id
JOIN sponsor ON  sponsor.id = page_views.sponsor_id;

ALTER VIEW psiphon_page_views OWNER TO postgres;
GRANT ALL ON psiphon_page_views TO postgres;
GRANT ALL ON psiphon_page_views TO psiphon3;

CREATE OR REPLACE VIEW psiphon_https_requests AS
SELECT
  https_requests."timestamp",
  https_requests.host_id,
  https_requests.server_id,
  https_requests.client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  https_requests.client_version,
  https_requests.client_platform,
  https_requests.relay_protocol,
  https_requests."domain",
  https_requests.count,
  https_requests.id
FROM https_requests
JOIN propagation_channel ON propagation_channel.id = https_requests.propagation_channel_id
JOIN sponsor ON  sponsor.id = https_requests.sponsor_id;

ALTER VIEW psiphon_https_requests OWNER TO postgres;
GRANT ALL ON psiphon_https_requests TO postgres;
GRANT ALL ON psiphon_https_requests TO psiphon3;

CREATE OR REPLACE VIEW psiphon_speed AS
SELECT
  speed."timestamp",
  speed.host_id,
  speed.server_id,
  speed.client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  speed.client_version,
  speed.client_platform,
  speed.relay_protocol,
  speed."operation",
  speed.info,
  speed.milliseconds,
  speed."size",
  speed.id
FROM speed
JOIN propagation_channel ON propagation_channel.id = speed.propagation_channel_id
JOIN sponsor ON  sponsor.id = speed.sponsor_id;

ALTER VIEW psiphon_speed OWNER TO postgres;
GRANT ALL ON psiphon_speed TO postgres;
GRANT ALL ON psiphon_speed TO psiphon3;

CREATE OR REPLACE VIEW psiphon_session AS
SELECT
  "session".host_id,
  "session".server_id,
  "session".client_region,
  propagation_channel.name AS propagation_channel_name,
  sponsor.name AS sponsor_name,
  "session".client_version,
  "session".client_platform,
  "session".relay_protocol,
  "session".session_id,
  "session".session_start_timestamp,
  "session".session_end_timestamp,
  "session".id
FROM "session"
JOIN propagation_channel ON propagation_channel.id = "session".propagation_channel_id
JOIN sponsor ON  sponsor.id = "session".sponsor_id;

ALTER VIEW psiphon_session OWNER TO postgres;
GRANT ALL ON psiphon_session TO postgres;
GRANT ALL ON psiphon_session TO psiphon3;

