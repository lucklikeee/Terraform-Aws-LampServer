#!/bin/bash
sudo dnf update -y
sudo dnf install httpd httpd-tools y
sudo systemctl enable httpd
sudo dnf install mysql-server mysql -y
systemctl start mysqld
systemctl enable mysqld
sudo dnf module enable php:8.0 -y
sudo dnf install php php-common php-opcache php-cli php-gd php-curl php-mysqlnd -y
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
sudo systemctl start httpd
sudo echo '<?php phpinfo (); ?>' >> /var/www/html/index.php
