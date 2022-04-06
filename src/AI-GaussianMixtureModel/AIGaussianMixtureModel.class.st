Class {
	#name : #AIGaussianMixtureModel,
	#superclass : #Object,
	#instVars : [
		'initializationStrategy',
		'numberOfGaussians',
		'gaussians',
		'mixingCoefficients',
		'responsibilities',
		'logLikelihoodHistory'
	],
	#category : #'AI-GaussianMixtureModel'
}

{ #category : #'class initialization' }
AIGaussianMixtureModel class >> defaultNumberOfGaussians [
	^ 2
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
AIGaussianMixtureModel >> evaluateResponsibilitiesFor: aCollectionOfVectors [
	| numerator denominator |

	responsibilities := aCollectionOfVectors collect: [ :each |
		(1 to: numberOfGaussians) collect: [ :k |
			numerator := (mixingCoefficients at: k) * ((gaussians at: k) value: each).
			denominator := ((1 to: numberOfGaussians) collect: [ :j |
				(mixingCoefficients at: j) * ((gaussians at: j) value: each) ]) sum.
			
			numerator / denominator ] ].
]

{ #category : #fitting }
AIGaussianMixtureModel >> fit: aCollectionOfCollections [
	"Fits the given number of multivariate norml distributions (defined by the numberOfGaussians) to the data which can be a collection of collections or a DataFrame"
	
	| collectionOfVectors |
	
	collectionOfVectors := OrderedCollection withAll: (aCollectionOfCollections
		collect: [ :each | each asPMVector ]).
	
	self initializeParametersFor: collectionOfVectors.
	
	[ self hasConverged ] whileFalse: [
		"Expectation (E step)"
		self evaluateResponsibilitiesFor: collectionOfVectors.
		
		"Maximization (M step)"
		self updateParametersFor: collectionOfVectors.
		
		"Evaluation"
		self calculateLogLikelihoodFor: collectionOfVectors ].
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

	logLikelihoodHistory size >= 100 ifTrue: [ "max iterations" ^ true ].

	(logLikelihoodHistory last closeTo: logLikelihoodHistory nextToLast) 
		ifTrue: [ ^ true ].

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
	
	numberOfGaussians := self class defaultNumberOfGaussians.
	self useRandomInitializationStrategy.
	
	logLikelihoodHistory := OrderedCollection new.
]

{ #category : #accessing }
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
	^ responsibilities collect: [ :each |
		each indexOf: each max ]
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
AIGaussianMixtureModel >> logLikelihoodHistory: anObject [

	logLikelihoodHistory := anObject
]

{ #category : #accessing }
AIGaussianMixtureModel >> mixingCoefficients [

	^ mixingCoefficients
]

{ #category : #accessing }
AIGaussianMixtureModel >> mixingCoefficients: anObject [

	mixingCoefficients := anObject
]

{ #category : #accessing }
AIGaussianMixtureModel >> numberOfGaussians [
	^ numberOfGaussians
]

{ #category : #accessing }
AIGaussianMixtureModel >> numberOfGaussians: aNumber [
	numberOfGaussians := aNumber
]

{ #category : #accessing }
AIGaussianMixtureModel >> randomSeed [

	^ initializationStrategy randomSeed
]

{ #category : #accessing }
AIGaussianMixtureModel >> randomSeed: aNumber [

	initializationStrategy randomSeed: aNumber
]

{ #category : #accessing }
AIGaussianMixtureModel >> responsibilities [

	^ responsibilities
]

{ #category : #accessing }
AIGaussianMixtureModel >> responsibilities: anObject [

	responsibilities := anObject
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
	initializationStrategy := AIGaussianMixtureModelKMeansInitializationStrategy new.
]

{ #category : #'initialization strategy' }
AIGaussianMixtureModel >> useRandomInitializationStrategy [
	initializationStrategy := AIGaussianMixtureModelRandomInitializationStrategy new.
]
