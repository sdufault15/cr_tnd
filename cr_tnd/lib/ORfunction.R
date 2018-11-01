# Modified so that this only evaluates treatment in 1 arm
# Modified to return p-values
# LAST EDIT: 12/22/17
library(splitstackshape)
library(dplyr)
library(tidyr)

ORTestFunction <- function(dF, rrIN, period, n1 = 1000, ratio = 4){
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
  pvalmeORMatrix <- vector('list', length = length(period))
  pvalstandORMatrix <- vector('list', length = length(period))
  pvalgeeORMatrix <- vector('list', length = length(period))
  zstar <- qnorm(0.975)
  iter1 <- 1
  
  for (j in period){
    dta <- dF[dF$Period == j,] # subset data to just the time period of interest
    sdME <- NULL
    sdGEE <- NULL
    sdStand <- NULL
    pvalME <- NULL
    pvalGEE <- NULL
    pvalStand <- NULL
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
      tempWide <- data.frame(Cluster = dta$clust, Treatment = txDta, Cases = nCases, Controls = nControls) # Adding the number of cases and controls observed in each cluster
      tempLong <- tempWide %>% gather("Status", "Counts", 3:4)
      tempLong$v <- round(tempLong$Counts)
      tempLong <- tempLong %>% expandRows(count = "v", count.is.col = TRUE, drop = FALSE) %>% select(-Counts)
      tempLong <- tempLong %>% mutate(Status = ifelse(Status == "Cases", 1, 0)) %>% arrange(Cluster, Treatment) # geeglm must have the clusters in order
      
      mod1 <- glm(Status ~ Treatment, family = "binomial", data = tempLong) 
      #test <- summary(mod, robust = TRUE) # getting robust standard errors 
      g1 <- geeglm(Status ~ Treatment, data = tempLong, family = binomial, id = Cluster, corstr = "exchangeable", scale.fix = TRUE)
      me1 <- glmer(Status ~ Treatment + (1 | Cluster ), family = binomial, data = tempLong) 
        
      ORgee <- rbind(ORgee, exp(summary(g1)$coefficients[2,1])) # Unlogged ORs
      ORme <- rbind(ORme, exp(summary(me1)$coefficients[2]))
      ORstand <- rbind(ORstand, exp(summary(mod1)$coefficients[2]))
      sdGEE <- rbind(sdGEE, summary(g1)$coefficients[2,2]) # Logged SDs
      sdME <- rbind(sdME, summary(me1)$coefficients[4])
      sdStand <- rbind(sdStand, summary(mod1)$coefficients[4])
      pvalGEE <- rbind(pvalGEE, summary(g1)$coefficients[2,4]) # Coefficient p-vals (log scale)
      pvalME <- rbind(pvalME, summary(me1)$coefficients[2,4])
      pvalStand <- rbind(pvalStand, summary(mod1)$coefficients[2,4])
    }
    geeORMatrix[[iter1]] <- ORgee
    meORMatrix[[iter1]] <- ORme
    standORMatrix[[iter1]] <- ORstand
    sdGEEMatrix[[iter1]] <- sdGEE
    sdMEMatrix[[iter1]] <- sdME
    sdStandMatrix[[iter1]] <- sdStand
    pvalgeeORMatrix[[iter1]] <- pvalGEE
    pvalmeORMatrix[[iter1]] <- pvalME
    pvalstandORMatrix[[iter1]] <- pvalStand
    
    iter1 <- iter1 + 1
  }
  output <- list(OR_stand = standORMatrix, sd_stand = sdStandMatrix, OR_gee = geeORMatrix,
                 sd_gee_est = sdGEEMatrix, OR_me = meORMatrix, sd_me_est = sdMEMatrix,
                 pval_gee = pvalgeeORMatrix, pval_me = pvalmeORMatrix, pval_stand = pvalstandORMatrix)
}