#!/bin/bash

do_run() {

    # Create and activate a 2 GB swapfile
    fallocate -l 2G /swapfile && \
    dd if=/dev/zero of=/swapfile bs=1k count=2048 && \
    chmod 600 /swapfile && \
    mkswap /swapfile && \
    swapon /swapfile && \
    echo '/swapfile swap swap defaults 0 0' | tee -a /etc/fstab && \
    mount -a

    # Install Docker
    sh -c "$(curl -sSL https://get.docker.com/)"

    # Install Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

    # Install additional tools
    apt install nano pwgen -y

}

do_run