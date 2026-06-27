Class {
	#name : 'GeminiErrorTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiErrorTest >> testSignalIsCaughtAndExposesMessageText [

	| caught |
	caught := false.
	[ (GeminiError new message: 'boom'; yourself) signal ]
		on: GeminiError
		do: [ :e |
			caught := true.
			self assert: e messageText equals: 'boom' ].
	self assert: caught
]

{ #category : 'tests' }
GeminiErrorTest >> testText [

	| error |
	error := GeminiError new.
	error message: 'Test error'.

	self assert: error text equals: 'Error: Test error'
]
