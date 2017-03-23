# Wolfram Schlenker's Weather Data:
# http://www.columbia.edu/~ws2162/dailyData.html

# Mike Roberts Stata file:
# http://dl.dropbox.com/u/25237727/Data/ddayOverAgAreaByMonth.dta.zip

# ---- Start --------------------------------------------------------------

print(paste0("Started 0-weather at ", Sys.time()))

library(tidyverse)

# Create a directory for the data
local_dir    <- "0-data/weather"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir)
if (!file.exists(data_source)) dir.create(data_source)

tempDir  <- tempdir()

urls <- "http://dl.dropbox.com/u/25237727/Data/ddayOverAgAreaByMonth.dta.zip"
download.file(urls, paste(data_source, basename(urls), sep = "/"))
unzip(paste(data_source, basename(urls), sep = "/"), exdir = local_dir,
      overwrite = T)

rm(list = ls())

print(paste0("Finished 0-weather at ", Sys.time()))