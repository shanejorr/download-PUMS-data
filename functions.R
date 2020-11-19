library(tidyverse)
library(glue)
library(R.utils)

create_http_address <- function(state, year, level) {
  
  # perform checks to ensure parameters were properly input
  if (nchar(state) != 2) {
    stop("`state` parameter must be two letter state abbreviation.")
  } else {
    state <- str_to_lower(state)
  }
  
  # get current year
  current_year <- as.integer(format(Sys.Date(), "%Y"))
  
  # ensure year is between 1996 (first year with data) and the current year
  if (!between(year, 1996, current_year)) {
    stop(glue("Year must be an integer between 1996 and {current_year}."))
  }
  
  level <- str_to_lower(level)
  
  # create http address
  if (level == 'population') {
    http_address <- glue("https://www2.census.gov/programs-surveys/acs/data/pums/{year}/1-Year/csv_p{state}.zip")
  } else if (level == 'housing') {
    http_address <- glue("https://www2.census.gov/programs-surveys/acs/data/pums/{year}/1-Year/csv_h{state}.zip")
  } else {
    # level must either be population or housing
    stop("Level must either be 'population' or 'housing'")
  }
  
  return(http_address)
  
}

# download file and delete extra files in downloaded zip file
download_delete <- function(http_address, destination_file_path, download_folder) {
  
  # download file
  download.file(http_address, destfile = destination_file_path, method="curl")
  
  # unzip file so we can remove documentation
  unzip(destination_file_path, exdir = download_folder)
  
  # we want to delete the zip file and PDF documentation
  # first get the file name of the documentation PDF
  delete_files <- list.files(download_folder, pattern = "ACS.*[.]pdf", full.names = TRUE)
  
  # delete documentation PDF and zip file
  file.remove(delete_files, destination_file_path)
  
}

gzip_pums <- function(download_folder, destination_file_path) {
  
  # get file name
  zip_file <- list.files(download_folder, pattern = "[.]csv$", full.names = TRUE)
  
  # create output name for gz file
  gz_output <- str_replace(destination_file_path, ".zip", ".csv.gz")
  
  gzip(zip_file, gz_output, remove = T)
}

# function to download file and unzip if needed state, year, level
download_pums_files <- function(state, year, level, destination_file_path, download_folder) {
  
  # create directory if it does not already exist
  if (!dir.exists(download_folder)){
    dir.create(download_folder)
  }
  
  # combine directory and downloaded zip file name into one object to create complete file path
  download_zip_full_path <- str_c(download_folder, destination_file_path, sep = '/')
  
  # create http address
  http_address <- create_http_address(state, year, level)
  
  # download PUMS file and delete unneeded PDF file
  download_delete(http_address, download_zip_full_path, download_folder)
  
  # gzip remaining csv file
  gzip_pums(download_folder, download_zip_full_path)
  
  # print statement showing operations are complete
  print(glue("Downloaded {level} PUMS data for {state} in {year}."))
}
