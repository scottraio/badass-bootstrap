# Clear the test DB before running tests
#mongoose 	= require 'mongoose'
#mongoose.connect('mongodb://localhost/pine-io-test')
#mongoose.connection.db.executeDbCommand {dropDatabase:1}, (err,result) ->
#	console.log(err); 
#	console.log(result); 

require '../app'
mock = require './mocks'

require './user_test'


