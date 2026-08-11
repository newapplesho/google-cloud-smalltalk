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

	self
		assert: url
		equals:
			'https://generativelanguage.googleapis.com/v1beta/models/test-model:generateContent?key=test-api-key'
]

{ #category : 'tests' }
GeminiClientTest >> testBuildUrlVertexAI [

	| config client request url |
	config := GoogleGenAIConfig new
		          useVertexAI: true;
		          projectId: 'my-project';
		          location: 'us-central1';
		          yourself.
	client := GoogleGenAIClient new config: config.

	request := GeminiRequest new model: 'gemini-2.5-flash'; yourself.
	url := client buildUrlFor: request.

	self
		assert: url
		equals:
			'https://us-central1-aiplatform.googleapis.com/v1/projects/my-project/locations/us-central1/publishers/google/models/gemini-2.5-flash:generateContent'
]

{ #category : 'tests' }
GeminiClientTest >> testBuildUrlVertexAIGlobal [

	| config client request url |
	config := GoogleGenAIConfig new
		          useVertexAI: true;
		          projectId: 'my-project';
		          location: 'global';
		          yourself.
	client := GoogleGenAIClient new config: config.

	request := GeminiRequest new model: 'gemini-2.5-flash'; yourself.
	url := client buildUrlFor: request.

	self
		assert: url
		equals:
			'https://aiplatform.googleapis.com/v1/projects/my-project/locations/global/publishers/google/models/gemini-2.5-flash:generateContent'
]
