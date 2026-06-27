"I configure a `GoogleGenAIClient`.

I select the endpoint (Vertex AI vs API Key), the `projectId` / `location`, the
`defaultModel`, and the request `timeout`. `serviceEndpoint` resolves the base
URL; on Vertex AI, `location: 'global'` uses the global endpoint required by the
Gemini 2.5 models. `supportedModels` lists the verified models.

Reference:
  Models: https://ai.google.dev/gemini-api/docs/models
  Vertex AI locations:
    https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations
"
Class {
	#name : 'GoogleGenAIConfig',
	#superclass : 'GoogleAPIConfig',
	#instVars : [
		'apiKey',
		'defaultModel',
		'logLevel',
		'timeout',
		'useVertexAI'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'accessing' }
GoogleGenAIConfig >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
GoogleGenAIConfig >> apiKey: aString [

	apiKey := aString
]

{ #category : 'models' }
GoogleGenAIConfig class >> supportedModels [
	"Gemini models verified against this client. The default is the first."

	^ #( 'gemini-2.5-flash' 'gemini-2.5-pro' 'gemini-2.0-flash' )
]

{ #category : 'accessing' }
GoogleGenAIConfig >> defaultModel [

	^ defaultModel ifNil: [ defaultModel := 'gemini-2.5-flash' ]
]

{ #category : 'accessing' }
GoogleGenAIConfig >> defaultModel: aString [

	defaultModel := aString
]

{ #category : 'accessing' }
GoogleGenAIConfig >> logLevel [

	^ logLevel
]

{ #category : 'accessing' }
GoogleGenAIConfig >> logLevel: anInteger [

	logLevel := anInteger
]

{ #category : 'accessing' }
GoogleGenAIConfig >> serviceEndpoint [

	self useVertexAI ifTrue: [
		self location = 'global' ifTrue: [
			^ 'https://aiplatform.googleapis.com/' ].

		^ 'https://{location}-aiplatform.googleapis.com/' format:
			  (Dictionary with: #location -> self location) ].
	^ 'https://generativelanguage.googleapis.com/'
]

{ #category : 'accessing' }
GoogleGenAIConfig >> timeout [

	^ timeout ifNil: [ timeout := 30 ]
]

{ #category : 'accessing' }
GoogleGenAIConfig >> timeout: anInteger [

	timeout := anInteger
]

{ #category : 'accessing' }
GoogleGenAIConfig >> useVertexAI [

	^ useVertexAI ifNil: [ useVertexAI := false ]
]

{ #category : 'accessing' }
GoogleGenAIConfig >> useVertexAI: anObject [

	useVertexAI := anObject
]
