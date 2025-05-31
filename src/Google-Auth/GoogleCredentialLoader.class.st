Class {
	#name : 'GoogleCredentialLoader',
	#superclass : 'Object',
	#instVars : [
		'filePathProvider'
	],
	#category : 'Google-Auth-Core',
	#package : 'Google-Auth',
	#tag : 'Core'
}

{ #category : 'accessing' }
GoogleCredentialLoader >> filePathProvider: aBlock [

	filePathProvider := aBlock
]

{ #category : 'initialization' }
GoogleCredentialLoader >> initialize [

	super initialize.
	filePathProvider := [
	                    | path |
	                    path := Smalltalk platform environment
		                            at: 'GOOGLE_APPLICATION_CREDENTIALS'
		                            ifPresent: [ :v |
		                            v asString asFileReference ]
		                            ifAbsent: [ nil ].
	                    path ifNil: [
		                    | gclouddir |
		                    gclouddir := FileLocator home / '.config'.
		                    path := gclouddir / 'gcloud'
		                            / 'application_default_credentials.json' ].
	                    path ]
]

{ #category : 'private' }
GoogleCredentialLoader >> loadApplicationDefaultCredentials [

	| credentialsFile |
	credentialsFile := filePathProvider value.
	^ self loadCredentialsFromFile: credentialsFile
]

{ #category : 'private' }
GoogleCredentialLoader >> loadCredentialsFromFile: aFileReference [

	aFileReference ifNil: [ ^ self error: 'Credentials file path is nil' ].
	(aFileReference exists and: [ aFileReference isFile ]) ifFalse: [
		^ self error: 'Credentials file does not exist or is not a file: '
			  , aFileReference fullName ].
	^ (NeoJSONReader on: aFileReference readStream)
		  mapClass: NeoJSONObject;
		  propertyNamesAsSymbols: true;
		  next
]
