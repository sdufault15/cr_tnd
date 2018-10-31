# Coverage 2 r = 4

set.seed(123242)
r.est5.4 <- ORTestFunction(dataFINAL, rrIN = 0.5, period1, n1 = 1000, ratio = 4)
save(r.est5.4, file = "r_est5_4_12292017_supp.RData")
set.seed(123242)
r.est4.4 <- ORTestFunction(dataFINAL, rrIN = 0.4, period1, n1 = 1000, ratio = 4)
save(r.est4.4, file = "r_est4_4_12292017_supp.RData")