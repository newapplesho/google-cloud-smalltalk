"I represent a single message in a Gemini conversation.

I carry a `role` (`'user'` or `'model'`) and an ordered collection of `parts`
(`GeminiPart`). Plain text messages keep working through `content` / `content:`,
which read and write a single text part. Function-calling round-trips add
`functionCall` or `functionResponse` parts via `addPart:`.

Example:
  GeminiChatMessage user: 'Who created Smalltalk?'.
  GeminiChatMessage functionResponse:
      (GeminiFunctionResponse name: 'get_weather' response: aDict).

Reference:
  Content (role + parts): https://ai.google.dev/api/caching#Content
"
Class {
	#name : 'GeminiChatMessage',
	#superclass : 'Object',
	#instVars : [
		'role',
		'parts'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiChatMessage class >> functionResponse: aGeminiFunctionResponse [
	"A user-role message carrying a single function result."

	^ self new
		  role: 'user';
		  addPart: (GeminiPart functionResponse: aGeminiFunctionResponse);
		  yourself
]

{ #category : 'instance creation' }
GeminiChatMessage class >> model: aString [

	^ self new
		  role: 'model';
		  content: aString;
		  yourself
]

{ #category : 'instance creation' }
GeminiChatMessage class >> role: aRole parts: aCollectionOfParts [

	^ self new
		  role: aRole;
		  parts: aCollectionOfParts asOrderedCollection;
		  yourself
]

{ #category : 'instance creation' }
GeminiChatMessage class >> user: aString [

	^ self new
		  role: 'user';
		  content: aString;
		  yourself
]

{ #category : 'building' }
GeminiChatMessage >> addPart: aGeminiPart [

	parts add: aGeminiPart.
	^ aGeminiPart
]

{ #category : 'accessing' }
GeminiChatMessage >> content [
	"The concatenated text of all text parts (backward compatible)."

	^ String streamContents: [ :stream |
		  parts do: [ :part |
			  part isText ifTrue: [
				  stream nextPutAll: (part text ifNil: [ '' ]) ] ] ]
]

{ #category : 'accessing' }
GeminiChatMessage >> content: aString [
	"Replace this message's parts with a single text part."

	parts := OrderedCollection with: (GeminiPart text: aString)
]

{ #category : 'initialization' }
GeminiChatMessage >> initialize [

	super initialize.
	parts := OrderedCollection new
]

{ #category : 'accessing' }
GeminiChatMessage >> parts [

	^ parts
]

{ #category : 'accessing' }
GeminiChatMessage >> parts: aCollection [

	parts := aCollection
]

{ #category : 'converting' }
GeminiChatMessage >> partsAsJson [
	"The wire-shape array of part dictionaries for this message."

	^ (parts collect: [ :part | part asDictionary ]) asArray
]

{ #category : 'accessing' }
GeminiChatMessage >> role [

	^ role
]

{ #category : 'accessing' }
GeminiChatMessage >> role: aString [

	role := aString
]
