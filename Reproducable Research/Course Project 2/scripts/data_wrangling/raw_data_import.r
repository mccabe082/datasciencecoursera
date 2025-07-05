# Ensure R.utils is installed for fread bz2 support
if (!requireNamespace("R.utils", quietly = TRUE)) {
  install.packages("R.utils")
}

library(data.table)

download.file(
  url ="https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2",
  destfile = "StormData.csv.bz2",
  mode = "wb")

storm_data <- fread("StormData.csv.bz2")

