-- Application arrival pattern based on start time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_start_time_agg
ENGINE = SummingMergeTree()
ORDER BY (application_name, flow_start_time)
AS
SELECT
    application_name,
    flow_start_time,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY application_name, flow_start_time;

-- SRC/DST IPV4 arrival based on the start time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_destinationIPv4Address_flow_start_time_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceIPv4Address, destinationIPv4Address, flow_start_time)
AS
SELECT
    sourceIPv4Address,
    destinationIPv4Address,
    flow_start_time,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, destinationIPv4Address, flow_start_time;

-- PORT SRC/DST arrival based on start time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_destinationTransportPort_flow_start_time_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceTransportPort, destinationTransportPort, flow_start_time)
AS
SELECT
    sourceTransportPort,
    destinationTransportPort,
    flow_start_time,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceTransportPort, destinationTransportPort, flow_start_time;

-- TCP errors/RST arrival based on flow start time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_rst_tcp_fin_flow_start_time_agg
ENGINE = SummingMergeTree()
ORDER BY (tcp_rst, tcp_fin, flow_start_time)
AS
SELECT
    tcp_rst,
    tcp_fin,
    flow_start_time,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY tcp_rst, tcp_fin, flow_start_time;

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

-- Bytes accumulated per Protocol Number overall
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

-- Select a IPV4 address and get the split of protocol Numbers seen per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_protocolIdentifier_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceIPv4Address, protocolIdentifier)
AS
SELECT
    sourceIPv4Address,
    protocolIdentifier,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, protocolIdentifier;

-- Application arrival pattern based on end time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_end_time_agg
ENGINE = SummingMergeTree()
ORDER BY (application_name, flow_end_time)
AS
SELECT
    application_name,
    flow_end_time,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY application_name, flow_end_time;

-- SRC/DST IPV4 arrival based on the end time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_destinationIPv4Address_flow_end_time_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceIPv4Address, destinationIPv4Address, flow_end_time)
AS
SELECT
    sourceIPv4Address,
    destinationIPv4Address,
    flow_end_time,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, destinationIPv4Address, flow_end_time;

-- PORT SRC/DST arrival based on end time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_destinationTransportPort_flow_end_time_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceTransportPort, destinationTransportPort, flow_end_time)
AS
SELECT
    sourceTransportPort,
    destinationTransportPort,
    flow_end_time,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceTransportPort, destinationTransportPort, flow_end_time;

-- TCP errors/RST arrival based on flow end time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_rst_tcp_fin_flow_end_time_agg
ENGINE = SummingMergeTree()
ORDER BY (tcp_rst, tcp_fin, flow_end_time)
AS
SELECT
    tcp_rst,
    tcp_fin,
    flow_end_time,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY tcp_rst, tcp_fin, flow_end_time;

-- Bytes accumulated per IPV4 address
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

-- Bytes accumulated per IPV4 subnet group
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

-- HTTP URLs seen per IPV4 address/group
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

-- Top Port Numbers per IPV4 address (can convert to application name based on port number)
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
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_https_usage_ipv4_agg
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
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_tcp_fin_tcp_rst_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceIPv4Address, tcp_fin, tcp_rst)
AS
SELECT
    sourceIPv4Address,
    tcp_fin,
    tcp_rst,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, tcp_fin, tcp_rst;

-- TCP retransmits per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_tcp_retransmits_agg
ENGINE = SummingMergeTree()
ORDER BY (sourceIPv4Address, tcp_retransmits)
AS
SELECT
    sourceIPv4Address,
    tcp_retransmits,
    sum(octetDeltaCount) AS total_bytes,
    sum(packetDeltaCount) AS total_packets,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, tcp_retransmits;