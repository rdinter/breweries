#Robert Dinterman

# County Business Patterns
# https://www.census.gov/econ/cbp/download/
# BEWARE: From 1986 to 1997, classification uses SIC. 1998+ is NAICS

# ---- Start --------------------------------------------------------------

print(paste0("Started 0-CBP at ", Sys.time()))

library(tidyverse)

# Create a directory for the data
local_dir    <- "0-data/CBP"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir)
if (!file.exists(data_source)) dir.create(data_source)

tempDir  <- tempdir()

# Get layout files for data
urls <- paste0("https://www.census.gov/econ/cbp/download/full_layout/",
               c("County_Layout.txt", "County_Layout_SIC.txt"))
map(urls,
    function(x) download.file(x, paste(data_source, basename(x), sep = "/")))

urls <- paste0("https://www.census.gov/econ/cbp/download/",
               c("sic86.txt", "sic87.txt", "sic88_97.txt", "naics.txt"))
map(urls,
    function(x) download.file(x, paste(data_source, basename(x), sep = "/")))

# ---- CBP Data from 1986 to 2001 -----------------------------------------
years  <- as.character(1986:2014)
urls   <- paste0("http://www2.census.gov/programs-surveys/cbp/datasets/",
                 years, "/cbp", substr(years, 3, 4), "co.zip")
files  <- paste(data_source, basename(urls), sep = "/")

map2(urls, files, function(urls, files)
  if(!file.exists(files)) download.file(urls, files))

# function
zipdata <- function(files, tempDir, years){
  unlink(tempDir, recursive = T)
  
  unzip(files, exdir = tempDir)
  files <- list.files(tempDir, pattern = "\\.txt$", full.names = T)
  rdata <- read_csv(files,
                    col_types = cols(.default = "i", fipstate = "c", 
                                     fipscty = "c", sic = "c", naics = "c",
                                     empflag = "c", emp_nf = "c", qp1_nf = "c",
                                     ap_nf = "c"))
  
  names(rdata) <- tolower(names(rdata))
  rdata$YEAR  <- as.numeric(years)
  
  return(rdata)
}
cbp_data <- pmap(list(files, tempDir, years), zipdata)

cbp      <- bind_rows(cbp_data)

#####
#### NEED TO GO THROUGH AND CHANGE THIS BECAUSE OF DUPLICATES
#####
cbp %>%
  filter(fipstate == "11") %>%
  mutate(fipscty = "001") %>%
  bind_rows(cbp) -> cbp

cbp %>% mutate(fipscty = ifelse(fipscty == "999", "0", fipscty),
               fips = 1000*as.numeric(fipstate) + as.numeric(fipscty),
               fips = ifelse(fips == 12025, 12086, fips)) %>%
  select(YEAR, fips, naics, sic:n1000_4) -> cbp

# So we can replace the FIPS, then group_by FIPS ....
cbp$fips[cbp$fips == 51780] = 51083
cbp$fips[cbp$fips == 51560] = 51005
cbp$fips[cbp$fips == 51515] = 51019

probs <- c(51083, 51005, 51019)

# empflag needs to be rethought

cbp %>% filter(fips %in% probs) %>% 
  group_by(YEAR, fips, naics, sic) %>% 
  summarise_each(funs(sum(., na.rm = T)), -empflag) -> cb3

# THIS STILL NEEDS WORK ^^^^
# cbp <- bind_rows(filter(cbp, !(fips %in% probs)), cb3)

write_rds(cbp, paste0(local_dir, "/CBP86-14.rds"))
# write_csv(cbp, path = paste0(local_dir, "/CBP86-14.csv"))

rm(list = ls())

print(paste0("Finished 0-CBP at ", Sys.time()))