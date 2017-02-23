#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on
sudo groupadd www
sudo usermod -a -G www ec2-user
sudo chown -R ec2-user:ec2-user /var/www
sudo chmod 2775 /var/www 
echo "<html><h1>Hello</h1></html>" > /var/www/html/index.html
sudo find /var/www -type d -exec chmod 2775 {} +
sudo find /var/www -type f -exec chmod 0664 {} +
