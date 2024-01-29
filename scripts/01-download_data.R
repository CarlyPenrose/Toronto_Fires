##### Preamble ####
# Purpose: Read in data from OpenData Toronto about fire incidents 2017-2021.
# Author: Carly Penrose 
# Email: carly.penrose@theijf.org
# Date: 21 January 2024

#### Setup Workspace ####
library(tidyverse)
library(janitor)
library(knitr)
library(lubridate)
library(opendatatoronto)
library(dplyr)

#### Acquire the fire incident data ####
toronto_fires <-
  
  # get all resources for this package
  resources <- list_package_resources("64a26694-01dc-4ec3-aa87-ad8509604f50") |>
  filter(name==
           "Fire Incidents Data.csv") |>
  # get the resource
  get_resource()

write_csv(
  x = toronto_fires,
  file = "~/Toronto_Fires/inputs/toronto_fires.csv"
)

head(toronto_fires)

#### Acquire the data for ward profiles ####

# get package
library(dplyr)
#I went to Sharla Gelfand's github to get code for a multi-sheet xlsx file
#https://sharlagelfand.github.io/opendatatoronto/articles/articles/multisheet_resources.html
ward_profiles <- list_package_resources("https://open.toronto.ca/dataset/ward-profiles-25-ward-model/") |>
  filter(name == "2023-WardProfiles-2011-2021-CensusData") |>
  get_resource()

#further following Gelfand's instruction, used this to isolate the first sheet called "2021 One Variable"
wards_2021 <- ward_profiles[["2021 One Variable"]]

#save the ward profiles data as a csv, used the "as.data.frame" function from example paper 
#https://github.com/christina-wei/INF3104-1-Covid-Clinics/blob/main/scripts/00-download_data.R
write_csv(
  x = as.data.frame(wards_2021),
  file = "~/Toronto_Fires/inputs/2021_ward_profiles.csv"
)

