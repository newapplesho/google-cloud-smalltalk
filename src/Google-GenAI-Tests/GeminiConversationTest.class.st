Class {
	#name : 'GeminiConversationTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiConversationTest >> testInitialize [

	| conversation |
	conversation := GeminiConversation new.
	self assert: conversation messages isEmpty
]

{ #category : 'tests' }
GeminiConversationTest >> testMessages [

	| conversation |
	conversation := GeminiConversation new.
	conversation addUser: 'Hello'.
	conversation addModel: 'Hi there!'.

	self assert: conversation messages size equals: 2.
	self assert: conversation messages first role equals: 'user'.
	self assert: conversation messages first content equals: 'Hello'.
	self assert: conversation messages second role equals: 'model'.
	self assert: conversation messages second content equals: 'Hi there!'
]
