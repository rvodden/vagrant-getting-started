#!/bin/sh

echo "Installing puppet server:"

/bin/yum -d 0 -e 0 -y install puppetserver

echo "Starting the puppet server:"

service puppetserver start
