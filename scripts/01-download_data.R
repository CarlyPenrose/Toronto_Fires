---
title: "download_fire_data"
author: "Carly Penrose"
format: html
---

##### Preamble ####
# Purpose: Read in data from OpenData Toronto about fire incidents 2017-2021.
# Author: Carly Penrose 
# Email: carly.penrose@theijf.org
# Date: 21 January 2024

#### Setup Workspace ####
library("tidyverse")
library("janitor")
library("knitr")
library("lubridate")
library("opendatatoronto")
library("dplyr")

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
  file = "toronto_fires.csv"
)

head(toronto_fires)

#### Acquire the data for ward profiles to isolate income ####

#used code from https://arbor-analytics.com/post/getting-your-data-into-r-from-google-sheets/ to help me include the code from the ward profiles#
install.packages("googlesheets4")
library(googlesheets4)

Ward_median_income <- read_sheet("https://docs.google.com/spreadsheets/d/1GhXf26tWdIasxY-KDeeGfmWv3EPXFACMI8gRtYWI1e8/edit?usp=sharing")

Ward_median_income
