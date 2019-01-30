############################
# Suzanne Dufault
# Running Estimators on Generated Data
# 1/4/2019
############################
library(tidyr)
library(purrr)
library(dplyr)
library(splitstackshape)
library(tibble)
library(geepack)
library(lme4)

load("jan19/multinom_data_200.RData")
load("jan19/multinom_data_400.RData")
load("jan19/multinom_data_600.RData")
load("jan19/multinom_data_800.RData")
load("jan19/multinom_data_1000.RData")

# Helper Functions
aggregate_or_function <- function(df, m, zstar){
  # applies aggregate OR estimation
  # requires generated data (df) with column names Treatment, cases, OFIs
  # m = number of clusters in one arm
  # zstar = Z value associated with desired significance level
  
  
  # collecting all cluster data on those who received the treatment and DID develop dengue
  AplusClusters <- df %>% filter(Treatment == 1) %>% select(cases) %>% unlist() #& PERIOD == "03_05" & iter == 1 & lambda == 0.6 & size == 200
  
  # collecting all cluster data on those who received the treatment and DID NOT develop dengue but OFI
  BplusClusters <- df %>% filter(Treatment == 1) %>% select(OFIs) %>% unlist()
  
  # collecting all cluster data on those who did not receive the treatment and DID develop dengue
  GplusClusters <- df %>% filter(Treatment == 0) %>% select(cases) %>% unlist()
  
  # collecting all cluster data on those who did not receive the treatment and DID NOT develop dengue
  HplusClusters <- df %>% filter(Treatment == 0) %>% select(OFIs) %>% unlist()
  
  Aplus <- sum(AplusClusters) # collecting all individuals who received the treatment and DID develop dengue
  Bplus <- sum(BplusClusters) # collecting all individuals who received the treatment and DID NOT develop dengue but OFI
  Gplus <- sum(GplusClusters) # collecting all individuals who did not receive the treatment and DID develop dengue
  Hplus <- sum(HplusClusters) # collecting all individuals who did not receive the treatment and DID NOT develop dengue but OFI
  
  lambdaHat <- (Aplus*Hplus)/(Gplus*Bplus)
  
  # Adjustment
  A_adj <- AplusClusters*(1/lambdaHat)
  Aplus_adj <- sum(A_adj)
  
  # Variance Calculations
  vD.A <- var(A_adj) 
  vD.G <- var(GplusClusters) 
  vD.B <- var(BplusClusters) 
  vD.H <- var(HplusClusters) 
  vD <- mean(c(vD.A, vD.G)) 
  vDbar <- mean(c(vD.B, vD.H)) 
  
  covAB <- cov(x = A_adj, y = BplusClusters) 
  covGH <- cov(x = GplusClusters, y = HplusClusters) 
  
  covABplus <- m*covAB*(m/(2*m)) # according to previous equation
  covGHplus <- m*covGH*(m/(2*m)) # according to previous equation
  covFINAL <- mean(c(covABplus, covGHplus))
  
  nD <- sum(c(Aplus_adj,Gplus)) # number of cases 
  nDbar <- sum(c(Bplus, Hplus)) # number of controls 
  
  varlogOR <- (16/(nD^2))*(m/2)*vD + (16/(nDbar^2))*(m/2)*vDbar - 2*( (nD*nDbar) / (Aplus_adj*(nD - Aplus_adj)*Bplus*(nDbar - Bplus)))*covFINAL
  
  sd <- sqrt(varlogOR) # for comparison with logistic regression output
  
  # Significance
  OR_est <- lambdaHat
  sig <- between(0,
                  log(OR_est) - zstar*sd,
                  log(OR_est) + zstar*sd)
  
  out <- c(OR_est, sd, sig)
  return(out)
}

mixed_effects_function <- function(df){
  df_long <- df %>% gather("test.status", "count", cases:OFIs) %>%
    mutate(test.status = ifelse(test.status == "cases", 1, 0)) %>%
    expandRows("count", count.is.col = TRUE, drop = TRUE) %>%
    arrange(Cluster, Treatment)
  
  gee <- geeglm(test.status ~ Treatment, data = df_long, family = binomial, id = Cluster, corstr = "exchangeable", scale.fix = TRUE)
  me <- glmer(test.status ~ Treatment + (1 | Cluster ), family = binomial, data = df_long)
  
  ORgee <- exp(summary(gee)$coefficients["Treatment",1]) # Unlogged ORs
  ORme <- exp(summary(me)$coefficients["Treatment", 1])
  
  sdGEE <- summary(gee)$coefficients["Treatment",2]# Logged SDs
  sdME <- summary(me)$coefficients["Treatment", 2]
  
  pvalGEE <- summary(gee)$coefficients["Treatment", 4] # Coefficient p-vals (log scale)
  pvalME <- summary(me)$coefficients["Treatment", 4]
  
  out <- list(OR = ORgee, sd = sdGEE, pval = pvalGEE, OR = ORme, sd = sdME, pval = pvalME)
  
  return(out)
}

# Full Function
performance_function <- function(df, m, zstar, estimator = c("AggOR", "ME.GEE")){
  
  df_temp <- as.tibble(df) %>% nest(-PERIOD, -iter, -lambda, -size)
  
  if("AggOR" %in% estimator){
    df_temp <- df_temp %>% mutate(AggOR = map(data, ~aggregate_or_function(., m, zstar))) %>% 
      mutate(OR.agg = map_dbl(AggOR, 1),
             sd.agg = map_dbl(AggOR, 2),
             sig.agg = map_dbl(AggOR, 3))
  }
  
  if("ME.GEE" %in% estimator){
    df_temp <- df_temp %>% mutate(ME.GEE = map(data, ~mixed_effects_function(.))) %>%
      mutate(OR.gee = map_dbl(ME.GEE, 1),
             sd.gee = map_dbl(ME.GEE, 2),
             pval.gee = map_dbl(ME.GEE, 3),
             OR.me = map_dbl(ME.GEE, 4),
             sd.me = map_dbl(ME.GEE, 5),
             pval.me = map_dbl(ME.GEE, 6))
  }
  
  return(df_temp)
}

multinom_results_200 <- performance_function(data_generated_200, 12, 1.96, estimator = c("AggOR", "ME.GEE"))
save(multinom_results_200, file = "jan19/multinom_results_200.RData")

multinom_results_400 <- performance_function(data_generated_400, 12, 1.96, estimator = c("AggOR", "ME.GEE"))
save(multinom_results_400, file = "jan19/multinom_results_400.RData")

multinom_results_600 <- performance_function(data_generated_600, 12, 1.96, estimator = c("AggOR", "ME.GEE"))
save(multinom_results_600, file = "jan19/multinom_results_600.RData")

multinom_results_800 <- performance_function(data_generated_800, 12, 1.96, estimator = c("AggOR", "ME.GEE"))
save(multinom_results_800, file = "jan19/multinom_results_800.RData")

multinom_results_1000 <- performance_function(data_generated_1000, 12, 1.96, estimator = c("AggOR", "ME.GEE"))
save(multinom_results_1000, file = "jan19/multinom_results_1000.RData")


  
