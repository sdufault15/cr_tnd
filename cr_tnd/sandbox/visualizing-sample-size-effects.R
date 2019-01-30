library(here)
library(tidyverse)

# load(here("cr_tnd", "data/oct18/or1_300_11012018.RData"))
# load(here("cr_tnd", "data/oct18/or1_400_11012018.RData"))
# load(here("cr_tnd", "data/oct18/or1_500_11012018.RData"))
# load(here("cr_tnd", "data/oct18/or1_600_11012018.RData"))
# load(here("cr_tnd", "data/oct18/or1_700_11012018.RData"))
# 
# load(here("cr_tnd", "data/oct18/or2_300_11012018.RData"))
# load(here("cr_tnd", "data/oct18/or2_400_11012018.RData"))
# load(here("cr_tnd", "data/oct18/or2_500_11012018.RData"))
# load(here("cr_tnd", "data/oct18/or2_600_11012018.RData"))
# load(here("cr_tnd", "data/oct18/or2_700_11012018.RData"))

load(here("cr_tnd", "data/oct18/or3_300_11012018.RData"))
load(here("cr_tnd", "data/oct18/or3_400_11012018.RData"))
load(here("cr_tnd", "data/oct18/or3_500_11012018.RData"))
load(here("cr_tnd", "data/oct18/or3_600_11012018.RData"))
load(here("cr_tnd", "data/oct18/or3_700_11012018.RData"))

hist(unlist(or3_300$pval_me), breaks = 100)
hist(unlist(or3_300$sd_me_est), breaks= 100)

# RR = 0.3, ratio = 1:1, sample size = 300, Random 247x2
ul <- log(unlist(or3_300$OR_me)) + 1.96*unlist(or3_300$sd_me_est)
ll <- log(unlist(or3_300$OR_me)) - 1.96*unlist(or3_300$sd_me_est)

tt <- data.frame(ul, ll) %>% mutate(yy = row_number())
tsub <- tt[1:100,]

tsub <- tsub %>% gather("limit", "value", 1:2)

tsub %>% ggplot(aes(x = exp(value), y = yy, group = yy)) + 
  geom_point(alpha = 0.4) + 
  geom_line(alpha = 0.3) + 
  xlim(0,2.5) + 
  geom_vline(xintercept = 0.3, lty = 2, col = 'lightblue') + 
  geom_vline(xintercept = 1, lty = 2, col = 'darkred') + 
  ggtitle("ME 95% CIs", subtitle = "RR = 0.3, Ratio = 1:1, Sample Size = 300, Constrained 247x2 Allocations") + 
  ylab("Random Iteration") + 
  xlab("Odds Ratio") + 
  theme_classic()
ggsave(here("cr_tnd", "graphs/rand10000_03_power_n300.png"), device = "png", units = "in", height = 8, width = 6)

# RR = 0.3, ratio = 1:1, sample size = 1000, Random 247x2
load(here("cr_tnd", "data/nov18/r_est3_11072018_supp.RData"))
ul3 <- log(unlist(r.est3.1$OR_me)) + 1.96*unlist(r.est3.1$sd_me_est)
ll3 <- log(unlist(r.est3.1$OR_me)) - 1.96*unlist(r.est3.1$sd_me_est)

tt3 <- data.frame(ul3, ll3) %>% mutate(yy = row_number())
tsub3 <- tt3[1:100,]

tsub3 <- tsub3 %>% gather("limit", "value", 1:2)

tsub3 %>% ggplot(aes(x = exp(value), y = yy, group = yy)) + 
  geom_point(alpha = 0.4) + 
  geom_line(alpha = 0.3) + 
  xlim(0,2.5) + 
  geom_vline(xintercept = 1, lty = 2, col = 'darkred') + 
  geom_vline(xintercept = 0.3, lty = 2, col = 'lightblue') + 
  theme_classic() + 
  ggtitle("ME 95% CIs", subtitle = "RR = 0.3, Ratio = 1:1, Sample Size = 1,000, Constrained 247x2 Allocations") + 
  ylab("Random Iteration") + 
  xlab("Odds Ratio")
ggsave(here("cr_tnd", "graphs/rand10000_03_power_n1000.png"), device = "png", units = "in", height = 8, width = 6)

# RR = 1, ratio = 1:1, sample size = 1000, Random 247x2
load(here("cr_tnd", "data/nov18/r_estNULL_11072018_supp.RData"))
ul4 <- log(unlist(r.estNULL.1$OR_me)) + 1.96*unlist(r.estNULL.1$sd_me_est)
ll4 <- log(unlist(r.estNULL.1$OR_me)) - 1.96*unlist(r.estNULL.1$sd_me_est)

tt4 <- data.frame(ul4, ll4) %>% mutate(yy = row_number())
tsub4 <- tt4[1:100,]

tsub4 <- tsub4 %>% gather("limit", "value", 1:2)

tsub4 %>% ggplot(aes(x = exp(value), y = yy, group = yy)) + 
  geom_point(alpha = 0.4) + 
  geom_line(alpha = 0.3) + 
  xlim(0,2.5) + 
  geom_vline(xintercept = 1, lty = 2, col = 'darkred') + 
  #geom_vline(xintercept = 0.3, lty = 2, col = 'lightblue') + 
  theme_classic() + 
  ggtitle("ME 95% CIs", subtitle = "RR = 1, Ratio = 1:1, Sample Size = 1,000, Constrained 247x2 Allocations") + 
  ylab("Random Iteration") + 
  xlab("Odds Ratio")
ggsave(here("cr_tnd", "graphs/rand10000_NULL_power_n1000.png"), device = "png", units = "in", height = 8, width = 6)



library(ggridges)
me1000 <- unlist(r.est3.1$sd_me_est)
me700 <- unlist(or3_700$sd_me_est)
me600 <- unlist(or3_600$sd_me_est)
me500 <- unlist(or3_500$sd_me_est)
me400 <- unlist(or3_400$sd_me_est)
me300 <- unlist(or3_300$sd_me_est)
sdframe <- data.frame(me1000, me700, me600, me500, me400, me300)

sdframe <- sdframe %>% gather("samplesize", "sd")
sdframe %>% ggplot(aes(x = sd, y = samplesize, group = samplesize, height = 0.8)) + geom_ridgeline()
sdframe %>% filter(samplesize %in% c("me1000", "me300")) %>% ggplot(aes(x = sd, group = samplesize, col = samplesize, fill = samplesize)) + 
  geom_density(alpha = 0.3) + 
  xlab("estimated standard deviation") + 
  ggtitle("Comparison of Estimated Mixed Effects SD", subtitle = "SDs are smaller for samples of 1,000 versus 300") + 
  theme_classic()
ggsave(here("cr_tnd", "graphs/densityplots_1000v300_sds_me.png"), device = "png", units = "in", height = 8, width = 6)

plot(density((unlist(r.est3.1$sd_me_est))),
     main = "Estimated Standard Deviation",
     col = alpha("darkblue", 0))
polygon(density((unlist(r.est3.1$sd_me_est))),
        col = alpha("darkblue", 0.3), border = NA)
polygon(density((unlist(or3_300$sd_me_est))),
      col = alpha("darkgreen", 0.3), border = NA)
