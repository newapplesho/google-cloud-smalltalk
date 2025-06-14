Class {
	#name : 'GoogleGenAIConfigTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

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
