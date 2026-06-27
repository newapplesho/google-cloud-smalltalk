"I build a multi-turn `generateContent` request from a `GeminiConversation`.

I subclass `GeminiRequest`, so I inherit `tools`, `toolConfig`,
`systemInstruction` and `generationConfig` handling. My `asJson` emits one
content per message, serializing each message's `parts` (text, functionCall and
functionResponse), which makes function-calling round-trips work.

Reference:
  models.generateContent (REST): https://ai.google.dev/api/generate-content
  Content (contents[]): https://ai.google.dev/api/caching#Content
"
Class {
	#name : 'GeminiChatRequest',
	#superclass : 'GeminiRequest',
	#instVars : [
		'conversation'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'converting' }
GeminiChatRequest >> asJson [

	| contents |
	contents := Dictionary new
		            at: 'contents' put: self contentsArray;
		            yourself.
	self addCommonFieldsTo: contents.
	^ NeoJSONWriter toString: contents
]

{ #category : 'private' }
GeminiChatRequest >> contentsArray [
	"One content dictionary per message, built from its parts."

	^ (conversation collect: [ :message |
		   Dictionary new
			   at: 'role' put: message role;
			   at: 'parts' put: message partsAsJson;
			   yourself ]) asArray
]

{ #category : 'accessing' }
GeminiChatRequest >> conversation [

	^ conversation
]

{ #category : 'accessing' }
GeminiChatRequest >> conversation: anObject [

	conversation := anObject
]
