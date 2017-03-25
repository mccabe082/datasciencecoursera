# data for plot acquired from UC Irvine Machine Learning Repository  "Thu Mar 02 21:39:13 2017"
# "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"


# get the raw data from workspace
data<-read.csv2("..\\household_power_consumption.txt",na.strings = "?")

# get data from the two dates 2007-02-01 and 2007-02-02
data<-data[which(data$Date=="1/2/2007"|data$Date=="2/2/2007"),]


# cast the numerical data here since R seems incapable of reading numerics directly
{
        ## household global minute-averaged active power (in kilowatt)
        data$Global_active_power<-as.numeric(paste(data$Global_active_power))
        
        ## household global minute-averaged reactive power (in kilowatt)
        data$Global_reactive_power<-as.numeric(paste(data$Global_reactive_power))
        
        ## minute-averaged voltage (in volt)
        data$Voltage<-as.numeric(paste(data$Voltage))
        
        ## household global minute-averaged current intensity (in ampere)
        data$Global_intensity<-as.numeric(paste(data$Global_intensity))
        
        ## energy sub-metering No. 1 (in watt-hour of active energy)
        data$Sub_metering_1<-as.numeric(paste(data$Sub_metering_1))
        
        ## Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy)
        data$Sub_metering_2<-as.numeric(paste(data$Sub_metering_2))
        
        ## energy sub-metering No. 3 (in watt-hour of active energy)
        data$Sub_metering_3<-as.numeric(paste(data$Sub_metering_3))
}


png("..\\figure\\plot1.png")
hist(
        data$Global_active_power,
        main = "Global Active Power",
        col = "red",
        xlab = "Global Active Power (kilowatts)",
        breaks = 15
)
dev.off()

