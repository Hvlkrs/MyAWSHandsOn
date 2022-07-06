import boto3

# Use Amazon S3
s3 = boto3.resource('s3')

# Upload a new file
data = open('README.md', 'rb')
s3.Bucket('hivel-boto3-bucket').put_object(Key='README.md', Body=data)