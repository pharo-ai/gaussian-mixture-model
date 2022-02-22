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

{ #category : #convergence }
AIGaussianMixtureModel >> calculateLogLikelihoodFor: aCollectionOfCollections [
	| logLikelihood |
	
	logLikelihood := (aCollectionOfCollections collect: [ :each | 
		((1 to: numberOfGaussians) collect: [ :k |
			(mixingCoefficients at: k) * ((gaussians at: k) value: each) ]) sum log ]) sum.
	
	logLikelihoodHistory add: logLikelihood.
]

{ #category : #fitting }
AIGaussianMixtureModel >> evaluateResponsibilitiesFor: aCollectionOfCollections [
	| numerator denominator |

	responsibilities := aCollectionOfCollections collect: [ :each |
		(1 to: numberOfGaussians) collect: [ :k |
			numerator := (mixingCoefficients at: k) * ((gaussians at: k) value: each).
			denominator := ((1 to: numberOfGaussians) collect: [ :j |
				(mixingCoefficients at: j) * ((gaussians at: j) value: each) ]) sum.
			
			numerator / denominator ] ].
]

{ #category : #fitting }
AIGaussianMixtureModel >> fit: aCollectionOfCollections [
	"Fits the given number of multivariate norml distributions (defined by the numberOfGaussians) to the data which can be a collection of collections or a DataFrame"
	
	self initializeParametersFor: aCollectionOfCollections.
	
	[ self hasConverged ] whileFalse: [
		"Expectation (E step)"
		self evaluateResponsibilitiesFor: aCollectionOfCollections.
		
		"Maximization (M step)"
		self updateParametersFor: aCollectionOfCollections.
		
		"Evaluation"
		self calculateLogLikelihoodFor: aCollectionOfCollections ].
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
	logLikelihoodHistory size < 2
		ifTrue: [ ^ false ].
	
	logLikelihoodHistory size >= 100 ifTrue: [
		self inform: 'Maximum number of iterations was reached'.
		^ true ].
		
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
AIGaussianMixtureModel >> initializeParametersFor: aCollectionOfCollections [
	gaussians := initializationStrategy
		initializeGaussiansFor: aCollectionOfCollections
		numberOfGaussians: numberOfGaussians.
		
	mixingCoefficients := initializationStrategy
		initializeMixingCoefficientsFor: aCollectionOfCollections
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
AIGaussianMixtureModel >> responsibilities [

	^ responsibilities
]

{ #category : #accessing }
AIGaussianMixtureModel >> responsibilities: anObject [

	responsibilities := anObject
]

{ #category : #fitting }
AIGaussianMixtureModel >> updateParametersFor: aCollectionOfCollections [
	| n mu deviation sigma |
	
	1 to: numberOfGaussians do: [ :k | 
		n := (responsibilities collect: [ :each | each at: k ]) sum.
		mu := (1 / n * ((1 to: aCollectionOfCollections size) collect: [ :i |
			((responsibilities at: i) at: k) * (aCollectionOfCollections at: i) ]) sum) asPMVector.
		
		sigma := 1 / n * ((1 to: aCollectionOfCollections size) collect: [ :i |
			deviation := (aCollectionOfCollections at: i) - mu.
			((responsibilities at: i) at: k) * (deviation tensorProduct: deviation) ]) sum.
		
		(gaussians at: k) initializeMeanVector: mu covarianceMatrix: sigma.
		
		mixingCoefficients at: k put: (n / aCollectionOfCollections size) ]
]

{ #category : #'initialization strategy' }
AIGaussianMixtureModel >> useKMeansInitializationStrategy [
	initializationStrategy := AIGaussianMixtureModelKMeansInitializationStrategy new.
]

{ #category : #'initialization strategy' }
AIGaussianMixtureModel >> useRandomInitializationStrategy [
	initializationStrategy := AIGaussianMixtureModelRandomInitializationStrategy new.
]
