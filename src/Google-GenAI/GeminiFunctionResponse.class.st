"I represent the result of executing a tool, sent back to a Gemini model.

I carry the function `name` (matching the `GeminiFunctionCall` I answer) and a
`response` Dictionary holding the tool's output. I serialize to a
`functionResponse` part inside a message with role `user` (or `function`).

Example:
  GeminiFunctionResponse
      name: 'get_weather'
      response: (Dictionary new at: 'tempC' put: 21; yourself).

Reference:
  FunctionResponse (REST): https://ai.google.dev/api/caching#FunctionResponse
  Function calling guide: https://ai.google.dev/gemini-api/docs/function-calling
"
Class {
	#name : 'GeminiFunctionResponse',
	#superclass : 'Object',
	#instVars : [
		'name',
		'response'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiFunctionResponse class >> fromJson: jsonData [

	^ self new
		  name: (jsonData at: 'name' ifAbsent: [ nil ]);
		  response: (jsonData at: 'response' ifAbsent: [ Dictionary new ]);
		  yourself
]

{ #category : 'instance creation' }
GeminiFunctionResponse class >> name: aString response: aDictionary [

	^ self new
		  name: aString;
		  response: aDictionary;
		  yourself
]

{ #category : 'converting' }
GeminiFunctionResponse >> asDictionary [

	^ Dictionary new
		  at: 'name' put: name;
		  at: 'response' put: self response;
		  yourself
]

{ #category : 'accessing' }
GeminiFunctionResponse >> name [

	^ name
]

{ #category : 'accessing' }
GeminiFunctionResponse >> name: aString [

	name := aString
]

{ #category : 'accessing' }
GeminiFunctionResponse >> response [

	^ response ifNil: [ response := Dictionary new ]
]

{ #category : 'accessing' }
GeminiFunctionResponse >> response: aDictionary [

	response := aDictionary
]
