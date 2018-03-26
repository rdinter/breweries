# Robert Dinterman

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

naics_urls <- paste0("https://www2.census.gov/programs-surveys/cbp/",
                     "technical-documentation/reference/naics-descriptions/",
                     c("naics2012.txt", "naics2007.txt",
                       "naics2002.txt", "naics.txt"))
map(naics_urls,
    function(x) download.file(x, paste(data_source, basename(x), sep = "/")))

sic_urls <- paste0("http://www2.census.gov/programs-surveys/cbp/",
                   "technical-documentation/records-layouts/",
                   "sic-code-descriptions/",
                   c("sic86.txt", "sic87.txt", "sic88_97.txt"))
map(sic_urls,
    function(x) download.file(x, paste(data_source, basename(x), sep = "/")))

# ---- CBP Data from 1986 to 2015 -----------------------------------------

years  <- as.character(1986:2015)
urls   <- paste0("http://www2.census.gov/programs-surveys/cbp/datasets/",
                 years, "/cbp", substr(years, 3, 4), "co.zip")
files  <- paste(data_source, basename(urls), sep = "/")

map2(urls, files, function(urls, files) {
  if (!file.exists(files)) {
    Sys.sleep(runif(1, 2, 3))
    download.file(urls, files)
    }
  })

# Do not grab the "calls", which I still need to parse through from the Chicago
#  Fed. Correction is to only grab the .zip files instead of the folder.
cbp_files <- dir(data_source, full.names = T, pattern = ".zip")

chars <- c("fipstate", "fipscty", "sic", "naics",
           "empflag", "emp_nf", "qp1_nf", "ap_nf")

cbp <- map(cbp_files, function(x) {
  j5 <- read_csv(x, col_types = cols(.default = "d", sic = "c", SIC = "c",
                                       naics = "c", NAICS = "c", empflag = "c",
                                       EMPFLAG = "c",  emp_nf = "c",
                                       EMP_NF = "c", qp1_nf = "c",
                                       QP1_NF = "c", ap_nf = "c", AP_NF = "c"))
  names(j5) <- tolower(names(j5))
  
  # j5_numeric <- names(j5)[!(names(j5) %in% chars)]
  # 
  # j5 <- mutate_at(j5, j5_numeric, parse_number)
  
  j5_year <- if_else(parse_number(basename(x)) < 86,
                       2000 + parse_number(basename(x)),
                       1900 + parse_number(basename(x)))
  j5$year <- j5_year
  
  return(j5)
  })

cbp <- bind_rows(cbp)

cbp <- cbp %>%
  mutate(fipscty = if_else(fipscty == 999, 0, fipscty),
         fipscty = if_else(fipscty == 0 & fipstate == 11, 1, fipscty),
         fips = 1000*fipstate + fipscty,
         fips = if_else(fips == 12025, 12086, fips)) %>% 
  select(year, fips, fipstate, fipscty, censtate, cencty, naics, sic,
         empflag, emp_nf, qp1_nf, ap_nf, emp:n1000_4)

# So we can replace the FIPS, then group_by FIPS ....
cbp$fips[cbp$fips == 51780] = 51083
cbp$fips[cbp$fips == 51560] = 51005
cbp$fips[cbp$fips == 51515] = 51019

probs <- c(51083, 51005, 51019)

# empflag needs to be rethought, but OK for now

cb3 <- cbp %>% 
  select(-fipstate, -fipscty, -censtate, -cencty) %>% 
  filter(fips %in% probs) %>% 
  group_by(year, fips, naics, sic) %>% 
  summarise_at(vars(emp:n1000_4), funs(sum(., na.rm = T)))

# Add in the grouped problem counties
cbp <- cbp %>% 
  filter(!(fips %in% probs)) %>% 
  bind_rows(cb3)

write_rds(cbp, paste0(local_dir, "/CBP86-15.rds"))
write_csv(cbp, path = paste0(local_dir, "/CBP86-15.csv"))

print(paste0("Finished 0-CBP at ", Sys.time()))