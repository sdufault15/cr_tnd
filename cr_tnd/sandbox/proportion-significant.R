# The proportion of simulations that returned significant results for each intervention effect of interest (\lambda)
# The GEE assumed an exchangeable correlation matrix. Each approach was applied to the results of the 20,000
# random intervention allocations with 1,000 cases and 4,000 controls (r = 4).

ratio <- 4
tNULLr <- tTestFunction(dataRAND, rrIN = 1, period = period1, ncases = 1000, ratio = 4, both = TRUE)
t60r <- tTestFunction(dataRAND, rrIN = 0.6, period = period1, ncases = 1000, ratio = 4, both = TRUE)
t50r <- tTestFunction(dataRAND, rrIN = 0.5, period = period1, ncases = 1000, ratio = 4, both = TRUE)
t40r <- tTestFunction(dataRAND, rrIN = 0.4, period = period1, ncases = 1000, ratio = 4, both = TRUE)
t30r <- tTestFunction(dataRAND, rrIN = 0.3, period = period1, ncases = 1000, ratio = 4, both = TRUE)