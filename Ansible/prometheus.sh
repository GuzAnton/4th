#!/bin/bash

PROMETHEUS_VERSION="2.5.1"
PROMETHEUS_FOLDER_CONFIG="/etc/prometheus"
PROMETHEUS_FOLDER_DATA="/etc/prometheus/data"
INVENTORY_FILE="inventory.txt"

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION.linux-amd64.tar.gz
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

# Function to add targets to prometheus.yml
add_targets() {
  local group=$1
  echo "  - job_name: \"$group\"" >> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
  echo "    static_configs:" >> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
  echo "    - targets:" >> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
  echo "      - localhost:9090" >> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml

  grep -A 100 "^\[$group\]" $INVENTORY_FILE | grep -v "^\[" | grep -v "^--" | grep -v "^$" | while read -r ip; do
    echo "      - ${ip}:9090" >> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
  done
}

# Add web_servers and db_servers to targets
add_targets "web_servers"
add_targets "db_servers"

useradd -rs /bin/false prometheus
chown prometheus:prometheus /usr/bin/prometheus
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
chown prometheus:prometheus $PROMETHEUS_FOLDER_DATA

useradd -rs /bin/false prometheus
chown prometheus:prometheus /usr/bin/prometheus
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
chown prometheus:prometheus $PROMETHEUS_FOLDER_DATA

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
    --config.file ${PROMETHEUS_FOLDER_CONFIG}/prometheus.yml
    --storage.tsdb.path ${PROMETHEUS_FOLDER_DATA}
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart prometheus
systemctl enable prometheus