#!/usr/bin/env python2

import os

def install_nginx_site(name, content):
    f = open('/etc/nginx/sites-available/{0}'.format(name), 'w')
    f.write(content)
    f.close()

    os.system('''
        cd /etc/nginx/sites-enabled
        rm {name} 2>/dev/null
        ln -s ../sites-available/{name} {name}
    '''.format(name=name))

def remove_nginx_default():
    os.system('''
        rm /etc/nginx/sites-enabled/default 2>/dev/null
        rm /etc/nginx/sites-available/default 2>/dev/null
    ''')

def install_nechifor_node():
    content = """
    server {
        server_name nechifor.net;
        location / {
            proxy_pass http://localhost:3000;
        }
        location /s/ {
            root /vagrant/sites/nechifor-site/build/;
        }
    }
    """
    install_nechifor_node_upstart()
    install_nginx_site('nechifor.net', content)

def install_nechifor_node_upstart():
    content = """#!upstart

description "nechifor-site node server"
author "Paul Nechifor <paul@nechifor.net>"

start on startup
stop on shutdown

# Run as an unprivileged user.
#setuid vagrant
#setgid vagrant

# Automatically respawn if it dies, but abandon if more than 5 times in 60 secs.
respawn
respawn limit 5 60

script
    exec /usr/bin/node /vagrant/sites/nechifor-site/build/app/app.js >> /var/log/nechifor-site 2>&1
end script
"""
    f = open('/etc/init/nechifor-site.conf', 'w')
    f.write(content)
    f.close()

def main():
    os.system('/opt/glassfish3/glassfish/bin/asadmin start-domain >/dev/null')
    remove_nginx_default()
    install_nechifor_node()
    os.system('service nechifor-site restart')
    os.system('service nginx restart')

if __name__ == '__main__':
    main()
