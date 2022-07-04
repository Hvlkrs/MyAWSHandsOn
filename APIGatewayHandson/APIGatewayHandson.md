## Part 3 - Create a Lambda Function with API Gateway


STEP 1: Create Lambda Function

- Go to Lambda Service on AWS Console

- Functions ----> Create Lambda function
```text
1. Select Author from scratch
  Name: RandomCityGenerator
  Runtime: Python 3.9
  Role: Create a new role with basic Lambda permissions
  Click 'Create function'
```

- Configuration of Function Code

- In the sub-menu of configuration go to the "Function code section" and paste code seen below

```python
from __future__ import print_function
from random import randint

print('Loading function')

def lambda_handler(event, context):
    myNumber = randint(0,8)
    mylist = ['Berlin', 'London', 'Athens', 'New York', 'Istanbul', 'Ankara', 'Brussels','Paris','CapeTown']
    return mylist[myNumber]

```
- Click "DEPLOY" button




STEP 2: Testing your function - Create test event

Click 'Test' button and opening page Configure test events
```
Select: Create new test event
Event template: Hello World
Event name: emptyClarus
Input test event as;

{}

Click 'Create'
Click 'Test'
```
You will see the message Execution result: succeeded(logs) and a random city in a box with a dotted line.


STEP 3 : Create New 'API'

- Go to API Gateway on AWS Console

- Click "Create API"

- Select REST API ----> Build
```

Choose the protocol : REST
Create new API      : New API
Settings            :

  - Name: FirstAPI
  - Description: test first api
  - Endpoint Type: Regional
  - Click 'Create API'
```

STEP 4 : Exposing Lambda via API Gateway

1. Add a New Child Resource

- APIs > FirstAPI > Resources > /

- Click on Actions > 'Create Resource'

   New Child Resource
  - Configure as proxy resource: Leave blank
  - Resource Name: city
  - Resource Path: /city (it has automatically appear)
  - Enable API Gateway CORS: Yes
  - Click 'Create Resource' button

2. Add a GET method to resource /city

- Actions > Create Method

- Under the resource a drop down will appear select GET method and click the 'tick'.

3. / GET - Method Execution
```
  - Integration type: Lambda Function
  - Use Lambda Proxy integration: Leave blank
  - Lambda Region: us-east-1
  - Lambda Function: RandomCityGenerator
  - Click 'Save'
  - Confirm the dialog 'Add Permission to Lambda Function', Click 'OK'
```

STEP 5: Testing Lambda via API Gateway

- Click GET method under /city

- Click TEST link in the box labeled 'Client At the bottom of the new view Click 'Test' button

- Under Response Body you should see a random city. Click the blue button labelled 'Test' again at the bottom of the screen and you will see a new city appear.

- Test completed successfully

STEP 6 : Deploy API

- Click Resources select /city

- Select Actions and select Deploy API
```
Deployment stage: [New Stage]
Stage Name: dev
```

- it can be seen invoke URL on top like;
"https://b8pize8i6e.execute-api.us-east-1.amazonaws.com/dev" and note it down somewhere.

- Entering the Invoke URL into the web browser adding "/city"and show the generated city with refreshing the page in the web browser.