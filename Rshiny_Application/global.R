library(readr)
library(readxl)
library(shiny)
library(shinyWidgets)

# Data manipulation
library(data.table)
library(magrittr) # to use the pipe
library(dplyr)
library(tidyr)
library(lubridate) # to manipulate dates

# Visualization
library(ggplot2)
library(esquisse)
library(hrbrthemes) # different themes for ggplot2 
library(plotly) # to have dynamic plot
library(gtExtras) # to plot the summary of a data frame
library("maps")     # Provides latitude and longitude data for various maps

# Importing data for creating map
france_map <- map_data("france")
city_coordinates <- fread("Datasets/fr_city_coordinates.csv", data.table = FALSE)

# Import data for analysis
real_estate <- fread("Datasets/clean_real_estate_data.csv", data.table = FALSE)


# Cleaning city coordinates data for the merge
city_coordinates <- city_coordinates %>%  
  mutate(city_lower = tolower(city)) %>% 
  select(city, city_lower, lat, lng) %>% 
  mutate(lat = gsub(",", ".", lat) %>% as.numeric()) %>% 
  mutate(lng = gsub(",", ".", lng) %>% as.numeric())


# Cleaning data
real_estate <- real_estate %>%
  select(-V1) %>% 
  mutate(city_lower = tolower(City))

# Removing Outliers
real_estate_no_outliers <- real_estate %>% 
  filter(Outlier == TRUE) %>% 
  select(-c(Outlier, `Lower Limit`, `Upper Limit`)) %>% 
  mutate(number_of_sales = 1)

# Adding city coordinates to initial data
real_estate_plot_data <- real_estate_no_outliers %>% 
  left_join(city_coordinates, by = c("city_lower" = "city_lower"))

# Data for labeling the cities, it is faster if fewer rows to go through
labels_data <- real_estate_plot_data %>% 
  group_by(city, lng, lat) %>% 
  summarise()


