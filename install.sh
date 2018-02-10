#!/bin/bash
# Author : Milan George

# Copying mysecureshell repo file
cp -r ./mysecureshell.repo /etc/yum.repos.d/mysecureshell.repo

# Installing mysecureshell
yum install -y mysecureshell

# Making required changes in ssh config file
echo " Making required changes in sshd config file \n"
echo " Copying current ssh config file as backup \n"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_orig
cp /etc/ssh/sshd_config /etc/ssh/sshd_config-`date +"%Y%m%d_%H%M%S"`
cp -rf ./sshd_config /etc/ssh/sshd_config

#sed -i '/Subsystem/s/^/#/g' /etc/ssh/sshd_config
#echo "Subsystem sftp /bin/MySecureShell -c sftp-server" >> sshd_configsed -i '/Subsystem/s/^/#/g' sshd_config

#l=`grep -n "AddressFamily" /etc/ssh/sshd_config | awk '{print $1}' | cut -d : -f 1`

echo "Copying sftp config file . . \n"
cp /etc/ssh/sftp_config /etc/ssh/sftp_config_orig
cp /etc/ssh/sftp_config /etc/ssh/sftp_config-`date +"%Y%m%d_%H%M%S"`
cp -rf ./sftp_config /etc/ssh/sftp_config

echo "Creating sftp group and user. . \n"
groupadd sftp_users
useradd -m -d /var/www/html/ -s /bin/MySecureShell ftpuser

echo "Installing mkpasswd"
yum install expect -y

pwd_sftp=`mkpasswd -l 15`
echo "$pwd_sftp" | passwd ftpuser --stdin
#echo "ftpuser:$pwd_sftp" | chpasswd 

echo "Restarting services"
/etc/init.d/sshd restart

echo "Changing ownership of /var/www/html to apache"
chown -R apache:apache /var/www/html

echo " The username is : ftpuser and the password is : $pwd_sftp "
