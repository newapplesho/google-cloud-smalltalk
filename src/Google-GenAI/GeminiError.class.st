"I am the exception signalled when a Gemini request fails.

I am raised by `GoogleGenAIClient` for HTTP transport failures and non-success
API responses; catch me with `[ ... ] on: GeminiError do: [ :e | e messageText ]`.
I carry the API `message`, the HTTP `statusCode`, and the raw error `properties`.

Reference:
  Error status codes: https://ai.google.dev/api/generate-content
"
Class {
	#name : 'GeminiError',
	#superclass : 'Error',
	#instVars : [
		'message',
		'statusCode',
		'properties'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'accessing' }
GeminiError >> code [

	^ self properties
		  ifNotNil: [ :p | p at: 'code' ifAbsent: [ nil ] ]
]

{ #category : 'accessing' }
GeminiError >> errorCode [

	^ self code
]

{ #category : 'accessing' }
GeminiError >> message [

	^ message ifNil: [
		  self properties ifNotNil: [ :p |
			  message := p at: 'message' ifAbsent: [ nil ] ] ]
]

{ #category : 'accessing' }
GeminiError >> message: aString [

	message := aString
]

{ #category : 'accessing' }
GeminiError >> messageText [
	"The standard exception message (so on:do: handlers read e messageText)."

	^ self message asString
]

{ #category : 'accessing' }
GeminiError >> properties [

	^ properties
]

{ #category : 'accessing' }
GeminiError >> properties: aDictionary [

	properties := aDictionary
]

{ #category : 'accessing' }
GeminiError >> status [

	^ self properties
		  ifNotNil: [ :p | p at: 'status' ifAbsent: [ nil ] ]
]

{ #category : 'accessing' }
GeminiError >> statusCode [

	^ statusCode
]

{ #category : 'accessing' }
GeminiError >> statusCode: anInteger [

	statusCode := anInteger
]

{ #category : 'accessing' }
GeminiError >> text [

	^ 'Error: ', self message asString.
]
