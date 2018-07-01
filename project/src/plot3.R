olist <- ls()
mod <- source("shared.R")$value

# global env, closure
plotfun <- function(df) {
  with(df, plot(DateTime, Sub_metering_1, type="l", ylab = "Energy sub metering", xlab =""))
  with(df, lines(DateTime, Sub_metering_2, type="l", col="red"))
  with(df, lines(DateTime, Sub_metering_3, type="l", col="blue"))
  legend("topright", lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
}

main <- function() {
  # call - careful with order
  df <- mod$readFile(colN = c("Date", "Time", "NULL", "NULL", "NULL", "NULL", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
                   colC = c("character", "character", "NULL", "NULL", "NULL", "NULL", "numeric", "numeric", "numeric"))
  df <- mod$aggDateTime(df)
  mod$withpng(df, plotfun, "plot3.png")
  print("Done")
  
}

main()
rm(list=setdiff(ls(), olist))
