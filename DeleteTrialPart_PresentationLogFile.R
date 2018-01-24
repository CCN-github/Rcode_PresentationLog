# Author: Mariam Kostandyan
# UGent
###############################################################################
###############################################################################


rm(list=ls()) # clear the working directory

#---------------setting up the path---------------
myPath <- "C:/Users/mariam/..." ## CHANGE TO YOUR DIRECTORY
setwd(myPath)

#--------------import all libraries---------------
# some of them you might not need (they are mainly for the main analysis, so try to run the code without them first)
library(dplyr)
library(plyr)
library(useful) # for shifting the columns 
library(stringr)
library(data.table)

###############################################################################
###############################################################################
# PREPROCESSING

#--------------create a list of files-------------
fs <- list.files(myPath, pattern = glob2rx("*.log"))


#--------------separating all log files--------------

for (f in fs) {
  fname <- file.path(myPath, f)               ## current file name
  df <- read.table(fname, sep=",")     # read in file
  setDT(df)[, paste0("V1", 1:13) := tstrsplit(V1, "\t")] #separate colums
  
  # edit the response part of the log file
  df <- df[!df$V11 %in% c("02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "21", "22", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "20", "23", "38", "39"),] # delete redundant rows !!!!! PAST here all numbers of the participants
  df$V1 <- NULL  # delete the first column 
  df <- df[-c(1, 2, 3), ] # delete first 3 rows
  df <- sapply(df, as.character) ## assigning a header 
  colnames(df) <- df[1, ] ## making the first row a header
  df <- as.data.frame(df[-1,]) ## bringing back the values into a data frame
  df <- df[1:301, ] # make sure all files have the same number of rows
  df[df==""] <- NA ## assign NAs to missing values
  
  write.table(df, fname, sep = "\t", row.names = FALSE)     ## save the data: !!!!!!!!! this will overwrite the existing txt files
  
}
