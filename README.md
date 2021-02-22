# Expectation-Maximization (EM) Algorithm

![Build status](https://github.com/pharo-ai/expectation-maximization/workflows/CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/pharo-ai/expectation-maximization/badge.svg?branch=master)](https://coveralls.io/github/pharo-ai/expectation-maximization?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/pharo-ai/expectation-maximization/master/LICENSE)

**Expectation-maximization algorithm** is an iterative method to find maximum likelihood or maximum a posteriori estimates of parameters in statistical models, where the model depends on unobserved latent variables

## How to install it?

To install `expectation-maximization`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'AIExpectationMaximization';
  repository: 'github://pharo-ai/expectation-maximization/src';
  load.
```

## How to depend on it?

If you want to add a dependency on `expectation-maximization` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'AIExpectationMaximization'
  with: [ spec repository: 'github://pharo-ai/expectation-maximization/src' ].
```

If you are new to baselines and Metacello, check out the [Baselines](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md) tutorial on Pharo Wiki.

## How to use it?
