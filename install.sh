#!/bin/bash
# Author : Milan George
# version 1.01

# Copying mysecureshell repo file
cp -r ./mysecureshell.repo /etc/yum.repos.d/mysecureshell.repo

# Installing mysecureshell and necessary packages
echo "============================"
echo "Installing necessay packages"
echo "============================"
yum --enablerepo=mysecureshell -y install mysecureshell expect

# Making required changes in ssh config file
echo "============================"
echo -e "Making required changes in sshd config file \n"
echo -e "Copying current sshd config file as backup \n"
echo "============================"
#cp /etc/ssh/sshd_config /etc/ssh/sshd_config_orig
cp /etc/ssh/sshd_config /etc/ssh/sshd_config-$(date +"%Y%m%d_%H%M%S")
cp -rf ./sshd_config /etc/ssh/sshd_config

echo "============================"
echo -e "Copying sftp config file . . \n"
echo "============================"
#cp /etc/ssh/sftp_config /etc/ssh/sftp_config_orig
cp /etc/ssh/sftp_config /etc/ssh/sftp_config-$(date +"%Y%m%d_%H%M%S")
cp -rf ./sftp_config /etc/ssh/sftp_config

echo "============================"
echo -e "Creating sftp group and user. . \n"
echo "============================"
groupadd sftp_users
useradd -m -d /var/www/html -s /bin/MySecureShell sftpuser

pwd_sftp=$(mkpasswd -l 16)
echo "$pwd_sftp" | passwd sftpuser --stdin
#echo "ftpuser:$pwd_sftp" | chpasswd 

echo "Restarting services"
/etc/init.d/sshd restart

echo "============================"
echo "Changing ownership of /var/www/html to apache"
echo "============================"
chown -R apache:apache /var/www/html/

echo -e " The username is : sftpuser \nand the password is : $pwd_sftp "
