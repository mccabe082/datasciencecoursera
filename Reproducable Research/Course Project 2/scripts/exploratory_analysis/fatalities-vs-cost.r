this_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
source(file.path(this_dir, "../data_wrangling/raw_data_import.r"))

library(ggplot2)

# plot 1: plotting events
ggplot(storm_data[FATALITIES>0], aes(x = PROPDMG/1e9, y = FATALITIES)) +
  geom_point(alpha = 0.3, color="steelblue") +
  labs(title = "Fatalities vs. Property Damage per (Fatal) Event",
       x = "Fatalities",
       y = "Property Damage (Billion USD)") +
  scale_x_log10() +
  scale_y_log10() +
  geom_smooth(method = "lm", se = TRUE, color = "red")+
  theme_minimal()


# plot 2: plotting event types
ggplot(
  storm_data[,.(total_fatalities=sum(FATALITIES), total_propcost=sum(PROPDMG)),by=.(EVTYPE)][total_fatalities>0&total_propcost>0],
  aes(y = total_fatalities, x = total_propcost)) +
  geom_point(alpha = 0.3, color="steelblue") +
  labs(title = "Fatalities vs. Property Damage per Event Type",
       x = "Fatalities",
       y = "Property Damage (Billion USD)") +
  scale_x_log10() +
  scale_y_log10() +
  geom_smooth(method = "lm", se = TRUE, color = "red")+
  theme_minimal()
