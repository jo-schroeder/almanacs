library(dplyr)
library(readr)
library(tidyr)
library(stringr)
library(googledrive)
library(googlesheets4)
library(DT)
library(purrr)
library(lubridate)
library(gargle)
library(data.table)

gs4_deauth()
gs4_auth(token = gargle::secret_read_rds(
  ".secrets/gs4-token.rds",
  key = "GOOGLE_DRIVE_KEY"
))
#gs4_auth(cache = ".secrets", email = "schroejh@bc.edu", scope = "https://www.googleapis.com/auth/drive")
drive_auth(token = gs4_token())

diocese <- read_sheet("1ZFY8n9QhvnUxhjSfZWi2n53QSAmDPmFWoCqxRUWpDQk", 
                           sheet = "Formatted Dioceses in each year") %>%
           filter(!is.na(`root no`)) %>% 
           pivot_longer(cols = "1895":"1834",
                         names_to = "year",
                         values_to = "name") %>%
           mutate(name = str_remove(name, "(?<=\\().*(?=\\))")) %>%
           mutate(name = str_remove_all(name, "[:punct:]")) %>%
           mutate(name = (str_remove_all(name , "\\s"))) %>% 
           mutate(name = case_when(
             name == "NewYork" ~ "NewYorkCity",
             name == "SantaFé" ~ "SantaFe",
             name == "SanteFé" ~ "SantaFe",
             name == "SantaFé" ~ "SantaFe",
             name == "Harrisburgh" ~ "Harrisburg",
             name == "VAMontanaincorrectlyrecordedinalmanacwithnoinstitutions" ~
               "VAMontana",
             name == "MarquetteandSautSainteMarie" ~ "Marquette",
             name == "SautSainteMarie" ~ "Marquette",
             name == "SautSaintMarie" ~ "Marquette",
             name == "MontereyandLosAngeles" ~ "Monterey",
             .default = name
           ))


write.csv(diocese, './_data/diocese_year_crosswalk.csv')

range_write("10rvRUGe4br313NCdOI7saxbwb9xmuY5OyOZkFojPk2k",
            diocese,
            sheet = "dioceseCrosswalk")  

diocese_filtered <- diocese %>% dplyr::filter(str_detect(year, "1870|1869|1868|1867|1866|1865|1864"))

                                              