# -*- encoding: utf-8 -*-

from flask import render_template
from jinja2 import TemplateNotFound
from flask_socketio import SocketIO, emit
from flask_cors import CORS
from datetime import datetime
from app import app
import json
import random
socketio = SocketIO(app)
#uncomment below if using MongoDB for data storage
#from pymongo import MongoClient

#fill in info below and uncomment if using MongoDB; see https://www.mongodb.com/docs/manual/reference/connection-string/ for more on URI connection strings
#uri="mongodb://[username:password@]host1[:port1][,...hostN[:portN]][/[defaultauthdb][?options]]"
#client=MongoClient(uri)
#db=client.dbName
#expDat=db.expDat


#lowStart_even: low and high frequency (information content) alternating, starting with low frequency, key is 'cassock_number'
#lowStart_clumped: sorted (maximally clumped) by frequency (information content), with low frequency first (*high* informaiton content); i.e., sorted in ascending order by frequency key is 'cassock_tallow'
#highStart_even: high and low frequency (information content) alternating, starting with high frequency key is 'justice_propane'
#highStart_clumped: sorted (maximally clumped) by frequency, with high frequency (*low* information content) first; i.e., sorted in descending order by frequency key is number_money
stimLists={	
			"lowStart_even":['cassock', 'number', 'propane', 'justice', 'tallow', 'money', 'wafer', 'kernel', 'tizzy', 'power', 'vigor', 'primer', 'pauper', 'level', 'probate', 'feeling', 'radish', 'body', 'racket', 'father', 'viscount', 'water', 'galley', 'degree', 'casters', 'product', 'gallup', 'mother', 'dipper', 'market', 'ethyl', 'unit', 'chanter', 'story', 'garnet', 'advice', 'respite', 'report', 'gander', 'police', 'yonder', 'series', 'fiddler', 'basis', 'caret', 'future', 'beret', 'device', 'forage', 'project', 'realty', 'nature', 'aloe', 'title', 'beaker', 'object', 'follies', 'format', 'adder', 'letter', 'rabble', 'driver', 'foyer', 'apple', 'fable', 'party', 'dingo', 'woman', 'docket', 'model'],
			"lowStart_clumped":['cassock', 'tallow', 'tizzy', 'pauper', 'radish', 'viscount', 'casters', 'dipper', 'chanter', 'respite', 'yonder', 'caret', 'forage', 'aloe', 'follies', 'rabble', 'fable', 'docket', 'dingo', 'foyer', 'adder', 'beaker', 'realty', 'beret', 'fiddler', 'gander', 'garnet', 'ethyl', 'gallup', 'galley', 'racket', 'probate', 'vigor', 'wafer', 'propane', 'justice', 'kernel', 'primer', 'feeling', 'father', 'degree', 'mother', 'unit', 'advice', 'police', 'basis', 'device', 'nature', 'object', 'letter', 'apple', 'woman', 'model', 'party', 'driver', 'format', 'title', 'project', 'future', 'series', 'report', 'story', 'market', 'product', 'water', 'body', 'level', 'power', 'money', 'number'],
			"highStart_even":['justice', 'propane', 'number', 'cassock', 'kernel', 'wafer', 'money', 'tallow', 'primer', 'vigor', 'power', 'tizzy', 'feeling', 'probate', 'level', 'pauper', 'father', 'racket', 'body', 'radish', 'degree', 'galley', 'water', 'viscount', 'mother', 'gallup', 'product', 'casters', 'unit', 'ethyl', 'market', 'dipper', 'advice', 'garnet', 'story', 'chanter', 'police', 'gander', 'report', 'respite', 'basis', 'fiddler', 'series', 'yonder', 'device', 'beret', 'future', 'caret', 'nature', 'realty', 'project', 'forage', 'object', 'beaker', 'title', 'aloe', 'letter', 'adder', 'format', 'follies', 'apple', 'foyer', 'driver', 'rabble', 'woman', 'dingo', 'party', 'fable', 'model', 'docket'],
			"highStart_clumped":['number', 'money', 'power', 'level', 'body', 'water', 'product', 'market', 'story', 'report', 'series', 'future', 'project', 'title', 'format', 'driver', 'party', 'model', 'woman', 'apple', 'letter', 'object', 'nature', 'device', 'basis', 'police', 'advice', 'unit', 'mother', 'degree', 'father', 'feeling', 'primer', 'kernel', 'justice', 'propane', 'wafer', 'vigor', 'probate', 'racket', 'galley', 'gallup', 'ethyl', 'garnet', 'gander', 'fiddler', 'beret', 'realty', 'beaker', 'adder', 'dingo', 'foyer', 'docket', 'fable', 'rabble', 'aloe', 'follies', 'forage', 'caret', 'yonder', 'respite', 'chanter', 'dipper', 'casters', 'viscount', 'radish', 'pauper', 'tizzy', 'tallow', 'cassock']}
ratingList=['aloe', 'adder', 'beaker', 'beret', 'caret', 'cassock', 'casters', 'chanter', 'dingo', 'dipper', 'docket', 'ethyl', 'fable', 'fiddler', 'follies', 'forage', 'foyer', 'galley', 'gallup', 'gander', 'garnet', 'yonder', 'wafer', 'viscount', 'vigor', 'tallow', 'tizzy', 'realty', 'respite', 'racket', 'radish', 'rabble', 'propane', 'probate', 'pauper', 'bacon', 'badger', 'armor', 'asset', 'axis', 'baker', 'berry', 'bias', 'descent', 'elite', 'encore', 'excuse', 'expense', 'expert', 'farmer', 'fiction', 'gallon', 'garden', 'hockey', 'hobby', 'honey', 'import', 'insect', 'intent', 'jacket', 'jelly', 'jungle', 'gravel', 'latter', 'lemur', 'glasses', 'marker', 'mayor', 'mercy', 'notion', 'offense', 'panel', 'parent', 'hornet', 'rebel', 'acorn', 'alley', 'holly', 'worker', 'wizard', 'winner', 'whiskey', 'vortex', 'village', 'vapor', 'hero', 'twister', 'tutor', 'tunnel', 'surgeon', 'trio', 'tribute', 'treaty', 'trailer', 'tractor', 'timber', 'tiger', 'tactic', 'sticker', 'sterling', 'sister', 'goddess', 'resin', 'gender', 'reflex', 'number', 'water', 'party', 'model', 'market', 'body', 'report', 'nature', 'basis', 'advice', 'woman', 'unit', 'title', 'story', 'series', 'apple', 'primer', 'power', 'police', 'project', 'product', 'object', 'mother', 'money', 'level', 'letter', 'kernel', 'justice', 'future', 'format', 'feeling', 'father', 'driver', 'device', 'degree']

@app.route('/')
def index():
	try:
		return render_template('index.html',wordseq=ratingList)
	except TemplateNotFound:
		return render_template('page-404.html'), 404

@socketio.on('get stims')
def getStims():
	conditionKey=random.choice(list(stimLists))
	words=stimLists[conditionKey]
	random.shuffle(ratingList)
	participantID=''.join(random.choice('0123456789abcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXY') for i in range(20))
	now=datetime.now()
	startTime=now.strftime("%m/%d/%Y, %H:%M:%S")
	emit('catch stims',{"memoryTargets":words,"ratingTargets":ratingList,"participantID":participantID, "condition":conditionKey, "startTime":startTime})

@socketio.on('final data')
def writeData(message):
	#add endTime
	now=datetime.now()
	endTime=now.strftime("%m/%d/%Y, %H:%M:%S")
	datForWrite=message
	datForWrite["demInfo"]["endTime"]=endTime
	#write the data to a database of your choice here.
	#e.g., for MongoDB using pymongo 
	#(with MongoClient, database ,and collection expDat already declared on lines 15-19)
	#expDat.insert_one(datForWrite)
	emit('write result')

@socketio.on('connect')
def connect():
	print("Client connected to sockets for experiment.")

if __name__ == '__main__':
	socketio.run(app,debug=True,use_reloader=True)
