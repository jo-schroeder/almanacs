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

gs4_deauth()
gs4_auth(token = gargle::secret_read_rds(
  ".secrets/gs4-token.rds",
  key = "GOOGLE_DRIVE_KEY"
))
#gs4_auth(cache = ".secrets", email = "schroejh@bc.edu", scope = "https://www.googleapis.com/auth/drive")
drive_auth(token = gs4_token())

folder_ids <- c("1vsjVWIWOAH1xN8RPvhgmI6ky1vA7CfcJ",
                "145ECofup4M7ZnA1dUF5_pDZN3OWEK1Yb",
                "1gi-k4cgD-XR_AiaSq6J9OPf3OWwkIPCt",
                "1IYkTrGI07fTcjaggY_12V72syNATNSIp",
                "10-NQy1b9lXuXnm5X_FuzYpetI_1PgjOQ",
                "1FbOjmMtKKbgpDou-eyVbhb162RQJMNy-",
                "1LEYANh7PIV9BIC4GpmWByWR4mi2dNtih")

files <- lapply(folder_ids, function(folder) {
  drive_ls(as_id(folder))
})
files <- do.call("rbind", files) 
files <- files %>% filter(!(str_detect(name, "TEMPLATE")))

for(i in 1:nrow(files)){
        year <- as.numeric(str_extract(files$name[i], "\\d+"))
        place <- str_extract(files$name[i], "[A-Za-z]+")
 # WRITE YEARS
        range_write(files$id[i], 
                   data.frame(year),
                   sheet = "master",
                   range = "AC2",
                   col_names = FALSE,
                   reformat = FALSE)
        range_write(files$id[i], 
                    data.frame("year"),
                    sheet = "master",
                    range = "AC1",
                    col_names = FALSE,
                    reformat = FALSE)
 # WRITE DIOCESE
        range_write(files$id[i], 
                    data.frame(place),
                    sheet = "master",
                    range = "AD2",
                    col_names = FALSE,
                    reformat = FALSE)
        range_write(files$id[i], 
                    data.frame("diocese"),
                    sheet = "master",
                    range = "AD1",
                    col_names = FALSE,
                    reformat = FALSE)
      }


for(i in 1:nrow(files)){
  nrows <- as.numeric(nrow(range_read(files$id[i])))
  
  formulas <- paste0('=ARRAYFORMULA(XLOOKUP(peopleInfo!L', 2:nrows , ' & master!AD$2 & master!AC$2,
  IMPORTRANGE("10rvRUGe4br313NCdOI7saxbwb9xmuY5OyOZkFojPk2k", "personIDs!A:A") & 
  IMPORTRANGE("10rvRUGe4br313NCdOI7saxbwb9xmuY5OyOZkFojPk2k", "personIDs!B:B") & 
  IMPORTRANGE("10rvRUGe4br313NCdOI7saxbwb9xmuY5OyOZkFojPk2k", "personIDs!C:C"),
  IMPORTRANGE("10rvRUGe4br313NCdOI7saxbwb9xmuY5OyOZkFojPk2k", "personIDs!E:E"), ""))')
  
  formula <- as.data.frame(list(formula = formulas)) 
  formula$formula <- gs4_formula(formula$formula)
  
  range_delete(files$id[i], 
               sheet = "peopleInfo", 
               cell_cols("M:O"), 
               shift = NULL)

  range_write(files$id[i], 
              data = formula,
              sheet = "peopleInfo",
              range = paste0("M2:M", nrows),
              col_names = FALSE,
              reformat = FALSE)
}


#library(stringr)
range_write(
  "1bkpm5s8sX86alO_I-ADBUMIagtLLtqOBvpP-dtiUQmY",
  data.frame("wow!"),
  sheet = "Sheet1",
  range = "A1",
  col_names = FALSE,
  reformat = FALSE
)
