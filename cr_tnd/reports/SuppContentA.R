setwd("cr_tnd")
load.project()

# Generating the Data for the Supplementary Tables
dataRAND <- Random10000Allocations
period1 <- c("03_05", "05_06", "06_07", "07_08", "08_10", "10_11", "11_12", "12_13", "13_14")

dataRAND <- subset(dataRAND, select = -c(X))

# Dengue Counts
caseData <- subset(dataRAND, select = c(clust, Period, Cases))
caseData <- caseData[order(caseData$Period),]
xx <- reshape(caseData, timevar = "Period", idvar = "clust", direction = "wide")
names(xx) <- c("Cluster", paste(period1))
xtable(xx) # Table output

# OFI Counts
ofiData <- subset(dataRAND, select = c(clust, Period, OFI))
yy <- ofiData[ofiData$Period == period1,]
yy <- subset(yy, select = -c(Period))
yy <- yy[order(yy$clust),]
names(yy) <- c("Cluster", "OFI")
xtable(yy)

ofiData2 <- dataRAND %>% filter(Period == "03_05") %>% select(Cluster = clust, OFI)
