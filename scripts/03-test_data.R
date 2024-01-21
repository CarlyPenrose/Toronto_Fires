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

#counting how many fire incidents happened per year
cleaned_fire_data |>
  count(year)