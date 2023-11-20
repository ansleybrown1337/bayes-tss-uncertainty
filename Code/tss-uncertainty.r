# ------------------------------------------------------------------------------
# Bayesian Inference for TSS Measurement Uncertainty
# By A.J. Brown
# Agricultural Data Scientist
# ansleybrown1337@gmail.com
# https://sites.google.com/view/ansleyjbrown/)
#
# Description: This script is used to perform Bayesian inference on TSS using
# the NIMBLE package in R. For more information please view the README.md file
# in the root directory of this repository: 
# (https://github.com/ansleybrown1337/bayes-tss-uncertainty)
# ------------------------------------------------------------------------------

# Set working directory to repo parent folder
setwd(dirname(getwd()))

# Load packages
package.list <- c(
  'BayesianTools',  
  'nimble',
  'coda',
  'ggplot2',
  'dplyr',
  'tidyr'
  )
packageLoad <- function(packages){
  for (i in packages) {
    if (!require(i, character.only = TRUE)) {
      install.packages(i)
      library(i, character.only = TRUE)
    }
  }
}
packageLoad(package.list)

# Load data
tss_df <- read.csv('./Example Data/TSS_Master_2023.csv')

# Process data
    # separate data into two dataframes: standards and real data
std_list <- c('Stock Solution', 'DI')
std_df <- tss_df %>% filter(Sample_ID %in% std_list)
real_df <- tss_df %>% filter(!Sample_ID %in% std_list)

    # calculate error column for standards
std_df <- std_df %>% mutate(
  tss.err = ifelse(Sample_ID == 'Stock Solution', 100-TSS_mg.L, 0-TSS_mg.L)
  )

# Defining our model
# We will use simple linear regression to estimate measurement error. I will
# assume the following form:


# Define model in NIMBLE
code <- nimbleCode({
  # continuous data
  beta0 ~ dnorm(0, sd = 100)
  beta1 ~ dnorm(0, sd = 100)
  # categorical data
  beta2 ~ dnorm(0, sd = 100)
  # variance components
  sigma ~ dunif(0, 100)        # prior for variance components based on Gelman (2006)
  for(i in 1:n) {
    y[i] ~ dnorm(beta0 + beta1*x1[i] + beta2*x2[i], sd = sigma) # manual entry of linear predictors
  }
})

## extract data for two predictors and center for better MCMC performance
x1 <- X[,1] - mean(X[,1])
x2 <- X[,2] - mean(X[,2])

constants <- list(n = n, x1 = x1, x2 = x2)
data <- list(y = y)
inits <- list(beta0 = mean(y), beta1 = 0, beta2 = 0, sigma = 1)
model <- nimbleModel(code, constants = constants, data = data, inits = inits) # build model

