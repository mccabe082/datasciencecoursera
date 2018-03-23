library(tidyr)
library(ggplot2)
library(data.table)
library(scales)


# perform data munging
source("../data_munging.R")

# get the most "significant" instances of individual events.
# significance based of subjective metrics either;
# deaths>100,
# injuries>10000
{
  worse_incidents<-dt[
    ,
    .(
      TOT_FATALITIES=sum(FATALITIES),   # get total, max & mean casualties for each event type
      AVE_FATALITIES=mean(FATALITIES),  #
      
      TOT_INJURIES=sum(INJURIES),       # get total, max & mean injuries for each event type
      AVE_INJURIES=mean(INJURIES),      #
      
      TOT_PROPDMG=sum(PROPDMG),
      TOT_CROPDMG=sum(CROPDMG)
      
    ),
    EVTYPE
  ][
    TOT_FATALITIES>500   |         # Taking top fives
    TOT_INJURIES>10000   |
    TOT_CROPDMG>100000   |
    TOT_PROPDMG>100000   ,         #
  ]
}

{
  worse_incidents<-gather(
    data=worse_incidents,
    value="occurances",
    key="statistics",
    TOT_FATALITIES,
    TOT_INJURIES,
    TOT_PROPDMG,
    TOT_CROPDMG
  )
}

{
  p1<-ggplot(data=worse_incidents)+
  geom_bar(
    data=worse_incidents,
    stat="identity",
    position = "dodge",
    aes(
      x=EVTYPE,
      y=occurances,
      #colour=statistics,
      fill=statistics
    )
  )+
  theme(
    axis.text.x=element_text(
      angle=80, # angled text for style
      hjust=1,  # text alignment (right alligned)
      vjust=1.0 # text vertical displacement (shifted up)
    )
  )+
  scale_y_continuous(
    trans = log10_trans(),
    breaks = trans_breaks("log10", function(x) 10^x),
    labels = trans_format("log10", math_format(10^.x))
  ) 

  plot(p1)
}
