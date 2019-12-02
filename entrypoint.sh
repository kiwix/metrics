#!/bin/bash

# set project Kiwix name
sed -i "s/CHAOSS/Kiwix/g" /project.cfg

# set Github token and enable cocom
{ \
  echo "[github]" ; \
  echo "api-token = $GITHUB_TOKEN" ; \
  echo ""  ; \
  echo "[panels]" ; \
  echo "code-complexity = true" ; \
  echo ""  ; \
  echo "[cocom]" ; \
  echo "raw_index = cocom_chaoss" ; \
  echo "enriched_index = cocom_chaoss_enrich" ; \
  echo "category = code_complexity_lizard_file" ; \
  echo "studies = [enrich_cocom_analysis]" ; \
  echo "branches = master" ; \
  echo ""  ; \
  echo "[enrich_cocom_analysis]" ; \
  echo "out_index = cocom_chaoss_study" ; \
  echo "interval_months = [3]" ; \
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

#sleep 10000d
