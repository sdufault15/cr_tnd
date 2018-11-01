##########################################################
# Suzanne Dufault
# November 1, 2018
# The proportion of significant results for varying sample sizes and 
# large intervention effects for the GEE and ME effects
##########################################################

# Interested in sample sizes: 300, 400, 500, 600, 700 cases x4 controls
# Interested in effect sizes: 0.3, 0.2, 0.1

library(geepack)
library(lme4)
library(tidyr)
library(dplyr)
library(splitstackshape)


period1 <- c("03_05", "05_06", "06_07", "07_08", "08_10", "10_11", "11_12", "12_13", "13_14")
zstar <- qnorm(0.975)

dta <- read.csv("~/cr_tnd/Final247Allocations.csv")
dta <- dta %>% select(-X)

# Manually flipping the treatment allocations
names(dta)
dta2 <- abs(1-dta[,5:ncol(dta)])
names(dta2) <- paste0("tx.", (ncol(dta) - 4) + 1:ncol(dta2))
dta <- bind_cols(dta, dta2)
source("~/cr_tnd/ORfunction.R")
source("~/cr_tnd/txtSetFunction.R")


# Odds Ratio Method
or3_300 <- ORTestFunction(dta, rrIN = 0.3, period = period1, ratio = 4, n1 = 300)
save(or3_300, file = "oct18/or3_300_11012018.RData")

or3_400 <- paperFunction2(dta, rrIN = 0.3, period = period1, ratio = 4, n1 = 400)
save(or3_400, file = "oct18/or3_400_11012018.RData")

or3_500 <- paperFunction2(dta, rrIN = 0.3, period = period1, ratio = 4, n1 = 500)
save(or3_500, file = "oct18/or3_500_11012018.RData")

or3_600 <- paperFunction2(dta, rrIN = 0.3, period = period1, ratio = 4, n1 = 600)
save(or3_600, file = "oct18/or3_600_11012018.RData")

or3_700 <- paperFunction2(dta, rrIN = 0.3, period = period1, ratio = 4, n1 = 700)
save(or3_700, file = "oct18/or3_700_11012018.RData")