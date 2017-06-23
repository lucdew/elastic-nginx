#curl -X DELETE http://localhost:9200/nginx_elastic_stack_example
# localhost:5601/app/kibana
# curl -XPUT http://localhost:9200/.kibana/index-pattern/nginx_elastic_stack_example -d '{"title" : "nginx_elastic_stack_example",  "timeFieldName": "@timestamp"}'
# Url to check http://localhost:9200/.kibana/index-pattern/_search
#curl -XPOST http://localhost:9200/nginx_elastic_stack_example/_search -d '{"query":{"match_all":{}},"size":10000}'
#curl -XPOST http://localhost:5601/es_admin/.kibana/index-pattern/nginx_elastic_stack_example/_create -d '{"title" : "nginx_elastic_stack_example",  "timeFieldName": "@timestamp"}'
#curl -XPOST http://localhost:5601/es_admin/.kibana/index-pattern/_search?stored_fields= -d '{"query":{"match_all":{}},"size":10000}'