# GCP-Wordpress
Deploying Wordpress on Google Cloud Platform

Get a free Wordpress instance running on [Google Cloud Platform](https://cloud.google.com/)

## Create and Connect

* Create a new Project
* Create a new __VM Instance__ in __Compute Engine__
  * Name : wordpress
  * Machine type : f1-micro (included in free subscription)
  * Boot disk : Ubuntu 18.x LTS Minimal with a 20GB disk
  * Allow HTTP and HTTPS traffic
* From the new VM Instance details, click the __nic0__ network interface and go to __Firewall rules__ and __Create Firewall Rule__
  * Name : phpmyadmin-allow
  * Target tags : http-server https-server
  * Source IP ranges : 0.0.0.0/0
  * tcp : 9182
* SSH into the new VM Instance

## Deploy

Run the deploy.sh from this Repository.

`
sudo sh -c "$(curl -sSL https://raw.githubusercontent.com/mjn798/GCP-Wordpress/master/deploy.sh)"
`

In the `/docker` directory, run

`
sudo docker-compose up -d
`

## Docker

### Docker Compose

* Run : `sudo docker-compose up -d`
* Delete : `sudo docker-compose down --volumes`

### Docker Containers

* Start : `sudo docker start <container>`
* Stop : `sudo docker stop <container>`
* Restart : `sudo docker restart <container>`
