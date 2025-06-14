Class {
	#name : 'GeminiChatMessageTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiChatMessageTest >> testModelMessage [

	| message |
	message := GeminiChatMessage model: 'Hi there!'.

	self assert: message role equals: 'model'.
	self assert: message content equals: 'Hi there!'
]

{ #category : 'tests' }
GeminiChatMessageTest >> testUserMessage [

	| message |
	message := GeminiChatMessage user: 'Hello world'.

	self assert: message role equals: 'user'.
	self assert: message content equals: 'Hello world'
]
