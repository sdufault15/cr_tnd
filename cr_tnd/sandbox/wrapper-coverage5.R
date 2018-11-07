# Updated 11/2018

# Definitions
period1 <- c("03_05", "05_06", "06_07", "07_08", "08_10", "10_11", "11_12", "12_13", "13_14")
zstar <- qnorm(0.975)

# Packages
library(dplyr)
library(tidyr)
library(splitstackshape)
library(geepack)
library(lme4)

# User-Supplied Data and Functions
source("~/cr_tnd/txtSetFunction.R")
source("~/cr_tnd/ORfunction.R")
load("~/cr_tnd/Random10000Allocations.RData")
dataRAND <- Random10000Allocations
dataRAND <- dataRAND %>% select(-X)

source("~/cr_tnd/coverage1_4.R")