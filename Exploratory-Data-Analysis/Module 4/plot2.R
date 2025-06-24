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
totals <- NEI[fips == "24510", .(Total_Emissions = sum(Emissions)), by = year]

png(filename = "plot2.png", width = 800, height = 600)
plot(totals$year, totals$Total_Emissions,
     pch = 19, col = "steelblue",
     xlab = "Year",
     ylab = "Total PM2.5 Emissions (millions of tons)",
     main = "Total PM2.5 Emissions in Baltimore City, Maryland (1999–2008)",
     type = "p")

fit <- lm((totals$Total_Emissions) ~ totals$year)

# Add trend line
abline(fit, col = "steelblue", lwd = 2, lty = 1)
dev.off()
