#################################
# Load necessary libraries
library(stringr)
library(dplyr)

# Here are our pages
numbers <- 819941:820657 #all pages
#numbers <- 820024:820034 #this is small for an example
#numbers <- 820061:820062 #error example
#numbers <- 820327 #error example
recapitulation <- list()
for (i in numbers) {
  print(paste0("We're on page ", ((i - 819941) + 1)))
  url <- paste0("https://digital.library.villanova.edu/files/vudl:", i ,"/OCR-DIRTY")
  text <- readLines(url, warn = FALSE)
  text <- paste(text, collapse = " ")
  if (str_detect(text, "RECAPITULATION") == TRUE) {
    print("We have recapitulation!")
    print(text)
    
    text <- str_replace_all(text, "[\r\n]+", " ")    # Replace line breaks
    text <- str_replace_all(text, "\\.+", " ")       # Replace multiple dots with a single space
    text <- str_squish(text)                         # Remove extra whitespace
    
    # Step 3: Extract the section between "RECAPITULATION" and "ARCHDIOCESE OF NEW YORK"
    # This should capture everything between the two keywords without interruption
    
    recap_text <- str_extract(text, "RECAPITULATION(.*?)DIOCESE OF")
    
    ## Need to match: Archdiocese, Diocese, Province (messed up OCR?), End of page
    # Display extracted section for verification
    cat(recap_text)
    
    # Check if extraction was successful
    if (is.na(recap_text) || nchar(recap_text) == 0) {
      message("Extraction of 'RECAPITULATION' section failed.")
      recapitulation[[paste0("Page ", ((i - 819941) + 1))]] <- "FAILED"
      
    } else {
    
    # Step 4: Refine text to remove unwanted characters within the recap_text
    cleaned_text <- str_replace_all(recap_text, "[.,|]+", " ")
    cleaned_text <- str_squish(cleaned_text)  # Collapse extra whitespace to ensure readability
    
    # Step 5: Define regex pattern to capture multi-word entities followed by numbers
    # The pattern captures names with multiple words or punctuation and numbers with commas
    pattern <- "([A-Za-z ,'-]+?)\\s+(\\d{1,3}(?:,\\d{3})*)"
    
    # Find all matches for entity-number pairs in the cleaned text
    matches <- str_match_all(cleaned_text, pattern)[[1]]
    
    # Convert matches into a data frame and ensure complete rows
    results <- data.frame(Entity = str_trim(matches[, 2]), Number = str_trim(matches[, 3]), stringsAsFactors = FALSE)
    results <- results[complete.cases(results), ]  # Remove any rows with NA values
    
    # Display the results
    print(results)
    
    recapitulation[[paste0("Page ", ((i - 819941) + 1))]] <- results
    }
    }
  else {
    print("We're moving on.")
  }
  Sys.sleep(5)
}

saveRDS(recapitulation, "recapitulation.RDS")

