"I group the function declarations exposed to a Gemini model in one request.

I hold an ordered collection of `GeminiFunctionDeclaration` and serialize to the
`functionDeclarations` array Gemini expects under a request's `tools` field. A
request may attach one or more of me.

Example:
  tool := GeminiTool new.
  tool addFunctionDeclaration:
      (GeminiFunctionDeclaration name: 'get_weather'
           description: 'Get the weather').

Reference:
  Tool (REST): https://ai.google.dev/api/caching#Tool
  Function calling guide: https://ai.google.dev/gemini-api/docs/function-calling
"
Class {
	#name : 'GeminiTool',
	#superclass : 'Object',
	#instVars : [
		'functionDeclarations'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiTool class >> withFunctionDeclaration: aDeclaration [

	^ self new
		  addFunctionDeclaration: aDeclaration;
		  yourself
]

{ #category : 'building' }
GeminiTool >> addFunctionDeclaration: aDeclaration [

	functionDeclarations add: aDeclaration.
	^ aDeclaration
]

{ #category : 'converting' }
GeminiTool >> asDictionary [

	^ Dictionary new
		  at: 'functionDeclarations'
		  put: (functionDeclarations collect: [ :each | each asDictionary ])
				  asArray;
		  yourself
]

{ #category : 'accessing' }
GeminiTool >> functionDeclarations [

	^ functionDeclarations
]

{ #category : 'initialization' }
GeminiTool >> initialize [

	super initialize.
	functionDeclarations := OrderedCollection new
]
