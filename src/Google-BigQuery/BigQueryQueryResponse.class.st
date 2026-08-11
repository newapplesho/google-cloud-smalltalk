"I represent the response from a BigQuery `jobs.query` request.

I parse the raw JSON and provide typed accessors for `rows`, `totalRows`,
`schema`, `fields`, `jobComplete`, `cacheHit`, `errors` and pagination
(`pageToken`, `hasMorePages`). `rows` transforms the BigQuery row format into
an ordered collection of field-name-keyed Dictionaries.

Reference:
  https://docs.cloud.google.com/bigquery/docs/reference/rest/v2/jobs/query
"
Class {
	#name : 'BigQueryQueryResponse',
	#superclass : 'Object',
	#instVars : [
		'rawJson'
	],
	#category : 'Google-BigQuery',
	#package : 'Google-BigQuery'
}

{ #category : 'instance creation' }
BigQueryQueryResponse class >> fromJson: aJsonObject [

	^ self new
		  rawJson: aJsonObject;
		  yourself
]

{ #category : 'accessing' }
BigQueryQueryResponse >> cacheHit [

	^ rawJson at: #cacheHit ifAbsent: [ false ]
]

{ #category : 'enumerating' }
BigQueryQueryResponse >> collect: aBlock [

	^ self rows collect: aBlock
]

{ #category : 'accessing' }
BigQueryQueryResponse >> dmlStats [

	^ rawJson at: #dmlStats ifAbsent: [ nil ]
]

{ #category : 'enumerating' }
BigQueryQueryResponse >> do: aBlock [

	self rows do: aBlock
]

{ #category : 'accessing' }
BigQueryQueryResponse >> errors [

	^ rawJson at: #errors ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> fields [

	^ self schema
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :s | s at: #fields ifAbsent: [ #(  ) ] ]
]

{ #category : 'testing' }
BigQueryQueryResponse >> hasErrors [

	^ self errors notEmpty
]

{ #category : 'testing' }
BigQueryQueryResponse >> hasMorePages [

	^ self pageToken notNil
]

{ #category : 'testing' }
BigQueryQueryResponse >> isEmpty [

	^ self totalRows = 0
]

{ #category : 'accessing' }
BigQueryQueryResponse >> jobComplete [

	^ rawJson at: #jobComplete ifAbsent: [ false ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> jobId [

	^ self jobReference
		  ifNil: [ nil ]
		  ifNotNil: [ :ref | ref at: #jobId ifAbsent: [ nil ] ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> jobReference [

	^ rawJson at: #jobReference ifAbsent: [ nil ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> kind [

	^ rawJson at: #kind ifAbsent: [ nil ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> numDmlAffectedRows [

	^ (rawJson at: #numDmlAffectedRows ifAbsent: [ '0' ]) asInteger
]

{ #category : 'accessing' }
BigQueryQueryResponse >> pageToken [

	^ rawJson at: #pageToken ifAbsent: [ nil ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> queryId [

	^ rawJson at: #queryId ifAbsent: [ nil ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> rawJson [

	^ rawJson
]

{ #category : 'accessing' }
BigQueryQueryResponse >> rawJson: aDictionary [

	rawJson := aDictionary
]

{ #category : 'accessing' }
BigQueryQueryResponse >> rawRows [

	^ rawJson at: #rows ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> rows [

	| fieldNames |
	fieldNames := self fields collect: [ :f | f at: #name ].

	^ self rawRows collect: [ :row |
			  | dict values |
			  dict := Dictionary new.
			  values := row at: #f.
			  fieldNames withIndexDo: [ :name :index |
				  dict at: name put: ((values at: index) at: #v) ].
			  dict ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> schema [

	^ rawJson at: #schema ifAbsent: [ nil ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> sessionInfo [

	^ rawJson at: #sessionInfo ifAbsent: [ nil ]
]

{ #category : 'accessing' }
BigQueryQueryResponse >> totalBytesProcessed [

	^ (rawJson at: #totalBytesProcessed ifAbsent: [ '0' ]) asInteger
]

{ #category : 'accessing' }
BigQueryQueryResponse >> totalRows [

	^ (rawJson at: #totalRows ifAbsent: [ '0' ]) asInteger
]
