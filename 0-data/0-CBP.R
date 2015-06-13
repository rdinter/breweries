#Robert Dinterman, NCSU Economics PhD Student

# County Business Patterns
# https://www.census.gov/econ/cbp/download/
# BEWARE: From 1986 to 1997, classification uses SIC. 1998+ is NAICS

print(paste0("Started 0-CBP at ", Sys.time()))

options(scipen=999) #Turn off scientific notation for write.csv()
require(dplyr, quietly = T)
require(readr, quietly = T)

# Create a directory for the data
localDir <- "0-data/CBP"
data_source <- paste0(localDir, "/Raw")
if (!file.exists(localDir)) dir.create(localDir)
if (!file.exists(data_source)) dir.create(data_source)
# data_source <- paste0(localDir, "/cbpR_data_source")
# data_final <- paste0(localDir, "/cbpR_data_final")
# if (!file.exists(data_final)) dir.create(data_final)

# http://www.census.gov/econ/isp/sampler.php?naicscode=312120&naicslevel=6
# Breweries NAICS Code is 312120

# NAICS 312120 Breweries; SIC 2082 Malt Beverages (except malt extract)
# NAICS 445310 Beer, Wine, and Liquor Stores; SIC 5181 Beer and Ale
#  (beer and ale sold via retail method)


tempDir  <- tempdir()
# unlink(tempDir, recursive = T)
url  <- paste0("https://www.census.gov/econ/cbp/",
               "download/full_layout/County_Layout.txt")
file <- paste(localDir, basename(url), sep = "/")
if (!file.exists(file)) download.file(url, file, method = "libcurl")

url  <- paste0("https://www.census.gov/econ/cbp/",
               "download/full_layout/County_Layout_SIC.txt")
file <- paste(localDir, basename(url), sep = "/")
if (!file.exists(file)) download.file(url, file, method = "libcurl")


##### CBP Data from 1986 to 2001
years  <- c(as.character(86:99), "00", "01")
url    <- "ftp://ftp.census.gov/Econ2001_And_Earlier/CBP_CSV/"
files  <- matrix(NA, nrow = length(years))
row.names(files) <- years
for (i in years){
  temp <- paste0(url, "cbp", i, "co.zip")
  file <- paste(data_source, basename(temp), sep = "/")
  files[i,] <- file
  if (!file.exists(file)) download.file(temp, file, method = "libcurl")
}

data <- data.frame()
year <- 1986
for (j in files){
  unzip(j, exdir = tempDir)
  file       <- list.files(tempDir, pattern = "\\.txt$", full.names = T)
  rdata      <- read_csv(file)
  rdata$year <- year
  
  data  <- bind_rows(data, rdata)
  year  <- year + 1
  unlink(tempDir, recursive = T)
  
}
write_csv(data, path = "0-data/CBP/CBP86-01.csv")
save(data, file = "0-data/CBP/CBP86-01.RData")

##### CBP Data from 2002 to 2013
years  <- as.character(2002:2013)
url    <- "ftp://ftp.census.gov/econ"
files  <- matrix(NA, nrow = length(years))
row.names(files) <- years
for (i in years){
  temp <- paste0(url, i, "/CBP_CSV/cbp", substr(i, 3, 4), "co.zip")
  file <- paste(data_source, basename(temp), sep = "/")
  files[i,] <- file
  if (!file.exists(file)) download.file(temp, file, method = "libcurl")
}

for (j in files){
  unzip(j, exdir = tempDir)
  file       <- list.files(tempDir, pattern = "\\.txt$", full.names = T)
  rdata      <- read_csv(file)
  rdata$year <- year
  
  data  <- bind_rows(data, rdata)
  year  <- year + 1
  unlink(tempDir, recursive = T)
  
}
write_csv(data, path =  "0-data/CBP/CBP86-13.csv")
save(data, file = "0-data/CBP/CBP86-13.RData")

rm(list = ls())

print(paste0("Finished 0-CBP at ", Sys.time()))
