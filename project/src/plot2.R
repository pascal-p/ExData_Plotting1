
olist <- ls()
mod <- source("shared.R")$value

# global env, closure
plotfun <- function(df) {
  with(df, 
       plot(DateTime, Global_Active_Power, type="l", xlab="", ylab = "Global Active Power(kilowatts)"))
}

main <- function() {
  df <- mod$readFile(colN =c("Date", "Time", "Global_Active_Power"), 
                  colC = c("character", "character", "numeric"))
  df <- mod$aggDateTime(df)
  mod$withpng(df, plotfun, "plot2.png")
  print("Done")
}

main()
rm(list=setdiff(ls(), olist))
