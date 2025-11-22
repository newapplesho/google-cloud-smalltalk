"
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

{ #category : 'convenience' }
BigQueryQueryResponse >> collect: aBlock [

	^ self rows collect: aBlock
]

{ #category : 'accessing' }
BigQueryQueryResponse >> dmlStats [

	^ rawJson at: #dmlStats ifAbsent: [ nil ]
]

{ #category : 'convenience' }
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

{ #category : 'convenience' }
BigQueryQueryResponse >> hasErrors [

	^ self errors notEmpty
]

{ #category : 'convenience' }
BigQueryQueryResponse >> hasMorePages [

	^ self pageToken notNil
]

{ #category : 'convenience' }
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
BigQueryQueryResponse >> rawJson: anObject [

	rawJson := anObject
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
