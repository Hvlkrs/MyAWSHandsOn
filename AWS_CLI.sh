AWS_CLI


# References
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/index.html  #commands documentation
# https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/



# Installation

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Win:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Mac:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# https://graspingtech.com/install-and-configure-aws-cli/


# Linux:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip  #install "unzip" if not installed
sudo ./aws/install

#1-Firstly install CLI

#2- Configuration(We need IAM user credentials)

aws configure
#3-Go to console-->Security credentials; if you do not have credentials on your local you have to create new IAM user

cat .aws/config
cat .aws/credentials

aws configure --profile user1 #We can configure other users

export AWS_PROFILE=user1
export AWS_PROFILE=default

aws configure list-profiles

aws sts get-caller-identity

# IAM
aws iam list-users

aws iam create-user --user-name aws-cli-user

aws iam delete-user --user-name aws-cli-user


# S3
aws s3 ls

aws s3 mb s3://hivel-cli-demo #create a bucket
# My output:
# make_bucket: hivel-cli-demo

aws s3 cp in-class.yaml s3://hivel-cli-demo #copy in-class.yaml file into bucket

aws s3 ls s3://hivel-cli-demo

aws s3 rm s3://hivel-cli-demo/in-class.yaml #remove in-class.yaml file from the bucket

aws s3 rb s3://hivel-cli-demo #remove bucket
aws s3 ls #shows the bucket is removed



--------------------------------------------------------------------------------------------------

# Update AWS CLI Version 1 on Amazon Linux (comes default) to Version 2
# Go to console launch instance(ssh)
# 1-Remove AWS CLI Version 1
aws --version #we will see cli 1
sudo yum remove awscli -y # pip uninstall awscli/pip3 uninstall awscli might also work depending on the image

# 2- Install AWS CLI Version 2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip  #install "unzip" if not installed
sudo ./aws/install

#3- Update the path accordingly if needed
export PATH=$PATH:/usr/local/bin/aws
aws --version



# EC2
aws ec2 describe-instances # we can see instances with details
# My output :
Reservations:
- Groups: []
  Instances:
  - AmiLaunchIndex: 0
    Architecture: x86_64
    BlockDeviceMappings:
    - DeviceName: /dev/xvda
      Ebs:
        AttachTime: '2022-06-11T08:16:09+00:00'  #Enter for more details, to exit with wq



aws ec2 run-instances \ #we can create instance
   --image-id ami-0022f774911c1d690 \
   --count 1 \
   --instance-type t2.micro \
   --key-name KEY_NAME_HERE # put here your key name without .cer or .pem


aws ec2 describe-instances \ 
   --filters "Name = key-name, Values = KEY_NAME_HERE" # put your key name; documentetion: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-instances.html

aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress[]"

aws ec2 describe-instances \
   --filters "Name = key-name, Values = KEY_NAME_HERE" --query "Reservations[].Instances[].PublicIpAddress[]" # put your key name

aws ec2 describe-instances \
   --filters "Name = instance-type, Values = t2.micro" --query "Reservations[].Instances[].InstanceId[]"


# Working with the latest Amazon Linux AMI
# https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/


aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1
# My output:
ARN: arn:aws:ssm:us-east-1::parameter/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2
  DataType: text
  LastModifiedDate: '2022-05-02T22:40:38.636000+02:00'
  Name: /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2
  Type: String
  Value: ami-06eecef118bbf9259
  Version: 69


aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text

aws ec2 run-instances \ #Pulls the latest ami automatically
   --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 
'Parameters[0].[Value]' --output text) \
   --count 1 \
   --instance-type t2.micro

# We can get ami with !Ref function, !Ref LatestAmi


aws ec2 stop-instances --instance-ids INSTANCE_ID_HERE # put your instance id(i-069d0beca80a357c8), we can stop instance from terminal

aws ec2 terminate-instances --instance-ids INSTANCE_ID_HERE # put your instance id, we can terminate instance from terminal

