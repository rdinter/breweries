library(foreign)
library(tidyverse)

beer <- read_rds("0-data/CBP/beer.rds") %>% 
  filter(sic == "2082" | naics == "312120") %>% 
  distinct()

beer_est <- beer %>% 
  mutate(YEAR = paste0("est_", YEAR)) %>% 
  select(YEAR, fips, est) %>% 
  spread(YEAR, est)

weather <- read.dta("0-data/weather/ddayOverAgAreaByMonth.dta")

# Estimate average annual precipitation by county
#  using precip data from 1950-1986.
prec_86 <- weather %>% 
  filter(year < 1987) %>% 
  group_by(fips) %>% 
  summarise(prec_mean_86 = mean(prec, na.rm = T),
            prec_sd_86 = sd(prec, na.rm = T)) %>% 
  left_join(beer_est)

prec_86[is.na(prec_86)] <- 0

write_csv(prec_86, "1-tidy/beer_prec.csv")
write_rds(prec_86, "1-tidy/beer_prec.rds")