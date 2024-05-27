# Project: Convert ITIS Number to species scientific name.

# Project Description: This script will convert ITIS number to scientific name
# in ITIS column from impact tables scraped from NAS database. This script is
# outdated - use the impactDataPull_Full.ipynb script instead.

# Developer: Joseph Redinger

# import libraries
library(taxize)
library(readxl)
library(dplyr)
library(openxlsx)


# load excel
nas.df <- read_excel("cisco_impact_data_2024-05-04.xlsx")

# create function to get scientific name from ITIS number 
get_species = function(itis_numbers) {
  
  output = list()
  
  if (is.na(itis_numbers)) {
    
    return(NA)
    
  } else {
    
    a = strsplit(itis_numbers, ", ")[[1]]
    
    output = list()
    
    for (itis in a) {
      
      x = id2name(as.numeric(itis), db = 'itis')[[1]]$name
      
      output = c(output, x)
      
      output = paste(output, collapse = ", ")
      
    }
    
    return(output)
  }
  
}


df$"Impacted Species" <- sapply(df$"Associated TSNs", get_species)
nas.df <- nas.df %>% relocate(`Impacted Species`, .after = `Associated TSNs`)

# Export
write.xlsx(df, "NAS_output_final.xlsx")
