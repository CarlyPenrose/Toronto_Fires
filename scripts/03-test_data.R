#### Preamble ####
# Purpose: Read in data from fires in Toronto from 2018-2022 and make two graphs:
#one about the number of fire-related casualties per ward, and one about the 
#number of fire-related casualties per year.  
# Author: Carly Penrose
# Email: carly.penrose@theijf.org
# Date: 21 January 2024

#### Read in the data ####
cleaned_fire_data <-
  read_csv(
    file = "cleaned_fire_data1.csv",
    show_col_types = FALSE
  )

head(cleaned_fire_data)
library(janitor)
library(knitr)
library(lubridate)
library(opendatatoronto)
library(tidyverse)

#counting how many fire incidents happened per year
cleaned_fire_data |>
  count(year)

#counting how many fire incidents happened in each ward 
print(
  cleaned_fire_data |>
    count(ward),
  n=25)

# Calculate the sum of civilian casualties per year
sum_per_year <- cleaned_fire_data |> group_by(year) |> 
  summarize(deaths = sum(deaths))

death_count_per_year <- cleaned_fire_data |>
  group_by(year) |>
  summarize(total_deaths = sum(deaths, na.rm = TRUE))

death_count_per_year

# Display the result
print(sum_per_year)

# creates a csv file of this data
write_csv(
  x = sum_per_year,
  file = "sum_per_year.csv"
)

# Calculate the sum of civilian casualties in each ward
print(
  sum_per_ward <- cleaned_fire_data |> group_by(ward) |> 
    summarize(total_casualties = sum(deaths)),
  n=25)

head(sum_per_ward)

# creates a csv file of ward data
write_csv(
  x = sum_per_ward,
  file = "sum_per_ward.csv"
)


#create a graph of the number of fire incidents per ward 

cleaned_fire_data |>
  ggplot(aes(x = ward)) +
  geom_bar() +
  theme_minimal() + # Make the theme neater
  labs(title = "Number of fire incidents per ward, 2018-2022", 
       x = "Ward", y = "Number of fires") 

#create a graph of number of fire incidents per year 
cleaned_fire_data |>
  ggplot(aes(x = year)) +
  geom_bar() +
  theme_minimal() + 
  labs(title = "Number of fires in Toronto by year, 2018-2022",
       x = "Year", y = "Number of fires"
       ) 

# create a graph of the number of civilian deaths due to fires per year 

ggplot(sum_per_year, aes(x = factor(year), y = deaths)) +
  geom_bar(stat = "identity") +
  labs(title = "Total civilian casualties in fire incidents by year",
       x = "Year",
       y = "Total Civilian Casualties") +
  theme_minimal()

# create a graph of the number of civilian deaths due to fires per ward

ggplot(sum_per_ward, aes(x = factor(ward), y = total_casualties)) +
  geom_bar(stat = "identity") +
  labs(title = "Total civilian casualties in fire incidents by ward, 2018-2022",
       x = "Ward",
       y = "Total civilian casualties") +
  theme_minimal() 

# create a scatterplot comparing the number of civilian casualties per ward to the median income per ward
#code adapted from Telling Stories with Data chapter 5
merged_ward_fires |>
  ggplot(mapping = aes(x = income, y = total_casualties, color = ward)) +
  geom_point()+
  geom_smooth(method = lm, color = "black", se = FALSE) +
  labs(title= "Number of civilian deaths from fires by ward income, 2018-2022",
       x = "Median income of ward in 2020",
       y = "Number of civilian deaths from fires per ward")+
  theme_minimal()
