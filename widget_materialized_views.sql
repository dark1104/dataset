-- Protocol Numbers by pie chart
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_protocolIdentifier_agg
ENGINE = SummingMergeTree()
ORDER BY (protocolIdentifier)
AS
SELECT
    protocolIdentifier,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY protocolIdentifier;

-- Bytes accumulated Per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address;

-- Bytes accumulated Per IPV4 subnet group
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_subnet_group_agg
ENGINE = SummingMergeTree()
ORDER BY (subnet_group)
AS
SELECT
    subnet_group,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY subnet_group;

-- HTTP URLs seen Per IPV4 address/group
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_http_url_sourceIPv4Address_agg
ENGINE = SummingMergeTree()
ORDER BY (http_url, sourceIPv4Address)
AS
SELECT
    http_url,
    sourceIPv4Address,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY http_url, sourceIPv4Address;

-- Top Port Numbers per IPV4 address (can map to application)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_sourceIPv4Address_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceTransportPort, sourceIPv4Address)
AS
SELECT
    sourceTransportPort,
    sourceIPv4Address,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceTransportPort, sourceIPv4Address;

-- Top applications by bytes accumulated per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_sourceIPv4Address_agg
ENGINE = SummingMergeTree()
ORDER BY (application_name, sourceIPv4Address)
AS
SELECT
    application_name,
    sourceIPv4Address,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY application_name, sourceIPv4Address;

-- VLANs per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_datalink_vlan_sourceIPv4Address_agg
ENGINE = SummingMergeTree()
ORDER BY (datalink_vlan, sourceIPv4Address)
AS
SELECT
    datalink_vlan,
    sourceIPv4Address,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY datalink_vlan, sourceIPv4Address;

-- HTTPS usage (bytes accumulated) for port 443 per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_filter443_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw
WHERE sourceTransportPort = 443
GROUP BY sourceIPv4Address;

-- FIN/RST per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_rst_tcp_fin_sourceIPv4Address_agg
ENGINE = SummingMergeTree()
ORDER BY (tcp_rst, tcp_fin, sourceIPv4Address)
AS
SELECT
    tcp_rst,
    tcp_fin,
    sourceIPv4Address,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY tcp_rst, tcp_fin, sourceIPv4Address;

-- TCP retransmits per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_retransmits_sourceIPv4Address_agg
ENGINE = SummingMergeTree()
ORDER BY (tcp_retransmits, sourceIPv4Address)
AS
SELECT
    tcp_retransmits,
    sourceIPv4Address,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY tcp_retransmits, sourceIPv4Address;