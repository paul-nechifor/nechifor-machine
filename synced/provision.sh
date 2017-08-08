#!/bin/bash

packages=(
    docker.io
    nginx
)

gitlab_image="gitlab/gitlab-ce:9.4.3-ce.0"

main() {
    install_packages

    setup_docker
    download_packages
    start_containers
}

install_packages() {
    apt-get update
    apt-get install -y "${packages[@]}"
}

setup_docker() {
    # Add the user to the docker group.
    gpasswd -a "$(getent passwd 1000 | cut -d: -f1)" docker
}

download_packages() {
    docker pull "$gitlab_image"
}

start_containers() {
    local vars=(
        --detach
        --hostname gitlab.nechifor.net
        --publish 8081:80
        # --publish 2222:22
        --name gitlab
        --restart always
        --volume /opt/gitlab/config:/etc/gitlab
        --volume /opt/gitlab/logs:/var/log/gitlab
        --volume /opt/gitlab/data:/var/opt/gitlab
        "$gitlab_image"
    )

    docker run "${vars[@]}"
}

main
