#!/bin/bash

# set project Kiwix name
sed -i "s/CHAOSS/Kiwix/g" /project.cfg

# set Github token
{ \
  echo "[github]" ; \
  echo "api-token = $GITHUB_TOKEN" ; \
} > /override.cfg

# Start Elasticsearch
echo "Starting Elasticsearch"
sudo chown -R elasticsearch.elasticsearch /var/lib/elasticsearch
sudo /etc/init.d/elasticsearch start

# Start MariaDB
echo "Starting MariaDB"
sudo /etc/init.d/mysql start

# Start Kibana
echo "Starting Kibiter"
${KB}-linux-x86_64/bin/kibana > kibana.log 2>&1 &

kidash --import /dashboard_overview.json --dashboard Overview 

# Start SirMordred
echo "Starting SirMordred"
/usr/local/bin/sirmordred $*


