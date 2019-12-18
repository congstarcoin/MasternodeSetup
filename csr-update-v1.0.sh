#!/bin/bash

echo -e "\n\nupdate csrd ...\n\n"
cd /root/csr
./csr-cli stop
sleep 10

rm /root/csr/csrd
rm /root/csr/csr-cli

sleep 1 

wget https://github.com/congstarcoin/congstar-core/releases/download/v1.0/csr-cli

sleep 5

wget https://github.com/congstarcoin/congstar-core/releases/download/v1.0/csrd

sleep 5

chmod -R 755 /root/csr/*

echo -e "\n\nlaunch csrd ...\n\n"
./csrd -reindex

echo "csr Daemon Updated"
