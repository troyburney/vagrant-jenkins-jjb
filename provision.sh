#!/bin/bash

VAGRANT_HOST_DIR=/mnt/host_machine

########################
# Jenkins & Java
########################
echo "Installing Jenkins and Java"
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update > /dev/null 2>&1
sudo apt-get -y install default-jdk jenkins > /dev/null 2>&1
echo "Installing Jenkins default user and config"
sudo cp $VAGRANT_HOST_DIR/JenkinsConfig/config.xml /var/lib/jenkins/
sudo mkdir -p /var/lib/jenkins/users/admin
sudo cp $VAGRANT_HOST_DIR/JenkinsConfig/users/admin/config.xml /var/lib/jenkins/users/admin/
sudo chown -R jenkins:jenkins /var/lib/jenkins/users/


########################
# nginx
########################
echo "Installing nginx"
sudo apt-get -y install nginx > /dev/null 2>&1
sudo service nginx start


########################
# Configuring nginx
########################
echo "Configuring nginx"
cd /etc/nginx/sites-available
sudo rm default ../sites-enabled/default
sudo cp /mnt/host_machine/VirtualHost/jenkins /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
sudo service nginx restart
sudo service jenkins restart


########################
# Configuring JJB
########################
echo "Installing Jenkins Job Builder"

sudo apt-get install -y python-pip
sudo pip install --upgrade pip

sudo pip install jenkins-job-builder


########################
# Configuring Aliases
########################
someFile=/etc/profile.d/00-aliases.sh

touch $someFile
chmod 755 $someFile

echo "alias jenkins-job='jenkins-jobs'" >> $someFile
echo "alias jjb='jenkins-jobs'" >> $someFile
echo "alias JJB='jenkins-jobs'" >> $someFile

source $someFile


########################
# Configuring JJB ini
########################
jjbConfigDir=/etc/jenkins_jobs/
jjbConfigFile=jenkins_jobs.ini

mkdir $jjbConfigDir
touch $jjbConfigDir$jjbConfigFile
sudo cp /mnt/host_machine/JenkinsConfig/$jjbConfigFile $jjbConfigDir$jjbConfigFile

cat $jjbConfigDir$jjbConfigFile


########################
# Add jobs using JJB
########################
cd /mnt/host_machine/
jenkins-jobs update jobs


########################
# Signal success
########################
echo "Success"

