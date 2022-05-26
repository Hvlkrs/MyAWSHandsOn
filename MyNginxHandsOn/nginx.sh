# Hands-on EC2-02 : How to Install Nginx Web Server on EC2 Linux 2

Purpose of the this hands-on training is to give the students basic knowledge of how to install Nginx Web Server on Amazon Linux 2 EC2 instance.

## What i learned

- demonstrate my knowledge of how to launch AWS EC2 Instance.

- establish a connection with AWS EC2 Instance with SSH.

- install the Nginx Server on Amazon Linux 2 Instance.

- configure the Nginx Server to run simple HTML page.

- write a simple bash script to run the Web Server

- automate the process of installation and configuration of a Web Server using the `user-data` script of EC2 Instance.

## Outline

- Part 1 - Launching an Amazon Linux 2 EC2 instance and Connect with SSH

- Part 2 - Installing and Configuring Nginx Web Server to Run a Simple Web Page

- Part 3 - Automation of Web Server Installation through Bash Script

## Part 1 - Launching an Amazon Linux 2 EC2 instance and Connect with SSH

-1.  Launch an Amazon 2 (one for spare)EC2 instance with AMI as `Amazon Linux 2`, instance type as `t2.micro` and default VPC security group which allows connections from anywhere and any port.

0. Connect to your instance with SSH.

#First on the terminal i went to my pem file 
#Copy public ipv4 address in the created instance
#I will use .cer because of my mac but if you use windows or somethingelse you have to use .pem

ssh -i "PrivatePirate.cer" ec2-user@3.83.99.182

#Result:
#Are you sure you want to continue connecting (yes/no/[fingerprint])? ssh -i "PrivatePirate.cer" ec2-user@3.83.99.182
#Please type 'yes', 'no' or the fingerprint: yes
#Warning: Permanently added '3.83.99.182' (ECDSA) to the list of known hosts.


## Part 2 - Installing and Configuring Nginx Web Server to Run a Simple Web Page

1. Update the installed packages and package cache on my instance.

sudo yum update -y

2. Install the Nginx Web Server.

sudo amazon-linux-extras install nginx1
#After finishing write y and enter

3. Start the Nginx Web Server.

sudo systemctl start nginx
#We can check the status, is it active or not
sudo systemctl status nginx

4. Check from browser with public IP/DNS
#There was nothing, so i realized i have to check security group settings and i saw i just added ssh port 22 and then i added http port 80

5. Go to /usr/share/nginx/html folder.

cd /usr/share/nginx/html

6. Show content of folder and change the permissions of /usr/share/nginx/html

ls

#permisson for index.html -R acts on both files and directories

sudo chmod -R 777 /usr/share/nginx/html

7. Remove existing `index.html`.

sudo rm index.html
#if i write ls i will see there is no index.html

8. Upload new txt as `index.html` and new image as `ken.jpg` files with `wget` command. Show the github and explain the RAW.

wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/ken.jpg

9. restart the Nginx Web Server.

sudo systemctl restart nginx

10. configure to start while launching

sudo systemctl enable nginx

#i wanted to see what is inside of index.html

cat index.html

11. Check if the Web Server is working properly from the browser.
#I saw the text and image

12. to add another content change the permissions of folder /usr/share/nginx/html.(If you have /'/'not before)

sudo chmod -R 777 /usr/share/nginx/html

13. Add another index.html file 

echo "Second Page" > /usr/share/nginx/html/index_2.html

14. On the web browser add "/index_2.html" at the end of the the public DNS 

http://3.83.99.182/index_2.html

#And i saw the second page text on the screen

## Part 3 - Automation of Web Server Installation through Bash Script (User data)

15. Configure an Amazon EC2 instance with AMI as `Amazon Linux 2`, instance type as `t2.micro`, default VPC security group which allows connections from anywhere and any port.

16. Configure instance to automate web server installation with `user data` script. 

#When i launched an instance and reached the User data under the Advanced Details and paste the following code. Then launch instance


#! /bin/bash

yum update -y
amazon-linux-extras install nginx1
systemctl start nginx
cd /usr/share/nginx/html
chmod -R 777 /usr/share/nginx/html
rm index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/ken.jpg
systemctl restart nginx
systemctl enable nginx

#I used Public IPv4 DNS in the instance it gives same result Public IPv4 address

17. Review and launch the EC2 Instance

18. Once Instance is on, check if the Nginx Web Server is working from the web browser.

19. Connect the Nginx Web Server from the terminal with `curl` command. Copy public IPv4 DNS in the instance. We can check the connection is working.

curl ec2-3-83-99-182.compute-1.amazonaws.com 