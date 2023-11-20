![Banner](Repo%20Images/tss_banner.png)

# Bayesian Inference for TSS Measurement Uncertainty
By A.J. Brown <br/>
Agricultural Data Scientist <br/>
[ansleybrown1337@gmail.com](mailto:ansleybrown1337@gmail.com) <br/>
[Personal Website](https://sites.google.com/view/ansleyjbrown/)

This project aims to apply Bayesian Inference and Markov Chain Monte Carlo (MCMC) methods to quantify uncertainty in Total Suspended Solids (TSS) measurements. By comparing these measurements against standard values from de-ionized water (0 ppm concentration) and a 100 ppm standard solution, I aim to establish a robust method for understanding and quantifying the error in TSS measurements taken in my lab. The ultimate goal is to 1) understand the 'real' error in our measurements for reporting, and 2) enhance the accuracy and reliability of measured TSS values from real water samples in various environmental and contexts.

## Table of Contents
- [Objectives](#objectives)
- [Getting Started](#getting-started)
- [Repo Contents](#repo-contents)
- [Methodology](#methodology)
- [Results](#results)
- [Contribute](#contribute)
- [License](#license)
- [References](#references)

## Objectives

1. **Quantify Measurement Uncertainty**: Use Bayesian Inference and MCMC to determine the uncertainty in TSS measurements compared to standard measurements.
2. **Adjust Real Water Sample Measurements**: Apply the quantified error margins to adjust TSS measurements obtained from real water samples.

## Getting Started
For this project, I will be using the work flow outlined by Dr. Richard McElreath in his book, [Statistical Rethinking](https://xcelab.net/rm/statistical-rethinking/). This flow is as follows, stated in [Chapter 4, Geocentric Models](https://www.youtube.com/watch?v=tNOu-SEacNU&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=3):
1. State a clear question
2. Sketch your causal assumptions
3. Use the sketch to build a generative model
4. Use the model to build estimator
5. Profit

For this project, I will be using the [NIMBLE](https://r-nimble.org/) package in R to implement the Bayesian models and MCMC algorithms. NIMBLE is a flexible, robust, and efficient package for Bayesian statistical modeling, and is well-suited for this project.

## Repo Contents
- `README.md`: This file, serves as a project overview.
- `LICENSE.md`: The license for this project.
- `AUTHORS.md`: The authors of this project.
- `CONTRIBUTING.md`: Guidelines for contributing to this project.
- `Code`: Contains all code for this project.
- `Example Data`: Contains all data for this project.
- `Output`: Contains all output for this project.
- `Repo Images`: Contains all images for this README file.

## Methodology
More to come here as I refine my approach, but the general steps will be as follows:

### **Defining the OWL:**
1. **State a clear question:**

What is the uncertainty in TSS measurements for both DI and 100ppm standard solutions given each person performing the analysis?

2. **Sketch your causal assumptions:**

The uncertainty in TSS measurements is a function of the person performing the analysis, the type of solution being analyzed (DI or 100ppm), and other unknown factors.

3. **Use the sketch to build a generative model:**

First, we must define what exactly we're looking for, that is, what is the error in TSS measurements? We can define this as the difference between the measured value and the true value of the standard, or:

$$
TSSerr_{i, k} = TSS_{i, k} - TSS_{std, i, k}
$$
    
Where:
- $TSSerr_{i, k}$ is the error in TSS measurement $i$ and standard solution, $k$
- $TSS_{i, k}$ is the measured TSS value for measurement $i$ and standard solution, $k$
- $TSS_{std, i, k}$ is the true TSS value for measurement $i$ and standard solution, $k$

Recall that we have two standard solutions:
- Stock solution of 100 ppm TSS
- De-ionized water (0 ppm TSS)

We also have two (but effectivley three) people performing the analysis:
- Person A
- Person B
- Person A and B (when they did it together)

One way of looking at it is like this:

$$
TSSerr_{i} = f(\beta_0, \beta_1, \epsilon)
$$

*"Measurement error in TSS is some function of the person performing the analysis, the solution being analyzed, and some unknown error."*

This then can become a deterministic linear model that deines the function $f$, where we can define the error in TSS measurement $i$ as:

$$
TSSerr_{i} = \alpha_i + \beta_{0, i} * person_i + \beta_{1, i} * solution_{i} + \epsilon_{i}
$$
Where:
- $TSSerr_{i}$ is the error in TSS measurement $i$
- $\alpha_i$ is the intercept for TSS measurement $i$
- $\beta_{0, i}$ is the coefficient for the person performing the analysis
- $\beta_{1, i}$ is the coefficient for the solution being analyzed
- $\epsilon_{i}$ is the error term for TSS measurement $i$

We then have to make some assumptions of prior distributions for the parameters in our model:

$\alpha_i$ ~ $N(0, \sigma)$

$\beta_0$ ~ $N(0, \sigma)$

$\beta_1$ ~ $N(0, \sigma)$

So when applied in the context of Bayes Theorem, we have:

$$
Pr(\alpha, \beta_0, \beta_1, \sigma | TSSerr_{i}) = \frac{Pr(TSSerr_{i} | \alpha, \beta_0, \beta_1, \sigma) \times Pr(\alpha, \beta_0, \beta_1, \sigma)}{Z}
$$

Where:
- $Pr(\alpha, \beta_0, \beta_1, \sigma | TSSerr_{i})$ is the posterior distribution of the parameters given the data
- $Pr(TSSerr_{i} | \alpha, \beta_0, \beta_1, \sigma)$ is the likelihood of the data given the parameters
- $Pr(\alpha, \beta_0, \beta_1, \sigma)$ is the prior distribution of the parameters
- $Z$ is the normalizing constant


4. Use the model to build estimator
5. Profit

## **Error Analysis and Adjustment**:
 Analyze the error characteristics and adjust the measurements of real water samples accordingly.

## Results
Coming soon!

## Contribute

Contributions are always welcome! Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file for details on how to contribute.

## License

This project is licensed under the GNU GPL 2.0 License. See the [LICENSE.md](LICENSE.md) file for details.

## References

- **NIMBLE Development Team. 2023.** *NIMBLE: MCMC, Particle Filtering, and Programmable Hierarchical Modeling.* doi: [10.5281/zenodo.1211190](https://doi.org/10.5281/zenodo.1211190). R package version 1.0.1, [https://cran.r-project.org/package=nimble](https://cran.r-project.org/package=nimble).