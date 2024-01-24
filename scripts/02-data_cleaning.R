title: "clean_fire_data"
author: "Carly Penrose"
format: html
---
  
  ##### Preamble ####
# Purpose: clean  data from OpenData Toronto about fire incidents 2018-2021 
#so it is usable for my analysis
# Author: Carly Penrose 
# Email: carly.penrose@theijf.org
# Date: 21 January 2024

#### Set up workspace ####
library("tidyverse")
library("janitor")
library("knitr")
library("lubridate")
library("opendatatoronto")

#preview the data
head(toronto_fires)
tail(toronto_fires)

# Make the names easier to type
cleaned_fire_data <-
  clean_names(toronto_fires)

# checking any changes from the name cleaning
head(cleaned_fire_data)
tail(cleaned_fire_data)

#select the columns I want
cleaned_fire_data <-
  cleaned_fire_data |>
  select(civilian_casualties, incident_ward, tfs_alarm_time)

head(cleaned_fire_data)

#remove all values after the first dash in the year
#code taken from a combination of telling stories with data, 
#https://stackoverflow.com/questions/71974098/how-to-remove-everything-after-a-space-in-a-column-of-an-r-data-frame 
#and ChatGPT LLM to clean up errors in my code from combining the two methods

cleaned_fire_data <- cleaned_fire_data %>%
  mutate(
    tfs_alarm_time = str_remove(tfs_alarm_time, "-.*"),
    tfs_alarm_time = as.integer(tfs_alarm_time)
  ) %>%
  rename(deaths = civilian_casualties, ward = incident_ward, year = tfs_alarm_time)

head(cleaned_fire_data)
tail(cleaned_fire_data)

#change N/A to zero for civilian_casualties column, to standardize
  cleaned_fire_data[is.na(cleaned_fire_data)] <- 0

#check that the NA values were replaced with 0
head(cleaned_fire_data)
tail(cleaned_fire_data)

#refining the data to years 2018 and later 
cleaned_fire_data <-
  filter(cleaned_fire_data, year >= 2018)

#re-check the tests to see if the filter worked 
cleaned_fire_data$ward |> min() == 1
cleaned_fire_data$ward |> max() == 25
cleaned_fire_data$year |> min() == 2018
cleaned_fire_data$year |> max() == 2022
cleaned_fire_data$deaths |> min() == 0
cleaned_fire_data$deaths |> class() == "integer"

#refining the data so that the ward number is 1 or greater to deal with empty data or N/A values.
cleaned_fire_data <-
  filter(cleaned_fire_data, ward >= 1)


#save the cleaned data as a new file
write_csv(
  x = cleaned_fire_data,
  file = "cleaned_fire_data1.csv"
)


