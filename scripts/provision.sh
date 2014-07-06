#!/bin/bash

packages=(
  ant
  default-jdk
  nginx
  unzip
)

main() {
  install_packages
  install_glassfish
  install_node
}

install_packages() {
  apt-get update
  apt-get install -y ${packages[@]}
}

install_glassfish() {
  if [ -d /opt/glassfish3 ]; then
    echo 'It looks like Glassfish is installed.'
    return
  fi
  wget 'http://download.java.net/glassfish/3.1.1/release/glassfish-3.1.1-web.zip'
  unzip -d /opt glassfish-*.zip
  rm glassfish-*.zip
  /opt/glassfish3/glassfish/bin/asadmin start-domain
}

install_node() {
  apt-get install -y python-software-properties
  add-apt-repository -y ppa:chris-lea/node.js
  apt-get update
  apt-get install -y nodejs
}

main
