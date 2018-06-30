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

withpng <- function(df, plotfun, filename="plot1.png") {
  png(filename=filename, width=480, height=480, bg="white")
  plotfun(df)
  dev.off()
}

plotfun <- function(df) {
  hist(df$Global_Active_Power, col="red", main="Global Active Power", xlab = "Global Active Power (kilowatts)")
}

# call - just 1 field required
df <- readFile(colN =c("NULL", "NULL", "Global_Active_Power"), 
               colC = c("NULL", "NULL", "numeric"))
withpng(df, plotfun)
print("Done")
