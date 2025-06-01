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
GoogleRestResponse >> response: anObject [

	response := anObject
]

{ #category : 'action' }
GoogleRestResponse >> value [

	| responseJson exception |
	responseJson := (NeoJSONReader on: self response contents readStream)
		                mapClass: NeoJSONObject;
		                propertyNamesAsSymbols: true;
		                next.

	self response isSuccess ifTrue: [ ^ responseJson ].

	exception := GoogleRestException new.
	exception properties: responseJson.
	exception messageText: responseJson message.
	exception signal
]
