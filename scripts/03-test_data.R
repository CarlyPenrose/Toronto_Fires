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
    file = "cleaned_fire_data.csv",
    show_col_types = FALSE
  )

head(cleaned_fire_data)

#running the tests
cleaned_fire_data$ward |> min() == 1
cleaned_fire_data$ward |> max() == 25
cleaned_fire_data$year |> min() == 2018
cleaned_fire_data$year |> max() == 2022
cleaned_fire_data$civilian_casualties |> min() == 0
cleaned_fire_data$civilian_casualties |> class() == "numeric"

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
  summarize(total_casualties = sum(civilian_casualties))

# Display the result
print(sum_per_year)

# Calculate the sum of civilian casualties in each ward
print(
  sum_per_ward <- cleaned_fire_data |> group_by(ward) |> 
    summarize(total_casualties = sum(civilian_casualties)),
  n=25)

head(sum_per_ward)

#create a graph of the number of fire incidents per ward 

cleaned_fire_data |>
  ggplot(aes(x = ward)) + # aes abbreviates "aesthetics" 
  geom_bar()

cleaned_fire_data |>
  ggplot(aes(x = ward)) +
  geom_bar() +
  theme_minimal() + # Make the theme neater
  labs(x = "Ward", y = "Number of fires") # Make labels more meaningful


#create a graph of number of fire incidents per year 
cleaned_fire_data |>
  ggplot(aes(x = year)) +
  geom_bar()

cleaned_fire_data |>
  ggplot(aes(x = year)) +
  geom_bar() +
  theme_minimal() + 
  labs(x = "Year", y = "Number of fires") 

#create a graph of the number of civilian deaths due to fires per ward 



#create a graph of the number of civilian deaths due to fires per year


