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
			package: 'Google-Auth-Tests'
			with: [ spec requires: #( 'Google-Auth' ) ];
			package: 'Google-BigQuery'
			with: [ spec requires: #( 'Google-Core' ) ];
			package: 'Google-GenAI'
			with: [ spec requires: #( 'Google-Core' ) ];
			package: 'Google-GenAI-Tests'
			with: [ spec requires: #( 'Google-GenAI' ) ].

		spec
			group: 'Core' with: #( 'Google-Auth' 'Google-Core' );
			group: 'BigQuery' with: #( 'Google-BigQuery' );
			group: 'GenAI' with: #( 'Google-GenAI' );
			group: 'Tests'
			with:
				#( 'Google-Core-Tests' 'Google-Auth-Tests' 'Google-GenAI-Tests' );
			group: 'default' with: #( 'Core' 'BigQuery' 'GenAI' 'Tests' ) ]
]

{ #category : 'baselines' }
BaselineOfGoogleCloud >> defineDependencies: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

	spec
		baseline: 'JSONWebToken'
		with: [ spec repository: 'github://noha/JSONWebToken/source' ]
]
