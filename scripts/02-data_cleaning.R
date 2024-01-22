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

#### running my up tests for the fire data ####
cleaned_fire_data$ward |> min() == 1
cleaned_fire_data$ward |> max() == 25
cleaned_fire_data$year |> min() == 2018
cleaned_fire_data$year |> max() == 2022
cleaned_fire_data$civilian_casualties |> min() == 0
cleaned_fire_data$civilian_casualties |> class() == "integer"

#data didn't pass the tests, looked found that there is pre-2018 data buried
#in the dataset, so I have to go in and refine so the data only includes 2018
#data and later. This should also solve the ward numbering issue because pre-2018
#wards had a different numbering system

#refining the data to years 2018 and later 
cleaned_fire_data <-
  filter(cleaned_fire_data, year >= 2018)

#re-check the tests to see if the filter worked 
cleaned_fire_data$ward |> min() == 1
cleaned_fire_data$ward |> max() == 25
cleaned_fire_data$year |> min() == 2018
cleaned_fire_data$year |> max() == 2022
cleaned_fire_data$civilian_casualties |> min() == 0
cleaned_fire_data$civilian_casualties |> class() == "numeric"

#noticed the the minimum for the ward number still isn't 1. Opened the csv, found
#there are five instances where the ward number is 0, or is not filled in. 
#for the purposes of this project, I will exclude these instances, but in most 
#situations I would call the data provider to discuss what may have happened and
#to use that to decide how to treat this information.

#refining the data so that the ward number is 1 or greater.
cleaned_fire_data <-
  filter(cleaned_fire_data, ward >= 1)

#running the tests one final time
#re-check the tests to see if the filter worked 
cleaned_fire_data$ward |> min() == 1
cleaned_fire_data$ward |> max() == 25
cleaned_fire_data$year |> min() == 2018
cleaned_fire_data$year |> max() == 2022
cleaned_fire_data$civilian_casualties |> min() == 0
cleaned_fire_data$civilian_casualties |> class() == "numeric"


#save the cleaned data as a new file
write_csv(
  x = cleaned_fire_data,
  file = "cleaned_fire_data1.csv"
)


