Class {
	#name : 'GoogleGenAIClient',
	#superclass : 'GoogleAPIClient',
	#instVars : [
		'config',
		'generativeModel'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'building' }
GoogleGenAIClient >> buildUrlFor: aGeminiRequest [

	self config useVertexAI ifTrue: [
		^ String streamContents: [ :stream |
			  stream
				  nextPutAll: config serviceEndpoint;
				  nextPutAll: 'v1/projects/';
				  nextPutAll: config projectId;
				  nextPutAll: '/locations/';
				  nextPutAll: config location;
				  nextPutAll: '/publishers/google/models/';
				  nextPutAll: aGeminiRequest model;
				  nextPutAll: ':generateContent' ] ].
	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: config serviceEndpoint;
			  nextPutAll: 'v1beta/models/';
			  nextPutAll: aGeminiRequest model;
			  nextPutAll: ':generateContent??key=';
			  nextPutAll: config apiKey ]
]

{ #category : 'rest api' }
GoogleGenAIClient >> chat: aConversation [

	^ self chat: aConversation withModel: self config defaultModel
]

{ #category : 'rest api' }
GoogleGenAIClient >> chat: aConversation withModel: modelName [

	| request response |
	request := GeminiChatRequest new
		           model: modelName;
		           conversation: aConversation;
		           yourself.
	response := self sendRequest: request.
	^ (response isKindOf: GeminiError)
		  ifTrue: [ response ]
		  ifFalse: [ GeminiResponse fromJson: response ]
]

{ #category : 'accessing' }
GoogleGenAIClient >> config [

	^ config ifNil: [ config := self defaultConfig ]
]

{ #category : 'accessing' }
GoogleGenAIClient >> config: anObject [

	config := anObject
]

{ #category : 'default' }
GoogleGenAIClient >> defaultConfig [

	^ GoogleGenAIConfig default
]

{ #category : 'rest api' }
GoogleGenAIClient >> generateContent: aPrompt [

	^ self generateContent: aPrompt withModel: self config defaultModel
]

{ #category : 'rest api' }
GoogleGenAIClient >> generateContent: aPrompt withModel: modelName [

	| request response |
	request := GeminiRequest new
		           model: modelName;
		           prompt: aPrompt;
		           yourself.
	response := self sendRequest: request.

	^ (response isKindOf: GeminiError)
		  ifTrue: [ response ]
		  ifFalse: [ GeminiResponse fromJson: response ]
]

{ #category : 'accessing' }
GoogleGenAIClient >> generativeModel [

	^ generativeModel
]

{ #category : 'accessing' }
GoogleGenAIClient >> generativeModel: anObject [

	generativeModel := anObject
]

{ #category : 'error handling' }
GoogleGenAIClient >> handleApiError: response [

	| errorData |
	errorData := NeoJSONReader fromString: response contents.
	^ GeminiError new
		  message: (errorData at: 'error' ifAbsent: [ 'Unknown API Error' ]);
		  statusCode: response code;
		  yourself
]

{ #category : 'error handling' }
GoogleGenAIClient >> handleHttpError: anException [

	^ GeminiError new
		  message: 'HTTP Error: ' , anException messageText;
		  yourself
]

{ #category : 'initialization' }
GoogleGenAIClient >> initialize [

	super initialize.
	self client timeout: self config timeout
]

{ #category : 'rest api' }
GoogleGenAIClient >> sendRequest: aGeminiRequest [

	| url jsonPayload response |
	url := self buildUrlFor: aGeminiRequest.
	jsonPayload := aGeminiRequest asJson.

	self config useVertexAI ifFalse: [ self client authClient: nil ].

	[
	response := self client
		            httpPost: url
		            contents: (ZnEntity json: jsonPayload) ]
		on: Error
		do: [ :ex | ^ self handleHttpError: ex ].

	response isSuccess
		ifTrue: [ ^ response contents ]
		ifFalse: [ ^ self handleApiError: response ]
]
