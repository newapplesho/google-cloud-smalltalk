"I am the Gemini (Generative AI) client.

I send generateContent requests over Vertex AI or the Gemini API-Key endpoint and
answer a `GeminiResponse`, signalling a `GeminiError` on failure. Beyond plain
`generateContent:` / `chat:`, I provide function-calling primitives
(`generateContent:tools:`, `chat:tools:`), a fully-built request entry point
(`send:`, e.g. for `systemInstruction`), and an automatic tool loop
(`runConversation:tools:handlers:`).

Reference:
  Function calling guide: https://ai.google.dev/gemini-api/docs/function-calling
  models.generateContent (REST): https://ai.google.dev/api/generate-content
  Vertex AI function calling:
    https://cloud.google.com/vertex-ai/generative-ai/docs/multimodal/function-calling
"
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

{ #category : 'function calling' }
GoogleGenAIClient >> attachTools: aToolCollection to: aRequest [
	"Add each tool in the collection to the request (nil is ignored)."

	aToolCollection ifNil: [ ^ aRequest ].
	aToolCollection do: [ :each | aRequest addTool: each ].
	^ aRequest
]

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

{ #category : 'function calling' }
GoogleGenAIClient >> chat: aConversation tools: aToolCollection [
	"Multi-turn chat with tools, using the default model."

	^ self
		  chat: aConversation
		  withModel: self config defaultModel
		  tools: aToolCollection
]

{ #category : 'rest api' }
GoogleGenAIClient >> chat: aConversation withModel: modelName [

	^ self chat: aConversation withModel: modelName tools: nil
]

{ #category : 'function calling' }
GoogleGenAIClient >> chat: aConversation withModel: modelName tools: aToolCollection [

	| request |
	request := GeminiChatRequest new
		           model: modelName;
		           conversation: aConversation;
		           yourself.
	self attachTools: aToolCollection to: request.
	^ self send: request
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

{ #category : 'function calling' }
GoogleGenAIClient >> generateContent: aPrompt tools: aToolCollection [
	"Single-turn generation with tools, using the default model."

	^ self
		  generateContent: aPrompt
		  withModel: self config defaultModel
		  tools: aToolCollection
]

{ #category : 'rest api' }
GoogleGenAIClient >> generateContent: aPrompt withModel: modelName [

	^ self generateContent: aPrompt withModel: modelName tools: nil
]

{ #category : 'function calling' }
GoogleGenAIClient >> generateContent: aPrompt withModel: modelName tools: aToolCollection [

	| request |
	request := GeminiRequest new
		           model: modelName;
		           prompt: aPrompt;
		           yourself.
	self attachTools: aToolCollection to: request.
	^ self send: request
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
GoogleGenAIClient >> messageFrom: errorObj [
	"Extract a human-readable message from the API error JSON."

	errorObj ifNil: [ ^ 'Unknown API Error' ].
	(errorObj isKindOf: Dictionary) ifTrue: [
		^ errorObj at: 'message' ifAbsent: [ errorObj printString ] ].
	^ errorObj asString
]

{ #category : 'error handling' }
GoogleGenAIClient >> signalApiError: response [
	"Signal a GeminiError describing a non-success API response."

	| errorData |
	errorData := NeoJSONReader fromString: response contents.
	^ (GeminiError new
		   message: (self messageFrom: (errorData at: 'error' ifAbsent: [ nil ]));
		   statusCode: response code;
		   yourself) signal
]

{ #category : 'error handling' }
GoogleGenAIClient >> signalHttpError: anException [
	"Signal a GeminiError wrapping an HTTP transport failure."

	^ (GeminiError new
		   message: 'HTTP Error: ' , anException messageText;
		   yourself) signal
]

{ #category : 'initialization' }
GoogleGenAIClient >> initialize [

	super initialize.
	self client timeout: self config timeout
]

{ #category : 'function calling' }
GoogleGenAIClient >> modelMessageFor: aResponse [
	"Rebuild the model's turn (including its functionCall parts) for replay."

	^ GeminiChatMessage
		  role: 'model'
		  parts: aResponse candidates first parts
]

{ #category : 'function calling' }
GoogleGenAIClient >> resolveCalls: aResponse into: aConversation handlers: handlers [
	"Append the model's call turn and one functionResponse per call."

	aConversation addMessage: (self modelMessageFor: aResponse).
	aResponse functionCalls do: [ :call |
		aConversation
			addFunctionResponse: call name
			response: (self runHandlerFor: call with: handlers) ]
]

{ #category : 'function calling' }
GoogleGenAIClient >> runConversation: aConversation tools: aToolCollection handlers: handlers [
	"Automatic function-calling loop with a default iteration guard."

	^ self
		  runConversation: aConversation
		  tools: aToolCollection
		  handlers: handlers
		  maxIterations: 8
]

{ #category : 'function calling' }
GoogleGenAIClient >> runConversation: aConversation tools: aToolCollection handlers: handlers maxIterations: maxIterations [
	"Send, execute any requested tools, append results, and resend until the
	 model stops calling functions (or the iteration guard is reached)."

	| response |
	response := nil.
	maxIterations timesRepeat: [
		response := self chat: aConversation tools: aToolCollection.
		response hasFunctionCall ifFalse: [ ^ response ].
		self resolveCalls: response into: aConversation handlers: handlers ].
	^ response
]

{ #category : 'function calling' }
GoogleGenAIClient >> runHandlerFor: aFunctionCall with: handlers [
	"Run the registered block for a call, normalizing its result to a Dictionary."

	| handler result |
	handler := handlers at: aFunctionCall name ifAbsent: [
		           ^ Dictionary new
			             at: 'error'
			             put: 'No handler for ' , aFunctionCall name;
			             yourself ].
	result := handler value: aFunctionCall args.
	^ (result isKindOf: Dictionary)
		  ifTrue: [ result ]
		  ifFalse: [ Dictionary new at: 'result' put: result; yourself ]
]

{ #category : 'rest api' }
GoogleGenAIClient >> send: aRequest [
	"Send a fully-built GeminiRequest / GeminiChatRequest and answer a
	 GeminiResponse. Use this to pass options the convenience methods do not
	 expose directly, e.g. systemInstruction or a custom toolConfig:
	     client send: (GeminiRequest new
	         prompt: 'Hi';
	         systemInstruction: 'You are a pirate';
	         yourself).
	 The request's model defaults to the config's defaultModel when unset.
	 Failures are signalled as a GeminiError (see sendRequest:)."

	aRequest model ifNil: [ aRequest model: self config defaultModel ].
	^ GeminiResponse fromJson: (self sendRequest: aRequest)
]

{ #category : 'rest api' }
GoogleGenAIClient >> sendRequest: aGeminiRequest [
	"POST the request and answer the raw response body on success.
	 On an HTTP transport failure or a non-success status, signal a GeminiError."

	| url jsonPayload response |
	url := self buildUrlFor: aGeminiRequest.
	jsonPayload := aGeminiRequest asJson.

	self config useVertexAI ifFalse: [ self client authClient: nil ].

	[
	response := self client
		            httpPost: url
		            contents: (ZnEntity json: jsonPayload) ]
		on: Error
		do: [ :ex | self signalHttpError: ex ].

	^ response isSuccess
		  ifTrue: [ response contents ]
		  ifFalse: [ self signalApiError: response ]
]
