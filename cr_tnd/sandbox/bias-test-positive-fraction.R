# The bias for the test-positive fraction quadratic estimates of the Relative Risk and the standard deviation 
# of the difference in arm-specific averages (T) from 10,000 unconstrained intervention allocations. 

# Ratio = 1
tNULLr.2.1 <- tTestFunction(dataRAND, rrIN = 1, period = period1, ncases = 1000, ratio = 1)
save(tNULLr.2.1, file = 'randomNULLtTest1_12192017.Rdata')
t60r.2.1 <- tTestFunction(dataRAND, rrIN = 0.6, period = period1, ncases = 1000, ratio = 1)
save(t60r.2.1, file = 'random6tTest1_12192017.Rdata')
t50r.2.1 <- tTestFunction(dataRAND, rrIN = 0.5, period = period1, ncases = 1000, ratio = 1)
save(t50r.2.1, file = 'random5tTest1_12192017.Rdata')
t40r.2.1 <- tTestFunction(dataRAND, rrIN = 0.4, period = period1, ncases = 1000, ratio = 1)
save(t40r.2.1, file = 'random4tTest1_12192017.Rdata')
t30r.2.1 <- tTestFunction(dataRAND, rrIN = 0.3, period = period1, ncases = 1000, ratio = 1)
save(t30r.2.1, file = 'random3tTest1_12192017.Rdata')

# Ratio = 4
tNULLr.2 <- tTestFunction(dataRAND, rrIN = 1, period = period1, ncases = 1000, ratio = 4) 
save(tNULLr.2, file = 'randomNULLtTest4_12192017.Rdata')
t60r.2 <- tTestFunction(dataRAND, rrIN = 0.6, period = period1, ncases = 1000, ratio = 4)
save(t60r.2, file = 'random6tTest4_12192017.Rdata')
t50r.2 <- tTestFunction(dataRAND, rrIN = 0.5, period = period1, ncases = 1000, ratio = 4)
save(t50r.2, file = 'random5tTest4_12192017.Rdata')
t40r.2 <- tTestFunction(dataRAND, rrIN = 0.4, period = period1, ncases = 1000, ratio = 4)
save(t40r.2, file = 'random4tTest4_12192017.Rdata')
t30r.2 <- tTestFunction(dataRAND, rrIN = 0.3, period = period1, ncases = 1000, ratio = 4)
save(t30r.2, file = 'random3tTest4_12192017.Rdata')