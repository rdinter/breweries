#Robert Dinterman, NCSU Economics PhD Student

# Zip Code Business Patterns
# https://www.census.gov/econ/cbp/download/
# BEWARE: From 1994 to 1997, classification uses SIC. 1998+ is NAICS

print(paste0("Started 0-ZBP at ", Sys.time()))

options(scipen=999) #Turn off scientific notation for write.csv()
require(dplyr, quietly = T)
require(readr, quietly = T)

# Create a directory for the data
localDir <- "0-data/ZBP"
data_source <- paste0(localDir, "/Raw")
if (!file.exists(localDir)) dir.create(localDir)
if (!file.exists(data_source)) dir.create(data_source)

# http://www.census.gov/econ/isp/sampler.php?naicscode=312120&naicslevel=6
# Breweries NAICS Code is 312120

# NAICS 312120 Breweries; SIC 2082 Malt Beverages (except malt extract)
# NAICS 445310 Beer, Wine, and Liquor Stores; SIC 5181 Beer and Ale
#  (beer and ale sold via retail method)


tempDir  <- tempdir()
# unlink(tempDir, recursive = T)

url  <- paste0("https://www.census.gov/econ/cbp/",
               "download/full_layout/ZIP_Totals_Layout.txt")
file <- paste(localDir, basename(url), sep = "/")
if (!file.exists(file)) download.file(url, file, method = "libcurl")

url  <- paste0("https://www.census.gov/econ/cbp/",
               "download/full_layout/ZIP_Detail_Layout.txt")
file <- paste(localDir, basename(url), sep = "/")
if (!file.exists(file)) download.file(url, file, method = "libcurl")

url  <- paste0("https://www.census.gov/econ/cbp/",
               "download/full_layout/ZIP_Detail_Layout_SIC.txt")
file <- paste(localDir, basename(url), sep = "/")
if (!file.exists(file)) download.file(url, file, method = "libcurl")


##### ZBP Data from 1994 to 2001
years  <- c(as.character(94:99), "00", "01")
url    <- "ftp://ftp.census.gov/Econ2001_And_Earlier/CBP_CSV/"
files  <- matrix(NA, nrow = length(years), ncol = 2)
row.names(files) <- years

for (i in years){
  temp <- paste0(url, "zbp", i, "totals.zip")
  file <- paste(data_source, basename(temp), sep = "/")
  files[i, 1] <- file
  if (!file.exists(file)) download.file(temp, file, method = "libcurl")
  
  temp <- paste0(url, "zbp", i, "detail.zip")
  file <- paste(data_source, basename(temp), sep = "/")
  files[i, 2] <- file
  if (!file.exists(file)) download.file(temp, file, method = "libcurl")
}

data1 <- data.frame()
year <- 1994
for (j in files[,1]){
  unzip(j, exdir = tempDir)
  file       <- list.files(tempDir, pattern = "\\.txt$", full.names = T)
  rdata      <- read_csv(file)
  rdata$year <- year
  
  data1 <- bind_rows(data1, rdata)
  year  <- year + 1
  unlink(tempDir, recursive = T)
  
}
write_csv(data1, path = "0-data/ZBP/ZBP94-01_totals.csv")
save(data1, file = "0-data/ZBP/ZBP94-01_totals.RData")

data2 <- data.frame()
year <- 1994
for (j in files[,2]){
  unzip(j, exdir = tempDir)
  file       <- list.files(tempDir, pattern = "\\.txt$", full.names = T)
  rdata      <- read_csv(file)
  rdata$year <- year
  
  data2 <- bind_rows(data2, rdata)
  year  <- year + 1
  unlink(tempDir, recursive = T)
  
}
write_csv(data2, path = "0-data/ZBP/ZBP94-01_detail.csv")
save(data2, file = "0-data/ZBP/ZBP94-01_detail.RData")


##### CBP Data from 2002 to 2013
years  <- as.character(2002:2013)
url    <- "ftp://ftp.census.gov/econ"
files  <- matrix(NA, nrow = length(years), ncol = 2)
row.names(files) <- years
for (i in years){
  temp <- paste0(url, i, "/CBP_CSV/zbp", substr(i, 3, 4), "totals.zip")
  file <- paste(data_source, basename(temp), sep = "/")
  files[i, 1] <- file
  if (!file.exists(file)) download.file(temp, file, method = "libcurl")
  
  temp <- paste0(url, i, "/CBP_CSV/zbp", substr(i, 3, 4), "detail.zip")
  file <- paste(data_source, basename(temp), sep = "/")
  files[i, 2] <- file
  if (!file.exists(file)) download.file(temp, file, method = "libcurl")
  
}

year <- 2002
for (j in files[,1]){
  unzip(j, exdir = tempDir)
  file       <- list.files(tempDir, pattern = "\\.txt$", full.names = T)
  rdata      <- read_csv(file)
  rdata$year <- year
  
  data1 <- bind_rows(data1, rdata)
  year  <- year + 1
  unlink(tempDir, recursive = T)
  
}
write_csv(data1, path = "0-data/ZBP/ZBP94-13_total.csv")
save(data1, file = "0-data/ZBP/ZBP94-13_total.RData")

year <- 2002
for (j in files[,2]){
  unzip(j, exdir = tempDir)
  file       <- list.files(tempDir, pattern = "\\.txt$", full.names = T)
  rdata      <- read_csv(file)
  rdata$year <- year
  
  data2 <- bind_rows(data2, rdata)
  year  <- year + 1
  unlink(tempDir, recursive = T)
  
}
write_csv(data2, path = "0-data/ZBP/ZBP94-13_detail.csv")
save(data2, file = "0-data/ZBP/ZBP94-13_detail.RData")


rm(list = ls())

print(paste0("Finished 0-ZBP at ", Sys.time()))
