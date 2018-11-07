# Coverage 2
set.seed(123242)
r.est5.1 <- ORTestFunction(dataFINAL, rrIN = 0.5, period1, n1 = 1000, ratio = 1)
save(r.est5.1, file = "nov18/r_est5_11072018_supp.RData")
set.seed(123242)
r.est4.1 <- ORTestFunction(dataFINAL, rrIN = 0.4, period1, n1 = 1000, ratio = 1)
save(r.est4.1, file = "nov18/r_est4_11072018_supp.RData")