Class {
	#name : 'BigQueryClient',
	#superclass : 'GoogleAPIClient',
	#category : 'Google-BigQuery',
	#package : 'Google-BigQuery'
}

{ #category : 'rest api' }
BigQueryClient >> datasetsWithAllParameter: aBoolean [

	| url response |
	url := self serviceEndpoint , '/bigquery/v2/projects/'
	       , self projectId , '/datasets?all=' , aBoolean asString.

	response := self client httpGet: url.
	^ self client readFromResponse: response
]

{ #category : 'rest api' }
BigQueryClient >> getDataset: datasetId [

	| url response |
	url := 'https://bigquery.googleapis.com/bigquery/v2/projects/'
	       , self projectId , '/datasets/' , datasetId.

	response := self client httpGet: url.
	^ self client readFromResponse: response
]

{ #category : 'rest api' }
BigQueryClient >> listAllDatasets [

	^ self datasetsWithAllParameter: true
]

{ #category : 'rest api' }
BigQueryClient >> listDatasets [

	^ self datasetsWithAllParameter: true
]

{ #category : 'accessing' }
BigQueryClient >> serviceEndpoint [

	^ 'https://bigquery.googleapis.com'
]
