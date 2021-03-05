#!bin/bash

cd /home/ubuntu

sudo forever stop 0
sudo git pull origin master

cd /lib/services/
sudo forever start server.js

echo "Server started"