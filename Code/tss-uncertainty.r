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

    # calculate mean and standard deviation for each standard