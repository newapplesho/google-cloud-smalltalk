"I parse a Google Cloud REST API response.

I wrap a `ZnResponse` and decode its JSON body via NeoJSON. On success, `value`
returns the parsed `NeoJSONObject`; on failure, I signal a `GoogleRestException`
with the API error message and the raw error properties.
"
Class {
	#name : 'GoogleRestResponse',
	#superclass : 'Object',
	#instVars : [
		'response'
	],
	#category : 'Google-Core',
	#package : 'Google-Core'
}

{ #category : 'instance creation' }
GoogleRestResponse class >> on: znResponse [

	^ self new
		  response: znResponse;
		  yourself
]

{ #category : 'accessing' }
GoogleRestResponse >> response [

	^ response
]

{ #category : 'accessing' }
GoogleRestResponse >> response: aZnResponse [

	response := aZnResponse
]

{ #category : 'action' }
GoogleRestResponse >> value [

	| responseJson exception errorObj |
	responseJson := (NeoJSONReader on: self response contents readStream)
		                mapClass: NeoJSONObject;
		                propertyNamesAsSymbols: true;
		                next.

	self response isSuccess ifTrue: [ ^ responseJson ].

	exception := GoogleRestException new.
	exception properties: responseJson.
	errorObj := responseJson at: #error ifAbsent: [ responseJson ].
	exception messageText:
		(errorObj at: #message ifAbsent: [ 'Unknown error' ]).
	exception signal
]
