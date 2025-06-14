Class {
	#name : 'GeminiChatRequestTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiChatRequestTest >> testAsJson [

	| request conversation json parsedJson contents |
	request := GeminiChatRequest new.
	request temperature: 0.95.

	conversation := GeminiConversation new.
	conversation addUser: 'Hello'.
	conversation addModel: 'Hi there!'.
	request conversation: conversation.

	json := request asJson.
	parsedJson := NeoJSONReader fromString: json.
	contents := parsedJson at: 'contents'.

	self assert: contents size equals: 2.
	self assert: (contents first at: 'role') equals: 'user'.
	self assert: (contents first at: 'parts') size equals: 1.
	self
		assert: ((contents first at: 'parts') first at: 'text')
		equals: 'Hello'.
	self
		assert: ((parsedJson at: 'generationConfig') at: 'temperature')
		equals: 0.95
]
