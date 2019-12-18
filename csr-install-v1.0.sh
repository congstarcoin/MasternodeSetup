#!/bin/bash

echo -e "\n\nupdate & prepare system ...\n\n"
sudo apt-get update -y &&
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y &&
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y 

sudo apt-get install nano htop git -y


sudo apt-get install unzip -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config -y
sudo apt-get install libssl-dev libevent-dev bsdmainutils -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install libzmq5-dev -y
sudo apt-get install libboost-all-dev -y

sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

echo -e "\n\nsetup csrd ...\n\n"

cd ~

version=`lsb_release -r | awk '{print $2}'`
echo "ubuntu version : "\n
echo $version

mkdir /root/csr
mkdir /root/.csr

cd /root/csr

wget https://github.com/congstarcoin/congstar-core/releases/download/v1.0/csr-cli
sleep 5
wget https://github.com/congstarcoin/congstar-core/releases/download/v1.0/csrd
sleep 5
chmod -R 755 ./*

sleep 5

chmod -R 755 /root/csr
chmod -R 755 /root/.csr

echo -e "\n\nlaunch csrd ...\n\n"
sudo apt-get install -y pwgen
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`

echo -e "rpcuser=csruser\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=256\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}:53266\nstaking=1" > /root/.csr/csr.conf
cd /root/csr
./csrd
sleep 40
masternodekey=$(./csr-cli masternode genkey)
./csr-cli stop

# add launch after reboot
crontab -l > tempcron
echo "@reboot /root/csr/csrd -reindex >/dev/null 2>&1" >> tempcron
crontab tempcron
rm tempcron

echo -e "masternode=1\nmasternodeprivkey=$masternodekey\n\n\n" >> /root/.csr/csr.conf

sleep 10

./csrd -reindex
cd /root/.csr
ufw allow 53266

# output masternode key
echo -e "${IP_ADD}:53266"
echo -e "Masternode private key: $masternodekey"
echo -e "Welcome to the CSR Masternode Network!"
