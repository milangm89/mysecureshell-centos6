#!/bin/bash
# Author :

# Copying mysecureshell repo file
cp -r ./mysecureshell.repo /etc/repos.d/mysecureshell.repo

# Installing mysecureshell
yum install -y mysecureshell

# Making required changes in ssh config file
echo " Making required changes in sshd config file \n"
echo " Copying current ssh config file as backup \n"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config-`date +"%Y%m%d_%H%M%S"`
sed -i '/Subsystem/s/^/#/g' /etc/ssh/sshd_config
echo "Subsystem sftp /bin/MySecureShell -c sftp-server" >> sshd_configsed -i '/Subsystem/s/^/#/g' sshd_config

l=`grep -n "AddressFamily" /etc/ssh/sshd_config | awk '{print $1}' | cut -d : -f 1`
