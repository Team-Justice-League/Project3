#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
aws s3 cp s3://justice-league-bucket/index.html /var/www/html/index.html
sudo systemctl start httpd
availabilityZone=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
sudo sed -i "s/_AZ_/$availabilityZone/1" /var/www/html/index.html
instanceID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
sudo sed -i "s/_instanceID_/$instanceID/1" /var/www/html/index.html