Class {
	#name : 'GeminiChatMessage',
	#superclass : 'Object',
	#instVars : [
		'role',
		'content'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiChatMessage class >> model: aString [

	^ self new
		  role: 'model';
		  content: aString;
		  yourself
]

{ #category : 'instance creation' }
GeminiChatMessage class >> user: aString [

	^ self new
		  role: 'user';
		  content: aString;
		  yourself
]

{ #category : 'accessing' }
GeminiChatMessage >> content [

	^ content
]

{ #category : 'accessing' }
GeminiChatMessage >> content: aString [

	content := aString
]

{ #category : 'accessing' }
GeminiChatMessage >> role [

	^ role
]

{ #category : 'accessing' }
GeminiChatMessage >> role: aString [

	role := aString
]
