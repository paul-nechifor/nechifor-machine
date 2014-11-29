#!/bin/bash

packages=(
  nginx
)

main() {
  install_packages
  install_node
}

install_packages() {
  apt-get update
  apt-get install -y ${packages[@]}
}

install_node() {
  apt-get install -y python-software-properties
  add-apt-repository -y ppa:chris-lea/node.js
  apt-get update
  apt-get install -y nodejs
}

main
