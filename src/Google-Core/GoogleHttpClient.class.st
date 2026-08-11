"I send authenticated HTTP requests to Google Cloud REST APIs.

I wrap a `ZnClient` and attach a Bearer token via `GoogleAuthClient`. Service
clients use my `httpGet:` and `httpPost:contents:` to issue requests, and
`readFromResponse:` to parse the response through `GoogleRestResponse`.
"
Class {
	#name : 'GoogleHttpClient',
	#superclass : 'Object',
	#instVars : [
		'authClient',
		'client'
	],
	#category : 'Google-Core',
	#package : 'Google-Core'
}

{ #category : 'accessing' }
GoogleHttpClient >> authClient [

	^ authClient
]

{ #category : 'accessing' }
GoogleHttpClient >> authClient: aGoogleAuthClient [

	authClient := aGoogleAuthClient
]

{ #category : 'accessing' }
GoogleHttpClient >> client [

	^ client ifNil: [ client := self defaultClient new ]
]

{ #category : 'private' }
GoogleHttpClient >> createRequest [

	| accessToken request |
	request := ZnRequest empty.

	self authClient ifNotNil: [
		accessToken := self authClient getAccessToken.
		accessToken ifNotNil: [
			request setAuthorization: 'Bearer ' , accessToken ] ].
	^ request
]

{ #category : 'default' }
GoogleHttpClient >> defaultClient [

	^ ZnClient
]

{ #category : 'initialization' }
GoogleHttpClient >> initialize [

	super initialize.
	authClient := GoogleAuthClient new
]

{ #category : 'default' }
GoogleHttpClient >> defaultResponseClass [

	^ GoogleRestResponse
]

{ #category : 'http-method' }
GoogleHttpClient >> httpGet: aUri [

	^ self httpRequest: aUri method: #GET contents: nil
]

{ #category : 'http-method' }
GoogleHttpClient >> httpPost: aUri contents: entity [

	^ self httpRequest: aUri method: #POST contents: entity
]

{ #category : 'private' }
GoogleHttpClient >> httpRequest: aUri method: aMethod contents: anEntity [

	| request |
	request := self createRequest.
	request method: aMethod.
	request url: aUri asString.

	anEntity ifNotNil: [ request entity: anEntity ].
	self client request: request.
	self client execute.
	^ self client response
]

{ #category : 'accessing' }
GoogleHttpClient >> logLevel [

	^ self client logLevel
]

{ #category : 'accessing' }
GoogleHttpClient >> logLevel: anInteger [
	"Set the log level to anInteger.
	0 - no logging
	1 - simplified transaction logging
	2 - detailed transaction logging
	3 - log everything"

	self client logLevel: anInteger
]

{ #category : 'private' }
GoogleHttpClient >> readFromResponse: response [

	^ self
		  readFromResponse: response
		  responseClass: self defaultResponseClass
]

{ #category : 'private' }
GoogleHttpClient >> readFromResponse: response responseClass: aResponseClass [

	^ (aResponseClass on: response) value
]

{ #category : 'accessing' }
GoogleHttpClient >> timeout [

	^ self client timeout
]

{ #category : 'accessing' }
GoogleHttpClient >> timeout: anInteger [

	self client timeout: anInteger
]
