#### Preamble ####
# Purpose: clean  data from OpenData Toronto about fire incidents 2018-2021 
#so it is usable for my analysis
# Author: Carly Penrose 
# Email: carly.penrose@theijf.org
# Date: 21 January 2024

#### Set up workspace ####
library(tidyverse)
library(janitor)
library(knitr)
library(lubridate)
library(opendatatoronto)

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

cleaned_fire_data <- cleaned_fire_data |>
  mutate(
    tfs_alarm_time = str_remove(tfs_alarm_time, "-.*"),
    tfs_alarm_time = as.integer(tfs_alarm_time)
  ) |>
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

#change the ward number to a factor instead of an integer
cleaned_fire_data <-cleaned_fire_data

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
  file = "~/Toronto_Fires/outputs/cleaned_fire_data.csv"
)

# reading in the ward file.
ward_profiles_2021 <- 
  read_csv(
  file = "~/Toronto_Fires/inputs/2021_ward_profiles.csv",
  show_col_types = FALSE)

#the data I want is on row 1385. Slicing that and the row above it, which has the ward name. Taken from 
# the tidyverse github account https://dplyr.tidyverse.org/reference/slice.html  
ward_income <- ward_profiles_2021 |> slice(1384)

#skip the first two rows, which are just the title and the median for the City of Toronto overall

median_ward_income <- median_ward_income[-(1:2)]

#I knew to transpose the data, but when trying the function it would always turn into a list. I 
#used ChatGPT for the t(x) transpose function to keep it as a dataframe and to restart the index.
median_ward_income_clean <- as.data.frame(t(median_ward_income))
median_ward_income_clean <- as_tibble(median_ward_income_clean)
median_ward_income_clean <- rownames_to_column(median_ward_income_clean, var = "RowIndex")

#used elections example from Telling Stories with Data to rename the RowIndex column to "ward"
median_ward_income_clean <-
  median_ward_income_clean |>
  rename(
    ward = RowIndex,
    median_income = V1
  )

head(median_ward_income_clean)

#change the ward number to a factor
median_ward_income_clean <-median_ward_income_clean |>
  mutate(
    ward = as.factor(ward),
    median_income = as.numeric(median_income)
  ) 

head(median_ward_income_clean)

#merge the two files for median income and 
#create a new dataset by merging the median income data with the ward data 
#code inspired by Christina Wei's example paper, and helped fine tune with chatgpt
merged_ward_fires <- merge(sum_per_ward, median_ward_income_clean, by = "ward", all = TRUE)

merged_ward_fires <- merged_ward_fires |>
  mutate(
    ward = as.factor(ward),
    median_income = as.numeric(median_income),
    total_casualties = as.integer(total_casualties)
  )

#create a new csv file for the merged ward info and fires  
write_csv(
  x = merged_ward_fires,
  file = "~/Toronto_Fires/outputs/merged_ward_fires.csv"
)

