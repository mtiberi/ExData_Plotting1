
load.data<- function() {
  section<- "section.csv"
  
  if (!file.exists(section)) {
    if (!file.exists("household_power_consumption.txt")) {
      zipfile<- "household_power_consumption.zip"
      if (!file.exists(zipfile)) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", zipfile)
      }
      unzip(zipfile)
    }
    #the file is too big for my computer, i will only load
    #the data of February 1 and 2, 2007
    system(paste0("head -1 household_power_consumption.txt >", section))
    system(paste0("cat household_power_consumption.txt | grep -E '^1/2/2007|^2/2/2007' >>", section))
  }
  
  d<- read.csv(section, sep=";")
  d$Time=strptime(paste(d$Date, d$Time, sep=" "), format="%d/%m/%Y %H:%M:%S") 
  d$Time=as.POSIXct(d$Time)
  d$Date=substr(weekdays(as.Date(d$Date, "%d/%m/%Y")),1,3)
  d
}

data<- load.data()

png("./plot2.png", width=480, height=480)

plot(
  data$Time,
  data$Global_active_power,
  type="l",
  xlab="",
  ylab="Global Active Power (kilowatts)"
  )

dev.off()
