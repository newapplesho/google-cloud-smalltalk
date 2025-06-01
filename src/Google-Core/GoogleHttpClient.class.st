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

	^ authClient ifNil: [ authClient := GoogleAuthClient new ]
]

{ #category : 'accessing' }
GoogleHttpClient >> authClient: anObject [

	authClient := anObject
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
	client execute.
	^ client response
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
