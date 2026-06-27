"I represent one response candidate returned by a Gemini model.

I expose the candidate's `text`, its parsed `parts`, and any `functionCalls` the
model emitted (`hasFunctionCall` tests for them), plus the `finishReason`.

Reference:
  Candidate (REST): https://ai.google.dev/api/generate-content#v1beta.Candidate
"
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

{ #category : 'accessing' }
GeminiCandidate >> functionCalls [
	"All function calls the model emitted in this candidate."

	^ self rawParts
		  select: [ :part | part includesKey: 'functionCall' ]
		  thenCollect: [ :part |
			  GeminiFunctionCall fromJson: (part at: 'functionCall') ]
]

{ #category : 'testing' }
GeminiCandidate >> hasFunctionCall [

	^ self rawParts anySatisfy: [ :part | part includesKey: 'functionCall' ]
]

{ #category : 'initialization' }
GeminiCandidate >> initializeFromJson: jsonData [

	content := jsonData at: 'content' ifAbsent: [ nil ].
	finishReason := jsonData at: 'finishReason' ifAbsent: [ nil ].
	safetyRatings := jsonData at: 'safetyRatings' ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
GeminiCandidate >> parts [
	"The parsed parts of this candidate as GeminiPart instances."

	^ self rawParts collect: [ :part | GeminiPart fromJson: part ]
]

{ #category : 'private' }
GeminiCandidate >> rawParts [
	"The raw part dictionaries from the parsed JSON content."

	content ifNil: [ ^ #(  ) ].
	^ content at: 'parts' ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
GeminiCandidate >> text [
	"Extract text from content"

	content ifNil: [ ^ '' ].
	^ String streamContents: [ :stream |
		  self rawParts do: [ :part |
			  stream nextPutAll: (part at: 'text' ifAbsent: [ '' ]) ] ]
]
