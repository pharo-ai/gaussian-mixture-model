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
	model randomSeed: 3.
	data := #( #( 0 0.25 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) )
]

{ #category : #tests }
AIGaussianMixtureModelTest >> testFitX [

	model numberOfGaussians: 2.
	model fitX: data
]

{ #category : #tests }
AIGaussianMixtureModelTest >> testLabels [

	model numberOfGaussians: 2.
	model fitX: #( #( 1 2 ) #( 1 4 ) #( 1 0 ) #( 10 2 ) #( 10 4 ) #( 10 0 ) ).

	self
		assertCollection: model labels
		includesAll: #( 1 1 1 0 0 0 )
]

{ #category : #tests }
AIGaussianMixtureModelTest >> testPredictNewData [

	model numberOfGaussians: 2.
	model fitX: #( #( 1 2 ) #( 1 4 ) #( 1 0 ) #( 10 2 ) #( 10 4 ) #( 10 0 ) ).

	self
		assertCollection: (model predict: #( #( 0 0 ) #( 12 3 ) ))
		includesAll: #( 1 0 )
]

{ #category : #tests }
AIGaussianMixtureModelTest >> testPredictSameFittingData [

	model numberOfGaussians: 2.
	model fitX: #( #( 1 2 ) #( 1 4 ) #( 1 0 ) #( 10 2 ) #( 10 4 ) #( 10 0 ) ).

	self
		assertCollection: (model predict: #( #( 1 2 ) #( 1 4 ) #( 1 0 ) #( 10 2 ) #( 10 4 ) #( 10 0 ) ))
		includesAll: #( 1 1 1 0 0 0 )
]

{ #category : #tests }
AIGaussianMixtureModelTest >> testProbabilityOfVectorBeingGeneratedByDistribution [

	| meanVector covarianceMatrix distribution vector distributionIndex probability |
	
	"Setting model parameters for easy manual calculation"
	meanVector := #(0 1) asPMVector.
	
	covarianceMatrix := PMMatrix rows: #(
		(1 0.8)
		(0.8 1)).
		
	distribution := PMMultivariateNormalDistribution 
		meanVector: meanVector
		covarianceMatrix: covarianceMatrix.
	
	model gaussians: { distribution }.
	
	vector := #(1 1) asPMVector.
	distributionIndex := 1.
	
	probability := model
		probabilityOfVector: vector
		beingGeneratedByDistributionAt: distributionIndex.
		
	self assert: probability closeTo: 0.06614272766298163.
]
