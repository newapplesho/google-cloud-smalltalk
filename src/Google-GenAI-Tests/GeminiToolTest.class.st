Class {
	#name : 'GeminiToolTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiToolTest >> testFunctionDeclarationParameters [

	| decl dict properties |
	decl := GeminiFunctionDeclaration
		        name: 'get_weather'
		        description: 'Get the weather for a city'.
	decl parameterNamed: 'city' type: 'string' description: 'City name'.
	decl requiredParameters: #( 'city' ).

	dict := decl asDictionary.
	properties := (dict at: 'parameters') at: 'properties'.
	self assert: (dict at: 'name') equals: 'get_weather'.
	self assert: ((properties at: 'city') at: 'type') equals: 'string'.
	self assert: ((dict at: 'parameters') at: 'required') first equals: 'city'
]

{ #category : 'tests' }
GeminiToolTest >> testFunctionDeclarationWithoutParameters [

	| decl dict |
	decl := GeminiFunctionDeclaration name: 'now' description: 'Current time'.

	dict := decl asDictionary.
	self deny: (dict includesKey: 'parameters')
]

{ #category : 'tests' }
GeminiToolTest >> testToolAsDictionary [

	| tool dict |
	tool := GeminiTool withFunctionDeclaration:
		        (GeminiFunctionDeclaration name: 'now' description: 'Time').
	dict := tool asDictionary.

	self assert: (dict at: 'functionDeclarations') size equals: 1.
	self
		assert: ((dict at: 'functionDeclarations') first at: 'name')
		equals: 'now'
]

{ #category : 'tests' }
GeminiToolTest >> testToolConfigAsDictionary [

	| config dict fcc |
	config := GeminiToolConfig
		          mode: 'ANY'
		          allowedFunctionNames: #( 'now' ).
	dict := config asDictionary.
	fcc := dict at: 'functionCallingConfig'.

	self assert: (fcc at: 'mode') equals: 'ANY'.
	self assert: (fcc at: 'allowedFunctionNames') first equals: 'now'
]
