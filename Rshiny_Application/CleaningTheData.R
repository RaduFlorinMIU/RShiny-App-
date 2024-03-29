# Import Library ---- 
library(readr)
library(readxl)

# Data manipulation
library(data.table)
library(magrittr) # to use the pipe
library(dplyr)
library(tidyr)
library(lubridate) # to manipulate dates
library(stringr)


# Import Data ---- 

estate_2015 = fread("Rshiny_Application//Datasets/2015_real_estate_transactions.csv", data.table = FALSE, na.strings ="")
estate_2016 = fread("Rshiny_Application//Datasets/2016_real_estate_transactions.csv", data.table = FALSE, na.strings ="")
estate_2017 = fread("Rshiny_Application//Datasets/2017_real_estate_transactions.csv", data.table = FALSE, na.strings ='')
estate_2018 = fread("Rshiny_Application//Datasets/2018_real_estate_transactions.csv", data.table = FALSE, na.strings ='')
estate_2019 = fread("Rshiny_Application//Datasets/2019_real_estate_transactions.csv", data.table = FALSE, na.strings ='')

# Merging tables ----

real_estate = bind_rows(estate_2015, estate_2016, estate_2017, estate_2018, estate_2019)

real_estate = real_estate %>% 
  unite("Sale Date", `Sale Date`, `Date of Sale`, remove = TRUE, na.rm = TRUE) %>% 
  unite("Number of rooms", `Number of rooms`, Rooms, remove = TRUE, na.rm = TRUE)

# Cleaning data ----

# Filter NA and Unwanted data

real_estate = real_estate %>% 
  filter(!is.na(`Postal Code`)) %>% 
  filter(!is.na(Price)) %>% 
  filter(!is.na(`Living Area`)) %>% 
  filter(`Sale Type` %in% c("SALE BEFORE COMPLETION", "SALE")) %>% 
  filter(`Local Type` %in% c("HOUSE", "APARTMENT"))

# Missing City names for data from 2019, solution: get City Names from Commune col 

real_estate$City = fifelse(is.na(real_estate$City), str_split_i(real_estate$Commune, " ", 1), real_estate$City)

# NA values for Land Area col set to 0 as default 

real_estate$`Land Area` = fifelse(is.na(real_estate$`Land Area`), 0, real_estate$`Land Area`)

# Changing Data type in columns to what is expected

real_estate = real_estate %>%  
  mutate(`Sale Date` = dmy(`Sale Date`)) %>% 
  mutate(Year = year(`Sale Date`)) %>% 
  mutate(`Number of rooms` = as.numeric(`Number of rooms`)) %>% 
  mutate(Price = gsub(" ", "", Price)) %>% 
  mutate(Price = gsub(",", ".", `Price`) %>% as.numeric())

# Outlier detection: 

real_estate = real_estate %>% 
  group_by(Year, `Local Type`, `Postal Code`) %>% 
  mutate(`Lower Limit` = Price >= quantile(Price, probs = 0.25)) %>% 
  mutate(`Upper Limit` = Price <= quantile(Price, probs = 0.75) + IQR(Price) * 1.5) %>% 
  mutate('Outlier' = `Lower Limit` & `Upper Limit`)

# Remove Unused columns
real_estate = real_estate %>% 
  select(!c(V12))


# Write CSV 

write.csv(real_estate, "Rshiny_Application/Datasets/clean_real_estate_data.csv")

