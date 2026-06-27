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
GeminiResponseTest >> testFromJsonWithFunctionCall [

	| jsonString response call |
	jsonString := '{
        "candidates": [
            {
                "content": {
                    "parts": [
                        {"functionCall": {
                            "name": "get_weather",
                            "args": {"city": "Tokyo"}
                        }}
                    ]
                },
                "finishReason": "STOP"
            }
        ]
    }'.

	response := GeminiResponse fromJson: jsonString.

	self assert: response hasFunctionCall.
	self assert: response functionCalls size equals: 1.
	call := response functionCalls first.
	self assert: call name equals: 'get_weather'.
	self assert: (call args at: 'city') equals: 'Tokyo'.
	self assert: response text equals: ''
]

{ #category : 'tests' }
GeminiResponseTest >> testJsonParsesStructuredText [

	| jsonString response parsed |
	jsonString := '{"candidates": [{"content": {"parts": [
        {"text": "{\"city\": \"Tokyo\", \"tempC\": 21}"}]}}]}'.
	response := GeminiResponse fromJson: jsonString.

	parsed := response json.
	self assert: (parsed at: 'city') equals: 'Tokyo'.
	self assert: (parsed at: 'tempC') equals: 21
]

{ #category : 'tests' }
GeminiResponseTest >> testFromJsonEmpty [

	| jsonString response |
	jsonString := '{"candidates": []}'.

	response := GeminiResponse fromJson: jsonString.

	self assert: response candidates isEmpty.
	self assert: response text equals: ''
]
