# Number of deaths from fires by ward income

## Overview

This paper tests the hypothesis that people in lower-income areas face worse outcomes from structure fires. Analysis was completed using data about the number of civilian casualties from fires in each ward between 2018 through 2022 and median ward income, according to 2021 census data.  

## Structure

The repo is structured as follows:

1. **inputs** contains the raw data downloaded from OpenData Toronto

2. **outputs** contains two folders:
* *Data*: all data files generated during analysis 
* *Paper*: both the Quarto document and the final paper pdf

3. **scripts** contains all r scripts:
* *00-simulate_data*: used to run simulated tests of the data
* *01-download_data*: used to download the data from OpenData Toronto
* *02-data_cleaning*: used to clean the data, isolate columns and merge the ward income and fire datasets
* *03-test_data*: used to test the data, run analyses and create plots and graphs.

## Disclosure

Some challenges and troubleshooting issues were addressed with the use of ChatGPT 3.5. Instances where code from ChatGPT was used are identified in the scripts and quarto document.
