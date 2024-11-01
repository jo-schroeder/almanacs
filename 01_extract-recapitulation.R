library(pdftools)
library(stringr)

# Setting working directory 
setwd("~/Documents/git/alamancs")

# Extracting text from pdf using pdftools, saving in txt object
txt <- pdf_text("almanac-test.pdf")
# Uncomment to check out txt object in console
# txt

# Delete everything before recapitulation and archdioceses
txt <- str_split(txt, "RECAPITULATION") 

txt <- str_replace_all(txt, "\\[ARCHDIOCESE].*", "")


txt <- unlist(str_split(txt, "ARCHDIOCESE"))
txt <- str_replace_all(txt[2], "[\\.]", "")

txt %>%
  str_remove_all("((?<=ARCHDIOCESE\\n\\n).)|((?=RECAPITULATION).)")
                 