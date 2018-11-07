********************************
* Suzanne Dufault
* GEE Odd Results
* November 6, 2018
********************************

**** HEADER ****
capture log close
cd "/Users/suzannedufault/Box Sync/Research/TND_CRT_PAPER1_2017/CR_TND/cr_tnd"
global sandbox "/Users/suzannedufault/Box Sync/Research/TND_CRT_PAPER1_2017/CR_TND/cr_tnd/sandbox/"
global graphs "/Users/suzannedufault/Box Sync/Research/TND_CRT_PAPER1_2017/CR_TND/cr_tnd/graphs/"
global data "/Users/suzannedufault/Box Sync/Research/TND_CRT_PAPER1_2017/CR_TND/cr_tnd/data"

set more off
log using "$sandbox/stata-comparison-10-clust-perm.log", replace


**** DATA ****

import delimited "$data/errors-permutation-dist-10-clust.csv", clear

label variable cases "Observed distribution of cases"
label variable ofi "Observed distribution of OFIs"
label variable tx "Cluster assignment"
label variable casestatus "Sampled cases and OFIs"

label define txstat 1 "Treatment" 0 "Control"
label define casestat 1 "Case" 0 "OFI"
label values tx txstat
label values casestatus casestat

**** Analysis ****

/*
Results from R's geepack


Call:
geeglm(formula = case.status ~ tx, family = binomial(link = "logit"), 
    data = errslong, id = clust, corstr = "exchangeable", scale.fix = TRUE)

 Coefficients:
              Estimate    Std.err  Wald Pr(>|W|)
(Intercept) -1.048e-01  8.443e-02 1.540    0.215
tx          -1.024e+15  1.083e+15 0.894    0.344

Scale is fixed.

Correlation: Structure = exchangeable  Link = identity 

Estimated Correlation Parameters:
       Estimate   Std.err
alpha 6.688e+14 7.242e+29
Number of clusters:   10   Maximum cluster size: 26 

*/

xtset clust

* Using an exchangeable correlation structure, GEE does not converge.
capture noisily xtgee casestatus tx , family(binomial) link(logit) vce(robust) corr(exc) 
capture noisily xtgee casestatus tx , family(binomial) link(logit) vce(conventional) corr(exc)  

* Using an independent corr structure, GEE does converge
xtgee casestatus tx , family(binomial) link(logit) vce(robust) corr(ind)



**** Shuffling Rows ****
* Row order does not matter for Stata's GEE function
gen shuffle = runiform()
sort shuffle

capture noisily xtgee casestatus tx, family(binomial) link(logit) vce(robust) corr(exc)

/*
Compared to sorted output:

. capture noisily xtgee casestatus tx , family(binomial) link(logit) vce(robust) corr(exc)

GEE population-averaged model                   Number of obs     =        199
Group variable:                      clust      Number of groups  =         10
Link:                                logit      Obs per group:
Family:                           binomial                    min =         16
Correlation:                  exchangeable                    avg =       19.9
                                                              max =         26
                                                Wald chi2(1)      =       1.08
Scale parameter:                         1      Prob > chi2       =     0.2990

                                  (Std. Err. adjusted for clustering on clust)
------------------------------------------------------------------------------
             |               Robust
  casestatus |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
          tx |   .1186221   .1142128     1.04   0.299    -.1052309    .3424752
       _cons |  -.1027439   .0589894    -1.74   0.082     -.218361    .0128732
------------------------------------------------------------------------------
convergence not achieved
*/

**** FOOTER ****
log close
