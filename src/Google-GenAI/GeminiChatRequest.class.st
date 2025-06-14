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
		            at: 'contents'
		            put: (conversation collect: [ :message |
					             Dictionary new
						             at: 'role' put: message role;
						             at: 'parts' put: (Array with: (Dictionary new
										               at: 'text' put: message content;
										               yourself));
						             yourself ]);
		            yourself.
	generationConfig isEmpty ifFalse: [
		contents at: 'generationConfig' put: generationConfig ].

	safetySettings isEmpty ifFalse: [
		contents at: 'safetySettings' put: safetySettings asArray ].

	^ NeoJSONWriter toString: contents
]

{ #category : 'accessing' }
GeminiChatRequest >> conversation [

	^ conversation
]

{ #category : 'accessing' }
GeminiChatRequest >> conversation: anObject [

	conversation := anObject
]
