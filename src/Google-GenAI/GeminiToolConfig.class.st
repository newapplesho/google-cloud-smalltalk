"I control how a Gemini model is allowed to call the declared functions.

My `mode` is one of `'AUTO'` (model decides), `'ANY'` (model must call a
function) or `'NONE'` (no calls). When mode is `'ANY'`, `allowedFunctionNames`
optionally restricts which functions may be called. I serialize to a request's
`toolConfig` field.

Example:
  GeminiToolConfig mode: 'ANY' allowedFunctionNames: #('get_weather').

Reference:
  ToolConfig (REST): https://ai.google.dev/api/caching#ToolConfig
  FunctionCallingConfig (REST): https://ai.google.dev/api/caching#FunctionCallingConfig
"
Class {
	#name : 'GeminiToolConfig',
	#superclass : 'Object',
	#instVars : [
		'mode',
		'allowedFunctionNames'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiToolConfig class >> mode: aMode [

	^ self new
		  mode: aMode;
		  yourself
]

{ #category : 'instance creation' }
GeminiToolConfig class >> mode: aMode allowedFunctionNames: aCollection [

	^ self new
		  mode: aMode;
		  allowedFunctionNames: aCollection;
		  yourself
]

{ #category : 'accessing' }
GeminiToolConfig >> allowedFunctionNames [

	^ allowedFunctionNames
]

{ #category : 'accessing' }
GeminiToolConfig >> allowedFunctionNames: aCollection [

	allowedFunctionNames := aCollection
]

{ #category : 'converting' }
GeminiToolConfig >> asDictionary [

	| functionCallingConfig |
	functionCallingConfig := Dictionary new
		                         at: 'mode' put: mode;
		                         yourself.
	allowedFunctionNames ifNotNil: [
		functionCallingConfig
			at: 'allowedFunctionNames'
			put: allowedFunctionNames asArray ].
	^ Dictionary new
		  at: 'functionCallingConfig' put: functionCallingConfig;
		  yourself
]

{ #category : 'accessing' }
GeminiToolConfig >> mode [

	^ mode
]

{ #category : 'accessing' }
GeminiToolConfig >> mode: aString [

	mode := aString
]
