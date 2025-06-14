Class {
	#name : 'GeminiErrorTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiErrorTest >> testText [

	| error |
	error := GeminiError new.
	error message: 'Test error'.

	self assert: error text equals: 'Error: Test error'
]
