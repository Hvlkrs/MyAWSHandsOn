# Import Flask modules
from flask import Flask, render_template, request
# Create an object named app
app = Flask(__name__)


# create a function named "lcm" which calculates a least common multiple values of two numbers. 
def GreatestNum(input1,input2,input3,input4,input5):
    
    if (input1 >= input2) and (input1 >= input3) and (input1 >= input4) and (input1 >= input5):
     yourlargestnum = input1
    elif (input2 >= input1) and (input2 >= input3) and (input2 >= input4) and (input2 >= input5):
     yourlargestnum = input2
    elif (input3 >= input1) and (input3 >= input2) and (input3 >= input4) and (input3 >= input5):
     yourlargestnum = input3
    elif (input4 >= input1) and (input4 >= input2) and (input4 >= input3) and (input4 >= input5):
     yourlargestnum = input4
    else:
     yourlargestnum = input5
    return yourlargestnum



# Create a function named `index` which uses template file named `index.html` 
# send two numbers as template variable to the app.py and assign route of no path ('/') 
@app.route("/")
def index():
    return render_template("index.html", methods=["GET"])




# calculate sum of them using "lcm" function, then sent the result to the 
# "result.hmtl" file and assign route of path ('/calc'). 
# When the user comes directly "/calc" path, "Since this is a GET request, LCM has not been calculated" string returns to them with "result.html" file
@app.route("/calc", methods=["GET", "POST"])
def calculate():
    if request.method == "POST":
        input1 = request.form.get("number1")
        input2 = request.form.get("number2")
        input3 = request.form.get("number3")
        input4 = request.form.get("number4")
        input5 = request.form.get("number5")
        return render_template("result.html", GreatestNum = GreatestNum(int(input1),int(input2),int(input3),int(input4),int(input5)),developer_name = 'Hivel')
    else:
        return render_template("result.html", developer_name = "Krasniqi")

# Add a statement to run the Flask application which can be debugged.
if __name__== "__main__":
    app.run(debug=True)