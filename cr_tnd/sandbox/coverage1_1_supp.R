# Coverage 1
set.seed(123242)
r.estNULL.1 <- ORTestFunction(dataFINAL, rrIN = 1, period1, n1 = 1000, ratio = 1)
save(r.estNULL.1, file = "r_estNULL_12292017_supp.RData")
set.seed(123242)
r.est6.1 <- ORTestFunction(dataFINAL, rrIN = 0.6, period1, n1 = 1000, ratio = 1)
save(r.est6.1, file = "r_est6_12292017_supp.RData")