# Coverage 1
set.seed(123242)
r.estNULL.1 <- ORTestFunction(dataRAND, rrIN = 1, period1, n1 = 1000, ratio = 1)
save(r.estNULL.1, file = "nov18/r_estNULL_11012018.RData")
set.seed(123242)
r.est6.1 <- ORTestFunction(dataRAND, rrIN = 0.6, period1, n1 = 1000, ratio = 1)
save(r.est6.1, file = "nov18/r_est6_11012018.RData")