# Get event types with > 100 total fatalities
high_fatal_evtypes <- storm_data[, .(TotalFatalities = sum(FATALITIES)), by = EVTYPE][TotalFatalities > 100]$EVTYPE
filtered_data <- storm_data[EVTYPE %in% high_fatal_evtypes]
filtered_data[, EventID := .I]  # Unique ID per event row


# Lets plot bar chart showing total fatalities for each event type - stacking each event by event type
library(ggplot2)

ggplot(filtered_data, aes(x = reorder(EVTYPE, -FATALITIES, sum), y = FATALITIES, fill = factor(EventID))) +
  geom_bar(stat = "identity") +
  labs(title = "Individual Fatal Events Stacked by Event Type",
       x = "Event Type", y = "Fatalities",
       fill = "Event ID") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

# this is too much i think
