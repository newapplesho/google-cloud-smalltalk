Class {
	#name : 'GeminiClientTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiClientTest >> testBuildUrl [

	| config client request url |
	config := GoogleGenAIConfig new.
	config apiKey: 'test-api-key'.
	client := GoogleGenAIClient new.
	client config: config.

	request := GeminiRequest new
		           model: 'test-model';
		           yourself.
	url := client buildUrlFor: request.

	self assert: (url includesSubstring:
			 'https://generativelanguage.googleapis.com/v1beta/models/test-model:generateContent').
	self assert: (url includesSubstring: 'key=test-api-key')
]
