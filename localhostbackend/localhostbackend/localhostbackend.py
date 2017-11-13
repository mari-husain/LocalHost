#!flask/bin/python
import os
import sqlite3
from flask import Flask, jsonify, abort, make_response, url_for, request
from flask import request, session, g, redirect, abort, render_template, flash 
from flask_httpauth import HTTPBasicAuth

app = Flask(__name__) # create the application instance
auth = HTTPBasicAuth() # a simple authentication tool

app.config.from_object(__name__) # load configs from this file - localhostbackend.py


# #
# Database methods
# #

# load default configs and override configs from an environment variable
app.config.update(dict(
	DATABASE = os.path.join(app.root_path, 'localhostbackend.db'),
	SECRET_KEY = 'imasecretkey',
	USERNAME = 'admin',
	PASSWORD = 'default2'
))
app.config.from_envvar('LOCALHOST_SETTINGS', silent = True)

# connect to the specific databse
def connect_db():
	rv = sqlite3.connect(app.config['DATABASE'])
	rv.row_factory = sqlite3.Row 
	return rv

# in lieu of a database, we will define a static array of users for now.
users = [
	{
		'id': 1,
		'name': u'Mari',
		'location': u'New York'
	},
	{
		'id': 2,
		'name': u'Eric',
		'location': u'LA'
	},
	{
		'id': 3,
		'name': u'Andrew',
		'location': u'Palo Alto'
	}
]

# #
# Helper Functions
# #

# make a public version of the user including a uri in place of the id
def make_public_user(user):
	new_user = {}
	for field in user:
		if field == 'id':
			new_user['uri'] = url_for('get_user', user_id=user['id'], _external = True)
		else:
			new_user[field] = user[field]

	return new_user

# #
# Authentication
# #

@auth.get_password
def get_password(username):
	if username == "Mari":
		return "python"
	return None

@auth.error_handler
def unauthorized():
	return make_response(jsonify({'error': 'Unauthorized access'}), 401)

# #
# Error Handling
# #

# map a 404 not found response to error message JSON
@app.errorhandler(404)
def not_found(error):
	return make_response(jsonify({'error': 'Not Found'}), 404)

# map a 403 unauthorized access response to error message JSON
def unauthorized():
	return make_response(jsonify({'error: Unauthorized access'}), 403)

# #
# Mappings of urls to functions
# #

# get a list of all users
@app.route('/localhost/api/v0.1/users', methods=['GET'])
#@auth.login_required
def get_users():
	return jsonify({'users': [make_public_user(user) for user in users]})

# add a new user
@app.route('/localhost/api/v0.1/users', methods=['POST'])
@auth.login_required
def create_user():
	if not request.json or not 'name' in request.json or not 'location' in request.json:
		abort(400)
	user = {
		'id': users[-1]['id'] + 1,
		'name': request.json['name'],
		'location': request.json['location']
	}
	users.append(user)
	return jsonify({'user': make_public_user(user)}), 201

# modify an existing user
@app.route('/localhost/api/v0.1/users/<int:user_id>', methods=['PUT'])
@auth.login_required
def update_user(user_id):
	user = [user for user in users if user['id'] == user_id] # get user by user id
	if len(user) == 0:
		abort(400)
	if not request.json:
		abort(400)
	if 'name' in request.json: 
		if type(request.json['name']) != str:
			abort(400) 
		user[0]['name'] = request.json.get('name', user[0]['name'])
	if 'location' in request.json:
		if type(request.json['location']) != str:
			user[0]['location'] = request.json.get('location', user[0]['location'])

	return jsonify({'user': make_public_user(user[0])})

# delete an existing user
@app.route('/localhost/api/v0.1/users/<int:user_id>', methods=['DELETE'])
@auth.login_required
def delete_user():
	user = [user for user in users if user['id'] == user_id] # get user by user id
	if len(user) == 0:
		abort(400)
	users.remove(user[0])
	return jsonify({'result': True})

# get user by user id
@app.route('/localhost/api/v0.1/users/<int:user_id>', methods=['GET'])
#@auth.login_required
def get_user(user_id):
	user = [user for user in users if user['id'] == user_id] # get user by user id
	if len(user) == 0:
		abort(404)
	return jsonify({'user': make_public_user(user[0])})

if __name__ == "__main__":
	# start the webserver
	app.run(debug=True)