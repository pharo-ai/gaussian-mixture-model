# Gaussian Mixture Model

![Build status](https://github.com/pharo-ai/gaussian-mixture-model/workflows/CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/pharo-ai/gaussian-mixture-model/badge.svg?branch=master)](https://coveralls.io/github/pharo-ai/gaussian-mixture-model?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/pharo-ai/gaussian-mixture-model/master/LICENSE)

**Gaussian Mixture Model (GMM)** is an iterative algorithm for fitting the data with multiple normal distributions (gaussians). Can be used for classification.

## How to install it?

To install `gaussian-mixture-model`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'AIGaussianMixtureModel';
  repository: 'github://pharo-ai/gaussian-mixture-model/src';
  load.
```

## How to depend on it?

If you want to add a dependency on `gaussian-mixture-model` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'AIGaussianMixtureModel'
  with: [ spec repository: 'github://pharo-ai/gaussian-mixture-model/src' ].
```

If you are new to baselines and Metacello, check out the [Baselines](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md) tutorial on Pharo Wiki.

## How to use it?
