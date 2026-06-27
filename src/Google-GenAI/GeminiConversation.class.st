"I hold the ordered `messages` (`GeminiChatMessage`) of a multi-turn Gemini chat.

Add plain turns with `addUser:` / `addModel:`, a tool result with
`addFunctionResponse:response:`, or any prebuilt message with `addMessage:`.
I serialize to the `contents` array of a generateContent request.

Reference:
  Content (contents[]): https://ai.google.dev/api/caching#Content
"
Class {
	#name : 'GeminiConversation',
	#superclass : 'Object',
	#instVars : [
		'messages'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'accessing' }
GeminiConversation >> addFunctionResponse: aName response: aDictionary [
	"Append a tool result so the model can continue after a function call."

	self addMessage: (GeminiChatMessage functionResponse:
			 (GeminiFunctionResponse name: aName response: aDictionary))
]

{ #category : 'accessing' }
GeminiConversation >> addMessage: aGeminiChatMessage [

	messages add: aGeminiChatMessage
]

{ #category : 'accessing' }
GeminiConversation >> addModel: aString [

	messages add: (GeminiChatMessage model: aString)
]

{ #category : 'accessing' }
GeminiConversation >> addUser: aString [
	messages add: (GeminiChatMessage user: aString)
]

{ #category : 'collection' }
GeminiConversation >> collect: aBlock [

	^ messages collect: aBlock
]

{ #category : 'collection' }
GeminiConversation >> do: aBlock [

	messages do: aBlock
]

{ #category : 'initialization' }
GeminiConversation >> initialize [

	super initialize.
	messages := OrderedCollection new
]

{ #category : 'accessing' }
GeminiConversation >> messages [

	^ messages
]
