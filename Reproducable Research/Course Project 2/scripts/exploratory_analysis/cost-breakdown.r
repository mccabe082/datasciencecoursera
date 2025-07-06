this_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
source(file.path(this_dir, "../data_wrangling/raw_data_import.r"))

# aggregate crop and property costs per event type
augm_storm_data<-storm_data[,
           .(total_prop_cost=sum(PROPDMG),
             total_crop_cost=sum(CROPDMG))
           ,by=.(EVTYPE)]
augm_storm_data[,total_cost:=total_prop_cost+total_crop_cost]

augm_storm_data<-augm_storm_data[total_prop_cost+total_crop_cost>1e9]

long_costs <- melt(augm_storm_data,
                   id.vars = c("EVTYPE","total_cost"),
                   measure.vars = c("total_prop_cost", "total_crop_cost"),
                   variable.name = "CostType",
                   value.name = "Cost")


library(ggplot2)
ggplot(long_costs, aes(x = reorder(EVTYPE,-total_cost), y = Cost/1e9, fill = CostType)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Weather Damage Events Types Exceeding $1B Costs ", x = "Event Type", y = "Cost (Billion USD)", fill = "Cost Type") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = c(0.8, 0.8))


# Worst incident:
# https://napavalleyregister.com/news/local/severe-flooding-hits-napa-valley/article_ebee8598-a512-572a-baea-ca254758614f.html
storm_data[PROPDMG==max(storm_data$PROPDMG),]$REFNUM
storm_data[REFNUM==605943,]$REMARKS
# this is a data entry error:
# https://www.theatlantic.com/business/archive/2011/05/the-10-costliest-floods-in-american-history/239309/?utm_source=chatgpt.com