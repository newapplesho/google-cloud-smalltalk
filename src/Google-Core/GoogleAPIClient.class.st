"I am the abstract base class for Google Cloud service clients.

I hold a `GoogleHttpClient` (with Bearer-token authentication), a `projectId`
and a `location`. Subclasses such as `GoogleGenAIClient` and `BigQueryClient`
add service-specific REST endpoints and request methods.
"
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
GoogleAPIClient >> client: aGoogleHttpClient [

	client := aGoogleHttpClient
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
GoogleAPIClient >> httpClient: aGoogleHttpClient [

	httpClient := aGoogleHttpClient
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
GoogleAPIClient >> location: aString [

	location := aString
]

{ #category : 'accessing' }
GoogleAPIClient >> logLevel [

	^ self client logLevel
]

{ #category : 'accessing' }
GoogleAPIClient >> logLevel: anInteger [
	"Set the log level to anInteger.
	0 - no logging
	1 - simplified transaction logging
	2 - detailed transaction logging
	3 - log everything"

	self client logLevel: anInteger
]

{ #category : 'accessing' }
GoogleAPIClient >> projectId [

	^ projectId
]

{ #category : 'accessing' }
GoogleAPIClient >> projectId: aString [

	projectId := aString
]
