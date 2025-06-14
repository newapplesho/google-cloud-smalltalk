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
