# GCP-Wordpress
Deploy Wordpress on [Google Cloud Platform](https://cloud.google.com/), \
using [Traefik](https://traefik.io/) as a load balancer and securing traffic with [Let's Encrypt](https://letsencrypt.org/) certificates \
Traffic will automatically be forwarded from HTTP to HTTPS to ensure secure connections

# Setup and Deployment
## Create and Connect

* Create a new Project
* Create a new __VM Instance__ in __Compute Engine__
  * Machine Type: f1-micro (included in free subscription and only in certain US regions)
    The f1-micro Machine Type is only available in the N1 (First Generation) Machine Family.
  * Boot Disk: Ubuntu 20.x LTS Minimal with a 30 GB Standard persistent disk (not balanced)
  * Allow HTTP and HTTPS traffic
* SSH into the new VM Instance

## Initial Deployment

Run the deploy.sh from this repository to setup the virtual machine

```shell
sudo sh -c "$(curl -sSL https://raw.githubusercontent.com/mjn798/GCP-Wordpress/master/deploy.sh)"
```

Run the wordpress.sh from this repository to setup Traefik and Wordpress

```shell
sudo sh -c "$(curl -sSL https://raw.githubusercontent.com/mjn798/GCP-Wordpress/master/wordpress.sh)"
```

## Prepare .env files

In the `/docker/trafik` directory, add your email address to the .env file \
In the `/docker/wordpress` directory, add your Wordpress URL to the .env file

```shell
sudo nano /docker/traefik/.env
sudo nano /docker/wordpress/.env
```

Example:

```shell
EMAIL=me@mydomain.com
WORDPRESS_URL=wordpress.mydomain.com
```
# Docker

For the initial start use docker-compose in the corresponding directories

Start with running **Traefik** and after this run **Wordpress**

```shell
cd /docker/traefik
sudo docker-compose up -d

cd /docker/wordpress
sudo docker-compose up -d
```

Traefik is configured to use a default certificate for testing \
If Wordpress can be called correctly, fix the Traefik configuration in the `/docker/traefik/docker-compose.yaml` by commenting the following lines:

```shell
- "--log.level=DEBUG"
- "--api.insecure=true"

- "--certificatesresolvers.myhttpchallenge.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory"
```

Delete Traefik with the `docker-compose down` command below \
Delete the letsencrypt folder to get rid of the cached fake certificates

```shell
sudo rm /docker/traefik/letsencrypt -Rf
```

Run Traefik with the `docker-compose up` command below \
It will take a couple of seconds to generate the proper certificates \
After this, the browser should not longer give a warning when accessing the URL via HTTPS

## Docker Compose

Run and delete Docker Containers with the following commands

* Run: `sudo docker-compose up -d`
* Delete: `sudo docker-compose down --volumes`

## Docker Containers

Start, stop and restart Docker Containers with the following commands

* Start: `sudo docker start <container>`
* Stop: `sudo docker stop <container>`
* Restart: `sudo docker restart <container>`

Check the current status with

* Status: `sudo docker ps -a`

# Static IP Address

* Go to __External IP Addresses__ in the __VPC Network__ section
* For the wordpress instance instead of __Ephemeral__ choose __Static__, choose a name (i.e. wordpress) and reserve the static IP address
* Use this IP Address in your cloud provider for A-name records, pointing the IP Address to the GCP instance