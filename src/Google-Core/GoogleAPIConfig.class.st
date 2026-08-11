"I hold the shared configuration for a Google Cloud service client.

I provide a `projectId` and a `location` (default `us-central1`). A class-side
`default` singleton lets multiple clients share one configuration. Subclasses
such as `GoogleGenAIConfig` add service-specific settings.
"
Class {
	#name : 'GoogleAPIConfig',
	#superclass : 'Object',
	#instVars : [
		'location',
		'projectId'
	],
	#classInstVars : [
		'default'
	],
	#category : 'Google-Core',
	#package : 'Google-Core'
}

{ #category : 'accessing' }
GoogleAPIConfig class >> default [

	^ default ifNil: [ default := self new ]
]

{ #category : 'class initialization' }
GoogleAPIConfig class >> initialize [

	default := nil
]

{ #category : 'accessing' }
GoogleAPIConfig >> location [

	^ location ifNil: [ location := 'us-central1' ]
]

{ #category : 'accessing' }
GoogleAPIConfig >> location: aString [

	location := aString
]

{ #category : 'accessing' }
GoogleAPIConfig >> projectId [

	^ projectId
]

{ #category : 'accessing' }
GoogleAPIConfig >> projectId: aString [

	projectId := aString
]
