Class {
	#name : 'GeminiCandidate',
	#superclass : 'Object',
	#instVars : [
		'content',
		'finishReason',
		'safetyRatings'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiCandidate class >> fromJson: jsonData [
	^ self new
		initializeFromJson: jsonData;
		yourself
]

{ #category : 'accessing' }
GeminiCandidate >> finishReason [

	^ finishReason
]

{ #category : 'initialization' }
GeminiCandidate >> initializeFromJson: jsonData [

	content := jsonData at: 'content' ifAbsent: [ nil ].
	finishReason := jsonData at: 'finishReason' ifAbsent: [ nil ].
	safetyRatings := jsonData at: 'safetyRatings' ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
GeminiCandidate >> text [
	"Extract text from content"

	content ifNil: [ ^ '' ].
	^ String streamContents: [ :stream |
		  (content at: 'parts' ifAbsent: [ #(  ) ]) do: [ :part |
			  stream nextPutAll: (part at: 'text' ifAbsent: [ '' ]) ] ]
]
