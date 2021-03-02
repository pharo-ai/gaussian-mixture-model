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
			baseline: 'PolyMath'
			with: [ spec repository: 'github://PolyMathOrg/PolyMath:master/src' ].
			
		"Packages"
		spec 
			package: 'AI-GaussianMixtureModel' with: [ spec requires: 'PolyMath' ];
			package: 'AI-GaussianMixtureModel-Tests' with: [ spec requires: #('AI-GaussianMixtureModel') ] ].
]
