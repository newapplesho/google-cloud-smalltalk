Class {
	#name : 'GoogleAPIConfig',
	#superclass : 'Object',
	#instVars : [
		'location',
		'projectId'
	],
	#classInstVars : [
		'default'
	],
	#category : 'Google-Core',
	#package : 'Google-Core'
}

{ #category : 'accessing' }
GoogleAPIConfig class >> default [
	default ifNil: [ default := self new ].
	^default
]

{ #category : 'class initialization' }
GoogleAPIConfig class >> initialize [
	default := nil.
]

{ #category : 'accessing' }
GoogleAPIConfig >> location [

	^ location ifNil: [ location := 'us-central1' ]
]

{ #category : 'accessing' }
GoogleAPIConfig >> location: aString [

	location := aString
]

{ #category : 'accessing' }
GoogleAPIConfig >> projectId [

	^ projectId
]

{ #category : 'accessing' }
GoogleAPIConfig >> projectId: aString [

	projectId := aString
]
