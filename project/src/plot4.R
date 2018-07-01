olist <- ls()
mod <- source("shared.R")$value

# global env, closure
plotfun <- function(df) {
  # Prep.
  par(mfrow = c(2, 2), mar = c(4, 4, 4, 1), oma = c(0, 2, 0, 1))
  
  # 1st plot
  with(df, plot(DateTime, Global_Active_Power, type="l", xlab="", ylab = "Global Active Power(kilowatts)"))
  
  # 2nd plot
  with(df, plot(DateTime, Voltage, type="l", xlab="datetime", ylab = "Voltage"))
  
  # 3rd plot
  with(df, plot(DateTime, Sub_metering_1, type="l", ylab = "Energy sub metering", xlab =""))
  with(df, lines(DateTime, Sub_metering_2, type="l", col="red"))
  with(df, lines(DateTime, Sub_metering_3, type="l", col="blue"))
  legend("topright", lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
         box.lty=0)
  
  # 4th plot
  with(df, plot(DateTime, Global_Reactive_Power, type="l", ylab = "Global Reactive Power", xlab ="datetime"))
}

main <- function() {
  # call - careful with order
  df <- mod$readFile()
  df <- mod$aggDateTime(df)
  mod$withpng(df, plotfun, "plot4.png")
  print("Done")
  
}

main()
rm(list=setdiff(ls(), olist))