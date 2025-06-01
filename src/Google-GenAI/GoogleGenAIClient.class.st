Class {
	#name : 'GoogleGenAIClient',
	#superclass : 'GoogleAPIClient',
	#instVars : [
		'generativeModel',
		'useVertexAI'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'rest api' }
GoogleGenAIClient >> generateContext: aString [
]

{ #category : 'accessing' }
GoogleGenAIClient >> generativeModel [

	^ generativeModel
]

{ #category : 'accessing' }
GoogleGenAIClient >> generativeModel: anObject [

	generativeModel := anObject
]

{ #category : 'accessing' }
GoogleGenAIClient >> serviceEndpoint [

	self useVertexAI ifTrue: [
		self location == 'global' ifTrue: [
			^ 'https://aiplatform.googleapis.com/' ].

		^ 'https://{location}-aiplatform.googleapis.com/' format:
			  (Dictionary with: #location -> self location) ].
	^ 'https://generativelanguage.googleapis.com/'
]

{ #category : 'accessing' }
GoogleGenAIClient >> useVertexAI [

	^ useVertexAI ifNil: [ useVertexAI := false ]
]

{ #category : 'accessing' }
GoogleGenAIClient >> useVertexAI: anObject [

	useVertexAI := anObject
]
