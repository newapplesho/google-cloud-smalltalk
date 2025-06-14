Class {
	#name : 'BaselineOfGoogleCloud',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGoogleCloud',
	#package : 'BaselineOfGoogleCloud'
}

{ #category : 'baselines' }
BaselineOfGoogleCloud >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.

		spec
			package: 'Google-Auth'
			with: [ spec requires: #( 'NeoJSON' 'JSONWebToken' ) ];
			package: 'Google-Core'
			with: [ spec requires: #( 'Google-Auth' 'NeoJSON' ) ];
			package: 'Google-Core-Tests'
			with: [ spec requires: #( 'Google-Core' ) ];
			package: 'Google-BigQuery'
			with: [ spec requires: #( 'Google-Core' ) ];
			package: 'Google-GenAI'
			with: [ spec requires: #( 'Google-Core' ) ]; 
			package: 'Google-GenAI-Tests'
			with: [ spec requires: #( 'Google-GenAI' ) ].].

	spec
		group: 'Tests' with: #( 'Google-Core' 'Google-GenAI' );
		group: 'CI' with: #( 'Tests' )
]

{ #category : 'baselines' }
BaselineOfGoogleCloud >> defineDependencies: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

	spec baseline: 'OpenSSL' with: [
		spec repository:
			'github://PierceNg/OpenSSL-Pharo:openssl_1_1_pharo9/src-st' ].

	spec
		baseline: 'JSONWebToken'
		with: [ spec repository: 'github://noha/JSONWebToken/source' ]
]
