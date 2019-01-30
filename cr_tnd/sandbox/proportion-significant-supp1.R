# SUPPLEMENT MATERIAL

# The proportion of simulations that returned significant results for each intervention effect of interest (\lambda)
# The GEE assumed an exchangeable correlation matrix. Each approach was applied to the results of the 10,000
# random intervention allocations with 1,000 cases and 1,000 controls (r = 1).
library(dplyr)
load(here("cr_tnd", "data/Final494Allocations.RData"))
dataFINAL <- Final247Allocations %>% select(-X1)
period1 <- c("03_05", "05_06", "06_07", "07_08", "08_10", "10_11", "11_12", "12_13", "13_14")
source(here("cr_tnd", "lib/tTestFunction.R"))
source(here("cr_tnd", "lib/paperFunction2.R"))
source(here("cr_tnd", "lib/txtSetFunction.R"))
source(here("cr_tnd", "lib/quadraticFUnction.R"))

setwd(here("cr_tnd", "data/jan19-supp"))
# Test-Positive Fraction
tNULLr <- tTestFunction(dataFINAL, rrIN = 1, period = period1, ncases = 1000, ratio = 1)
save(tNULLr, file = "tNULLr_12292017_supp.RData")
t60r <- tTestFunction(dataFINAL, rrIN = 0.6, period = period1, ncases = 1000, ratio = 1)
save(t60r, file = "t60r_12292017_supp.RData")
t50r <- tTestFunction(dataFINAL, rrIN = 0.5, period = period1, ncases = 1000, ratio = 1)
save(t50r, file = "t50r_12292017_supp.RData")
t40r <- tTestFunction(dataFINAL, rrIN = 0.4, period = period1, ncases = 1000, ratio = 1)
save(t40r, file = "t40r_12292017_supp.RData")
t30r <- tTestFunction(dataFINAL, rrIN = 0.3, period = period1, ncases = 1000, ratio = 1)
save(t30r, file = "t30r_12292017_supp.RData")

# Odds Ratio (ABGH method)
nullFINAL <- paperFunction2(dataFINAL, rr = 1, period = period1, ratio = 1, ncases = 1000)
save(nullFINAL, file = "orNULLr_12292017_supp.RData")
t6FINAL <- paperFunction2(dataFINAL, rr = 0.6, period = period1, ratio = 1, ncases = 1000)
save(t6FINAL, file = "or6r_12292017_supp.RData")
t5FINAL <- paperFunction2(dataFINAL, rr = 0.5, period = period1, ratio = 1, ncases = 1000)
save(t5FINAL, file = "or5r_12292017_supp.RData")
t4FINAL <- paperFunction2(dataFINAL, rr = 0.4, period = period1, ratio = 1, ncases = 1000)
save(t4FINAL, file = "or4r_12292017_supp.RData")
t3FINAL <- paperFunction2(dataFINAL, rr = 0.3, period = period1, ratio = 1, ncases = 1000)
save(t3FINAL, file = "or3r_12292017_supp.RData")

# GEE & Random Effects
# USE RESULTS FROM COVERAGE SCRIPTS!!!! THEY USE THE UPDATED ORTESTFUNCTION
