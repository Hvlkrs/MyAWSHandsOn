# Hands-on Lambda-01 : Lambda Function and API Gateway.

The topics for this hands-on session will be AWS Lambda, function as a service (FaaS). During this Playground we will create two AWS S3 Buckets and using AWS Lambda to synchronize them. In addition, We will show the association between Lambda and API Gateway.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Create a S3 bucket.

- Create Lambda Function

- Trigger the Lambda Function with S3 Bucket

- Create a lambda function, that generates a random city and trigger it with API Gateway.



## Outline

- Part 1 - Prep - Creating AWS S3 Bucket

- Part 2 - Creating a Lambda Function and Setting a Trigger Event

- Part 3 - Create a Lambda Function with API Gateway



## Part 1 - Prep - Creating a S3 Bucket

STEP 1 : Prep - Creating S3 Bucket

- Go to S3 menu using AWS console

- Create a bucket of `clarusway.source.lambda` with following properties,

```text
Bucket name                 : clarusway.source.lambda
Region                      : N.Virginia
Block all public access     : Checked (KEEP BlOCKED)
Versioning                  : Disabled
Tagging                     : 0 Tags
Default encryption          : None
Object-level logging        : Disabled
```
PS: Please, do not forget to select "US East (N.Virginia)" as Region

- Create another bucket of `clarusway.destination.lambda` with following properties,

```text
Bucket name                 : clarusway.destination.lambda
Region                      : N.Virginia
Block all public access     : Checked (KEEP BlOCKED)
Versioning                  : Disabled
Tagging                     : 0 Tags
Default encryption          : None
Object-level logging        : Disabled
```

PS: Please, do not forget to select "US East (N.Virginia)" as Region


## Part 2 - Create a Lambda Function and Trigger Event

STEP 1: Create IAM Role:

Go to IAM page.

- Go to `Roles` on the left hand menu and click `create role`.

```text
Type of Trusted Entity      : AWS Service
Use Case                    : Lambda
Permissions                 : AmazonS3FullAccess 
Name:                       : Lambda.S3.Replica
```

STEP 2: Create Lambda Function

- Go to Lambda Service on AWS Console

- Functions ----> Create Lambda function
```text
1. Select Author from scratch
  Name: s3Synchronize
  Runtime: Python 3.9
  Role: Lambda.S3.Replica
  
```

STEP 3: Setting Trigger Event

- Go to Configuration sub-menu and click AddTrigger on Designer  
```
Trigger Configuration : S3

- Bucket              : clarusway.source.lambda

- Event Type          : All object create events

- Acknowledge         : checked
```

STEP 4: Create Function Code

- Go to the Function Code sub-menu and paste code seen below:

```python
import json
import boto3

# boto3 S3 initialization
s3_client = boto3.client("s3")


def lambda_handler(event, context):
   destination_bucket_name = 'clarusway.destination.lambda'

   # event contains all information about uploaded object
   print("Event :", event)

   # Bucket Name where file was uploaded
   source_bucket_name = event['Records'][0]['s3']['bucket']['name']

   # Filename of object (with path)
   file_key_name = event['Records'][0]['s3']['object']['key']

   # Copy Source Object
   copy_source_object = {'Bucket': source_bucket_name, 'Key': file_key_name}

   # S3 copy object operation
   s3_client.copy_object(CopySource=copy_source_object, Bucket=destination_bucket_name, Key=file_key_name)

   return {
       'statusCode': 200,
       'body': json.dumps('Hello from S3 events Lambda!')
   }
```

- Click "DEPLOY" button

STEP 5: Testing S3 Bucket Synchronization


- Go to S3 Bucket Service

- Select S3 bucket named 'clarusway.source.lambda'

- Upload any files to source bucket

- Go to the S3 bucket named 'clarusway.destination.lambda' and show the uploaded files to the source bucket.

- You can show some other functions if have enough time (Optional)


- Example 2: 

```python
from __future__ import print_function
from random import randint
print('Loading function')
def lambda_handler(event, context):
    myNumber = randint(1,3999)
    number = myNumber
    roman = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I']
    sayi = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    romanvalue = ""
    for i, d in enumerate(sayi):
        while (myNumber >= d):
            myNumber -= d
            romanvalue += roman[i]
    return f'Roman Representation of the {number} is {romanvalue}'

```

For testing: 

{
 
}


- Example 3: 

```python

def lambda_handler(event, context):
 roman = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I']
 sayi = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
 romanvalue = ""
 for i, d in enumerate(sayi):
   while (event['num'] >= d):
      event['num'] -= d
      romanvalue += roman[i]
 return romanvalue
```

For testing: 

{
  "num": 2546
}


