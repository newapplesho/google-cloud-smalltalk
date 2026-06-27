"I represent a function call requested by a Gemini model.

I am parsed from a `functionCall` part in a response candidate and carry the
function `name` together with the `args` the model wants to pass (a Dictionary).
Use me to dispatch to the matching tool implementation, then send the result back
as a `GeminiFunctionResponse`.

Example:
  call := candidate functionCalls first.
  result := weatherService forCity: (call args at: 'city').

Reference:
  FunctionCall (REST): https://ai.google.dev/api/caching#FunctionCall
  Function calling guide: https://ai.google.dev/gemini-api/docs/function-calling
"
Class {
	#name : 'GeminiFunctionCall',
	#superclass : 'Object',
	#instVars : [
		'name',
		'args'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiFunctionCall class >> fromJson: jsonData [

	^ self new
		  name: (jsonData at: 'name' ifAbsent: [ nil ]);
		  args: (jsonData at: 'args' ifAbsent: [ Dictionary new ]);
		  yourself
]

{ #category : 'instance creation' }
GeminiFunctionCall class >> name: aString args: aDictionary [

	^ self new
		  name: aString;
		  args: aDictionary;
		  yourself
]

{ #category : 'accessing' }
GeminiFunctionCall >> args [

	^ args ifNil: [ args := Dictionary new ]
]

{ #category : 'accessing' }
GeminiFunctionCall >> args: aDictionary [

	args := aDictionary
]

{ #category : 'converting' }
GeminiFunctionCall >> asDictionary [

	^ Dictionary new
		  at: 'name' put: name;
		  at: 'args' put: self args;
		  yourself
]

{ #category : 'accessing' }
GeminiFunctionCall >> name [

	^ name
]

{ #category : 'accessing' }
GeminiFunctionCall >> name: aString [

	name := aString
]

{ #category : 'printing' }
GeminiFunctionCall >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: (name ifNil: [ '' ]);
		nextPutAll: ')'
]
