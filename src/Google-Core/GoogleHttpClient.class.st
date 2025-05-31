Class {
	#name : 'GoogleHttpClient',
	#superclass : 'Object',
	#instVars : [
		'client'
	],
	#category : 'Google-Core',
	#package : 'Google-Core'
}

{ #category : 'accessing' }
GoogleHttpClient >> client [

	^ client ifNil: [ client := self defaultClient new ]
]

{ #category : 'private' }
GoogleHttpClient >> createRequest [

	| request |
	request := ZnRequest empty.
	^ request
]

{ #category : 'default' }
GoogleHttpClient >> defaultClient [

	^ ZnClient
]

{ #category : 'http-method' }
GoogleHttpClient >> httpGet: aUri [

	| request |
	request := self createRequest.
	request method: #GET.
	request url: aUri asString.
	self client request: request.
	client execute.
	^ client response
]

{ #category : 'http-method' }
GoogleHttpClient >> httpPost: aUri contents: entity [

	| request |
	request := self createRequest.
	request method: #POST.
	request url: aUri asString.
	request entity: entity.
	self client request: request.
	client execute.
	^ client response
]
