Class {
	#name : #AIGaussianMixtureModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'data'
	],
	#category : #'AI-GaussianMixtureModel-Tests'
}

{ #category : #running }
AIGaussianMixtureModelTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	model := AIGaussianMixtureModel new.
	data := #( #( 0 0.25 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) )
]

{ #category : #test }
AIGaussianMixtureModelTest >> testFit [

	
	model fit:data
]
