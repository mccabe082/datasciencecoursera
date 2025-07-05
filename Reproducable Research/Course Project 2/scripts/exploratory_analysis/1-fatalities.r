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

med_fatal_by_event <- storm_data[FATALITIES > 0][, .(MedianFatalities = median(FATALITIES)), by = EVTYPE][MedianFatalities > 1]
ggplot(med_fatal_by_event, aes(x = reorder(EVTYPE, -MedianFatalities), y = MedianFatalities)) +
  geom_bar(stat = "identity", fill = "tomato") +
  labs(title = "Median Fatalities per Event Type (ignoring non-fatal event instances)",
       x = "Event Type", y = "Average Fatalities") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


################################################################################
# closer look a total deaths in event types which have killed more than 100 people over the period
fatal_by_event <- storm_data[, .(TotalFatalities = sum(FATALITIES)), by = EVTYPE][TotalFatalities > 100]
fatal_events <- storm_data[EVTYPE %in% fatal_by_event$EVTYPE]

ggplot(fatal_events, aes(x = reorder(EVTYPE, -FATALITIES, FUN = median), y = FATALITIES)) +
  geom_boxplot(fill = "skyblue") +
  #scale_y_log10() +
  labs(title = "Event Type",
       x = "Event Type", y = "Fatalities per Incident (log scale)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# the is a heat event which has the maximum number of fatalities:
# https://en.wikipedia.org/wiki/1995_Chicago_heat_wave
# this is an extreme outlier with deaths being undereported and due to poverty in the local urban area:
storm_data[FATALITIES==max(storm_data$FATALITIES),]$REMARKS
storm_data[FATALITIES==max(storm_data$FATALITIES),]$REFNUM
storm_data[REFNUM==198690,]$REMARKS

# remove the chicago heat wave
ggplot(fatal_events[REFNUM!=198690], aes(x = reorder(EVTYPE, -FATALITIES, FUN = median), y = FATALITIES)) +
  geom_boxplot(fill = "skyblue") +
  #scale_y_log10() +
  labs(title = "Event Type",
       x = "Event Type", y = "Fatalities per Incident (log scale)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
