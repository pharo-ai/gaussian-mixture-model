Class {
	#name : #BaselineOfAIExpectationMaximization,
	#superclass : #BaselineOf,
	#category : #BaselineOfAIExpectationMaximization
}

{ #category : #baselines }
BaselineOfAIExpectationMaximization >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"Packages"
		spec 
			package: 'AI-ExpectationMaximization';
			package: 'AI-ExpectationMaximization-Tests' with: [ spec requires: #('AI-ExpectationMaximization') ] ].
]
