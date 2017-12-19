# The bias and standard deviation for the random effects Odds Ratio estimates of the 
# relative risk from 10,000 unconstrained intervention allocations

# Ratio = 1
set.seed(123242)
biasOR.paper.NULL.1 <- paperFunction2(dataRAND, 1, period1, ratio = 1, ncases = 1000)
save(biasOR.paper.NULL.1, file = "biasOR_paper_NULL_1_12192017.Rdta")
biasOR.paper.6.1 <- paperFunction2(dataRAND, 0.6, period1, ratio = 1, ncases = 1000)
save(biasOR.paper.6.1, file = "biasOR_paper_6_1_12192017.Rdta")
biasOR.paper.5.1 <- paperFunction2(dataRAND, 0.5, period1, ratio = 1, ncases = 1000)
save(biasOR.paper.5.1, file = "biasOR_paper_5_1_12192017.Rdta")
biasOR.paper.4.1 <- paperFunction2(dataRAND, 0.4, period1, ratio = 1, ncases = 1000)
save(biasOR.paper.4.1, file = "biasOR_paper_4_1_12192017.Rdta")
biasOR.paper.3.1 <- paperFunction2(dataRAND, 0.3, period1, ratio = 1, ncases = 1000)
save(biasOR.paper.3.1, file = "biasOR_paper_3_1_12192017.Rdta")

# Ratio = 4
biasOR.paper.NULL <- paperFunction2(dataRAND, 1, period1, ratio = 4, ncases = 1000)
save(biasOR.paper.NULL, file = "biasOR_paper_NULL_12192017.Rdta")
biasOR.paper.6 <- paperFunction2(dataRAND, 0.6, period1, ratio = 4, ncases = 1000)
save(biasOR.paper.6, file = "biasOR_paper_6_12192017.Rdta")
biasOR.paper.5 <- paperFunction2(dataRAND, 0.5, period1, ratio = 4, ncases = 1000)
save(biasOR.paper.5, file = "biasOR_paper_5_12192017.Rdta")
biasOR.paper.4 <- paperFunction2(dataRAND, 0.4, period1, ratio = 4, ncases = 1000)
save(biasOR.paper.4, file = "biasOR_paper_4_12192017.Rdta")
biasOR.paper.3 <- paperFunction2(dataRAND, 0.3, period1, ratio = 4, ncases = 1000)
save(biasOR.paper.3, file = "biasOR_paper_3_12192017.Rdta")
