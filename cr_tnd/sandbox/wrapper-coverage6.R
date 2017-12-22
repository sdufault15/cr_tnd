setwd("~/cr_tnd/dec17/")
period1 <- c("03_05", "05_06", "06_07", "07_08", "08_10", "10_11", "11_12", "12_13", "13_14")
zstar <- qnorm(0.975)

source("~/cr_tnd/paperFunction2.R")
source("~/cr_tnd/quadraticFunction.R")
source("~/cr_tnd/txtSetFunction.R")
load("~/cr_tnd/Random10000Allocations.RData")
dataRAND <- Random10000Allocations
source("~/cr_tnd/coverage2_4.R")