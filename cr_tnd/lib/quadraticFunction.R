# Quadratic Function

quad <- function(x, ratio){rootSolve::uniroot.all(function(lambda){
  # This function takes in a difference of cluster means (T) and solves a quadratic equation to 
  # estimate the relative risk (lambda). This also requires the ratio of controls to cases to be 
  # specified
  x - (2*ratio*(lambda^2 - 1)/(((2 + ratio)*lambda + ratio)*(ratio*lambda + (2 + ratio))))}, c(-5,5))
}
