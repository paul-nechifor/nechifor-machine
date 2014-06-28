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

main
