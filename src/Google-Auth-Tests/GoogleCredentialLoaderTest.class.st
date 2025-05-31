Class {
	#name : 'GoogleCredentialLoaderTest',
	#superclass : 'TestCase',
	#instVars : [
		'loader',
		'testCredentialsFile'
	],
	#category : 'Google-Auth-Tests-Core',
	#package : 'Google-Auth-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
GoogleCredentialLoaderTest >> setUp [

	super setUp.
	loader := GoogleCredentialLoader new.
	testCredentialsFile := FileLocator workingDirectory / 'test_adc.json'.
	testCredentialsFile ensureDelete.
	testCredentialsFile writeStreamDo: [ :stream |
		stream nextPutAll:
			'{"client_id": "test-client-id", "type": "authorized_user"}' ]
]

{ #category : 'running' }
GoogleCredentialLoaderTest >> tearDown [

	testCredentialsFile ifNotNil: [ testCredentialsFile ensureDelete ].
	super tearDown
]

{ #category : 'tests' }
GoogleCredentialLoaderTest >> testLoadApplicationDefaultCredentialsSuccessfully [

	| credentials |
	loader filePathProvider: [ testCredentialsFile ].
	credentials := loader loadApplicationDefaultCredentials.

	self assert: (credentials at: #client_id) equals: 'test-client-id'.
	self assert: (credentials at: #type) equals: 'authorized_user'
]

{ #category : 'tests' }
GoogleCredentialLoaderTest >> testLoadApplicationDefaultCredentialsWhenFileDoesNotExist [

	| nonExistentFile |
	nonExistentFile := FileLocator workingDirectory
	                   / 'non_existent_credentials.json'.
	nonExistentFile ensureDelete.

	loader filePathProvider: [ nonExistentFile ].

	self
		should: [ loader loadApplicationDefaultCredentials ]
		raise: Error
		description:
		'Should raise an error if file from provider does not exist'
]

{ #category : 'tests' }
GoogleCredentialLoaderTest >> testLoadApplicationDefaultCredentialsWhenPathProviderReturnsNil [

	loader filePathProvider: [ nil ].

	self
		should: [ loader loadApplicationDefaultCredentials ]
		raise: Error
		description: 'Should raise an error if resolved path is nil'
]
