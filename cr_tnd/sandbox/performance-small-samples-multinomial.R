####################
# Suzanne Dufault
# Checking Performance of Multinomial
# 1/4/2019
####################

library(tidyverse)
library(here)
library(xtable)
library(ggrepel)
load(here("cr_tnd", "data/jan19/multinom_results_200.RData"))
load(here("cr_tnd", "data/jan19/multinom_results_400.RData"))
load(here("cr_tnd", "data/jan19/multinom_results_600.RData"))
load(here("cr_tnd", "data/jan19/multinom_results_800.RData"))
load(here("cr_tnd", "data/jan19/multinom_results_1000.RData"))

head(multinom_results_200)

multinom_results_200 %>% group_by(lambda, size) %>%
  summarize(meanOR.agg = mean(OR.agg),
            meanOR.gee = mean(OR.gee),
            meanOR.me = mean(OR.me),
            sig.agg = 1 - mean(sig.agg),
            sig.gee = mean(pval.gee <= 0.05),
            sig.me = mean(pval.me <= 0.05)) %>%
  xtable(digits = c(0,1,0,rep(2,3), rep(3,3))) %>% 
  print(include.rownames = FALSE)

#
previously <- data.frame(lambda = c(1, 0.6, 0.5, 0.4, 0.3), 
                         sig.agg = c(0.0104, 0.6055, 0.8864, 0.9852, 0.9998),
                         sig.re = c(0.0043, 0.6462, 0.9166, 0.9919, 1.000))

summary_function <- function(results){
  out <- results %>% group_by(lambda) %>%
    summarize(sig.agg = 1-mean(sig.agg),
              sig.re = mean(pval.me <= 0.05))
  return(out)
}

sub <- summary_function(multinom_results_200)

df.comparison <- rbind(previously, sub)
names(df.comparison) <- c("lambda", "Aggregate OR", "Mixed Effects")

df.comparison %>% 
  mutate(Type = c(rep("deterministic", 5), rep("multinomial", 5))) %>%
  gather("Estimator", "Power", 2:3) %>%
  ggplot(aes(x = lambda, y = Power, col = Type, shape = Type)) + 
  facet_wrap(~Estimator) + 
  geom_point(size = 3) + 
  ggtitle("Power", subtitle = "Multinomial (n.cases = 200)\nDeterministic (n.cases = 1000)\n x4 controls\n 247x2 Constrained Tx Allocations") + 
  geom_line(lwd = 1) +
  # geom_label_repel(aes(label = round(Power, 3)),
  #                  box.padding = 0.25, 
  #                  label.padding = 0.25,
  #                  label.r = .25,
  #                  label.size = .1,
  #                  nudge_x = 0.01,
  #                  nudge_y = 0.1,
  #                  point.padding = 0.025,
  #                  segment.color = 'gray') +
  scale_x_reverse() + 
  xlab("Intervention RR\n (increasing in effect)") +
  geom_hline(yintercept = 0.8, lty = 3, col = "gray") + 
  theme_classic()

ggsave(filename = here("cr_tnd/graphs", "multinomial_deterministic_comparison_200.png"), 
       device = "png", 
       units = "in",
       height = 8,
       width = 12)


##########
s2 <- data.frame(summary_function(multinom_results_200), n = 200)
s4 <- data.frame(summary_function(multinom_results_400), n = 400)
s6 <- data.frame(summary_function(multinom_results_600), n = 600)
s8 <- data.frame(summary_function(multinom_results_800), n = 800)
s10 <- data.frame(summary_function(multinom_results_1000), n = 1000)

previously <- data.frame(previously, n = "deterministic", stringsAsFactors = FALSE)

comparison <- rbind(previously, s2, s4, s6, s8, s10)
names(comparison) <- c("Intervention RR", "Aggregate OR", "Mixed Effects", "N")

myvalues <- c( "#ED7D31", "#4bacc6","#8064A2", "#FFC000", "#f79646", "#9bbb59", "#5DCEAF")
comparison$N <- factor(comparison$N, levels = c("deterministic", "200", "400", "600", "800", "1000"))

comparison %>% 
  gather("Estimator", "Power", 2:3) %>%
  ggplot(aes(x = `Intervention RR`, y = Power, col = N, shape = N)) + 
  facet_wrap(~Estimator) + 
  geom_point(size = 3, alpha = 0.8) + 
  ggtitle("Power", subtitle = "4 controls : 1 case\n247x2 constrained tx allocations\n9 historic time periods") + 
  geom_line(lwd = 1, alpha = 0.8) +
  scale_color_manual("Sample Size (cases)", values = c("deterministic" = "#ED7D31", 
                                                 "200" = "#4bacc6",
                                                 "400" = "#5DCEAF",
                                                 "600" = "#FFC000",
                                                 "800" = "#c0504d",
                                               "1000" = "#9bbb59")) + #,
  scale_shape_manual("Sample Size (cases)", values = c("deterministic" = 8,
                                               "200" = 15,
                                               "400" = 16,
                                               "600" = 17,
                                               "800" = 18, 
                                               "1000" = 19)) + 
  scale_x_reverse() + 
  xlab("Intervention RR\n (increasing in effect)") +
  geom_hline(yintercept = 0.8, lty = 3, col = "gray") + 
  theme_classic()

ggsave(filename = here("cr_tnd/graphs", "multinomial_deterministic_comparison_all.png"), 
       device = "png", 
       units = "in",
       height = 8,
       width = 12)
