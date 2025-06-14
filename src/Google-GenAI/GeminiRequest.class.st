Class {
	#name : 'GeminiRequest',
	#superclass : 'Object',
	#instVars : [
		'model',
		'prompt',
		'generationConfig',
		'safetySettings'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'converting' }
GeminiRequest >> asJson [

	| contents |
	contents := Dictionary new
		            at: 'contents' put: (Array with: (Dictionary new
						              at: 'role' put: 'user';
						              at: 'parts' put: (Array with: (Dictionary new
										                at: 'text' put: prompt;
										                yourself));
						              yourself));
		            yourself.

	generationConfig isEmpty ifFalse: [
		contents at: 'generationConfig' put: generationConfig ].

	safetySettings isEmpty ifFalse: [
		contents at: 'safetySettings' put: safetySettings asArray ].

	^ NeoJSONWriter toString: contents
]

{ #category : 'initialization' }
GeminiRequest >> initialize [

	super initialize.
	generationConfig := Dictionary new.
	safetySettings := OrderedCollection new
]

{ #category : 'accessing' }
GeminiRequest >> maxOutputTokens: anInteger [
	"Set maximum tokens in response"

	generationConfig at: 'maxOutputTokens' put: anInteger
]

{ #category : 'accessing' }
GeminiRequest >> model [

	^ model
]

{ #category : 'accessing' }
GeminiRequest >> model: aString [

	model := aString
]

{ #category : 'accessing' }
GeminiRequest >> prompt [

	^ prompt
]

{ #category : 'accessing' }
GeminiRequest >> prompt: aString [

	prompt := aString
]

{ #category : 'accessing' }
GeminiRequest >> temperature: aNumber [
	"Set generation temperature (0.0 to 1.0)"

	generationConfig at: 'temperature' put: aNumber
]

{ #category : 'accessing' }
GeminiRequest >> topP: aNumber [

	generationConfig at: 'topP' put: aNumber
]
