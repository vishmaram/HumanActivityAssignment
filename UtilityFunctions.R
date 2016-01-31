
# This method splits the string by / in the file path and return last element of the split as fileName
getObjectNames <- function(x)
{
  splitPath <- strsplit(x,"/")
  fileName <- splitPath[[1]][length(splitPath[[1]])]
  fileName <- sub(".txt","",fileName)
  return(fileName)
}

#This method takes the string vectors, split by " " object and convert to data frame
convertToDataFrame <- function(x)
{
  x_len <- length(x)
  x_mod <- strsplit(x," ",fixed=TRUE)
  x_mod <- unlist(x_mod)
  x_mod <- matrix(x_mod,nrow = x_len,byrow = T)
  x_mod <- data.frame(x_mod,stringsAsFactors = FALSE, check.names = FALSE)
  return(x_mod)
}

#this take string vectors and removes all unnecessary empty spaces expect one space between measurements
trimSpaces <- function(x)
{
  x_mod <- as.character(x)
  x_mod <- gsub("  "," ",x_mod)
  x_mod <- sub(" ","",x_mod)
  return(x_mod)
}