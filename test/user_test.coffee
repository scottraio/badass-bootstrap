should  	= require 'should'
Browser		= require 'zombie'
mock 		= require './mocks'
User 		= app.models.User

describe 'User', () ->

	describe 'basic crud operations', () ->

		beforeEach (done) ->
			@user = new User(mock.user)
			done()

		it 'should save without error', (done) ->
			@user.save(done)

		afterEach (done) ->
			User.findOne {_id:@user._id}, (err, user) ->
				user.remove()
				done(err)

	describe 'ensure authentication', () ->

		it 'should return status 200 ok on login page', (done) ->
			Browser.visit "http://localhost:8000/login", {debug: false}, done

