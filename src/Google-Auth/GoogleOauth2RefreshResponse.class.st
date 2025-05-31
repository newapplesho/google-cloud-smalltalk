Class {
	#name : 'GoogleOauth2RefreshResponse',
	#superclass : 'NeoJSONObject',
	#instVars : [
		'fetchedAt'
	],
	#category : 'Google-Auth-Model',
	#package : 'Google-Auth',
	#tag : 'Model'
}

{ #category : 'accessing' }
GoogleOauth2RefreshResponse >> fetchedAt [

	^ fetchedAt
]

{ #category : 'accessing' }
GoogleOauth2RefreshResponse >> fetchedAt: anObject [

	fetchedAt := anObject
]

{ #category : 'testing' }
GoogleOauth2RefreshResponse >> isExpired [

	^ fetchedAt + (self at: 'expires_in') <= (Time now asSeconds + 60)
]

{ #category : 'accessing' }
GoogleOauth2RefreshResponse >> token [
	^ self at:'access_token'.
	
]
