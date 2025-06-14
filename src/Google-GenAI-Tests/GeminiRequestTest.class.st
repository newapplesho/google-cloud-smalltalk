Class {
	#name : 'GeminiRequestTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

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
