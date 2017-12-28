# The proportion of simulations that returned significant results for each intervention effect of interest (\lambda)
# The GEE assumed an exchangeable correlation matrix. Each approach was applied to the results of the 20,000
# random intervention allocations with 1,000 cases and 4,000 controls (r = 4).

# Test-Positive Fraction
tNULLr <- tTestFunction(dataRAND, rrIN = 1, period = period1, ncases = 1000, ratio = 4)
save(tNULLr, file = "tNULLr_12192017.RData")
t60r <- tTestFunction(dataRAND, rrIN = 0.6, period = period1, ncases = 1000, ratio = 4)
save(t60r, file = "t60r_12192017.RData")
t50r <- tTestFunction(dataRAND, rrIN = 0.5, period = period1, ncases = 1000, ratio = 4)
save(t50r, file = "t50r_12192017.RData")
t40r <- tTestFunction(dataRAND, rrIN = 0.4, period = period1, ncases = 1000, ratio = 4)
save(t40r, file = "t40r_12192017.RData")
t30r <- tTestFunction(dataRAND, rrIN = 0.3, period = period1, ncases = 1000, ratio = 4)
save(t30r, file = "t30r_12192017.RData")

# Odds Ratio
nullRAND <- paperFunction2(dataRAND, rr = 1, period = period1, ratio = 4, ncases = 1000)
save(nullRAND, file = "orNULLr_12192017.RData")
t6RAND <- paperFunction2(dataRAND, rr = 0.6, period = period1, ratio = 4, ncases = 1000)
save(t6RAND, file = "or6r_12192017.RData")
t5RAND <- paperFunction2(dataRAND, rr = 0.5, period = period1, ratio = 4, ncases = 1000)
save(t5RAND, file = "or5r_12192017.RData")
t4RAND <- paperFunction2(dataRAND, rr = 0.4, period = period1, ratio = 4, ncases = 1000)
save(t4RAND, file = "or4r_12192017.RData")
t3RAND <- paperFunction2(dataRAND, rr = 0.3, period = period1, ratio = 4, ncases = 1000)
save(t3RAND, file = "or3r_12192017.RData")

# GEE & Random Effects
# INSTEAD USE RESULTS FROM COVERAGE SCRIPTS!!!! THEY USE THE UPDATED ORTESTFUNCTION
#rand1 <- ORTestFunction(dataRAND, rrIN = 1, period1, n1 = 1000, ratio = 4)
#save(rand1, file = "rand1_12192017.RData")
#rand6 <- ORTestFunction(dataRAND, rrIN = .6, period1, n1 = 1000, ratio = 4)
#save(rand6, file = "rand6_12192017.RData")
#rand5 <- ORTestFunction(dataRAND, rrIN = .5, period1, n1 = 1000, ratio = 4)
#save(rand5, file = "rand5_12192017.RData")
#rand4 <- ORTestFunction(dataRAND, rrIN = .4, period1, n1 = 1000, ratio = 4)
#save(rand4, file = "rand4_12192017.RData")
#rand3 <- ORTestFunction(dataRAND, rrIN = .3, period1, n1 = 1000, ratio = 4)
#save(rand3, file = "rand3_12192017.RData")
