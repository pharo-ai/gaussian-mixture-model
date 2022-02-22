Class {
	#name : #AIGaussianMixtureModelRandomInitializationStrategy,
	#superclass : #AIGaussianMixtureModelInitializationStrategy,
	#category : #'AI-GaussianMixtureModel'
}

{ #category : #initialization }
AIGaussianMixtureModelRandomInitializationStrategy >> initializeMeanVectorsFor: aCollectionOfCollections numberOfGaussians: aNumber [
	| power columns random |
	
	power := aCollectionOfCollections anyOne size.
	
	columns := (1 to: power) collect: [ :j |
		aCollectionOfCollections collect: [ :each | each at: j ] ].
	
	random := Random new.
	
	^ (1 to: aNumber) collect: [ :k |
		PMVector withAll: ((1 to: power) collect: [ :j |
			(columns at: j) at: (random nextIntegerBetween: 1 and: aCollectionOfCollections size) ]) ].
	
]
