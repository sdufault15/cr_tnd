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
library(readr)

# User-Supplied Data and Functions
source("~/cr_tnd/txtSetFunction.R")
source("~/cr_tnd/ORfunction.R")
load("Final494Allocations.RData")
dataFINAL <- Final247Allocations %>% select(-X1)

source("~/cr_tnd/coverage2_1_supp.R")