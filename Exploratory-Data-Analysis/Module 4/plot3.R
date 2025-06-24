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




# Question 3)
totals <- NEI[fips == "24510", .(Total_Emissions = sum(Emissions)), by = .(year, type)]
library(ggplot2)
png(filename = "plot3.png", width = 800, height = 600)
ggplot(totals, aes(x = factor(year), y = Total_Emissions, fill = type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "PM2.5 Emissions in Baltimore (1999–2008)",
       x = "Year",
       y = "Total PM2.5 Emissions (tons)",
       fill = "Source Type") +
  theme_minimal()
dev.off()
