"I exchange Application Default Credentials (ADC) for OAuth2 access tokens.

I support `authorized_user` (refresh-token flow) and `service_account` (RS256 JWT
exchange). I cache the token and refresh it when expired. `getAccessToken` is the
main entry point; `GoogleHttpClient` calls it when building authenticated requests.
"
Class {
	#name : 'GoogleAuthClient',
	#superclass : 'Object',
	#instVars : [
		'credentialsLoader',
		'httpClient',
		'tokenCache'
	],
	#category : 'Google-Auth-Core',
	#package : 'Google-Auth',
	#tag : 'Core'
}

{ #category : 'private' }
GoogleAuthClient >> configureAuthorizedUserEntity: anEntity using: adcContents [
	"Configures the entity for an authorized_user credential type."

	#( 'client_id' 'client_secret' 'refresh_token' ) do: [ :k |
		anEntity at: k put: (adcContents at: k) ].
	anEntity at: 'grant_type' put: 'refresh_token'
]

{ #category : 'private' }
GoogleAuthClient >> configureEntity: anEntity forType: aType using: adcContents [
	"Configures the entity based on the credential type."

	aType = 'authorized_user'
		ifTrue: [
		self configureAuthorizedUserEntity: anEntity using: adcContents ]
		ifFalse: [
			aType = 'service_account'
				ifTrue: [
				self configureServiceAccountEntity: anEntity using: adcContents ]
				ifFalse: [ self error: 'Unsupported credential type: ' , aType ] ]
]

{ #category : 'private' }
GoogleAuthClient >> configureServiceAccountEntity: anEntity using: adcContents [
	"Configures the entity for a service_account credential type."

	| now payload jwt |
	now := DateAndTime now asUnixTime.
	payload := JWTClaimsSet new
		           iss: (adcContents at: 'client_email');
		           at: 'scope'
		           put: 'https://www.googleapis.com/auth/cloud-platform';
		           aud: (adcContents at: 'token_uri');
		           exp: now + 3600;
		           iat: now;
		           yourself.

	jwt := JsonWebSignature new
		       algorithmName: 'RS256';
		       payload: payload;
		       yourself.
	jwt key: (adcContents at: 'private_key').

	anEntity at: 'assertion' put: jwt compactSerialized.
	anEntity
		at: 'grant_type'
		put: 'urn:ietf:params:oauth:grant-type:jwt-bearer'
]

{ #category : 'private' }
GoogleAuthClient >> createRequest [

	^ ZnRequest empty
]

{ #category : 'private' }
GoogleAuthClient >> credentialsForType: aType using: adcContents [

	| entity fetchedAt request response |
	entity := ZnApplicationFormUrlEncodedEntity new.
	self configureEntity: entity forType: aType using: adcContents.

	fetchedAt := DateAndTime now asUnixTime.

	request := self createRequest.
	request method: #POST.
	request url: self oauth2Endpoint.
	request entity: entity.
	self httpClient request: request.
	self httpClient execute.

	response := (NeoJSONReader on:
			             self httpClient response contents readStream)
		            mapClass: GoogleOauth2RefreshResponse;
		            next.
	^ response
		  fetchedAt: fetchedAt;
		  yourself
]

{ #category : 'accessing' }
GoogleAuthClient >> credentialsLoader [

	^ credentialsLoader ifNil: [ credentialsLoader := GoogleCredentialLoader new ]
]

{ #category : 'accessing' }
GoogleAuthClient >> credentialsLoader: aGoogleCredentialLoader [

	credentialsLoader := aGoogleCredentialLoader
]

{ #category : 'default' }
GoogleAuthClient >> defaultHttpClientClass [

	^ ZnClient
]

{ #category : 'accessing auth' }
GoogleAuthClient >> getAccessToken [

	^ self getCredentials token
]

{ #category : 'private' }
GoogleAuthClient >> fetchCredentials [
	"Load ADC and exchange them for a fresh OAuth2 access token."

	| adcContents |
	adcContents := self credentialsLoader
		               loadApplicationDefaultCredentials.
	^ self
		  credentialsForType: (adcContents at: 'type')
		  using: adcContents
]

{ #category : 'accessing auth' }
GoogleAuthClient >> getCredentials [
	"Return cached credentials while still valid, otherwise fetch and cache."

	tokenCache ifNotNil: [ :cache |
		cache isExpired ifFalse: [ ^ cache ] ].
	^ tokenCache := self fetchCredentials
]

{ #category : 'accessing' }
GoogleAuthClient >> httpClient [

	^ httpClient ifNil: [ httpClient := self defaultHttpClientClass new ]
]

{ #category : 'accessing' }
GoogleAuthClient >> httpClient: aZnClient [

	httpClient := aZnClient
]

{ #category : 'default' }
GoogleAuthClient >> oauth2Endpoint [

	^ 'https://oauth2.googleapis.com/token'
]

{ #category : 'accessing' }
GoogleAuthClient >> tokenCache [

	^ tokenCache
]

{ #category : 'accessing' }
GoogleAuthClient >> tokenCache: aGoogleOauth2RefreshResponse [

	tokenCache := aGoogleOauth2RefreshResponse
]
