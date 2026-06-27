"I am a test double for `GoogleGenAIClient` that never touches the network.

I return queued raw JSON strings from `sendRequest:` in order, and record each
request's serialized payload in `sentPayloads` so tests can assert what was sent
(for example that a `functionResponse` was returned to the model).
"
Class {
	#name : 'GeminiStubClient',
	#superclass : 'GoogleGenAIClient',
	#instVars : [
		'responses',
		'sentPayloads'
	],
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'initialization' }
GeminiStubClient >> initialize [

	super initialize.
	responses := OrderedCollection new.
	sentPayloads := OrderedCollection new
]

{ #category : 'accessing' }
GeminiStubClient >> responses: aCollection [

	responses := aCollection asOrderedCollection
]

{ #category : 'rest api' }
GeminiStubClient >> sendRequest: aGeminiRequest [

	sentPayloads add: aGeminiRequest asJson.
	^ responses removeFirst
]

{ #category : 'accessing' }
GeminiStubClient >> sentPayloads [

	^ sentPayloads
]
