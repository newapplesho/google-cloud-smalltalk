"I declare a function (tool) that a Gemini model may call.

I carry a `name`, a `description` the model uses to decide when to call me, and a
`parameters` schema (an OpenAPI-subset Dictionary with `type`, `properties` and
`required`). Build the schema by hand, or use my convenience builders
`parameterNamed:type:description:` and `requiredParameters:`.

Example:
  decl := GeminiFunctionDeclaration name: 'get_weather'
              description: 'Get the current weather for a city'.
  decl parameterNamed: 'city' type: 'string' description: 'City name'.
  decl requiredParameters: #('city').

Reference:
  FunctionDeclaration (REST): https://ai.google.dev/api/caching#FunctionDeclaration
  Schema (parameters): https://ai.google.dev/api/caching#Schema
  Function calling guide: https://ai.google.dev/gemini-api/docs/function-calling
"
Class {
	#name : 'GeminiFunctionDeclaration',
	#superclass : 'Object',
	#instVars : [
		'name',
		'description',
		'parameters'
	],
	#category : 'Google-GenAI',
	#package : 'Google-GenAI'
}

{ #category : 'instance creation' }
GeminiFunctionDeclaration class >> name: aName description: aDescription [

	^ self new
		  name: aName;
		  description: aDescription;
		  yourself
]

{ #category : 'converting' }
GeminiFunctionDeclaration >> asDictionary [

	| dict |
	dict := Dictionary new
		        at: 'name' put: name;
		        yourself.
	description ifNotNil: [ dict at: 'description' put: description ].
	self hasParameters ifTrue: [ dict at: 'parameters' put: parameters ].
	^ dict
]

{ #category : 'accessing' }
GeminiFunctionDeclaration >> description [

	^ description
]

{ #category : 'accessing' }
GeminiFunctionDeclaration >> description: aString [

	description := aString
]

{ #category : 'testing' }
GeminiFunctionDeclaration >> hasParameters [

	^ parameters notNil and: [ (parameters at: 'properties') notEmpty ]
]

{ #category : 'initialization' }
GeminiFunctionDeclaration >> initialize [

	super initialize.
	parameters := Dictionary new
		              at: 'type' put: 'object';
		              at: 'properties' put: Dictionary new;
		              yourself
]

{ #category : 'accessing' }
GeminiFunctionDeclaration >> name [

	^ name
]

{ #category : 'accessing' }
GeminiFunctionDeclaration >> name: aString [

	name := aString
]

{ #category : 'building' }
GeminiFunctionDeclaration >> parameterNamed: aName type: aType description: aDescription [
	"Add a single property to the parameters schema."

	| property |
	property := Dictionary new
		            at: 'type' put: aType;
		            at: 'description' put: aDescription;
		            yourself.
	(parameters at: 'properties') at: aName put: property
]

{ #category : 'accessing' }
GeminiFunctionDeclaration >> parameters [

	^ parameters
]

{ #category : 'accessing' }
GeminiFunctionDeclaration >> parameters: aDictionary [
	"Set the full OpenAPI-subset parameter schema at once."

	parameters := aDictionary
]

{ #category : 'building' }
GeminiFunctionDeclaration >> requiredParameters: aCollectionOfNames [
	"Mark the named parameters as required in the schema."

	parameters at: 'required' put: aCollectionOfNames asArray
]
