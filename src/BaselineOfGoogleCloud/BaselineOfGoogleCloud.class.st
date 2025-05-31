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
		spec
			baseline: 'JSONWebToken'
			with: [ spec repository: 'github://noha/JSONWebToken/source' ].

		spec
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

		spec
			package: 'Google-Core';
			package: 'Google-Auth' with: [ spec requires: #( 'Google-Core' ) ] ].

	spec
		group: 'Tests' with: #( 'Google-Core' );
		group: 'CI' with: #( 'Tests' )
]
