# Robert Dinterman

print(paste0("Started 0-ZBP-imputed at ", Sys.time()))

options(scipen=999) #Turn off scientific notation for write.csv()
require(dplyr, quietly = T)
require(readr, quietly = T)
# require(stringr, quietly = T)

load("0-data/ZBP/ZBPtotal94-01.RData") # 1994 to 2001 data
load("0-data/ZBP/ZBPdetail94-01.RData") # 1994 to 2001 data

zbp9401 <- left_join(zbptot9401,
                     filter(zbpind9401, sic == "----" | naics == "------"))
rm(zbpind9401, zbptot9401)

test <- lm(emp ~ n5_9 + n10_19 + n20_49 + n50_99 + n100_249 + n250_499 +
             n500_999 + n1000 - 1,
           filter(zbp9401, empflag == ""))
summary(test)

zbpimpute      <- filter(zbp9401, empflag != "")
imputed        <- predict(test, zbpimpute)
imputed        <- as.data.frame(round(imputed))
names(imputed) <- "imputed"

zbpimpute <- bind_cols(zbpimpute, imputed)
zbpimpute <- zbpimpute %>% rowwise() %>%
  mutate(emp_ = imputed,
         emp_ = ifelse(empflag == "A", max(min(emp_, 19), 0), emp_),
         emp_ = ifelse(empflag == "B", max(min(emp_, 99), 20), emp_),
         emp_ = ifelse(empflag == "C", max(min(emp_, 249), 100), emp_),
         emp_ = ifelse(empflag == "E", max(min(emp_, 499), 250), emp_),
         emp_ = ifelse(empflag == "F", max(min(emp_, 999), 500), emp_),
         emp_ = ifelse(empflag == "G", max(min(emp_, 2499), 1000), emp_),
         emp_ = ifelse(empflag == "H", max(min(emp_, 4999), 2500), emp_),
         emp_ = ifelse(empflag == "I", max(min(emp_, 9999), 5000), emp_),
         emp_ = ifelse(empflag == "J", max(min(emp_, 24999), 10000), emp_),
         emp_ = ifelse(empflag == "K", max(min(emp_, 49999), 25000), emp_),
         emp_ = ifelse(empflag == "L", max(min(emp_, 99999), 50000), emp_),
         emp_ = ifelse(empflag == "M", max(emp_, 100000), emp_))

zbp9401 %>% filter(empflag == "") %>%
  bind_rows(zbpimpute) %>%
  mutate(emp_ = ifelse(is.na(emp_), emp, emp_)) -> z9401
# A 0-19
# B 20-99
# C 100-249
# E 250-499
# F 500-999
# G 1,000-2,499
# H 2,500-4,999
# I 5,000-9,999
# J 10,000-24,999
# K 25,000-49,999
# L 50,000-99,999
# M 100,000 or More

rm(zbp9401, zbpimpute, imputed)


# From 2002 and beyond ----------------------------------------------------

load("0-data/ZBP/ZBPtotal02-13.RData") # 2002 to 2013 data
load("0-data/ZBP/ZBPdetail02-13.RData") # 2002 to 2013 data

zbp0213 <- left_join(zbptot0213, filter(zbpind0213, naics == "------"))
rm(zbptot0213, zbpind0213)

zbp0213$emp_nf <- ifelse(is.na(zbp0213$emp_nf), "", zbp0213$emp_nf)

test <- lm(emp ~ n1_4 + n5_9 + n10_19 + n20_49 + n50_99 + n100_249 +
             n250_499 + n500_999 + n1000 -  1,
           filter(zbp0213, empflag == ""))
summary(test)

zbpimpute      <- filter(zbp0213, empflag != "")
imputed        <- predict(test, zbpimpute)
imputed        <- as.data.frame(round(imputed))
names(imputed) <- "imputed"

zbpimpute <- bind_cols(zbpimpute, imputed)
zbpimpute <- zbpimpute %>% rowwise() %>%
  mutate(emp_ = imputed,
         emp_ = ifelse(empflag == "A", max(min(emp_, 19), 0), emp_),
         emp_ = ifelse(empflag == "B", max(min(emp_, 99), 20), emp_),
         emp_ = ifelse(empflag == "C", max(min(emp_, 249), 100), emp_),
         emp_ = ifelse(empflag == "E", max(min(emp_, 499), 250), emp_),
         emp_ = ifelse(empflag == "F", max(min(emp_, 999), 500), emp_),
         emp_ = ifelse(empflag == "G", max(min(emp_, 2499), 1000), emp_),
         emp_ = ifelse(empflag == "H", max(min(emp_, 4999), 2500), emp_),
         emp_ = ifelse(empflag == "I", max(min(emp_, 9999), 5000), emp_),
         emp_ = ifelse(empflag == "J", max(min(emp_, 24999), 10000), emp_),
         emp_ = ifelse(empflag == "K", max(min(emp_, 49999), 25000), emp_),
         emp_ = ifelse(empflag == "L", max(min(emp_, 99999), 50000), emp_),
         emp_ = ifelse(empflag == "M", max(emp_, 100000), emp_))

zbp0213 %>% filter(empflag == "") %>%
  bind_rows(zbpimpute) %>%
  mutate(emp_ = ifelse(is.na(emp_), emp, emp_)) -> z0213

rm(zbp0213, zbpimpute, imputed)

zbpimpute <- bind_rows(z9401, z0213)

write_csv(zbpimpute, path = "0-data/ZBP/ZBPimpute.csv")
save(zbpimpute, file = "0-data/ZBP/ZBPimpute.RData")

rm(list = ls())

print(paste0("Finished 0-ZBP-imputed at ", Sys.time()))