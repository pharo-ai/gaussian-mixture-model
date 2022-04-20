Class {
	#name : #BaselineOfAIGaussianMixtureModel,
	#superclass : #BaselineOf,
	#category : #BaselineOfAIGaussianMixtureModel
}

{ #category : #baselines }
BaselineOfAIGaussianMixtureModel >> baseline: spec [
	<baseline>
	spec for: #common do: [
		"External dependencies"
		spec
			baseline: 'AIExternalDependencies'
			with: [ spec
				loads: #('PolyMathGroup');
				repository: 'github://pharo-ai/external-dependencies' ].
			
		"Packages"
		spec 
			package: 'AI-GaussianMixtureModel' with: [ spec requires: 'AIExternalDependencies' ];
			package: 'AI-GaussianMixtureModel-Tests' with: [ spec requires: #('AI-GaussianMixtureModel') ] ].
]
