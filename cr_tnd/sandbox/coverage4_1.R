# coverage 4
set.seed(123242)
biasOR.paper.4.1 <- paperFunction2(dataRAND, 0.4, period1, ratio = 1, ncases = 1000)
save(biasOR.paper.4.1, file = "biasOR_paper_4_1_12192017.RData")
biasOR.paper.3.1 <- paperFunction2(dataRAND, 0.3, period1, ratio = 1, ncases = 1000)
save(biasOR.paper.3.1, file = "biasOR_paper_3_1_12192017.RData")