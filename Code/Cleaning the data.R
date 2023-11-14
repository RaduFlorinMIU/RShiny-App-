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

estate_2015 = fread("2015_real_estate_transactions.csv", data.table = FALSE,na.strings ="")
estate_2016 = fread("2016_real_estate_transactions.csv", data.table = FALSE,na.strings ="")
estate_2017 = fread("2017_real_estate_transactions.csv", data.table = FALSE,na.strings ='')
estate_2018 = fread("2018_real_estate_transactions.csv", data.table = FALSE,na.strings ='')
estate_2019 = fread("2019_real_estate_transactions.csv", data.table = FALSE,na.strings ='')


# Merging tables ----

real_estate = bind_rows (estate_2015,estate_2016,estate_2017,estate_2018,estate_2019)

real_estate = real_estate %>% 
  unite("Sale Date", `Sale Date`,`Date of Sale`,remove = TRUE, na.rm = TRUE) %>% 
  unite("Number of rooms", `Number of rooms`,Rooms,remove = TRUE, na.rm = TRUE)

# Cleaning data ----

# Filter na and Unwanted data

real_estate = real_estate %>% 
  filter(!is.na(`Postal Code`)) %>% 
  filter(!is.na(Price)) %>% 
  filter(!is.na(`Living Area`)) %>% 
  filter(`Sale Type` %in% c("SALE BEFORE COMPLETION", "SALE")) %>% 
  filter(`Local Type` %in% c("HOUSE", "APARTMENT"))

# Missing City names for data from 2019, solution : get City Names form Commune col 

real_estate$City = fifelse(is.na(real_estate$City),str_split_i(real_estate$Commune, " ", 1 ), real_estate$City)

# Na values for Land Area col set to 0 as default 

real_estate$`Land Area` = fifelse(is.na(real_estate$`Land Area`),0, real_estate$`Land Area`)

# Changing Data type in columns to what is expected

real_estate = real_estate %>%  
  mutate(`Sale Date` = dmy(`Sale Date`)) %>% 
  mutate(Year = year(`Sale Date`)) %>% 
  mutate(`Number of rooms` =  as.numeric(`Number of rooms`)) %>% 
  mutate(Price = gsub(" ","",Price)) %>% 
  mutate(Price = gsub(',','.',`Price`) %>% as.numeric())

# Outlier detection : 

real_estate = real_estate %>% 
  group_by(Year, `Local Type`, `Postal Code`) %>% 
  mutate(`Lower Limit` = Price >= quantile(Price,probs = 0.25)) %>% 
  mutate(`Upper Limit` = Price <= quantile(Price,probs = 0.75) + IQR(Price)*1.5) %>% 
  mutate('Outlier' = `Lower Limit` & `Upper Limit`)

# Remove Unused clumns
real_estate = real_estate %>% 
  select(!c(V12))


# Write CSV 

write.csv(real_estate,"Clean Real Estate Data.csv")

# Used Functions to have an idea regarding the cleaning completion. 

#real_estate %>% 
#  sapply(function(x) sum(is.na(x)))
                       
#real_estate %>% str()

