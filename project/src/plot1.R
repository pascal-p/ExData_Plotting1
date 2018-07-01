olist <- ls()
mod <- source("shared.R")$value

# global env, closure
myPlotFun <- function(df) {
  hist(df$Global_Active_Power, col="red", main="Global Active Power", xlab = "Global Active Power (kilowatts)")
}

main <- function() {
  # call - just 1 field required
  df <- mod$readFile(colN =c("NULL", "NULL", "Global_Active_Power"), 
                   colC = c("NULL", "NULL", "numeric"))
  mod$withpng(df, myPlotFun, "plot1.png") # plotfun from global env 
  print("Done")
}

main()
rm(list=setdiff(ls(), olist))
