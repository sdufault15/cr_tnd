# Coverage 3
set.seed(123242)
r.est3.1 <- ORTestFunction(dataFINAL, rrIN = 0.3, period1, n1 = 1000, ratio = 1)
save(r.est3.1, file = "r_est3_12292017_supp.RData")