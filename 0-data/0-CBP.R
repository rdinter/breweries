#Robert Dinterman, NCSU Economics PhD Student

# County Business Patterns
# https://www.census.gov/econ/cbp/download/
# BEWARE: From 1986 to 1997, classification uses SIC. 1998+ is NAICS

print(paste0("Started 0-CBP at ", Sys.time()))

options(scipen=999) #Turn off scientific notation for write.csv()
require(dplyr, quietly = T)
require(readr, quietly = T)
source("0-functions.R")

# Create a directory for the data
localDir <- "0-data/CBP"
data_source <- paste0(localDir, "/Raw")
if (!file.exists(localDir)) dir.create(localDir)
if (!file.exists(data_source)) dir.create(data_source)

tempDir  <- tempdir()
<<<<<<< HEAD

# Get layout files for data
urls <- paste0("https://www.census.gov/econ/cbp/download/full_layout/",
               c("County_Layout.txt", "County_Layout_SIC.txt"))
lapply(urls, function(x) bdown(url = x, folder = localDir))

urls <- paste0("https://www.census.gov/econ/cbp/download/",
               c("sic86.txt", "sic87.txt", "sic88_97.txt", "naics.txt"))
lapply(urls, function(x) bdown(url = x, folder = localDir))
=======
>>>>>>> b075bf19c9df63311defc96f152724db6df5618d

# Get layout files for data
urls <- paste0("https://www.census.gov/econ/cbp/download/full_layout/",
               c("County_Layout.txt", "County_Layout_SIC.txt"))
lapply(urls, function(x) bdown(url = x, folder = localDir))

##### CBP Data from 1986 to 2001
years  <- c(as.character(86:99), "00", "01")
url    <- "ftp://ftp.census.gov/Econ2001_And_Earlier/CBP_CSV/"
urls   <- paste0(url, "cbp", years, "co.zip")
lapply(urls, function(x) bdown(url = x, folder = data_source))

files  <- paste(data_source, basename(urls), sep = "/")
year   <- 1986:2001
<<<<<<< HEAD
cbp8601<- mapply(function(x, y) zipdata(x, tempDir, y), x = files,
                 y = year, SIMPLIFY = F, USE.NAMES = T)

cbp8601<- bind_rows(cbp8601)
write_csv(cbp8601, path = paste0(localDir, "/CBP86-01.csv"))
save(cbp8601, file = paste0(localDir, "/CBP86-01.RData"))
rm(cbp8601)
=======
data   <- mapply(function(x, y) zipdata(x, tempDir, y), x = files,
                 y = year, SIMPLIFY = F, USE.NAMES = T)

data   <- bind_rows(data)
write_csv(data, path = paste0(localDir, "/CBP86-01.csv"))
save(data, file = paste0(localDir, "/CBP86-01.RData"))
>>>>>>> b075bf19c9df63311defc96f152724db6df5618d

##### CBP Data from 2002 to 2013
years  <- as.character(2002:2013)
url    <- "ftp://ftp.census.gov/econ"
urls   <- paste0(url, years, "/CBP_CSV/cbp",
                 substr(years, 3, 4), "co.zip")
lapply(urls, function(x) bdown(url = x, folder = data_source))

files   <- paste(data_source, basename(urls), sep = "/")
year    <- 2002:2013
<<<<<<< HEAD
cbp0213 <- mapply(function(x, y) zipdata(x, tempDir, y), x = files,
                  y = year, SIMPLIFY = F, USE.NAMES = T)

cbp0213 <- bind_rows(cbp0213)
write_csv(cbp0213, path = paste0(localDir, "/CBP02-13.csv"))
save(cbp0213, file = paste0(localDir, "/CBP02-13.RData"))
=======
data    <- mapply(function(x, y) zipdata(x, tempDir, y), x = files,
                  y = year, SIMPLIFY = F, USE.NAMES = T)

data   <- bind_rows(data)
write_csv(data, path = paste0(localDir, "/CBP02-13.csv"))
save(data, file = paste0(localDir, "/CBP02-13.RData"))
>>>>>>> b075bf19c9df63311defc96f152724db6df5618d

rm(list = ls())

print(paste0("Finished 0-CBP at ", Sys.time()))