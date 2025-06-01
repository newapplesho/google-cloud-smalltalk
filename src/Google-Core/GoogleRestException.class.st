Class {
	#name : 'GoogleRestException',
	#superclass : 'Error',
	#instVars : [
		'properties'
	],
	#category : 'Google-Core',
	#package : 'Google-Core'
}

{ #category : 'accessing' }
GoogleRestException >> properties [

	^ properties
]

{ #category : 'accessing' }
GoogleRestException >> properties: anObject [

	properties := anObject
]
