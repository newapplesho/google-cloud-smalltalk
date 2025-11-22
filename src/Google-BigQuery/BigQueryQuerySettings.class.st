"
#BigQueryQuerySettings
https://docs.cloud.google.com/bigquery/docs/reference/rest/v2/jobs/query
"
Class {
	#name : 'BigQueryQuerySettings',
	#superclass : 'Object',
	#instVars : [
		'settings'
	],
	#category : 'Google-BigQuery',
	#package : 'Google-BigQuery'
}

{ #category : 'converting' }
BigQueryQuerySettings >> asDictionary [
 ^ settings copy

]

{ #category : 'settings' }
BigQueryQuerySettings >> dryRun [

	settings at: 'dryRun' put: true
]

{ #category : 'initialization' }
BigQueryQuerySettings >> initialize [

	super initialize.
	settings := Dictionary new.
	settings at: 'dryRun' put: false.
	settings at: 'useLegacySql' put: false
]

{ #category : 'settings' }
BigQueryQuerySettings >> maxResults: anInteger [

	settings at: 'maxResults' put: anInteger
]

{ #category : 'settings' }
BigQueryQuerySettings >> timeoutMs: anInteger [ 
 settings at: 'timeoutMs' put: anInteger

]

{ #category : 'settings' }
BigQueryQuerySettings >> useLegacySql [

	settings at: 'useLegacySql' put: true
]
