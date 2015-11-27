#!/bin/sh


echo -e "Using Packer to build machine"

packer build template.json
retval=$?
if [ $retval -ne 0 ]; then
    echo "Packer exited with non-zero return code ($retval). Aborting."
    exit retval
fi


echo -e "Importing box into Vagrant"

vagrant box add centos-7-1-x64-nexus-virtualbox.box --name=centos-nexus --force

retval=$?
if [ $retval -ne 0 ]; then
    echo "Vagrant exited with non-zero return code ($retval). Aborting."
    exit retval
fi
echo -e "Importing setting up vagrant environment"

vagrant init centos-nexus

retval=$?
if [ $retval -ne 0 ]; then
    echo "Vagrant exited with non-zero return code ($retval). Aborting."
    exit retval
fi

echo -e "Starting up environment"

vagrant up

