#!/usr/bin/env bash

INSTALL="yum install -y"
GROUP_INSTALL="yum groupinstall -y"
ENABLE_REPO="--enablerepo=epel,remi,rpmforge,nginx"
EPEL="https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
REMI="http://remi.check-update.co.uk/enterprise/remi-release-7.rpm"
RPMFORGE="http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm"

yum upgrade -y

## add repos
#
rpm -i $EPEL
rpm -i $REMI
rpm -i $RPMFORGE

yum-config-manager --enable epel
yum-config-manager --enable remi
yum-config-manager --enable rpmforge

yum install ansible -y 
