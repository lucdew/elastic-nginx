# Offline Nginx logs stats with ELK

Offline access log stats for a single personal nginx web site using a dockerized ELK stack (6.X)

Note that the access.log file is already concatenated (not realistic for large volumes web sites)
In the example script here, it is retrieved from a remote host through ssh

# Requirements

## Required binaries
* docker-compose
* jq

## Docker

Increase `max_map_count` on your Docker host.
See https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode

```
sudo sysctl -w vm.max_map_count=262144
```

## Run
./elk_nginx.sh

## Dashboard example

<img src="https://github.com/lucdew/elastic-nginx/raw/master/nginx_logs_dashboard.png" alt="Nginx logs dashboard" />

