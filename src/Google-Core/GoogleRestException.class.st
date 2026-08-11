"I am the exception signalled when a Google Cloud REST API request fails.

I carry the raw error `properties` (parsed JSON) from the API response. Callers
catch me with `[ ... ] on: GoogleRestException do: [ :e | e messageText ]`.
"
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
GoogleRestException >> properties: aDictionary [

	properties := aDictionary
]
