# TO DO:
# - Currently only works if both == TRUE

# LAST EDIT: 10/29/17

ORTestFunction <- function(dF, rrIN, period, n1 = 1000, ratio = 4, both = TRUE){
  # 'dta' is a matrix/dataframe containing cluster, case and control data, corresponding time periods and treatment allocations
  # 'rr' is a vector of relative risks to be tested
  # 'period' is a vector of corresponding time periods for the case and control data
  # 'n1' is the number of cases you want to observe (default is 1000)
  # 'ratio' is the number of controls you want per case (default is 4)
  # 'print' is a logical that will output various aspects of the function while it runs. Useful for checking code
  
  # Storage preparation for output and internal functions
  #sig <- matrix(NA, nrow = length(rrIN), ncol = length(period)) # Matrix for significance storage
  #rownames(sig) <- paste0(rrIN) 
  #colnames(sig) <- paste0(period)
  sigMatrix <- vector('list', length = length(period))
  sdMatrix <- vector('list', length = length(period))
  geeORMatrix <- vector('list', length = length(period))
  meORMatrix <- vector('list', length = length(period))
  sdStandMatrix <- vector('list', length = length(period))
  standORMatrix <- vector('list', length = length(period))
  sdGEEMatrix <- vector('list', length = length(period))
  sdMEMatrix <- vector('list', length = length(period))
  zstar <- qnorm(0.975)
  iter1 <- 1
  
  for (j in period){
    dta <- dF[dF$Period == j,] # subset data to just the time period of interest
    sdME <- NULL
    sdGEE <- NULL
    sdStand <- NULL
    ORme <- NULL
    ORgee <- NULL
    ORstand <- NULL
    txDtaF <- txtSet(dta)
    m <- nrow(dta)/2
    
    for (i in 1:ncol(txDtaF)){
      txDta <- txDtaF[,i]
      
      propCases <- dta$Cases/sum(dta$Cases) # proportion of cases per cluster
      propOFI <- dta$OFI/sum(dta$OFI) # proportion of OFI per cluster
      nControls <- ratio*n1*propOFI # assigning controls to clusters
      nStarProp <- propCases # place keeper (so as not to overwrite the original proportions)
      nStarProp[txDta == 1] <- nStarProp[txDta == 1]*rrIN # apply treatment to all clusters within the treatment arm
      nStarProp <- nStarProp/sum(nStarProp) # Re-standardizing proportions so they sum to 1
      nCases <- nStarProp*n1 # assigning cases to clusters
      
      # NEED TO RESHAPE THE DATA
      freq.1 <- nCases
      freq.0 <- nControls
      tempWide <- data.frame(dta$Cluster, txDta, freq.1, freq.0)
      tempWide <- reshape(data = tempWide, direction = "long", varying = 3:4, sep = "." )
      #print(tempWide)
      #v <- ceiling(as.matrix(tempWide$freq))
      v <- round(as.matrix(tempWide$freq))
      mod1 <- glm(time ~ tempWide[[2]] , family = "binomial", data = tempWide, weights = v) 
      #test <- summary(mod, robust = TRUE) # getting robust standard errors 
      g1 <- geeglm(time ~ tempWide[[2]], data = tempWide, family = binomial, weights = v, id = tempWide[[1]], corstr = "exchangeable", scale.fix = TRUE)
      me1 <- glmer(time ~ tempWide[[2]] + (1 | id ), family = binomial, data = tempWide, weights = v) 
        
      if (both == TRUE){
        #tStat <- NULL
        # Switch Treatment to Alternate Treatment Allocation
        tx.temp <- txDtaF[,i]
          
          nStarProp <- propCases # Recode the proportion of dengue per cluster
          for (b in 1:length(tx.temp)){
            if (tx.temp[b] == 1){tx.temp[b] <- 0}
            else {tx.temp[b] <- 1}
          }
          
          nStarProp[tx.temp == 1] <- nStarProp[tx.temp == 1]*rrIN
          nStarProp <- nStarProp/sum(nStarProp)
          nCases <- nStarProp*n1
          prop <- nCases/(nCases + nControls)
          
          # NEED TO RESHAPE THE DATA
          freq.1 <- nCases
          freq.0 <- nControls
          tempWide <- data.frame(dta$Cluster, tx.temp, freq.1, freq.0)
          tempWide <- reshape(data = tempWide, direction = "long", varying = 3:4, sep = "." )
          #print(tempWide)
          v <- ceiling(as.matrix(tempWide$freq))
          mod2 <- glm(time ~ tempWide[[2]] , family = "binomial", data = tempWide, weights = v) 
          #test2 <- summary(mod, robust = TRUE) # getting robust standard errors 
          g2 <- geeglm(time ~ tempWide[[2]], data = tempWide, family = binomial, weights =v, id = tempWide[[1]], corstr = "exchangeable", scale.fix = TRUE)
          #print(summary(g2)$coefficients)
          me2 <- glmer(time ~ tempWide[[2]] + (1 | id ), family = binomial, data = tempWide, weights = v) 
          #print(me2)
          }
        #OR_est <- rbind(OR_est, c(OR_est1, OR_est2))
      ORgee <- rbind(ORgee, c(exp(summary(g1)$coefficients[2,1]), exp(summary(g2)$coefficients[2,1]))) # Unlogged ORs
      ORme <- rbind(ORme, c(exp(summary(me1)$coefficients[2]), exp(summary(me2)$coefficients[2])))
      ORstand <- rbind(ORstand, c(exp(summary(mod1)$coefficients[2]), exp(summary(mod2)$coefficients[2])))
      sdGEE <- rbind(sdGEE, c(summary(g1)$coefficients[2,2], summary(g2)$coefficients[2,2])) # Logged SDs
      sdME <- rbind(sdME, c(summary(me1)$coefficients[4], summary(me2)$coefficients[4]))
      sdStand <- rbind(sdStand, c(summary(mod1)$coefficients[4], summary(mod2)$coefficients[4]))
    }
    geeORMatrix[[iter1]] <- ORgee
    meORMatrix[[iter1]] <- ORme
    standORMatrix[[iter1]] <- ORstand
    sdGEEMatrix[[iter1]] <- sdGEE
    sdMEMatrix[[iter1]] <- sdME
    sdStandMatrix[[iter1]] <- sdStand
    
    iter1 <- iter1 + 1
  }
  output <- list(OR_stand = standORMatrix, sd_stand = sdStandMatrix, OR_gee = geeORMatrix,
                 sd_gee_est = sdGEEMatrix, OR_me = meORMatrix, sd_me_est = sdMEMatrix)
}