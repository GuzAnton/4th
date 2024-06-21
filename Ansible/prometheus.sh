#!/bin/bash

PROMETHEUS_VERSION="2.5.1"
PROMETHEUS_FOLDER_CONFIG="/etc/prometheus"
PROMETHEUS_FOLDER_DATA="/etc/prometheus/data"
INVENTORY_FILE="inventory.txt"

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
tar xzvf prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
cd prometheus-$PROMETHEUS_VERSION.linux-amd64

mv prometheus /usr/bin
rm -rf /tmp/prometheus*

mkdir -p $PROMETHEUS_FOLDER_CONFIG
mkdir -p $PROMETHEUS_FOLDER_DATA

cat <<EOF> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
global:
    scrape_interval: 60s

scrape_configs:
    - job_name: "prometheus"
      static_configs:
        - targets:
          - localhost:9090
EOF

add_targets() {
  awk '/^\[.*\]/ { group=$1; next } group && NF { print "          - " $1 ":9090" }' $INVENTORY_FILE >> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
}

# Add web_servers and db_servers to targets under prometheus job
add_targets

# Create Prometheus user and set permissions
useradd -rs /bin/false prometheus
chown prometheus:prometheus /usr/bin/prometheus
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
chown prometheus:prometheus $PROMETHEUS_FOLDER_DATA

# Create systemd service file for Prometheus
cat <<EOF> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
ExecStart=/usr/bin/prometheus \
    --config.file ${PROMETHEUS_FOLDER_CONFIG}/prometheus.yml \
    --storage.tsdb.path ${PROMETHEUS_FOLDER_DATA}

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, start and enable Prometheus service
systemctl daemon-reload
systemctl restart prometheus
systemctl enable prometheus

echo "Prometheus configuration and service setup is complete."
