# Downloading US Census PUMS files

The Public Use Microdata Sample (PUMS) files are individual-level responses from the US Census American Community Survey (ACS). This repo allows users to programatically download the population and household files by state. The final output is a gunzip (gz) file for a level (population or housing), year, and state combination. The unzipped data is a csv file.

The primary function used is: `download_pums_files`.

### Function parameters

- state: two letter abbreviation of state, can be lower or upper case (string)
- year = the year to extract PUMS data for (integer)
- level = whether to download popualtion or housing PUMS data (string)
  - Options:
    - 'population' = population data
    - 'housing' = housing data
- destination_file_path = the file name to give the initial downloaded .zip file. Must end in '.zip'. This name will also be the file name of the gz file, but it will end in '.csv.gz' instead of .zip. (string)
- download_folder = An empty folder to download the .zip files into. The folder will be created if it does not exist.

### Example

Download the 2019 North Carolina population PUMS data set. Save files to `pums_pop`.

```r
# download 2019 North Carolina population PUMS dataset

download_pums_files(state = 'nc', 
                    year = 2019, 
                    level = 'population', 
                    destination_file_path = 'population_nc_2019.zip', 
                    download_folder = 'pums_pop')
```

Download multiple years iteratively. The following code downloads all North Carolina population PUMS files from 2010 to 2019.

```r
# vector of needed years
years <- seq(2010, 2019, 1)

# names of downloaded .zip files
pop_files <- glue("population_nc_{years}.zip") 

# download NC population PUMS files for each year
map2(years, pop_files, download_pums_files, 
     state = 'nc', level = 'population', download_folder = 'pums_pop')
```

Since the .gz files are compressed .csv files, users can import them as R data frames the same way they would import .csv files:

```r
read_csv('pums_pop/population_nc_2010.csv.gz)
```
An additional example of usage is found in `download_PUMS.R.`

*NOTE:* The function only downloads 1-year files. It will be modified in the future to also download 5-year files.
