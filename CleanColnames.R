cleanColnames <- function(dataframe){
  colnames = colnames(dataframe)
  colnames = tolower(colnames) # everybody to lowercase
  
  # substitutions occur in the order in which they appear here
  stringSubstitutions = list(c("\\.", "_"), # periods to underscores
                             c("_+", "_"), # collapse consecutive underscores
                             c("^_|_$", "") # remove leading and trailing underscores
  )
  
  for (stringSubstitution in stringSubstitutions){
    from = stringSubstitution[1]
    to = stringSubstitution[2]
    colnames = gsub(from, to, colnames)
  }
  colnames(dataframe) = colnames
  return(dataframe)
}
