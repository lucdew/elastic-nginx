#!/bin/sh

echo "Downloading aggregated logs"
ssh vpsgra "gunzip -c access.log.gz" | cat > logstash/nginx/access.log

echo "Cleaning existing Elk containers and starting new ones"
docker-compose down --remove-orphans --volumes || true
docker-compose up -d

echo "Sleeping waiting for servers to start and logs to be indexed"
sleep 60

# Variables to create default index pattern in Kibana
index_pattern="nginx_logs"
time_field="@timestamp"
# Create index pattern and get the created id
# curl -f to fail on error
echo "Creating default index pattern"
id=$(curl -f -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
  "http://localhost:5601/api/saved_objects/index-pattern" \
  -d"{\"attributes\":{\"title\":\"$index_pattern\",\"timeFieldName\":\"$time_field\"}}" \
  | jq -r '.id')
# Create the default index
curl -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
  "http://localhost:5601/api/kibana/settings/defaultIndex" \
  -d"{\"value\":\"$id\"}"

echo "Importing visualizations and dashboards"
./import_objects.py "$id"

echo "Done, go to http://localhost:5601/app/kibana#/dashboards"