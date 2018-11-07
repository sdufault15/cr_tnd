# Coverage 3 r = 4

set.seed(123242)
r.est3.4 <- ORTestFunction(dataFINAL, rrIN = 0.3, period1, n1 = 1000, ratio = 4)
save(r.est3.4, file = "nov18/r_est3_4_11072018_supp.RData")