#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start
echo "<h1>this is {{BRANCH_NAME}} application with default version</h1>" | sudo tee /var/www/html/index.html