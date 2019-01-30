#######
# Mirroring the 247 treatment allocations from the constrained set
# Nov 19, 2018
# Suzanne Dufault
#######

library(tidyverse)
Final247Allocations <- read_csv("~/Box Sync/Research/TND_CRT_Paper1_2017/CR_TND/cr_tnd/data/Final247Allocations.csv")

txs <- Final247Allocations %>% select(tx.1:tx.247)
head(txs)

txs2 <- 1 - txs
head(txs2)
names(txs2) <- paste0("tx.",248:494) 

Final247Allocations <- bind_cols(Final247Allocations, txs2)
names(Final247Allocations)
save(Final247Allocations, file = here("cr_tnd", "data/Final494Allocations.RData"))
