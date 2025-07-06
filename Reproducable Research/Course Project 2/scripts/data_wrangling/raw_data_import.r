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

summary(storm_data)

storm_data[, (c("EVTYPE")) := lapply(.SD, as.factor), .SDcols = c("EVTYPE")]


####################################################
# alphabetical characters used to signify magnitude
# should be entered as actual dollar amounts,
# include “K” for thousands, “M” for millions, and “B” for billions
actual_dollar_amount <- function(DMG, DMGEXP) {
  multipliers <- c("K" = 1e3, "M" = 1e6, "B" = 1e9)
  factor <- multipliers[as.character(DMGEXP)]
  factor[is.na(factor)] <- 1
  return (unname(DMG * factor))
}


storm_data[,PROPDMG:=actual_dollar_amount(PROPDMG,PROPDMGEXP)][,PROPDMGEXP=NULL]
storm_data[,CROPDMG:=actual_dollar_amount(CROPDMG,CROPDMGEXP)][,CROPDMGEXP=NULL]


####################
# drop missing data
storm_data[complete.cases(
  storm_data$EVTYPE,
  storm_data$FATALITIES,
  storm_data$INJURIES,
  storm_data$PROPDMG,
  storm_data$CROPDMG
), ]
