this_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
source(file.path(this_dir, "../data_wrangling/raw_data_import.r"))

library(ggplot2)

ggplot(storm_data[FATALITIES>0], aes(x = FATALITIES, y = INJURIES)) +
  geom_point(alpha = 0.3, color="steelblue") +
  xlim(0,50)+
  ylim(0,500)+
  labs(title = "Fatalities vs. Injuries per (Fatal) Event",
       x = "Fatalities",
       y = "Injuries") +
  geom_smooth(method = "lm", se = TRUE, color = "red")+
  theme_minimal()


ggplot(
  storm_data[,.(total_fatalities=sum(FATALITIES), total_injuries=sum(INJURIES)),by=.(EVTYPE)],
  aes(x = total_fatalities, y = total_injuries)) +
  geom_point(alpha = 0.3, color="steelblue") +
  xlim(0,40)+
  ylim(0,200)+
  labs(title = "Fatalities vs. Injuries per Event Type",
       x = "Fatalities",
       y = "Injuries") +
  geom_smooth(method = "lm", se = TRUE, color = "red")+
  theme_minimal()
