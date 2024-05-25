#!/bin/bash

sudo apt update
sudo apt upgrade

#install nginx
sudo apt install nginx

#start nginx
sudo systemctl start nginx

#status nginx
sudo systemctl status nginx
