
cat(paste0("ARRAYFORMULA(IFERROR(IMPORTRANGE(\"", files$id, '\", \"master!A:AD\"), SUBSTITUTE(COLUMN(A:AD)^0, 1, \"\")));'))

cat(paste0("ARRAYFORMULA(IFERROR(IMPORTRANGE(\"", files$id, '\", \"master!A:AD\"), SUBSTITUTE(COLUMN(A:AD)^0, 1, \"\")));'))

cat(paste0("ARRAYFORMULA(IFERROR(IMPORTRANGE(\"", files$id, '\", \"instLocations!A:S\"), SUBSTITUTE(COLUMN(A:S)^0, 1, \"\")));'))

reports_id <- "1hdZ2AVwhP2dGEAkQgR_6c9Q_P8BF2XHBNaTT01EI6wQ"
everything <- read_sheet(reports_id,
                         sheet = "Everything") 

everything %>% filter(persTitle == "Sister") %>% count()

everything %>% filter(persTitle == "Sister") %>%
  mutate(total = n()) %>%
  group_by(persName) %>% 
  mutate(count = n(), unique = ifelse(count > 1, "no", "yes")) %>%
  ungroup(persName, diocese...32) %>% group_by(unique) %>%
  summarise(percent_unique = (n()/total)*100) %>% distinct()

unique_wo_place <- peopleIDs %>% 
  filter(year == 1870) %>% mutate(total = n()) %>%
  group_by(person_id) %>% 
  mutate(count = n(), unique = ifelse(count > 1, "no", "yes")) %>%
  ungroup(person_id, place) %>% group_by(unique) %>%
  summarise(percent_unique = (n()/total)*100) %>% distinct()

unique_w_place <- peopleIDs %>% 
  filter(year == 1870) %>% 
  distinct(person_id, place) %>%
  mutate(total = n()) %>% group_by(person_id) %>% 
  mutate(count = n(), unique = ifelse(count > 1, "no", "yes")) %>%
  ungroup(person_id) %>% group_by(unique) %>%
  summarise(percent_unique = (n()/total)*100) %>% distinct()


data1 <- read_csv("~/Downloads/everything (2).csv") %>%
  fill(c(year, diocese), .direction = c("down")) %>%
  select(instID, year, diocese, attendingChurchNote) %>%
  filter(!(is.na(attendingChurchNote)))


write.csv(data, "attendingChurchNotes.csv")
