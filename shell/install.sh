#!/bin/bash

###
### Prepare Environment ###
###

### Install Library ###
sudo apt-get update
sudo apt-get install openssl libtool autoconf automake uuid-dev build-essential gcc g++ software-properties-common unzip make git libcap2-bin -y

### Setup Swap ###
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab


NODE_VERSION="v14.17.6"
NODE_FILENAME="node-$NODE_VERSION-linux-x64"
PARENT_LOCATION="/opt/nodejs"

###
### Install NodeJS & PM2 ###
###

### Download NodeJS ###
cd /usr/local/src
sudo wget -nc http://nodejs.org/dist/$NODE_VERSION/$NODE_FILENAME.tar.gz
#wget -E -H -k -K -p http:///
sudo tar zxvf $NODE_FILENAME.tar.gz
sudo mkdir -p $PARENT_LOCATION
sudo mv $NODE_FILENAME $PARENT_LOCATION/

### Link binary files ###
rm -f /usr/local/bin/node
rm -f /usr/local/bin/npm
sudo ln -s $PARENT_LOCATION/$NODE_FILENAME/bin/node /usr/local/bin
sudo ln -s $PARENT_LOCATION/$NODE_FILENAME/bin/npm /usr/local/bin

### assign 80 & 443 port ###
sudo setcap 'cap_net_bind_service=+ep' $PARENT_LOCATION/$NODE_FILENAME/bin/node

### Install PM2 ###
sudo npm i -g pm2
sudo ln -s $PARENT_LOCATION/$NODE_FILENAME/bin/pm2 /usr/local/bin

### Deploy
mkdir $HOME/workspace
cd $HOME/workspace
git clone https://github.com/Luphia/ecProxy
cd ecProxy
npm i
pm2 start . --name ecProxy
