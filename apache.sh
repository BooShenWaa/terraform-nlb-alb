#!/bin/bash -xe
cd /tmp
yum update -y
yum install -y httpd
echo "Hello from the EC2 instance" > /var/www/html/index.html
systemctl start httpd