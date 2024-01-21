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

# take a look
head(cleaned_fire_data)
tail(cleaned_fire_data)

# Convert the fire_under_control_time column to a date object
cleaned_fire_data$tfs_alarm_time <- as.Date(cleaned_fire_data$tfs_alarm_time)

# Extract the year from the full_date column using lubridate
cleaned_fire_data$year_only <- year(cleaned_fire_data$tfs_alarm_time)

#see what just happened there
head(cleaned_fire_data)

# select the columns I want to focus on for my analysis, casualties, ward, and year
cleaned_fire_data <-
  cleaned_fire_data |>
  select(
    civilian_casualties,
    incident_ward,
    year_only
  )

#look at the data  
head(cleaned_fire_data)
tail(cleaned_fire_data)

#rename the columns 
cleaned_fire_data <-
  cleaned_fire_data |>
  rename(
    ward = incident_ward ,
    year = year_only
  )

#look again
head(cleaned_fire_data)
tail(cleaned_fire_data)

#change N/A to zero for civilian_casualties column, to standardize
  cleaned_fire_data[is.na(cleaned_fire_data)] <- 0

#check that the NA values were replaced with 0
head(cleaned_fire_data)
tail(cleaned_fire_data)

#save the cleaned data as a new file
write_csv(
  x = cleaned_fire_data,
  file = "cleaned_fire_data.csv"
)
