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




# Question 2)
totals <- NEI[, .(Total_Emissions = sum(Emissions)), by = year]

png(filename = "plot1.png", width = 800, height = 600)
barplot(
  totals$Total_Emissions / 10^6,           # convert to millions
  names.arg = totals$year,                # labels
  col = "steelblue",
  xlab = "Year",
  ylab = "Total PM2.5 Emissions (millions of tons)",
  main = "Decrease in Total PM2.5 Emissions in the US (1999–2008)"
)
dev.off()


