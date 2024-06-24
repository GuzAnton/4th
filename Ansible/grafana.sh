#!/bin/bash

GRAFANA_VERSION="10.4.4"
PROMETHEUS_URL="http://localhost"

sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Updates the list of available packages
sudo apt-get update
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_${GRAFANA_VERSION}_amd64.deb
sudo dpkg -i grafana-enterprise_${GRAFANA_VERSION}_amd64.deb
echo "export PATH=/usr/share/grafana/bin:$PATH" >> /etc/profile

cat <<EOF> /etc/grafana/provisioning/datasources/prometheus.yaml
api.version: 1
datasources:
    - name: Prometheus
      type: Prometheus
      url: ${PROMETHEUS_URL}
EOF

systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server