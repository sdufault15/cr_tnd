############################
# Testing the performance of various methods with smaller sample sizes 
# and multinomial models
# 
# Suzanne Dufault
# January 3, 2019
############################

library(dplyr)
library(tidyr)

load("Final494Allocations.RData")
data <- Final247Allocations %>% select(-X1)


multinom_sample_function <- function(lambda, vecP.observed, tx.status, n, print = FALSE){
  if (print == TRUE){ 
    print(tx.status)
    print(vecP.observed)
  }
  vecP.intervention <- vecP.observed*tx.status*lambda + vecP.observed*(1-tx.status)
  if (print == TRUE){
    print(vecP.intervention)
  }
  vecP.intervention <- vecP.intervention/sum(vecP.intervention)
  if (print == TRUE){
    print(vecP.intervention)
  }
  counts <- rmultinom(1, size = n, prob = vecP.intervention)
  out <- data.frame(counts)
  return(out)
}
generate_function <- function(cluster, lambda, n, tx, vecP.observed, vecP2.observed, print = FALSE){
  # lambda is a vector of lambdas
  # n is a vector of ns
  out <- NULL
  
  for (size in n){
    for (lamb in lambda){
      out <- rbind(out, cbind(cluster, tx, lamb, size, 
                              cases = multinom_sample_function(lambda = lamb, vecP.observed = vecP.observed, tx.status = tx, n = size), 
                              OFIs = multinom_sample_function(lambda = 1, vecP.observed = vecP2.observed, tx.status = tx, n = 4*size)))
    }
  }
  out <- data.frame(out, row.names = NULL)
  names(out) <- c("Cluster", "Treatment", "lambda", "size", "cases", "OFIs")
  return(out)
}

periods <- sort(unique(data$Period))

sample_size_function <- function(df, periods, lambdas = c(1,0.6,0.5, 0.4,0.3), ns = c(200, 400, 600, 800, 1000), print = FALSE){
  
  treatment.status <- unlist(grep("tx", names(df), value = TRUE))
  
  #print(treatment.status)
  iter <- 1
  df_gen <- NULL
  df_temp <- NULL
  df_temp_2 <- NULL
  
  for (PERIOD in periods){
    df_temp <- df %>% filter(Period == PERIOD)
    #print(df_temp)
    
    for (TX in treatment.status){
      print(c("Iteration: ", iter, "Period: ", PERIOD, "Tx: ", TX))
      
      df_temp_2 <- df_temp %>% select(clust:Cases, TX) %>%
        mutate(propCases = Cases/sum(Cases),
               propOFI = OFI/sum(OFI))
      #print(names(df_temp_2))
      #print(summary(df_temp_2))
      #propCases <- df_temp_2$Cases/sum(df_temp_2$Cases)
      #print(propCases)
      #propOFI <- df_temp_2$OFI/sum(df_temp_2$OFI)
      #print(propOFI)
      
      df_gen <- rbind(df_gen, 
                      cbind(iter, PERIOD, 
                            generate_function(cluster = df_temp_2$clust, lambda = lambdas, n = ns, 
                                              tx = unlist(df_temp_2[,5]), vecP.observed = unlist(df_temp_2$propCases), 
                                              vecP2.observed = unlist(df_temp_2$propOFI), print = print)))
      iter <- iter + 1
      
    }
  }
  return(df_gen)
}

data_generated_200 <- sample_size_function(data, 
                                           periods = periods, 
                                           lambdas = c(1, 0.6, 0.5, 0.4, 0.3), 
                                           ns = 200, 
                                           print = FALSE)
save(data_generated_200, file = "jan19/multinom_data_200.RData")

data_generated_400 <- sample_size_function(data, 
                                           periods = periods, 
                                           lambdas = c(1, 0.6, 0.5, 0.4, 0.3), 
                                           ns = 400, 
                                           print = FALSE)
save(data_generated_400, file = "jan19/multinom_data_400.RData")

data_generated_600 <- sample_size_function(data, 
                                           periods = periods, 
                                           lambdas = c(1, 0.6, 0.5, 0.4, 0.3), 
                                           ns = 600, 
                                           print = FALSE)
save(data_generated_600, file = "jan19/multinom_data_600.RData")

data_generated_800 <- sample_size_function(data, 
                                           periods = periods, 
                                           lambdas = c(1, 0.6, 0.5, 0.4, 0.3), 
                                           ns = 800, 
                                           print = FALSE)
save(data_generated_800, file = "jan19/multinom_data_800.RData")

data_generated_1000 <- sample_size_function(data, 
                                           periods = periods, 
                                           lambdas = c(1, 0.6, 0.5, 0.4, 0.3), 
                                           ns = 1000, 
                                           print = FALSE)
save(data_generated_1000, file = "jan19/multinom_data_1000.RData")