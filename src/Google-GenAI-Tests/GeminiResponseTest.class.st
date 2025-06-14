Class {
	#name : 'GeminiResponseTest',
	#superclass : 'TestCase',
	#category : 'Google-GenAI-Tests',
	#package : 'Google-GenAI-Tests'
}

{ #category : 'tests' }
GeminiResponseTest >> testFromJson [

	| jsonString response |
	jsonString := '{
        "candidates": [
            {
                "content": {
                    "parts": [
                        {"text": "Hello! How can I help you today?"}
                    ]
                },
                "finishReason": "STOP"
            }
        ]
    }'.

	response := GeminiResponse fromJson: jsonString.

	self assert: response candidates size equals: 1.
	self assert: response text equals: 'Hello! How can I help you today?'
]

{ #category : 'tests' }
GeminiResponseTest >> testFromJsonEmpty [

	| jsonString response |
	jsonString := '{"candidates": []}'.

	response := GeminiResponse fromJson: jsonString.

	self assert: response candidates isEmpty.
	self assert: response text equals: ''
]
