
# import os
# from flask import Flask, render_template, abort, url_for, json, jsonify
# import json

# app = Flask(__name__, template_folder='.')

# # read file
# with open('db.json', 'r') as myfile:
    # data = myfile.read()

# @app.route("/")
# def index():
    # return render_template('index.html', title="page", jsonfile=json.dumps(data))


# if __name__ == '__main__':
    # app.run(debug=True, host='0.0.0.0')


# ------------------------------------------------------------------------------
# https://www.educative.io/blog/python-flask-tutorial

from flask import Flask            # import flask modules

app = Flask(__name__)              # create a flask object

@app.route("/")                    # assign a url route
def home():                        # create a view function and return a response
    return "Welcome to the HomePage!"

@app.route("/educative")
def learn():
    return "Happy Learning at Educative!"


if __name__ == "__main__":         # run the application in main
    app.run(debug = True, host = "0.0.0.0", port = 5002)

# ------------------------------------------------------------------------------
