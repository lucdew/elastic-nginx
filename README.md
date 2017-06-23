# Offline Nginx stats with ELK

Offline access log stats for a personal nginx web site using containerized ELK stack
Access.log file is already concatenated

# Requirements

## Docker toolbox

Increase `max_map_count` on your Docker host.
See https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode

docker-machine ssh
sudo sysctl -w vm.max_map_count=262144

## Sources checkcout
Clone in C:/Users/Luc/elastic-nginx

## Run
./elk_nginx.sh

