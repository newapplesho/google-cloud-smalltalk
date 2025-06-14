Class {
	#name : 'GeminiError',
	#superclass : 'Error',
	#instVars : [
		'message',
		'statusCode',
		'properties'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'accessing' }
GeminiError >> code [
	^ self properties code
]

{ #category : 'accessing' }
GeminiError >> errorCode [

	^ self code
]

{ #category : 'accessing' }
GeminiError >> message [

	^ message ifNil: [ message := self properties message ]
]

{ #category : 'accessing' }
GeminiError >> message: anObject [

	message := anObject
]

{ #category : 'accessing' }
GeminiError >> properties [

	^ properties
]

{ #category : 'accessing' }
GeminiError >> properties: anObject [

	properties := anObject
]

{ #category : 'accessing' }
GeminiError >> status [

	^ self properties status
]

{ #category : 'accessing' }
GeminiError >> statusCode [

	^ statusCode
]

{ #category : 'accessing' }
GeminiError >> statusCode: anObject [

	statusCode := anObject
]

{ #category : 'accessing' }
GeminiError >> text [

	^ 'Error: ', self message asString.
]
