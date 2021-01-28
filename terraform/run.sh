#!/bin/bash

HOST_DB=$(terraform output -raw external_ip_address_db)
HOST_NGINX=$(terraform output -raw external_ip_address_nginx)
HOST_APP=$(terraform output -raw external_ip_address_app)
HOST_APP2=$(terraform output -raw external_ip_address_app2)

# db
ssh dany@$HOST_DB << EOF

sudo apt-get install git --yes
sudo apt-get install docker --yes
sudo apt-get install docker-compose --yes
sudo docker stop
sudo dockerd &
git clone https://github.com/SunForLife/healthcheck.git
cd healthcheck
sudo docker-compose up --build --force-recreate --detach db

EOF

# nginx
ssh dany@$HOST_NGINX << EOF

sudo apt-get install git --yes
sudo apt-get install docker --yes
sudo apt-get install docker-compose --yes
sudo docker stop
sudo dockerd &
git clone https://github.com/SunForLife/healthcheck.git
cd healthcheck
sudo docker-compose up --build --force-recreate --detach nginx

EOF

# app
ssh dany@$HOST_APP << EOF

sudo apt-get install git --yes
sudo apt-get install docker --yes
sudo apt-get install docker-compose --yes
sudo docker stop
sudo dockerd &
git clone https://github.com/SunForLife/healthcheck.git
cd healthcheck
sudo docker-compose up --build --force-recreate --detach app

EOF

# app2
ssh dany@$HOST_APP2 << EOF

sudo apt-get install git --yes
sudo apt-get install docker --yes
sudo apt-get install docker-compose --yes
sudo docker stop
sudo dockerd &
git clone https://github.com/SunForLife/healthcheck.git
cd healthcheck
sudo docker-compose up --build --force-recreate --detach app2

EOF

yc compute instance remove-one-to-one-nat db --network-interface-index 0

yc compute instance remove-one-to-one-nat app --network-interface-index 0

yc compute instance remove-one-to-one-nat app2 --network-interface-index 0

echo $HOST_NGINX
