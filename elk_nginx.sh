#!/bin/sh
set -x
set -e
ssh ovh "gunzip -c access.log.gz" | cat > logstash/nginx/access.log
set +e
docker-compose stop && docker-compose rm -f
set -e
COMPOSE_CONVERT_WINDOWS_PATHS=1 docker-compose up -d

echo "Sleeping waiting for servers to start and logs to be imported"
sleep 420

curl -XPOST http://192.168.99.100:9200/.kibana/index-pattern/nginx_elastic_stack_example -d '@indexed_fields.json'
node import_object.js http://192.168.99.100:9200

start http://192.168.99.100:5601/app/kibana#/dashboard/Dashboard-for-nginx-Logs