Class {
	#name : 'GeminiFunctionCallingTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'fixtures' }
GeminiFunctionCallingTest >> finalTextResponse [

	^ '{"candidates": [{"content": {"parts": [
        {"text": "It is 21C in Tokyo."}]}, "finishReason": "STOP"}]}'
]

{ #category : 'fixtures' }
GeminiFunctionCallingTest >> functionCallResponse [

	^ '{"candidates": [{"content": {"parts": [
        {"functionCall": {"name": "get_weather", "args": {"city": "Tokyo"}}}
        ]}, "finishReason": "STOP"}]}'
]

{ #category : 'fixtures' }
GeminiFunctionCallingTest >> weatherTool [

	| decl |
	decl := GeminiFunctionDeclaration
		        name: 'get_weather'
		        description: 'Get the weather'.
	decl parameterNamed: 'city' type: 'string' description: 'City'.
	^ GeminiTool withFunctionDeclaration: decl
]

{ #category : 'tests' }
GeminiFunctionCallingTest >> testAutoLoopExecutesHandlerAndReturnsFinalText [

	| client conversation handlers response |
	client := GeminiStubClient new.
	client responses: {
			self functionCallResponse.
			self finalTextResponse }.
	conversation := GeminiConversation new.
	conversation addUser: 'What is the weather in Tokyo?'.
	handlers := Dictionary new
		            at: 'get_weather'
		            put: [ :args | Dictionary with: 'tempC' -> 21 ];
		            yourself.

	response := client
		            runConversation: conversation
		            tools: { self weatherTool }
		            handlers: handlers.

	self assert: response text equals: 'It is 21C in Tokyo.'.
	self assert: (client sentPayloads second includesSubstring: 'functionResponse')
]

{ #category : 'tests' }
GeminiFunctionCallingTest >> testAutoLoopAppendsModelAndFunctionMessages [

	| client conversation handlers |
	client := GeminiStubClient new.
	client responses: {
			self functionCallResponse.
			self finalTextResponse }.
	conversation := GeminiConversation new.
	conversation addUser: 'Weather in Tokyo?'.
	handlers := Dictionary new
		            at: 'get_weather'
		            put: [ :args | Dictionary with: 'tempC' -> 21 ];
		            yourself.

	client
		runConversation: conversation
		tools: { self weatherTool }
		handlers: handlers.

	"user + model functionCall turn + functionResponse turn"
	self assert: conversation messages size equals: 3.
	self assert: conversation messages second role equals: 'model'.
	self assert: conversation messages third role equals: 'user'
]
