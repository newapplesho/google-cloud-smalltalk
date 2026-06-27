"I build a single-turn `generateContent` request for a Gemini model.

I hold the `model`, the user `prompt`, and optional `generationConfig`,
`safetySettings`, `tools` (`GeminiTool`), `toolConfig` (`GeminiToolConfig`) and a
`systemInstruction` string. `asJson` serializes the wire payload via NeoJSON.
`GeminiChatRequest` subclasses me for multi-turn conversations.

Example:
  request := GeminiRequest new
      model: 'gemini-2.5-flash';
      prompt: 'What is the weather in Tokyo?';
      addTool: aWeatherTool;
      yourself.

Reference:
  models.generateContent (REST): https://ai.google.dev/api/generate-content
  GenerationConfig: https://ai.google.dev/api/generate-content#v1beta.GenerationConfig
  systemInstruction / tools / toolConfig: https://ai.google.dev/api/caching#Content
"
Class {
	#name : 'GeminiRequest',
	#superclass : 'Object',
	#instVars : [
		'model',
		'prompt',
		'generationConfig',
		'safetySettings',
		'tools',
		'toolConfig',
		'systemInstruction'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'building' }
GeminiRequest >> addCommonFieldsTo: aDictionary [
	"Add the optional fields shared by all request kinds."

	generationConfig isEmpty ifFalse: [
		aDictionary at: 'generationConfig' put: generationConfig ].
	safetySettings isEmpty ifFalse: [
		aDictionary at: 'safetySettings' put: safetySettings asArray ].
	self addToolFieldsTo: aDictionary
]

{ #category : 'building' }
GeminiRequest >> addTool: aGeminiTool [

	tools add: aGeminiTool.
	^ aGeminiTool
]

{ #category : 'building' }
GeminiRequest >> addToolFieldsTo: aDictionary [
	"Add tools, toolConfig and systemInstruction when present."

	tools isEmpty ifFalse: [
		aDictionary
			at: 'tools'
			put: (tools collect: [ :each | each asDictionary ]) asArray ].
	toolConfig ifNotNil: [
		aDictionary at: 'toolConfig' put: toolConfig asDictionary ].
	systemInstruction ifNotNil: [
		aDictionary
			at: 'systemInstruction'
			put: (self contentDictForText: systemInstruction) ]
]

{ #category : 'converting' }
GeminiRequest >> asJson [

	| contents |
	contents := Dictionary new
		            at: 'contents'
		            put: (Array with: (self contentDictForText: prompt));
		            yourself.
	self addCommonFieldsTo: contents.
	^ NeoJSONWriter toString: contents
]

{ #category : 'private' }
GeminiRequest >> contentDictForText: aString [
	"A single user-role content holding one text part."

	^ Dictionary new
		  at: 'role' put: 'user';
		  at: 'parts' put: (Array with: (Dictionary new
					    at: 'text' put: aString;
					    yourself));
		  yourself
]

{ #category : 'initialization' }
GeminiRequest >> initialize [

	super initialize.
	generationConfig := Dictionary new.
	safetySettings := OrderedCollection new.
	tools := OrderedCollection new
]

{ #category : 'accessing' }
GeminiRequest >> maxOutputTokens: anInteger [
	"Set maximum tokens in response"

	generationConfig at: 'maxOutputTokens' put: anInteger
]

{ #category : 'accessing' }
GeminiRequest >> model [

	^ model
]

{ #category : 'accessing' }
GeminiRequest >> model: aString [

	model := aString
]

{ #category : 'accessing' }
GeminiRequest >> prompt [

	^ prompt
]

{ #category : 'accessing' }
GeminiRequest >> prompt: aString [

	prompt := aString
]

{ #category : 'accessing' }
GeminiRequest >> systemInstruction [

	^ systemInstruction
]

{ #category : 'accessing' }
GeminiRequest >> systemInstruction: aString [

	systemInstruction := aString
]

{ #category : 'accessing' }
GeminiRequest >> temperature: aNumber [
	"Set generation temperature (0.0 to 1.0)"

	generationConfig at: 'temperature' put: aNumber
]

{ #category : 'accessing' }
GeminiRequest >> toolConfig [

	^ toolConfig
]

{ #category : 'accessing' }
GeminiRequest >> toolConfig: aGeminiToolConfig [

	toolConfig := aGeminiToolConfig
]

{ #category : 'accessing' }
GeminiRequest >> tools [

	^ tools
]

{ #category : 'accessing' }
GeminiRequest >> tools: aCollection [

	tools := aCollection asOrderedCollection
]

{ #category : 'accessing' }
GeminiRequest >> responseMimeType: aString [
	"Constrain the output format, e.g. 'application/json' for structured output."

	generationConfig at: 'responseMimeType' put: aString
]

{ #category : 'accessing' }
GeminiRequest >> responseSchema: aDictionary [
	"An OpenAPI-subset schema the JSON output must conform to (structured output).
	 Same shape as a GeminiFunctionDeclaration's parameters."

	generationConfig at: 'responseSchema' put: aDictionary
]

{ #category : 'accessing' }
GeminiRequest >> topP: aNumber [

	generationConfig at: 'topP' put: aNumber
]
