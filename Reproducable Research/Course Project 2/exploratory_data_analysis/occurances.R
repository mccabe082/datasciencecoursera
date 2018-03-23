library(tidyr)
library(ggplot2)
library(data.table)
library(scales)


# perform data munging
source("../data_munging.R")


# get a feel for any temporal sampling bias in the data
#  There number of reported incidents increases over time
#  Suspect this is due to;
#  - increased observations over time?
#  - changes to classifcation schemes?
{
  Event_Instances_by_Year<-dt[
    ,
    .(Instances=.N),
    .(Year=year(BGN_TIME))
  ]
  with(
    Event_Instances_by_Year,
    plot(
      main = "No. of Extreme Weather Events Per Year",
      x = Year,
      xlab = "Year",
      y = Instances,
      ylab = "No. Recorded Events"
    )
  )
}


#  It appears most of the data was collected after the mid to late 90's
#  Some events have older samples - these will easily skew the analysis 
{
  Event_Occurances_by_Year<-dt[
    ,
    .(Occurances=.N),
    .(
      Event_Type=EVTYPE,
      Year=year(BGN_TIME)
    )
    ]

  p1<-ggplot(data=Event_Occurances_by_Year, aes(x=Year,y=Event_Type))+
    geom_tile(aes(fill=Occurances))
  
  plot(p1)
}

# Determine a cut off year to stop
= 1994 looks like the earliest year
{
  # Function to color branches
  colbranches <- function(node, col){
    
    # Find the attributes of current node
    a <- attributes(node)
    
    # Color edges with requested color
    attr(node, "edgePar") <- c(a$edgePar, list(col=col, lwd=2))
    
    # Return the node!
    node
  }
  
  Occurances_by_Year<-dt[
    ,
    .(Occurances=.N),
    .(
      Year=as.integer(year(BGN_TIME))
    )
  ][
    !is.na(Year)
  ]
  hClustering<-hclust(dist(Occurances_by_Year$Occurances))
  hClustering$labels = Occurances_by_Year$Year
  dendro <- as.dendrogram(hClustering)
  dendro[[2]] = dendrapply(dendro[[2]], colbranches, "blue")
  
  plot(dendro)
}

