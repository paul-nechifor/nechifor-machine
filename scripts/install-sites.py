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

def install_nechifor_ee():
    os.system('''
        sudo {0} undeploy Nechifor
        sudo {0} deploy --contextroot "/" /vagrant/sites/Nechifor.war
    '''.format('/opt/glassfish3/glassfish/bin/asadmin'))

    content = """
    server {
        server_name old.nechifor.net;
        location / {
            proxy_pass http://localhost:8080;
        }
    }
    """
    install_nginx_site('old.nechifor.net', content)

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
    install_nginx_site('nechifor.net', content)

def main():
    os.system('/opt/glassfish3/glassfish/bin/asadmin start-domain >/dev/null')
    remove_nginx_default()
    install_nechifor_ee()
    install_nechifor_node()
    os.system('service nginx restart')

if __name__ == '__main__':
    main()
