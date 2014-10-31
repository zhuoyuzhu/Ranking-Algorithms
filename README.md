TrueSkill Ranking System Algorithms
-----------------------------------
This ranking system is used to both identify and track the skills of players in a tennis game based on the binary results of the 2011 ATP men’s tennis singles for 107 players in a total of 1801 games, which these players played against each other in the 2011 season. Three different approaches are used to compute this ranking system for these ATP tennis players. The algorithm's implementation is complished by Matlab.

## Three Key ranking algorithms files:
**1. Empircal.m:** It simply based on the empirical ratio of number of wins to total number of games played.

**2. gibbsrank.m:** This ranking system algorithm is accomplished by utilising Bayes Decision Rule with generative model, Gibbs Sampling and Markov Chain Monte Carlo(MCMC).

**3. eprank.m:** This ranking system algorithm is based on Message Passing on Factor Graph and Expectation Propagation(EP).

## The visualisation results of three methods:
**1. Empirical-Graph.png:** Empirical method.

**2. Gibbs-Sampling-MCMC.png:** Bayes Decision Rule with generative model, Gibbs Sampling and Markov Chain Monte Carlo(MCMC) algorithms.

**3. Message-Passing-EP.png:** Message Passing on Factor Graph and Expectation Propagation(EP) algorithms.

## Getting Started

In order to run each corresponding Matlab program you will want to do the following:

1. Download tennis_data.mat and other algorithms. Store them into the same directory.
2. Comments inside these algorithms will help you understand procedure approximately.

**For thorough and deep understanding of these algorithms, please refer to the Resources section below.**

## Resources

* Probabilistic-Ranking.docx: Final version of this machine learning report.
* [Bayes Decision Rule with Generative Model, Gibbs Sampling and MCMC](http://mlg.eng.cam.ac.uk/teaching/4f13/1314/lect0607.pdf)
* [Message Passing on Factor Graphs](http://mlg.eng.cam.ac.uk/teaching/4f13/1314/lect0809.pdf)
* [Pattern Recognition and Machine Learning](http://research.microsoft.com/en-us/um/people/cmbishop/PRML/index.htm)

## Ranking System Algorithms

This machine learning project was accomplished by Michael Zhuoyu Zhu solely during the fourth-year information and computing engineering master degree in the University of Cambridge.
