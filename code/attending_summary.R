library(tidyverse)
library(googlesheets4)

data <- read_csv("~/Downloads/everything (1).csv") %>%
  select(instID, attendingChurch) %>%
  filter(!is.na(attendingChurch))

