Class {
	#name : 'GeminiPartTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiPartTest >> testFunctionCallRoundTrip [

	| part dict parsed |
	part := GeminiPart functionCall:
		        (GeminiFunctionCall
			         name: 'get_weather'
			         args: (Dictionary with: 'city' -> 'Tokyo')).
	dict := part asDictionary.
	self assert: ((dict at: 'functionCall') at: 'name') equals: 'get_weather'.

	parsed := GeminiPart fromJson: dict.
	self assert: parsed isFunctionCall.
	self assert: parsed functionCall name equals: 'get_weather'
]

{ #category : 'tests' }
GeminiPartTest >> testFunctionResponseAsDictionary [

	| part dict |
	part := GeminiPart functionResponse:
		        (GeminiFunctionResponse
			         name: 'get_weather'
			         response: (Dictionary with: 'tempC' -> 21)).
	dict := part asDictionary.

	self assert: part isFunctionResponse.
	self assert: ((dict at: 'functionResponse') at: 'name') equals: 'get_weather'.
	self
		assert: (((dict at: 'functionResponse') at: 'response') at: 'tempC')
		equals: 21
]

{ #category : 'tests' }
GeminiPartTest >> testTextPart [

	| part |
	part := GeminiPart text: 'hello'.

	self assert: part isText.
	self assert: (part asDictionary at: 'text') equals: 'hello'
]

{ #category : 'tests' }
GeminiPartTest >> testTextPartFromJson [

	| parsed |
	parsed := GeminiPart fromJson: (Dictionary with: 'text' -> 'hi').

	self assert: parsed isText.
	self assert: parsed text equals: 'hi'
]
