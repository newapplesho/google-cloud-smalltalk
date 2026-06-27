Class {
	#name : 'GeminiRequestTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiRequestTest >> testAsJsonWithToolsAndSystemInstruction [

	| request decl tool parsed declJson |
	decl := GeminiFunctionDeclaration
		        name: 'get_weather'
		        description: 'Get the weather'.
	decl parameterNamed: 'city' type: 'string' description: 'City name'.
	decl requiredParameters: #( 'city' ).
	tool := GeminiTool withFunctionDeclaration: decl.

	request := GeminiRequest new
		           model: 'gemini-2.5-flash';
		           prompt: 'Weather in Tokyo?';
		           systemInstruction: 'You are helpful';
		           addTool: tool;
		           yourself.

	parsed := NeoJSONReader fromString: request asJson.
	declJson := ((parsed at: 'tools') first at: 'functionDeclarations') first.
	self assert: (declJson at: 'name') equals: 'get_weather'.
	self assert: ((declJson at: 'parameters') at: 'required') first equals: 'city'.
	self
		assert: (((parsed at: 'systemInstruction') at: 'parts') first at: 'text')
		equals: 'You are helpful'
]

{ #category : 'tests' }
GeminiRequestTest >> testAsJsonWithResponseSchema [

	| request parsed generationConfig schema |
	schema := Dictionary new
		          at: 'type' put: 'object';
		          at: 'properties'
		          put: (Dictionary with: 'city' -> (Dictionary with: 'type' -> 'string'));
		          yourself.
	request := GeminiRequest new
		           model: 'gemini-2.5-flash';
		           prompt: 'Weather as JSON';
		           responseMimeType: 'application/json';
		           responseSchema: schema;
		           yourself.

	parsed := NeoJSONReader fromString: request asJson.
	generationConfig := parsed at: 'generationConfig'.
	self assert: (generationConfig at: 'responseMimeType') equals: 'application/json'.
	self
		assert: ((generationConfig at: 'responseSchema') at: 'type')
		equals: 'object'
]

{ #category : 'tests' }
GeminiRequestTest >> testAsJson [

	| request json parsedJson contents |
	request := GeminiRequest new.

	request
		model: 'test-model';
		prompt: 'Hello world';
		temperature: 0.95.

	json := request asJson.
	parsedJson := NeoJSONReader fromString: json.
	contents := parsedJson at: 'contents'.

	self assert: contents size equals: 1.
	self assert: (contents first at: 'role') equals: 'user'.
	self assert: (contents first at: 'parts') size equals: 1.
	self
		assert: ((contents first at: 'parts') first at: 'text')
		equals: 'Hello world'.
	self
		assert: ((parsedJson at: 'generationConfig') at: 'temperature')
		equals: 0.95
]
