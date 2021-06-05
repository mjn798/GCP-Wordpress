#!/bin/bash

do_run() {

    # Create the /docker directory, including random passwords and docker-compose.yaml
    mkdir /docker

    # Prepare Docker network and folders
    # generate random passwords for database users
    docker network create traefik
    mkdir {/docker/traefik,/docker/wordpress} && \
    printf "EMAIL=\n" | tee /docker/traefik/.env && \
    printf "MYSQL_ROOT=%s\n" $(pwgen 32 1) | tee /docker/wordpress/.env && \
    printf "MYSQL_USER=%s\n" $(pwgen 32 1) | tee -a /docker/wordpress/.env && \
    printf "WORDPRESS_URL=\n" | tee -a /docker/wordpress/.env && \
    chmod 400 /docker/wordpress/.env /docker/traefik/.env

    # Download docker-compose files
    curl -L "https://raw.githubusercontent.com/mjn798/GCP-Wordpress/master/traefik/docker-compose.yaml" -o /docker/traefik/docker-compose.yaml && \
    curl -L "https://raw.githubusercontent.com/mjn798/GCP-Wordpress/master/wordpress/docker-compose.yaml" -o /docker/wordpress/docker-compose.yaml && \
    chown $(id -un $SUDO_USER):$(id -gn $SUDO_USER) /docker -R && \
    cd /docker

}

do_run