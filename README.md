## Introduction
This repository holds all of the code necessary to recreate the analysis done in *Analysis of Cluster Randomized Test Negative Designs: Cluster-Level Methods*. 

## Details
This project was completed using R 3.3.1 (Bug in Your Hair). I have attempted to use `packrat` to keep a history of the package versions used in these analyses. This information is stored in the folder labeled **packrat**. 

The .Rnw files are compiled with `knitr` and make use of `pdflatex` to compile.

## Project Layout
This repository adopted/modified the formatting used by the `ProjectTemplate` package.

To load the project change `setwd()` to the location 
where this README file is located. Then run the following two
lines of R code:

	library('ProjectTemplate')
	load.project()

For more details about ProjectTemplate, see http://projecttemplate.net

Overview of the contents of this repository:
* **data** contains both the historical data and 3 different generated random allocation sets (5,000 allocations, 10,000 allocations, and 50,000 allocations). We used the 10,000 random treatment allocations for the sake of computation. 
* **lib** contains the helper functions written for this analysis. 
  + `ORfunction.R` implements GEE, Mixed Effects, and naive estimation of the ORs from the collated cluster data. It returns a list containing the OR point estimates and standard deviation estimates (on the log scale) for each method.
  + `paperFunction2.R` implements the variance estimation of the OR from collated cluster data as proposed in Section 4.2 of the paper. It returns a list containing the estimated OR, the estimated standard deviation (on the log scale), and an indicator for each allocation of whether or not this produced insignificant results.
  + `quadraticFunction.R` implements the proposed quadratic estimation method for the relative risk from Section 4.1. This is primarily used as a helper function. It returns an estimate of the Relative Risk.
  + `tTestFunction.R` makes use of the `quadraticFunction.R` to estimate the Relative Risk and carry out the proposed t-test. As mentioned in the paper, this currently operates under the assumption of equal variances. The function returns a list containing the estimated Relative Risk (lambda), the estimated standard deviation (the square root of the averaged empirical variances in the treated and untreated clusters), the p-value associated with the t-test, the estimated T statistics associated with the t-test, and the coverage of the estimated relative risk which again makes use of the `quadraticFunction.R` by solving for the endpoints of the confidence interval rather than directly estimating the variance, and finally the estimated values of T = alpha_I - alpha_C.
  + `txtSetFunction.R` a helper function that identifies which columns of the dataframe contain the treatment allocations. Returns a dataset of only treatment allocations, removing the cluster level data.
* **cache** contains saved R objects.
* **reports** contains any summary output of the analysis, including the output necessary for the supplemental material.
* **docs** contains pdf versions of the reports generated in **reports**.
* **sandbox** contains on-going work regarding the analysis.
* **packrat** contains the versions of the packages used in this analysis.

## Final Thoughts
There are still quite a few things on my to-do list with respect to making the code more computationally efficient and user friendly. However, the structure here should be sufficient and reliable with respect to generating the results in the paper.
