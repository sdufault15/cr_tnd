tTestFunction <- function(dta, rrIN, period, ncases = 1000, ratio = 4, both = TRUE){
  # This function uses the quadratic equation formulated in the paper to estimate lambda
  # for the t-tests. Last modified on 8/14/2017 to include coverage and the output of T
  # values (i.e. the difference in arm-specific means)
  
  set.seed(1234234) # Reproducibility
  
  out <- out2 <- out3 <- out4 <- out5 <- NULL
  sigMatrix <-NULL
  TOTpvals <- vector("list", length(rrIN)) # p-values for the T-tests
  TOTtStats <- vector("list", length(rrIN)) # T test statistics
  lambdas <- vector("list", length(rrIN)) # storage of estimated lambdas
  sds <- vector('list', length(rrIN)) # storage of standard deviations
  tVals <- vector('list', length(rrIN)) # not T statistics, but difference in arm specific means
  coverage <- vector('list', length(rrIN)) # storage of coverage
  iter1 <- 1 # counts number of iterations (if there are 4 different relative risks, iter1 should end at 5)
  TOTinsignifs <- NULL # vector flagging the insignificant allocations 
  
  for (j in period){
    temp <- dta[dta$Period == j,] # subset data to just the time period of interest
    rr <- rrIN
    n1 <- ncases
    n2 <- ratio*n1
    
    propCases <- (temp$Cases)/sum(temp$Cases)
    propOFI <- temp$OFI/sum(temp$OFI)
    nControls <- n2*propOFI
    
    # Separate treatment allocations from other data
    txDta <- txtSet(temp)
    
    out <- out2 <- out3 <- out4 <- out5 <- out6 <- NULL
    
    for (i in 1:ncol(txDta)){
      tx.temp <- txDta[[i]] # Select the Treatment Allocation
      nStarProp <- propCases # Set up for adjustment of proportion of cases according to treatment allocation
      nStarProp[tx.temp == 1] <- nStarProp[tx.temp == 1]*rr # Modify those clusters that are within the treatment arm
      nStarProp <- nStarProp/sum(nStarProp) # Make sure the proportions sum to 1
      nCases <- nStarProp*n1 # Assign cases to clusters according to proportion of cases per cluster
      
      prop <- nCases/(nCases + nControls) # a_j  
      test <- t.test(prop ~ as.factor(tx.temp), var.equal = TRUE) # Pooled variance
      ET <- diff(test$estimate)
      lambda.hat <- quad(ET)[which(quad(ET) > 0)]
      
      # To get coverage
      cov <- rrIN < quad(-test$conf.int[1])[which(quad(-test$conf.int[1]) > 0)] & rrIN > quad(-test$conf.int[2])[which(quad(-test$conf.int[2]) > 0)]
      
      # To get the estimated variances, take the average of the variance of the logged proportions in each arm
      sd.hat <- sqrt(mean(c(var(prop[tx.temp == 1]), var(prop[tx.temp == 0]))))
      
      if (both == TRUE){
        # Switch Treatment to Alternate Treatment Allocation
        tx.temp <- txDta[[i]]
        nStarProp <- propCases # Recode the proportion of dengue per cluster
        for (b in 1:length(tx.temp)){
          if (tx.temp[b] == 1){tx.temp[b] <- 0}
          else {tx.temp[b] <- 1}
        }
        
        nStarProp[tx.temp == 1] <- nStarProp[tx.temp == 1]*rr
        nStarProp <- nStarProp/sum(nStarProp)
        nCases <- nStarProp*n1
        prop <- nCases/(nCases + nControls)
        test2 <- t.test(prop ~ as.factor(tx.temp), var.equal = TRUE)
        ET2 <- diff(test2$estimate)
        cov2 <- rrIN < quad(-test2$conf.int[1])[which(quad(-test2$conf.int[1]) > 0)] & rrIN > quad(-test2$conf.int[2])[which(quad(-test2$conf.int[2]) > 0)]
        
        lambda.hat.2 <- quad(ET2)[which(quad(ET2) > 0)]
        sd.hat.2 <- sqrt(mean(c(var(prop[tx.temp == 1]), var(prop[tx.temp == 0]))))
        
      }
      
      if (both == TRUE) {
        out <- rbind(out, c(test$statistic, test2$statistic))
        out2 <- rbind(out2, c(test$p.val, test2$p.val))
        out3 <- rbind(out3, c(lambda.hat, lambda.hat.2))
        out4 <- rbind(out4, c(sd.hat, sd.hat.2))
        out5 <- rbind(out5, c(cov,cov2))
        out6 <- rbind(out6, c(ET, ET2))
      }
      
    }
    TOTtStats[[iter1]] <- out
    TOTpvals[[iter1]] <- out2
    lambdas[[iter1]] <- out3
    sds[[iter1]] <- out4
    coverage[[iter1]] <- out5
    tVals[[iter1]] <- out6
    iter1 <- iter1 + 1
  }
  output <- list(tStatistics = TOTtStats, pVals = TOTpvals, lambdas = lambdas, sds = sds, coverage = coverage, tVals = tVals)
}