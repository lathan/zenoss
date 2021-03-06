#!/bin/bash
#######################################################
# Version: 01b                                        #
#  Status: Functional                                 #
#######################################################

read -p "Please verify that zenoss is not currently running! Press ctrl+c to cancel if needed..."

# Installer variables
## Home path for the zenoss user
zenosshome="/home/zenoss"
## Download Directory
downdir="/tmp"
## DEB Version
debver="02a"
## Zenoss Variables
. $zenosshome/zenoss424-srpm_install/variables.sh

# Install FPM
if [ -f /usr/local/bin/fpm ]
	then
		echo "...Skipping fpm installation"
	else
		apt-get install rubygems -y
		gem install fpm
fi

# MySQL Dump
mysqldump -u root zenoss_zep > $zenosshome/zenoss_zep.sql
mysqldump -u root zodb > $zenosshome/zodb.sql
mysqldump -u root zodb_session > $zenosshome/zodb_session.sql

# Cleanup 
rm -fr $zenosshome/zenoss424-srpm_install/zenoss_core-4.2.4
rm -fr $zenosshome/zenoss424-srpm_install/*.rpm
rm -fr $zenosshome/zenoss424-srpm_install/*.tar
rm -fr $zenosshome/zenoss424-srpm_install/*.spec
rm -fr $zenosshome/zenoss424-srpm_install/rrdtool-1.4.7 

# Build Deb
echo "...Building DEB"
fpm -n zenoss-core_424-1897 -v $debver -s dir -t deb $zenosshome /usr/local/zenoss

echo "...Script Complete"
exit 0
