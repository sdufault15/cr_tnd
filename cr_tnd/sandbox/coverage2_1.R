# Coverage 2
set.seed(123242)
r.est5.1 <- ORTestFunction(dataRAND, rrIN = 0.5, period1, n1 = 1000, ratio = 1)
save(r.est5.1, file = "nov18/r_est5_11042018.RData")
set.seed(123242)
r.est4.1 <- ORTestFunction(dataRAND, rrIN = 0.4, period1, n1 = 1000, ratio = 1)
save(r.est4.1, file = "nov18/r_est4_11042018.RData")