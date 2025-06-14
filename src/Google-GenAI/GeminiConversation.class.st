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
