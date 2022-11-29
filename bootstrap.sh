#!/bin/bash

if [ $(id -u) -ne 0 ]; 
  then echo "Ubuntu dev bootstrapper, APT-GETs all the things -- run as root...";
  exit 1; 
fi

apt-get update -y
apt-get upgrade -y