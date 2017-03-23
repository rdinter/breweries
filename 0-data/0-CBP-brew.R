# Robert Dinterman

#http://www.census.gov/econ/isp/sampler.php?naicscode=312120&naicslevel=6
# Breweries NAICS Code is 312120

# NAICS 312120 Breweries; SIC 2082 Malt Beverages (except malt extract)
# NAICS 445310 Beer, Wine, and Liquor Stores; SIC 5181 Beer and Ale
#  (beer and ale sold via retail method)

print(paste0("Started 0-CBP-brew at ", Sys.time()))

library(tidyverse)

cbp <- read_rds("0-data/CBP/CBP86-14.rds")

# Problems in 1986: Manufacturing was titled 19-- ...
cbp <- mutate(cbp, sic = replace(sic, sic == "19--", "20--"))

# data$sic <- str_replace(data$sic, "[[:punct:]]", "0")

bsic   <- c("----", "20--", "2000", "2080", "2082",
            "50--", "5100", "5180", "5181")
bnaics <- c("------", "31----", "312///", "3121//", "31212/", "312120",
            "42----", "424///", "4248//", "42481/", "424810")
beer   <- filter(cbp, sic %in% bsic | naics %in% bnaics)
rm(cbp)

# EMPFLAG: This denotes employment size class for data withheld to
# avoid disclosure (confidentiality) or withheld because data do
# not meet publication standards.
# A       0-19
# B       20-99
# C       100-249
# E       250-499
# F       500-999
# G       1,000-2,499
# H       2,500-4,999
# I       5,000-9,999
# J       10,000-24,999
# K       25,000-49,999
# L       50,000-99,999
# M       100,000 or More

# n1000 Number of Establishments: 1,000 or More Employee Size Class
# n1000_1 Employment Size Class:  1,000-1,499 Employees
# n1000_2 Employment Size Class:  1,500-2,499 Employees
# n1000_3 Employment Size Class:  2,500-4,999 Employees
# n1000_4 Employment Size Class:  5,000 or More Employees

beer <- beer %>%
  mutate(emp_min = 1*n1_4 + 5*n5_9 + 10*n10_19 + 20*n20_49 + 
           50*n50_99 + 100*n100_249 + 250*n250_499 + 500*n500_999 +
           + 1000*n1000_1 + 1500*n1000_2 + 2500*n1000_3 + 5000*n1000_4,
         emp_max = 4*n1_4 + 9*n5_9 + 19*n10_19 + 49*n20_49 + 
           99*n50_99 + 249*n100_249 + 499*n250_499 + 999*n500_999 +
           + 1499*n1000_1 + 2499*n1000_2 + 4999*n1000_3 + 5999*n1000_4)

beersic   <- filter(beer, !is.na(sic))
beernaics <- filter(beer, !is.na(naics))

write_csv(beer, "0-data/CBP/beer.csv")
write_rds(beer, "0-data/CBP/beer.rds")

print(paste0("Finished 0-CBP-brew at ", Sys.time()))
