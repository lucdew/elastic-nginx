#!/usr/bin/env python3
#pylint: disable=invalid-name
"""
Import visualisations and dashboard into .kibana index
"""
import json
import re
import sys
import urllib3

idxPatternId = sys.argv[1] if len(sys.argv) > 1 else None
elUrl = sys.argv[2] if len(sys.argv) > 2 else "http://localhost:5601"

http = urllib3.PoolManager()

if idxPatternId is None:
    # Get nginx_logs index pattern id
    r = http.request(
        'GET',
        'http://localhost:5601/api/saved_objects?type=index-pattern&fields=title')

    if r.status != 200:
        raise Exception("Failed request, got status {0} and message {1}"
                        .format(r.status, str(r.data)))

    idxPatterns = json.loads(r.data, encoding='utf-8')
    savedObjs = idxPatterns['saved_objects']
    for obj in savedObjs:
        if 'attributes' in obj and obj['attributes']['title'] == 'nginx_logs':
            idxPatternId = obj['id']

with open('./kibana_objects.json') as f:
    objs = json.load(f)

    for obj in objs:
        attributes = obj['_source']
        attributes['kibanaSavedObjectMeta']['searchSourceJSON'] = re.sub(
            r'index":"([^"]+)',
            r'index":"'+idxPatternId,
            attributes['kibanaSavedObjectMeta']['searchSourceJSON'])
        print(attributes['kibanaSavedObjectMeta']['searchSourceJSON'])
        bodyData = {
            'attributes':attributes
        }
        r = http.request(
            'POST',
            '{0}/api/saved_objects/{1}/{2}?overwrite=true'.format(elUrl, obj['_type'], obj['_id']),
            body='{"attributes":%s}'%(json.dumps(obj['_source'])),
            headers={
                'Content-Type': 'application/json;charset=utf-8',
                #'kbn-version': '6.1.1',
                'kbn-xsrf': 'anything'
                })
        if r.status != 200:
            raise Exception("Failed request, got status {0} and message {1}"
                            .format(r.status, str(r.data)))
