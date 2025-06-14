Class {
	#name : 'GoogleAPIClient',
	#superclass : 'Object',
	#instVars : [
		'client',
		'httpClient',
		'location',
		'projectId'
	],
	#category : 'Google-Core',
	#package : 'Google-Core'
}

{ #category : 'accessing' }
GoogleAPIClient >> client [

	^ client ifNil: [ client := self httpClient ]
]

{ #category : 'accessing' }
GoogleAPIClient >> client: anObject [

	client := anObject
]

{ #category : 'default' }
GoogleAPIClient >> defaultHttpClientClass [

	^ GoogleHttpClient
]

{ #category : 'accessing' }
GoogleAPIClient >> httpClient [

	^ httpClient ifNil: [ httpClient := self defaultHttpClientClass new ]
]

{ #category : 'accessing' }
GoogleAPIClient >> httpClient: anObject [

	httpClient := anObject
]

{ #category : 'initialization' }
GoogleAPIClient >> initialize [

	super initialize.
	client := self httpClient
]

{ #category : 'accessing' }
GoogleAPIClient >> location [

	^ location ifNil: [ location := 'us-central1' ]
]

{ #category : 'accessing' }
GoogleAPIClient >> location: anObject [

	location := anObject
]

{ #category : 'accessing' }
GoogleAPIClient >> logLevel [

	self client logLevel
]

{ #category : 'accessing' }
GoogleAPIClient >> logLevel: integer [
	"Set the log level to integer.
	0 - no logging
	1 - simplified transaction logging
	2 - detailed transaction logging
	3 - log everything"

	self client logLevel: integer
]

{ #category : 'accessing' }
GoogleAPIClient >> projectId [

	^ projectId
]

{ #category : 'accessing' }
GoogleAPIClient >> projectId: anObject [

	projectId := anObject
]
