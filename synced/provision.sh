#!/bin/bash

packages=(
    docker.io
    nginx
)

main() {
    install_packages

    setup_docker
    get_packages
    start_containers
    configure_nginx
}

install_packages() {
    apt-get update
    apt-get install -y "${packages[@]}"
}

setup_docker() {
    # Add the user to the docker group.
    gpasswd -a "$(getent passwd 1000 | cut -d: -f1)" docker
}

get_packages() {
    docker load < /opt/nechifor-machine/nechifor-web-1.tar.xz
}

start_containers() {
    local args=(
        run
        --name nechifor-web
        --restart always
        -p 8080:80
        -d nechifor-web:1
        /usr/bin/supervisord
        -n
        -c /etc/supervisord.conf
    )
    docker "${args[@]}"
}

configure_nginx() {
    cp /opt/nechifor-machine/nginx.conf /etc/nginx/nginx.conf
    service nginx restart
}

main
