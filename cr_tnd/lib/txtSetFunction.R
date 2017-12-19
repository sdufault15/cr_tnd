# Helper Function

txtSet <- function(x){
  # This function takes in a data frame x and extracts all the columns corresponding to treatment. It is IMPERATIVE that ONLY the columns corresponding to treatment contain the pattern 'tx'
  nms <- names(x)
  loc <- unlist(gregexpr(pattern = 'tx',nms)) # finds the locations of the treatment variables
  txt <- x[,loc == 1] # Subsets treatment allocations 
  
  return(txt)
}
