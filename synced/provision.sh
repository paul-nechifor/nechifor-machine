#!/bin/bash

packages=(
    docker.io
    nginx
)

main() {
    install_packages

    setup_docker
}

install_packages() {
    apt-get update
    apt-get install -y "${packages[@]}"
}

setup_docker() {
    gpasswd -a "$(getent passwd 1000 | cut -d: -f1)" docker
}

main
