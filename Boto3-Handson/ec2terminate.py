import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('i-0a196e9fe7c27ef1e').terminate()