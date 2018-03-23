# data munging



setwd("C:/gSource/Reproducable Research/Course Project 2")

library(data.table)
library(chron) # avoids timezone issues unlike POSIXct

dt<-fread("StormData.csv")

# attempt multiple time string conversions
getDateTime<-function(DATE,TIME){

  # time string conversion (format 1) 
  getDateTime1<-function(DATE,TIME){
    return(
      as.chron(
        x = paste(
          DATE,
          TIME,
          sep = "|"
        ),
        format = "%m/%d/%Y 0:00:00|%H%M"
      )
    )
  }
  
  # time string conversion (format 2) 
  getDateTime2<-function(DATE,TIME){
    return(
      as.chron(
        x = paste(
          DATE,
          TIME,
          sep="|"
        ),
        format = "%m/%d/%Y 0:00:00|%I:%M:%S %p"
      )
    )
  }
  
  # time string conversion (format 3 - illegal) 
  getDateTime3<-function(DATE,TIME){
    return(
      as.chron(
        x = paste(
          DATE,
          TIME,
          sep="|"
        ),
        # NOT STRICTLY LEGAL - CAN'T HAVE %H AND %p
        format = (
          "%m/%d/%Y 0:00:00|%H:%M:%S %p"
        )
      )
    )
  }
  
  datetime<-as.POSIXct(rep(NA,length(DATE)))
  
  NAs<-which(is.na(datetime))
  datetime[NAs]<-getDateTime1(DATE,TIME)[NAs]
  
  NAs<-which(is.na(datetime))
  datetime[NAs]<-getDateTime2(DATE,TIME)[NAs]
  
  NAs<-which(is.na(datetime))
  datetime[NAs]<-getDateTime3(DATE,TIME)[NAs]
  
  return(datetime)
}

# replace begin time and date strings with single datetime chron object
{
  dt[,BGN_TIME:=getDateTime(BGN_DATE,BGN_TIME)]
  dt[,END_TIME:=getDateTime(END_DATE,END_TIME)]
}

# remove redundant columns
{
  dt[,BGN_DATE:=NULL]
  dt[,END_DATE:=NULL]
  dt[,REMARKS:=NULL]
}

