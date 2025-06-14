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

{ #category : 'accessing' }
GoogleGenAIConfig >> defaultModel [

	^ defaultModel ifNil: [ defaultModel := 'gemini-2.0-flash-001' ]
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
		self location == 'global' ifTrue: [
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
