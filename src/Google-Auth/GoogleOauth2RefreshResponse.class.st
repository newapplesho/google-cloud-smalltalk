"I hold an OAuth2 token response from the Google token endpoint.

I extend `NeoJSONObject` so I am populated directly by NeoJSON. I add `fetchedAt`
(the unix time the token was obtained) and `isExpired` (with a 60-second margin).
`token` returns the `access_token` value.
"
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
GoogleOauth2RefreshResponse >> fetchedAt: anInteger [

	fetchedAt := anInteger
]

{ #category : 'testing' }
GoogleOauth2RefreshResponse >> isExpired [

	^ fetchedAt + (self at: 'expires_in') <= (DateAndTime now asUnixTime + 60)
]

{ #category : 'accessing' }
GoogleOauth2RefreshResponse >> token [

	^ self at: 'access_token'
]
