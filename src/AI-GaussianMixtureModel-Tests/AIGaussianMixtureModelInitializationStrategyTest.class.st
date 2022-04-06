Class {
	#name : #AIGaussianMixtureModelInitializationStrategyTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'data'
	],
	#category : #'AI-GaussianMixtureModel-Tests'
}

{ #category : #testing }
AIGaussianMixtureModelInitializationStrategyTest class >> isAbstract [

	^ self == AIGaussianMixtureModelInitializationStrategyTest
]

{ #category : #initialization }
AIGaussianMixtureModelInitializationStrategyTest >> setUp [

	super setUp.

	model := self strategy.
	data := 
				 #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) )
]

{ #category : #initialization }
AIGaussianMixtureModelInitializationStrategyTest >> strategy [

	^ self subclassResponsibility
]

{ #category : #initialization }
AIGaussianMixtureModelInitializationStrategyTest >> testInitializeCovarianceMatrices [

	| expected |
	expected := { (PMSymmetricMatrix new initializeIdentity: 2). (PMSymmetricMatrix new initializeIdentity: 2) }.

	self
		assertCollection: (model initializeCovarianceMatricesFor: data numberOfGaussians: 2)
		equals: expected
]

{ #category : #initialization }
AIGaussianMixtureModelInitializationStrategyTest >> testInitializeMixingCoefficients [

	self
		assertCollection: (model initializeMixingCoefficientsFor: data numberOfGaussians: 2)
		equals: { 1 / 2 . 1 / 2 }
]
