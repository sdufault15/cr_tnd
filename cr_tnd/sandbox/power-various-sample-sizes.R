# Visualizing power at various sample sizes

library(here)
library(tidyverse)
library(ggplot2)
library(ggridges)

# Data
load(here("cr_tnd", "data/oct18/or3_300_11012018.RData"))
load(here("cr_tnd", "data/oct18/or3_400_11012018.RData"))
load(here("cr_tnd", "data/oct18/or3_500_11012018.RData"))
load(here("cr_tnd", "data/oct18/or3_600_11012018.RData"))
load(here("cr_tnd", "data/oct18/or3_700_11012018.RData"))


# Power
pvals300 <- data.frame(n = 300, ME = unlist(or3_300$pval_me) )
pvals400 <- data.frame(n = 400, ME = unlist(or3_400$pval_me) )
pvals500 <- data.frame(n = 500, ME = unlist(or3_500$pval_me) )
pvals600 <- data.frame(n = 600, ME = unlist(or3_600$pval_me) )
pvals700 <- data.frame(n = 700, ME = unlist(or3_700$pval_me) )

pvals <- bind_rows(pvals300, pvals400, pvals500, pvals600, pvals700)

pvals %>% ggplot(aes(x = n, y = ME, group = n)) + 
  geom_boxplot(outlier.shape = NA) + 
  theme_classic()

pvals %>% ggplot(aes(x = ME, y = as.factor(n))) + 
  geom_density_ridges(scale = 0.9) + 
  xlim(0,0.00005)
