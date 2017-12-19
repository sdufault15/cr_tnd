paperFunction2 <- function(dF, rr, period, both = TRUE, ratio, ncases){
  # Modified 7/17/2017 to reinflate A*s by 1/RR

  sigMatrix <- vector('list', length = length(period))
  sdMatrix <- vector('list', length = length(period))
  ORMatrix <- vector('list', length = length(period))
  zstar <- qnorm(0.975)
  iter1 <- 1
  for (j in period){
    dta <- dF[dF$Period == j,] # subset data to just the time period of interest
    sig <- NULL
    sd <- NULL
    dbgF <- txtSet(dta)
    m <- nrow(dta)/2
    OR_est <- NULL
    
  for (i in 1:ncol(dbgF)){
    dbg <- dbgF[,i]
    
    propCases <- dta$Cases/sum(dta$Cases) # proportion of cases per cluster
    propOFI <- dta$OFI/sum(dta$OFI) # proportion of OFI per cluster
    nControls <- ratio*ncases*propOFI # assigning controls to clusters
    nStarProp <- propCases # place keeper (so as not to overwrite the original proportions)
    nStarProp[dbg == 1] <- nStarProp[dbg == 1]*rr # apply treatment to all clusters within the treatment arm
    nStarProp <- nStarProp/sum(nStarProp) # Re-standardizing proportions so they sum to 1
    nCases <- nStarProp*ncases # assigning cases to clusters
    
    # collecting all cluster data on those who received the treatment and DID develop dengue
    AplusClusters <- nCases[dbg == 1]
    
    # collecting all cluster data on those who received the treatment and DID NOT develop dengue but OFI
    BplusClusters <- nControls[dbg == 1]
    
    # collecting all cluster data on those who did not receive the treatment and DID develop dengue
    GplusClusters <- nCases[dbg == 0]
    
    # collecting all cluster data on those who did not receive the treatment and DID NOT develop dengue
    HplusClusters <- nControls[dbg == 0]
    
    Aplus <- sum(AplusClusters) # collecting all individuals who received the treatment and DID develop dengue
    Bplus <- sum(BplusClusters) # collecting all individuals who received the treatment and DID NOT develop dengue but OFI
    Gplus <- sum(GplusClusters) # collecting all individuals who did not receive the treatment and DID develop dengue
    Hplus <- sum(HplusClusters) # collecting all individuals who did not receive the treatment and DID NOT develop dengue but OFI
    
    lambdaHat <- (Aplus*Hplus)/(Gplus*Bplus)
    
    # Adjustment
    A_adj <- AplusClusters*(1/lambdaHat)
    Aplus_adj <- sum(A_adj)
    
    # Variance Calculations
    vD.A <- var(A_adj) #GOOD
    vD.G <- var(GplusClusters) #GOOD
    vD.B <- var(BplusClusters) #GOOD
    vD.H <- var(HplusClusters) #GOOD
    vD <- mean(c(vD.A, vD.G)) # GOOD
    vDbar <- mean(c(vD.B, vD.H)) # GOOD
    
    covAB <- cov(x = A_adj, y = BplusClusters) # empirical estimate of cov(Aj, Bj)
    covGH <- cov(x = GplusClusters, y = HplusClusters) # empirical estimate of cov(Gj, Hj)
 
    covABplus <- m*covAB*(m/(2*m)) # according to previous equation
    covGHplus <- m*covGH*(m/(2*m)) # according to previous equation
    covFINAL <- mean(c(covABplus, covGHplus))
    covABplus 
    covGHplus
    covFINAL
    nD <- sum(c(Aplus_adj,Gplus)) # number of cases 
    nDbar <- sum(c(Bplus, Hplus)) # number of controls 
    
    varlogOR <- (16/(nD^2))*(m/2)*vD + (16/(nDbar^2))*(m/2)*vDbar - 2*( (nD*nDbar) / (Aplus_adj*(nD - Aplus_adj)*Bplus*(nDbar - Bplus)))*covFINAL
    
    sd1 <- sqrt(varlogOR) # for comparison with logistic regression output
    
    # Paper Significance
    OR_est1 <- lambdaHat
    sig1 <- (0 <= log(OR_est1) + zstar*sd1 & 0 >= log(OR_est1) - zstar*sd1)
    if (is.nan(sd1) == TRUE){sig1 <- FALSE}
    
    if (both == TRUE){
      propCases <- dta$Cases/sum(dta$Cases) # proportion of cases per cluster
      propOFI <- dta$OFI/sum(dta$OFI) # proportion of OFI per cluster
      nControls <- ratio*ncases*propOFI # assigning controls to clusters
      nStarProp <- propCases # place keeper (so as not to overwrite the original proportions)
      nStarProp[dbg == 0] <- nStarProp[dbg == 0]*rr # apply treatment to all clusters within the treatment arm 
      # check the above process in the code
      #nStarProp[dbg1 == 1] <- nStarProp[dbg1 == 1]*0.5 # test to prove it is only applying to the treated clusters
      nStarProp <- nStarProp/sum(nStarProp) # Re-standardizing proportions so they sum to 1
      nCases <- nStarProp*ncases # assigning cases to clusters
      
      # collecting all cluster data on those who received the treatment and DID develop dengue
      AplusClusters <- nCases[dbg == 0]
      
      # collecting all cluster data on those who received the treatment and DID NOT develop dengue but OFI
      BplusClusters <- nControls[dbg == 0]
      
      # collecting all cluster data on those who did not receive the treatment and DID develop dengue
      GplusClusters <- nCases[dbg == 1]
      
      # collecting all cluster data on those who did not receive the treatment and DID NOT develop dengue
      HplusClusters <- nControls[dbg == 1]
      
      Aplus <- sum(AplusClusters) # collecting all individuals who received the treatment and DID develop dengue
      Bplus <- sum(BplusClusters) # collecting all individuals who received the treatment and DID NOT develop dengue but OFI
      Gplus <- sum(GplusClusters) # collecting all individuals who did not receive the treatment and DID develop dengue
      Hplus <- sum(HplusClusters) # collecting all individuals who did not receive the treatment and DID NOT develop dengue but OFI
      
      lambdaHat <- (Aplus*Hplus)/(Gplus*Bplus)

      # Adjustment
      A_adj <- AplusClusters*(1/lambdaHat)
      Aplus_adj <- sum(A_adj)
      
      # Variance Calculations
      vD.A <- var(A_adj) #GOOD
      vD.G <- var(GplusClusters) #GOOD
      vD.B <- var(BplusClusters) #GOOD
      vD.H <- var(HplusClusters) #GOOD
      vD <- mean(c(vD.A, vD.G)) # GOOD
      vDbar <- mean(c(vD.B, vD.H)) # GOOD
      
      covAB <- cov(x = A_adj, y = BplusClusters) # empirical estimate of cov(Aj, Bj)
      covGH <- cov(x = GplusClusters, y = HplusClusters) # empirical estimate of cov(Gj, Hj)
      
      covABplus <- m*covAB*(m/(2*m)) # according to previous equation
      covGHplus <- m*covGH*(m/(2*m)) # according to previous equation
      covFINAL <- mean(c(covABplus, covGHplus))
      
      nD <- sum(c(Aplus_adj,Gplus)) # number of cases 
      nDbar <- sum(c(Bplus, Hplus)) # number of controls 

      varlogOR2 <- (16/(nD^2))*(m/2)*vD + (16/(nDbar^2))*(m/2)*vDbar - 2*( (nD*nDbar) / (Aplus_adj*(nD - Aplus_adj)*Bplus*(nDbar - Bplus)))*covFINAL
      
      sd2 <- sqrt(varlogOR2) # for comparison with logistic regression output
      # Paper Significance
      OR_est2 <- lambdaHat
      sig2 <- (0 <= log(OR_est2) + zstar*sd2 & 0 >= log(OR_est2) - zstar*sd2)
      if (is.nan(sd2) == TRUE){sig2 <- FALSE}
    }
    OR_est <- rbind(OR_est, c(OR_est1, OR_est2))
    sd <- rbind(sd, c(sd1, sd2))
    sig <- rbind(sig, c(sig1,sig2))
  }
    sigMatrix[[iter1]] <- sig
    sdMatrix[[iter1]] <- sd
    ORMatrix[[iter1]] <- OR_est
    iter1 <- iter1 + 1
  }
  output <- list(sd_est = sdMatrix, insignificance = sigMatrix, OR_est = ORMatrix)
  return(output)
}