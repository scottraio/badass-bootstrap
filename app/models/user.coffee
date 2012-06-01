wrench		= require 'wrench'
util 		= require 'util'
path		= require 'path'
Schema 		= mongoose.Schema
ObjectId 	= Schema.ObjectId
Validations = require './validations'
Setter 		= require './setters'
SHA2		= new (require('jshashes').SHA512)()
salt 		= 'sc2ishard'


encodePassword = (pass) ->
	return '' if typeof pass is 'string' and pass.length < 6 
	return SHA2.b64_hmac(pass, salt)

UserSchema = new Schema
	name  	 	: { type: String, required: true, trim: true }
	email	 	: { type: String, required: true, trim: true, unique: true, lowercase: true }
	subdomain 	: { type: String, required: true, trim: true, set: Setter.to_system_format }
	password 	: { type: String, required: true, set: encodePassword }

UserSchema.path('name').validate 		Validations.uniqueFieldInsensitive('User', 'name'), 'unique'
UserSchema.path('email').validate 		Validations.uniqueFieldInsensitive('User', 'email'), 'unique'
UserSchema.path('email').validate 		Validations.emailFormat, 'format'
UserSchema.path('password').validate 	Validations.cannotBeEmpty, 'password'

# 
# Callbacks
#

UserSchema.pre 'save', (next) ->
	dir = app.root_dir + '/domains/' + this.subdomain
	unless path.existsSync dir
		console.log '\n\tCreating directory: ' + dir
		wrench.mkdirSyncRecursive dir, 0o0777
		next()
	else
		next new Error('Directory already exists')

UserSchema.pre 'remove', (next) ->
	dir = app.root_dir + '/domains/' + this.subdomain
	console.log '\n\tRemoving directory: ' + dir
	wrench.rmdirSyncRecursive(dir, false)
	next()

	
#
# Methods & Statics
#

UserSchema.methods.domain_dir = () ->
	app.root_dir + '/public/domains/' + this.subdomain

UserSchema.methods.validPassword = (pass) ->
	return true if encodePassword(pass) is @password

UserSchema.methods.url_encoded_email = () ->
	return @email.replace /@/, '%40'

mongoose.model('User', UserSchema)