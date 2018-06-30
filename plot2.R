NCOL <- 9

readFile <- function(filename="./household_power_consumption.txt", skip=66637, nrows=2880, 
                     colC = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), 
                     colN = c("Date", "Time", "Global_Active_Power", "Global_Reactive_Power", "Voltage", "Global_Intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3") ) {
  
  # no attempt to check the validity of skip or nrows
  # assuming colNames and ColClasses have same length and do match
  if (length(colC) < NCOL) {
    v <- rep("NULL", NCOL - length(colC))    
    colC <- c(colC, v)
    colN <- c(colN, v)
  }
  
  read.table(filename, sep=';', header=FALSE, skip=skip, dec = ".", nrows=nrows, na.strings=c("NA", "?"), 
             colClasses = colC, col.names = colN)
}

aggDateTime <- function(df) {
  # Assuming colNames Date and Time in correct format and at pos 1, 2 
  colN = colnames(df)[-(1:2)]
  vDate <- as.character(as.Date(df$Date, format="%d/%m/%Y")) 
  df$DateTime <- strptime(paste(vDate, df$Time, sep=" "), format = "%F %H:%M:%S", tz = "UTC")
  subset(df, select=-(Date:Time))[, c("DateTime", colN)]
}

withpng <- function(df, plotfun, filename="plot2.png") {
  png(filename=filename, width=480, height=480, bg="white")
  plotfun(df)
  dev.off()
}

plotfun <- function(df) {
  with(df, plot(DateTime, Global_Active_Power, type="l", xlab="", ylab = "Global Active Power(kilowatts)"))
}

# call
df <- readFile(colN =c("Date", "Time", "Global_Active_Power"), 
               colC = c("character", "character", "numeric"))
df <- aggDateTime(df)
withpng(df, plotfun)
print("Done")
