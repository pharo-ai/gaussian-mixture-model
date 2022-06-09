Class {
	#name : #AIGaussianMixtureModel,
	#superclass : #Object,
	#instVars : [
		'initializationStrategy',
		'numberOfGaussians',
		'gaussians',
		'mixingCoefficients',
		'responsibilities',
		'logLikelihoodHistory',
		'maxIterations'
	],
	#category : #'AI-GaussianMixtureModel'
}

{ #category : #'accesing - defaults' }
AIGaussianMixtureModel class >> defaultMaxIterations [

	^ 100
]

{ #category : #accessing }
AIGaussianMixtureModel class >> numberOfGaussians: aNumber [

	^ self new
		numberOfGaussians: aNumber;
		yourself
]

{ #category : #convergence }
AIGaussianMixtureModel >> calculateLogLikelihoodFor: aCollectionOfVectors [

	| logLikelihood |
	
	logLikelihood := (aCollectionOfVectors collect: [ :each | 
		((1 to: numberOfGaussians) collect: [ :k |
			(mixingCoefficients at: k) * ((gaussians at: k) value: each) ]) sum log ]) sum.
	
	logLikelihoodHistory add: logLikelihood.
]

{ #category : #fitting }
AIGaussianMixtureModel >> calculateResponsibilitiesFor: aCollectionOfVectors [
	| probability numerator denominator |

	^ aCollectionOfVectors collect: [ :each |
		(1 to: numberOfGaussians) collect: [ :k |
			
			probability := self probabilityOfVector: each beingGeneratedByDistributionAt: k.
			
			numerator := (mixingCoefficients at: k) * probability.
			
			denominator := ((1 to: numberOfGaussians) collect: [ :j |
				probability := self probabilityOfVector: each beingGeneratedByDistributionAt: j.
				(mixingCoefficients at: j) * probability ]) sum.
			
			numerator / denominator ] ].
]

{ #category : #fitting }
AIGaussianMixtureModel >> fitX: aCollectionOfCollections [

	| collectionOfVectors |
	collectionOfVectors := OrderedCollection withAll:
		(aCollectionOfCollections collect: [ :each | each asPMVector ]).

	self initializeParametersFor: collectionOfVectors.

	[ self hasConverged ] whileFalse: [
		"Expectation (E step)"
		responsibilities := self calculateResponsibilitiesFor: collectionOfVectors.

		"Maximization (M step)"
		self updateParametersFor: collectionOfVectors.

		"Evaluation"
		self calculateLogLikelihoodFor: collectionOfVectors ]
]

{ #category : #accessing }
AIGaussianMixtureModel >> gaussians [

	^ gaussians
]

{ #category : #accessing }
AIGaussianMixtureModel >> gaussians: anObject [

	gaussians := anObject
]

{ #category : #convergence }
AIGaussianMixtureModel >> hasConverged [

	logLikelihoodHistory size < 2 ifTrue: [ ^ false ].

	logLikelihoodHistory size > maxIterations ifTrue: [ ^ true ].

	(logLikelihoodHistory last closeTo: logLikelihoodHistory nextToLast) ifTrue: [ ^ true ].

	^ false
]

{ #category : #accessing }
AIGaussianMixtureModel >> initializationStrategy [
	^ initializationStrategy
]

{ #category : #accessing }
AIGaussianMixtureModel >> initializationStrategy: anObject [
	initializationStrategy := anObject
]

{ #category : #initialization }
AIGaussianMixtureModel >> initialize [

	super initialize.

	self useRandomInitializationStrategy.

	logLikelihoodHistory := OrderedCollection new.
	maxIterations := self class defaultMaxIterations
]

{ #category : #fitting }
AIGaussianMixtureModel >> initializeParametersFor: aCollectionOfVectors [

	gaussians := initializationStrategy
		initializeGaussiansFor: aCollectionOfVectors
		numberOfGaussians: numberOfGaussians.
		
	mixingCoefficients := initializationStrategy
		initializeMixingCoefficientsFor: aCollectionOfVectors
		numberOfGaussians: numberOfGaussians.
]

{ #category : #classification }
AIGaussianMixtureModel >> labels [

	^ responsibilities collect: [ :each | each indexOf: each max ]
]

{ #category : #accessing }
AIGaussianMixtureModel >> logLikelihood [
	"Answer the current value of log-likelihood. It should be the last value in the history"
	^ logLikelihoodHistory
		ifEmpty: [ nil ]
		ifNotEmpty: [ logLikelihoodHistory last ]
]

{ #category : #accessing }
AIGaussianMixtureModel >> logLikelihoodHistory [

	^ logLikelihoodHistory
]

{ #category : #accessing }
AIGaussianMixtureModel >> maxIterations: aPositiveNumber [

	maxIterations := aPositiveNumber
]

{ #category : #accessing }
AIGaussianMixtureModel >> mixingCoefficients [

	^ mixingCoefficients
]

{ #category : #accessing }
AIGaussianMixtureModel >> numberOfGaussians [
	^ numberOfGaussians
]

{ #category : #accessing }
AIGaussianMixtureModel >> numberOfGaussians: aNumber [
	numberOfGaussians := aNumber
]

{ #category : #classification }
AIGaussianMixtureModel >> predict: aCollectionOfCollections [

	| newResponsibilites aCollectionOfVectors|
	aCollectionOfVectors := OrderedCollection withAll:
		(aCollectionOfCollections collect: [ :each | each asPMVector ]).
		
	newResponsibilites := self calculateResponsibilitiesFor: aCollectionOfVectors.
	^ newResponsibilites collect: [ :each | each indexOf: each max ]
]

{ #category : #fitting }
AIGaussianMixtureModel >> probabilityOfVector: aVector beingGeneratedByDistributionAt: anIndex [

	| distribution |
	distribution := gaussians at: anIndex.
	^ distribution value: aVector
]

{ #category : #accessing }
AIGaussianMixtureModel >> randomSeed [

	^ initializationStrategy randomSeed
]

{ #category : #accessing }
AIGaussianMixtureModel >> randomSeed: aNumber [

	initializationStrategy randomSeed: aNumber
]

{ #category : #fitting }
AIGaussianMixtureModel >> updateParametersFor: aCollectionOfVectors [

	| n mu deviation sigma |
	
	1 to: numberOfGaussians do: [ :k | 
		n := (responsibilities collect: [ :each | each at: k ]) sum.
		mu := (1 / n * ((1 to: aCollectionOfVectors size) collect: [ :i |
			((responsibilities at: i) at: k) * (aCollectionOfVectors at: i) ]) sum).
		
		sigma := 1 / n * ((1 to: aCollectionOfVectors size) collect: [ :i |
			deviation := (aCollectionOfVectors at: i) - mu.
			((responsibilities at: i) at: k) * (deviation tensorProduct: deviation) ]) sum.
		
		(gaussians at: k) initializeMeanVector: mu covarianceMatrix: sigma.
		
		mixingCoefficients at: k put: (n / aCollectionOfVectors size) ]
]

{ #category : #'initialization strategy' }
AIGaussianMixtureModel >> useKMeansInitializationStrategy [

	initializationStrategy := AIGaussianMixtureModelKMeansInitializationStrategy new
]

{ #category : #'initialization strategy' }
AIGaussianMixtureModel >> useRandomInitializationStrategy [

	initializationStrategy := AIGaussianMixtureModelRandomInitializationStrategy new
]
