"I parse and represent a Gemini generateContent response.

I hold the `candidates` and `promptFeedback`, and offer convenience accessors over
the first candidate: `text`, `functionCalls` and `hasFunctionCall`.

Reference:
  GenerateContentResponse (REST):
    https://ai.google.dev/api/generate-content#v1beta.GenerateContentResponse
"
Class {
	#name : 'GeminiResponse',
	#superclass : 'Object',
	#instVars : [
		'candidates',
		'promptFeedback'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiResponse class >> fromJson: jsonString [

	| jsonData |
	jsonData := NeoJSONReader fromString: jsonString.
	^ self new
		  initializeFromJson: jsonData;
		  yourself
]

{ #category : 'accessing' }
GeminiResponse >> candidates [

	^ candidates
]

{ #category : 'accessing' }
GeminiResponse >> functionCalls [
	"The function calls emitted by the first candidate, or an empty array."

	^ candidates isEmpty
		  ifTrue: [ #(  ) ]
		  ifFalse: [ candidates first functionCalls ]
]

{ #category : 'testing' }
GeminiResponse >> hasFunctionCall [

	^ candidates notEmpty and: [ candidates first hasFunctionCall ]
]

{ #category : 'converting' }
GeminiResponse >> json [
	"Parse the response text as JSON (for structured output requests that set
	 responseMimeType: 'application/json'). Answers a Dictionary / Array."

	^ NeoJSONReader fromString: self text
]

{ #category : 'initialize' }
GeminiResponse >> initializeFromJson: jsonData [

	candidates := (jsonData at: 'candidates' ifAbsent: [ #(  ) ])
		              collect: [ :candidate |
		              GeminiCandidate fromJson: candidate ].
	promptFeedback := jsonData at: 'promptFeedback' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
GeminiResponse >> promptFeedback [

	^ promptFeedback
]

{ #category : 'accessing' }
GeminiResponse >> text [

	^ candidates isEmpty
		  ifTrue: [ '' ]
		  ifFalse: [ candidates first text ]
]
