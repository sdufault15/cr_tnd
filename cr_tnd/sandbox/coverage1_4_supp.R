# Coverage 1 r = 4
set.seed(123242)
r.estNULL.4 <- ORTestFunction(dataFINAL, rrIN = 1, period1, n1 = 1000, ratio = 4)
save(r.estNULL.4, file = "nov18/r_estNULL_4_11072018_supp.RData")
set.seed(123242)
r.est6.4 <- ORTestFunction(dataFINAL, rrIN = 0.6, period1, n1 = 1000, ratio = 4)
save(r.est6.4, file = "nov18/r_est6_4_11072018_supp.RData")
set.seed(123242)