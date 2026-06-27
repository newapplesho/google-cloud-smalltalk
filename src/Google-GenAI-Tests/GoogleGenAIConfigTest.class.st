Class {
	#name : 'GoogleGenAIConfigTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GoogleGenAIConfigTest >> testDefaultModelIsGemini25Flash [

	self
		assert: GoogleGenAIConfig new defaultModel
		equals: 'gemini-2.5-flash'
]

{ #category : 'tests' }
GoogleGenAIConfigTest >> testServiceEndpointGlobalUsesGlobalHost [
	"Gemini 2.5 models on Vertex AI are served via the global endpoint."

	| config |
	config := GoogleGenAIConfig new
		          useVertexAI: true;
		          location: 'global';
		          yourself.
	self
		assert: config serviceEndpoint
		equals: 'https://aiplatform.googleapis.com/'
]

{ #category : 'tests' }
GoogleGenAIConfigTest >> testServiceEndpoint [

	| config |
	config := GoogleGenAIConfig new.
	config projectId: 'test-project'.
	config location: 'us-central1'.
	config useVertexAI: true.

	self
		assert: config serviceEndpoint
		equals: 'https://us-central1-aiplatform.googleapis.com/'.

	config useVertexAI: false.
	self
		assert: config serviceEndpoint
		equals: 'https://generativelanguage.googleapis.com/'
]
