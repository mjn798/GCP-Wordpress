#!/bin/bash

# Update OS and install additional tools
apt update && apt upgrade -y && apt install nano pwgen -y

# Create and activate a 1GB swapfile
fallocate -l 1G /swapfile && \
dd if=/dev/zero of=/swapfile bs=1024 count=1048576 && \
chmod 600 /swapfile && \
mkswap /swapfile && \
swapon /swapfile && \
echo '/swapfile swap swap defaults 0 0' | tee -a /etc/fstab && \
mount -a

# Install Docker and Docker Compose
sh -c "$(curl -sSL https://get.docker.com/)" && \
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose

# Create the /docker directory, including random passwords and docker-compose.yaml
mkdir /docker && \
chown $(id -un):$(id -gn) /docker && \
printf "MYSQL_ROOT=%s\n" $(pwgen 32 1) | tee /docker/.env && \
printf "MYSQL_USER=%s\n" $(pwgen 32 1) | tee /docker/.env && \
chmod 400 /docker/.env && \
curl -L "https://raw.githubusercontent.com/mjn798/GCP-Wordpress/master/docker-compose.yaml" -o /docker/docker-compose.yaml && \
chown $(id -un):$(id -gn) /docker/.env /docker/docker-compose.yaml
