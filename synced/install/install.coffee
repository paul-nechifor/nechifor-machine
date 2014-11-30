deployTools = require 'deploy-tools'

site =
  id: 'nechifor-site'
  domain: 'nechifor.net'
  appType: 'node'
  script: 'build/app/app.js'
  port: 3000

  nginx: """
    server {
        server_name [[[ domain ]]];
        location / {
            proxy_pass http://localhost:[[[ port ]]];
        }
        location /s/ {
            root [[[ appsRoot ]]]/[[[ id ]]]/build/;
        }
    }
  """

main = ->
  deployTools.install site, (err) ->
    throw err if err

main()
