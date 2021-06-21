#!/usr/bin/env -u

#*********************************
# setup phpmyadmin to remote
# with ubuntu 20
#********************************

# transfer the phpmyadmin zip to remote
# eg:
# scp phpmyadmin-5.11.zip jrg-uat:~/backup

# extract zip 
# eg:
# unzip phpmyadmin-5.11.zip 
# move extract folder to /var/www/phpmyadmin
# eg:
#  cd /var/www/phpmyadmin

# modify phpmyadmin config
# eg:
# sudo vi /var/www/phpmyadmin/config.inc.php
# set 'Authentication type`
# // $cfg['Servers'][$i]['auth_type'] = 'cookie';
# $cfg['Servers'][$i]['auth_type'] = 'config';
# $cfg['Servers'][$i]['user'] = 'root';
# $cfg['Servers'][$i]['password'] = '';
# $cfg['Servers'][$i]['extension'] = 'mysqli';

# create a folder in /var/www
# eg:
# sudo mkdir /var/www/phpmyadmin
# create a temporary folder
# 

# secure phpmyadmin with htpasswd
# install apache2-utils
# eg:
# sudo apt-get install -y apache2-utils
## create a basic auth user at /etc/phpmyadmin
# eg:
#  sudo htpasswd -c /etc/phpmyadmin/.htpasswd phpmyadmin_user



# basic auth
# create a .htaccess at /var/www/phpmyadmin
# create a config at /etc/apache2/conf-available/phpmyadmin.conf

