Class {
	#name : #AIGaussianMixtureModelInitializationStrategy,
	#superclass : #Object,
	#category : #'AI-GaussianMixtureModel'
}

{ #category : #initialization }
AIGaussianMixtureModelInitializationStrategy >> initializeCovarianceMatricesFor: aCollectionOfCollections numberOfGaussians: aNumber [
	"TODO: Find a better way to initialize covariance matrices"
	| power |
	power := aCollectionOfCollections anyOne size.
	
	^ (1 to: aNumber) collect: [ :k |
		PMSymmetricMatrix identity: power ]
]

{ #category : #initialization }
AIGaussianMixtureModelInitializationStrategy >> initializeGaussiansFor: aCollectionOfCollections numberOfGaussians: aNumber [
	| sigmas mus |
	
	sigmas := self initializeCovarianceMatricesFor: aCollectionOfCollections numberOfGaussians: aNumber.
	mus := self initializeMeanVectorsFor: aCollectionOfCollections numberOfGaussians: aNumber.
	
	^ (1 to: aNumber) collect: [ :i |
		PMMultivariateNormalDistribution
			meanVector: (mus at: i)
			covarianceMatrix: (sigmas at: i) ]
]

{ #category : #initialization }
AIGaussianMixtureModelInitializationStrategy >> initializeMeanVectorsFor: aCollectionOfCollections numberOfGaussians: aNumber [
	self subclassResponsibility
]

{ #category : #initialization }
AIGaussianMixtureModelInitializationStrategy >> initializeMixingCoefficientsFor: aCollectionOfCollections numberOfGaussians: aNumber [
	^ (1 to: aNumber) collect: [ :k | 1 / aNumber ]
]
