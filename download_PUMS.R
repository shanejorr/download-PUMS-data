#######################################################################
#
# Example of an R script that iterates through multiple years, 
# downloading PUMS data.
#
# This script downloads all housing and population PUMS files
# from North Carolina between 2008 and 2019.
#
#######################################################################

library(tidyverse)
library(glue)
library(R.utils)

source('functions.R')

# Parameters to change ----------------------------

# specify all years that you want to download PUMS data for
years <- seq(2008, 2019, 1)

# two letter state abbreviation
state_abb <- 'nc'

# directory to download zip files to
# NOTE: directory will be created if it does not already exist
download_folder_pop <- "pums_pop_nc"
download_folder_house <- "pums_house_nc"

# End parameters to change ----------------------------

# create names of the zip file that will be downloaded
housing_files <- glue("housing-{state_abb}-{years}.zip")
pop_files <- glue("pop-{state_abb}-{years}.zip")

# download housing data
map2(years, housing_files, download_pums_files, 
     state = state_abb, level = 'housing', download_folder = download_folder_house)

# download population data
map2(years, pop_files, download_pums_files, 
<<<<<<< HEAD
     state = state_abb, level = 'population', download_folder = download_folder_pop)
=======
     state = 'nc', level = 'population', download_folder = 'pums_pop')
>>>>>>> dfc9517da2f86d7e0f84cb3d290a4a4e382a4a04
