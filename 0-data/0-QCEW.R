# Robert Dinterman

# Downloading Quarterly Census of Employment and Wages Program
# ReadMe: http://www.bls.gov/cew/doc/layouts/enb_end_layout.htm

# http://www.bls.gov/cew/datatoc.htm

library(tidyverse)

# Create a directory for the data
local_dir <- "0-data/QCEW"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir)
if (!file.exists(data_source)) dir.create(data_source)

tempDir  <- tempdir()

##### QCEW Data through 2017 -- unless it is only partially complete with the
# .end extension
years  <- 1990:2017
url    <- "http://data.bls.gov/cew/data/files/"
urls   <- paste0(url, years, "/enb/", years, "_all_enb.zip")
map(urls, function(x){
  Sys.sleep(runif(1, 2, 3))
  file_x <- paste0(data_source, "/", basename(x))
  if (!file.exists(file_x)) download.file(x, file_x)
})

files  <- paste(data_source, basename(urls), sep = "/")

delim_enb <- read_csv("http://data.bls.gov/cew/doc/layouts/enb_layout.csv")
delim_end <- read_csv("https://data.bls.gov/cew/doc/layouts/end_layout.csv")
starts <- delim_enb$start_position
ends   <- delim_enb$end_position
fixed  <- delim_enb$field_length

# Enter the codes of naics classifications needed for analysis
naics    <- c("10", "11", "21", "22", "23", "31-33", "42", "44-45",
              "48-49", "51", "52", "53", "54", "55", "56", "61",
              "62", "71", "72", "81", "92",
              # Breweries and such:
              "312", "3121", "31212", "312120",
              "424", "4248", "42481", "424810")
qcew     <- data.frame()

# Do not grab the "calls", which I still need to parse through from the Chicago
#  Fed. Correction is to only grab the .zip files instead of the folder.
qcew_files <- dir(data_source, full.names = T, pattern = ".zip")

files <- map(qcew_files, function(x){
  #temp_name <- paste0(str_sub(basename(x), 1, -5), "_")
  txts <- unzip(x, list = T)[, 1]
  txts <- txts[str_detect(tolower(txts), "county/")]
  txts <- txts[str_detect(tolower(txts), ".enb")]
  txts <- txts[-c(grep("vi", txts, ignore.case = T), #removes Virgin Islands
                  grep("pr", txts, ignore.case = T))] #removes Puerto Rico
  #tbls <- str_remove(txts, temp_name)
  #tbls <- str_remove(tbls, ".csv")
  
  j5 <- tibble(file_zip = x, file_csv = txts)
  return(j5)
})

files <- bind_rows(files)

j5 <- pmap(files, function(file_zip, file_csv) {
  temp <- tryCatch(read_fwf(unz(file_zip, file_csv), fwf_widths(fixed),
                            col_types = cols(.default = "c")),
                   error = function(e){
                     read.fwf(unz(file_zip, file_csv), fixed)
                   })
  temp <- mutate_all(temp, str_trim)
  temp <- filter(temp, X4 == 0 & (X5 == 0 | X5 == 5) & X6 %in% naics)
  print(file_csv)
  return(temp)
})

qcew <- bind_rows(j5)
names <- c("survey", "fips", "datatype", "sizecode", "ownership", "naics",
           "year", "aggregation", "status1", "establishments1", "employ11",
           "employ21", "employ31", "wages1", "taxwage1", "contr1", "avgwage1",
           "status2", "establishments2", "employ12", "employ22", "employ32",
           "wages2", "taxwage2", "contr2", "avgwage2", "status3",
           "establishments3", "employ13", "employ23", "employ33", "wages3",
           "taxwage3", "contr3", "avgwage3", "status4", "establishments4",
           "employ14", "employ24", "employ34", "wages4", "taxwage4", "contr4",
           "avgwage4", "statusA", "establishmentsA", "employA", "wagesA",
           "taxwageA", "contrA", "avgwageA", "avgpayA")
names(qcew) <- names

# Data parsing ...
qcew <- qcew %>% 
  mutate_at(vars("establishments1", "employ11", "employ21", "employ31",
                 "wages1", "taxwage1", "contr1", "avgwage1", "establishments2",
                 "employ12", "employ22", "employ32", "wages2", "taxwage2",
                 "contr2", "avgwage2", "establishments3", "employ13",
                 "employ23", "employ33", "wages3", "taxwage3", "contr3",
                 "avgwage3", "establishments4", "employ14", "employ24",
                 "employ34", "wages4", "taxwage4", "contr4", "avgwage4",
                 "establishmentsA", "employA", "wagesA", "taxwageA", "contrA",
                 "avgwageA", "avgpayA"), parse_number)

write_csv(qcew, paste0(local_dir, "/QCEW.csv"))
write_rds(qcew, paste0(local_dir, "/QCEW.rds"))

#Annual Data
annual <- select(qcew, year, fips, naics, ownership, est = establishmentsA,
                 employ = employA, wages = wagesA, taxwage = taxwageA,
                 contr = contrA, avgwage = avgwageA, avgpay = avgpayA)

write_csv(annual, paste0(local_dir, "/QCEW_annual.csv"))
write_rds(annual, paste0(local_dir, "/QCEW_annual.rds"))

#Quarterly Data
qcew1 <- select(qcew, year, fips, naics, ownership, establishments1, employ11,
                employ21, employ31, wages1, taxwage1, contr1, avgwage1)
qcew1$quarter <- 1

qcew2 <- select(qcew, year, fips, naics, ownership, establishments2, employ12,
                employ22, employ32, wages2, taxwage2, contr2, avgwage2)
qcew2$quarter <- 2

qcew3 <- select(qcew, year, fips, naics, ownership, establishments3, employ13,
                employ23, employ33, wages3, taxwage3, contr3, avgwage3)
qcew3$quarter <- 3

qcew4 <- select(qcew, year, fips, naics, ownership, establishments4, employ14,
                employ24, employ34, wages4, taxwage4, contr4, avgwage4)
qcew4$quarter <- 4

names <- c("year", "fips", "naics", "ownership", "establishments", "employ1",
           "employ2", "employ3", "wages", "taxwage", "contr", "avgwage",
           "quarter")
names(qcew1)  <- names
names(qcew2)  <- names
names(qcew3)  <- names
names(qcew4)  <- names
quarterly     <- bind_rows(qcew1, qcew2, qcew3, qcew4)
rm(qcew1, qcew2, qcew3, qcew4)

write_csv(quarterly, paste0(local_dir, "/QCEW_quarter.csv"))
write_rds(quarterly, paste0(local_dir, "/QCEW_quarter.rds"))

zip(paste0(local_dir, "/QCEW.zip"), 
    files = c(paste0(local_dir, "/QCEW.csv"),
              paste0(local_dir, "/QCEW_annual.csv"),
              paste0(local_dir, "/QCEW_quarter.csv")))