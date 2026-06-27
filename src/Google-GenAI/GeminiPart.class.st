"I represent a single part of a Gemini content message.

A message's `parts` is an ordered collection of me. I hold exactly one kind of
payload: plain `text`, a `functionCall` (a `GeminiFunctionCall` emitted by the
model), or a `functionResponse` (a `GeminiFunctionResponse` carrying a tool
result). `asDictionary` emits the matching wire shape and `fromJson:` reconstructs
me from a parsed response part.

Example:
  GeminiPart text: 'Hello'.
  GeminiPart functionResponse:
      (GeminiFunctionResponse name: 'get_weather' response: aDict).

Reference:
  Part (REST): https://ai.google.dev/api/caching#Part
"
Class {
	#name : 'GeminiPart',
	#superclass : 'Object',
	#instVars : [
		'text',
		'functionCall',
		'functionResponse'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiPart class >> fromJson: jsonData [

	(jsonData includesKey: 'functionCall') ifTrue: [
		^ self functionCall:
			  (GeminiFunctionCall fromJson: (jsonData at: 'functionCall')) ].
	(jsonData includesKey: 'functionResponse') ifTrue: [
		^ self functionResponse:
			  (GeminiFunctionResponse fromJson:
				   (jsonData at: 'functionResponse')) ].
	^ self text: (jsonData at: 'text' ifAbsent: [ '' ])
]

{ #category : 'instance creation' }
GeminiPart class >> functionCall: aGeminiFunctionCall [

	^ self new
		  functionCall: aGeminiFunctionCall;
		  yourself
]

{ #category : 'instance creation' }
GeminiPart class >> functionResponse: aGeminiFunctionResponse [

	^ self new
		  functionResponse: aGeminiFunctionResponse;
		  yourself
]

{ #category : 'instance creation' }
GeminiPart class >> text: aString [

	^ self new
		  text: aString;
		  yourself
]

{ #category : 'converting' }
GeminiPart >> asDictionary [

	self isFunctionCall ifTrue: [
		^ Dictionary new
			  at: 'functionCall' put: functionCall asDictionary;
			  yourself ].
	self isFunctionResponse ifTrue: [
		^ Dictionary new
			  at: 'functionResponse' put: functionResponse asDictionary;
			  yourself ].
	^ Dictionary new
		  at: 'text' put: (text ifNil: [ '' ]);
		  yourself
]

{ #category : 'accessing' }
GeminiPart >> functionCall [

	^ functionCall
]

{ #category : 'accessing' }
GeminiPart >> functionCall: aGeminiFunctionCall [

	functionCall := aGeminiFunctionCall
]

{ #category : 'accessing' }
GeminiPart >> functionResponse [

	^ functionResponse
]

{ #category : 'accessing' }
GeminiPart >> functionResponse: aGeminiFunctionResponse [

	functionResponse := aGeminiFunctionResponse
]

{ #category : 'testing' }
GeminiPart >> isFunctionCall [

	^ functionCall notNil
]

{ #category : 'testing' }
GeminiPart >> isFunctionResponse [

	^ functionResponse notNil
]

{ #category : 'testing' }
GeminiPart >> isText [

	^ functionCall isNil and: [ functionResponse isNil ]
]

{ #category : 'accessing' }
GeminiPart >> text [

	^ text
]

{ #category : 'accessing' }
GeminiPart >> text: aString [

	text := aString
]
