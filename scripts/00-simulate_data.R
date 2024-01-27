###Preamble###
# Purpose: Simulate data for fire incidents in Toronto over a four year period
#from 2018 to 2022 
# Author: Carly Penrose
# Email: carly.penrose@theijf.org
# Date: 21 January 2024
# Prerequisites: -

#### Workspace setup ####

library(janitor)
library(lubridate)
library(opendatatoronto)
library(tidyverse)
library(knitr)

#### Simulate the number of casualties per year per ward####
set.seed(256)

start_year <- 2018
end_year <- 2022

# Simulate a dataset counting civilian casualties from fires by ward, 2018-2022
#needed some additional help from ChatGPT to properly set up the rpois and lambda element
simulated_fire_data <- tibble(
  "year" = rep(start_year:end_year, each = 25),
  "ward" = rep(1:25, times = end_year - start_year + 1),
  "casualties" = rpois(25 * (end_year - start_year + 1), lambda=4)
)  

# Display the result
print(simulated_fire_data)

#### Setting up tests for the fire data ####
simulated_fire_data$ward |> min() == 1
simulated_fire_data$ward |> max() == 25
simulated_fire_data$year |> min() == 2018
simulated_fire_data$year |> max() == 2022
simulated_fire_data$casualties |> min() == 0
simulated_fire_data$casualties |> class() == "integer"


#Simulate a dataset counting civilian casualties from fires by ward income 
set.seed(256)

simulated_fire_by_income_data <- tibble(
  "ward" = 1:25,
  #got help from Telling Stories with Data neonatal mortality rate to help me set parameters to randomly pick an income between $60,000 and $90,000
  "income" = runif(n = 25, min = 60000, max = 90000),
  "casualties" = rpois(25, lambda=30)
)  

head(simulated_fire_by_income_data)

simulated_fire_by_income_data$ward |> min() == 1
simulated_fire_by_income_data$ward |> max() == 25
#because the data is randomly generated, this wasn't working with the == operator, 
#so I've changed to >= or <= where appropriate
simulated_fire_by_income_data$income |> min() >= 60000
simulated_fire_by_income_data$income |> max() <= 90000
simulated_fire_by_income_data$casualties |> min() >= 0
simulated_fire_by_income_data$casualties |> class() == "integer"

