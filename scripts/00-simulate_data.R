#### Preamble ####
# Purpose: Simulate data for fire incidents in Toronto over a four year period
#from 2018 to 2022 
# Author: Carly Penrose
# Email: carly.penrose@theijf.org
# Date: 21 January 2024
# Prerequisites: -

#### Workspace setup ####
install.packages("knitr")

library(knitr)
library(janitor)
library(lubridate)
library(opendatatoronto)
library(tidyverse)

#### Simulate the number of casualties per year per ward####

set.seed(256)

start_year <- 2018
end_year <- 2022

# Simulate a dataset counting civilian casualties from fires by ward, 2018-2022
simulated_fire_data <- tibble(
  year = rep(start_year:end_year, each = 25),
  ward = rep(1:25, times = end_year - start_year + 1),
  casualties = rpois(25 * (end_year - start_year + 1), lambda=4)
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
