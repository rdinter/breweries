# NASS API for their Quickstats web interface:
# https://quickstats.nass.usda.gov/

# devtools::install_github("emraher/rnass")
library(rnass)
library(tidyverse)

# Create a directory for the data
local_dir    <- "0-data/NASS"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir)
if (!file.exists(data_source)) dir.create(data_source)


api_nass_key <- "21E12D8F-E59B-3C68-9113-EC288AA44D4D"

years <- as.character(c(1997, 2002, 2007, 2012))
nass_county <- map(years, function(x){
  nass_data(commodity_desc = "AG LAND", agg_level_desc = "COUNTY",
            statisticcat_desc = "ASSET VALUE",
            year = x, token = api_nass_key)
})

farm_county <- nass_county %>% 
  bind_rows() %>% 
  mutate(FIPS = paste0(state_fips_code, county_code),
         YEAR = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("agland", "agland_per_acre",
                                        "agland_per_farm", "junk"))) %>% 
  select(FIPS, Value, short_desc, YEAR) %>% 
  filter(short_desc != "junk") %>% 
  spread(short_desc, Value) %>% 
  complete(FIPS, YEAR)

# Operations
nass_county <- map(years, function(x){
  nass_data(commodity_desc = "FARM OPERATIONS", agg_level_desc = "COUNTY",
            short_desc = "FARM OPERATIONS - NUMBER OF OPERATIONS",
            domain_desc = "TOTAL", year = x, token = api_nass_key)
})

farm_county <- nass_county %>% 
  bind_rows() %>% 
  mutate(FIPS = paste0(state_fips_code, county_code),
         YEAR = as.numeric(year)) %>% 
  select(YEAR, FIPS, FARMS = Value) %>% 
  left_join(farm_county)

# Net Cash Income
years <- as.character(c(2002, 2007, 2012))
nass_county <- map(years, function(x){
  nass_data(commodity_desc = "INCOME, NET CASH FARM",
            sector_desc = "ECONOMICS", agg_level_desc = "COUNTY",
            statisticcat_desc = "NET INCOME",
            year = x, token = api_nass_key)
})

farm_county <- nass_county %>% 
  bind_rows() %>% 
  mutate(FIPS = paste0(state_fips_code, county_code),
         YEAR = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("farm_net_cash",
                                        "farm_net_cash_per_farm",
                                        "junk", "farmer_net_cash",
                                        "farmer_net_cash_per_farm")),
         short_desc = as.character(short_desc)) %>% 
  select(FIPS, Value, short_desc, YEAR) %>% 
  filter(short_desc != "junk") %>% 
  spread(short_desc, Value) %>% 
  right_join(farm_county)

# Problem writing this with write_csv ...
options(scipen = 999)
write.csv(farm_county, paste0(local_dir, "/NASS_farms_county.csv"),
          row.names = F)

years <- as.character(c(1850, 1860, 1870, 1880, 1890, 1900, 1910:2016))

nass_land  <- map(years, function (x){
  nass_data(commodity_desc = "AG LAND", agg_level_desc = "STATE",
            statisticcat_desc = "ASSET VALUE", freq_desc = "ANNUAL",
            year = x, token = api_nass_key)
})

akhi_land  <- map(c("1997", "2002", "2007", "2012"), function (x){
  nass_data(commodity_desc = "AG LAND", agg_level_desc = "STATE",
            sector_desc = "ECONOMICS", domain_desc = "TOTAL",
            statisticcat_desc = "ASSET VALUE", source_desc = "CENSUS",
            year = x, token = api_nass_key)
})

akhi <- akhi_land %>% 
  bind_rows() %>% 
  select(state = state_name, Value, short_desc, year) %>% 
  mutate(year = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("agland_total", "agland",
                                        "junk", "more_junk"))) %>% 
  filter(short_desc == "agland", state %in% c("ALASKA", "HAWAII")) %>% 
  spread(short_desc, Value) %>% 
  complete(year = full_seq(1997:2016, 1L), state) %>% 
  group_by(state) %>% 
  fill(agland)

nass_land_data <- nass_land %>% 
  bind_rows() %>% 
  select(state = state_name, Value, short_desc, year) %>% 
  mutate(year = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("cropland", "cropland_irr",
                                        "cropland_nonirr", "agland_total",
                                        "agland", "pastureland"))) %>% 
  filter(short_desc != "agland_total", state != "OTHER STATES") %>% 
  spread(short_desc, Value) %>% 
  bind_rows(akhi) %>% 
  complete(state, year) %>% 
  arrange(state)


years <- as.character(1910:2015)
nass_farms <- map(years, function(x){
  nass_data(commodity_desc = "FARM OPERATIONS", agg_level_desc = "STATE",
            short_desc = "FARM OPERATIONS - NUMBER OF OPERATIONS",
            source_desc = "SURVEY", domain_desc = "TOTAL",
            year = x, token = api_nass_key)
})

nass_land_data <- nass_farms %>% 
  bind_rows() %>% 
  mutate(year = as.numeric(year)) %>% 
  select(year, state = state_name, farms = Value) %>% 
  distinct() %>% 
  right_join(nass_land_data)


years <- as.character(1950:2015)
nass_acres <- map(years, function(x){
  nass_data(commodity_desc = "FARM OPERATIONS", agg_level_desc = "STATE",
            short_desc = "FARM OPERATIONS - ACRES OPERATED",
            source_desc = "SURVEY", domain_desc = "TOTAL",
            year = x, token = api_nass_key)
})

nass_land_data <- nass_acres %>% 
  bind_rows() %>% 
  mutate(year = as.numeric(year)) %>% 
  select(year, state = state_name, acres = Value) %>% 
  distinct() %>% 
  right_join(nass_land_data)

library(FredR)
library(lubridate)

api_key_fred <- "b65075ee860e6c0e1c27bad40c602ef4"

fred  <- FredR(api_key_fred)
gdpd  <- "GDPDEF" %>% 
  fred$series.observations(observation_start = "1947-01-01") %>% 
  select(date, deflator = value) %>% 
  mutate(year = year(date), deflator = as.numeric(deflator))
cpi   <- "CPIAUCNS" %>% 
  fred$series.observations(observation_start = "1913-01-01") %>% 
  select(date, cpi = value) %>% 
  mutate(year = year(date), cpi = as.numeric(cpi))
fred <- gdpd %>% 
  right_join(cpi) %>% 
  group_by(year) %>% 
  summarise(deflator = mean(deflator, na.rm = T), cpi = mean(cpi, na.rm = T))

nass_land_data <- left_join(nass_land_data, fred) %>% 
  group_by(state) %>% 
  fill(acres, farms, cropland, cropland_irr, cropland_nonirr, agland,
       pastureland, deflator, cpi)

# write_csv(nass_land_data, paste0(local_dir, "/NASS_agland.csv"))
write.csv(nass_land_data, paste0(local_dir, "/NASS_agland.csv"),
          row.names = F)
