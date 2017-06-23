const fs = require('fs')
const http = require('http')
const objs = JSON.parse(fs.readFileSync('nginx_kibana.json'))
const url = require('url')

const destUrl = url.parse(process.argv[2])

function createObj (obj, data) {
  const options = {
    hostname: destUrl.hostname,
    port: destUrl.port,
    path: `/.kibana/${obj._type}/${obj._id}`,
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    }
  }
  return new Promise((resolve, reject) => {
    var req = http.request(options, function (res) {
      res.setEncoding('utf8')
      res.on('data', function (body) {
        console.log(`Create ${obj._type} ${obj._source.title}`)
        resolve(body)
      })
    })
    req.on('error', function (e) {
      reject(e)
    })
    req.write(JSON.stringify(obj._source))
    req.end()
  })
}

objs.reduce((acc, obj) => acc.then(() => createObj(obj)), Promise.resolve())
    .catch(err => console.log(err))
