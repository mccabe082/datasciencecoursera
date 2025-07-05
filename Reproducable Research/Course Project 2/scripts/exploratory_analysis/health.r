this_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
source(file.path(this_dir, "../data_wrangling/raw_data_import.r"))

# look a total deaths
tot_fatal_by_event <- storm_data[, .(TotalFatalities = sum(FATALITIES)), by = EVTYPE][TotalFatalities > 100]

library(ggplot2)
ggplot(tot_fatal_by_event, aes(x = reorder(EVTYPE, -TotalFatalities), y = TotalFatalities)) +
  geom_bar(stat = "identity", fill = "tomato") +
  labs(title = "Total Fatalities by Event Type (over 100)",
       x = "Event Type", y = "Total Fatalities") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# look at average deaths per event
ave_fatal_by_event <- storm_data[, .(AverageFatalities = mean(FATALITIES)), by = EVTYPE][AverageFatalities > 1]
ggplot(ave_fatal_by_event, aes(x = reorder(EVTYPE, -AverageFatalities), y = AverageFatalities)) +
  geom_bar(stat = "identity", fill = "tomato") +
  labs(title = "Avereage Fatalities per Event Type (over 1)",
       x = "Event Type", y = "Average Fatalities") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


