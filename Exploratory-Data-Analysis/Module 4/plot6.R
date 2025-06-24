setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Download the data
if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file(
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
    "exdata_data_NEI_data.zip", mode = "wb")
}

# Decompress the data
if (!dir.exists("exdata_data_NEI_data.zip")) {
  unzip("exdata_data_NEI_data.zip", exdir = "exdata_data_NEI_data")
}

## This first line will likely take a few seconds. Be patient!
library(data.table)
NEI <- as.data.table(readRDS("exdata_data_NEI_data/summarySCC_PM25.rds"))
SCC <- as.data.table(readRDS("exdata_data_NEI_data/Source_Classification_Code.rds"))
# head(NEI)
# head(SCC)




# Question 6)

# scrape vehicle source classification codes
vehicle_scc <- SCC[Data.Category=="Onroad"]$SCC

# calculate totals
totals <- NEI[
    # subset vehicle data
    SCC %in% vehicle_scc
  ][
    # subset Baltimore & LA data
    fips %in% c("24510","06037")
  ][, .(Total_Emissions = sum(Emissions)), by = .(year,fips)]

# name cities
totals[fips == "24510", city := "Baltimore"]
totals[fips == "06037", city := "Los Angeles"]

library(ggplot2)
png(filename = "plot6.png", width = 800, height = 600)
ggplot(totals, aes(x = year, y = Total_Emissions, fill = city)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Motor Vehicle PM2.5 Emissions: Baltimore vs Los Angeles",
       x = "Year",
       y = "Total Emissions (tons)") +
  theme_minimal()
dev.off()

