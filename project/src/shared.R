myModule <- function() {
  .DATA_DIR = "../data"   # relative to src
  .IMG_DIR = "../images"
  .NCOL = 9 # bound to downloaded file
  
  .checkDir <- function(dir=.DATA_DIR) {
    if (!file.exists(dir)) { dir.create(dir) }
    TRUE
  }
  
  .dirFile <- function(file, dir=.DATA_DIR) {
    paste(dir, file, sep="/")
  }
  
  .isURL <- function(url) {
    # basic check, by no means a full URL check
    grepl("^http[s]?://", c(url), perl=TRUE)
  }
  
  downloadFile <- function(from="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                           suffix='txt') {
    # check if from is a URL
    if (!.isURL(url)) {
      stop("invalid URL", call. = FALSE)
    } 
    
    # get file from given URL
    compFile <- tail(strsplit(from, "/")[[1]], 1)
    filePrefName <- strsplit(compFile, "\\.")[[1]][1]
    dstFile <- paste(filePrefName, suffix, sep=".")
    
    # check if file already present in subdir data
    if (.checkDir() && file.exists(.dirFile(dstFile))) { return() }
    
    # at this stage dir existing but file not present, is compressed file present?
    if (file.exists(.dirFile(compFile))) {
      # uncompress
      unzip(.dirFile(compFile), exdir=.DATA_DIR)
      return()
    }
    
    # at this stage, need to download and un-compress
    compFileDst <- .dirFile(compFile) 
    download.file(url=from, method="curl", destfile=compFileDst)
    
    # assuming download is fine....
    unzip(compFileDst, exdir=.DATA_DIR)
  }
  
  readFile <- function(filename=.dirFile("household_power_consumption.txt"), skip=66637, nrows=2880, 
                       colC = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), 
                       colN = c("Date", "Time", "Global_Active_Power", "Global_Reactive_Power", "Voltage", "Global_Intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3") ) {
    
    # no attempt to check the validity of skip or nrows
    # Assuming colNames and ColClasses have same length and do match
    if (length(colC) < .NCOL) {
      v <- rep("NULL", .NCOL - length(colC))    
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
  
  withpng <- function(df, plotfun, filename="plot1.png") {
    .checkDir(dir=.IMG_DIR)
    png(filename=.dirFile(filename, dir=.IMG_DIR), width=480, height=480, bg="white")
    plotfun(df)
    dev.off()
  }
  
  # list all functions, same order...
  .funVect <- c(downloadFile, readFile, aggDateTime, withpng)
  names(.funVect) <- c("downloadFile", "readFile", "aggDateTime", "withpng") # ls()
  return(.funVect)
}

myModule() # invoke it
