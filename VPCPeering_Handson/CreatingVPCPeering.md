# Hands-on VPC-03 : 

## Part 5 - Creating VPC peering between two VPCs (Default and Custom one)

## STEP 1 : Prep---> Launching Instances


- Launch two Instances. First instance will be in "clarus-az1a-private-subnet" of "clarus-vpc-a",and the other one will be in your "Default VPC". 

- In addition, since the private EC2 needs internet connectivity to set user data, we also need NAT Gateway.

### A. Configure Public Windows instance in Default VPC.

```text
AMI             : Microsoft Windows Server 2019 Base
Instance Type   : t2.micro
Network         : Default VPC
Subnet          : Default Public Subnet
Security Group  : 
    Sec.Group Name : WindowsSG
    Rules          : RDP --- > 3389 ---> Anywhere
Tag             :
    Key         : Name
    Value       : Public-Windows

PS: For MAC, "Microsoft Remote Desktop" program should be installed on the computer.
```

### B. Since the private EC2 instance needs internet connectivity to set user data, first create NAT Gateway

- Click Create Nat Gateway button in left hand pane on VPC menu

- click Create NAT Gateway.

```bash
Name                      : clarus-nat-gateway

Subnet                    : clarus-az1a-public-subnet

Elastic IP allocation ID  : Allocate Elastic IP
```
- click "Create Nat Gateway" button

### C. Modify Route Table of Private Instance's Subnet

- Go to VPC console on left hand menu and select Route Table tab

- Select "clarus-private-rt" ---> Routes ----> Edit Rule ---> Add Route
```
Destination     : 0.0.0.0/0
Target ----> Nat Gateway ----> clarus-nat-gateway
```
- click save changes

WARNING!!! ---> Be sure that NAT Gateway is in active status. Since the private EC2 needs internet connectivity to set user data, NAT Gateway must be ready.


### D. Configure Private instance in 'clarus-az1a-private-subnet' of 'clarus-vpc-a'.

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a 
Subnet          : clarus-az1a-private-subnet
user data       : 

#!/bin/bash

yum update -y
amazon-linux-extras install nginx1.12
cd /usr/share/nginx/html
chmod o+w /usr/share/nginx/html
rm index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/ken.jpg
systemctl enable nginx
systemctl start nginx

Security Group    : 
    Sec.Group Name : PrivateSG
    Rules          : SSH  ---> 22 ---> Anywhere
                     HTTP ---> 80 ---> Anywhere
                     All ICMP IPv4 ---> Anywhere
    
Tag             :
    Key         : Name
    Value       : Private-Instance
```

- Go to instance named 'Public-Windows' and hit the connect button ----> Download Remote Desktop File

- Decrypt your ".pem key" using "Get Password" button
  - Push "Get Password" button
  - Select your pem key using "Choose File" button ----> Push "Decrypt Password" button
  - copy your Password and paste it "Windows Remote Desktop" program as a "administrator password"

- Open the internet explorer of windows machine and paste the private IP of EC2 named 'Private-Instance'

- It is not able to connect to the website 


## STEP 2: Setting up Peering


- Go to 'Peering connections' menu on the left hand side pane of VPC

- Push "Create Peering Connection" button

```text
Peering connection name tag : First Peering
VPC(Requester)              : Default VPC
Account                     : My Account
Region                      : This Region (us-east-1)
VPC (Accepter)              : clarus-vpc-a
```
- Hit "Create peering connection" button

- Select 'First Peering' ----> Action ---> Accept Request ----> Accept Request

- Go to route Tables and select default VPC's route table ----> Routes ----> Edit routes
```
Destination: paste "clarus-vpc-a" CIDR blok
Target ---> peering connection ---> select 'First Peering' ---> Save routes
```

- select clarus-private-rt's route table ----> Routes ----> Edit routes
```
Destination: paste "default VPC" CIDR blok
Target ---> peering connection ---> select 'First Peering' ---> Save routes
```

- Go to windows EC2 named 'Public-Windows', write the private IP address of the Private-Instance on browser and show the website with KEN.


WARNING!!! ---> Please do not terminate "NAT Gateway" and "Private-Instance" for next part.