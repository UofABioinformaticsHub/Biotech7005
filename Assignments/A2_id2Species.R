# This is to assign each student to a different species for Assignment 2

library(AnnotationHub)
library(pander)
library(taxize)
library(magrittr)
library(tidyverse)

# Get the species with a gtf in release 92
ah <- AnnotationHub()
sp <- ah %>% 
	subset(dataprovider == "Ensembl") %>%
	subset(rdataclass == "GRanges") %>%
	query(".gtf") %>%
	mcols() %>%
	as.data.frame() %>%
	filter(grepl("release-96", rdatapath)) %>%
	distinct(species, taxonomyid) %>%
	as_data_frame()

# Load the students
ids <- read_tsv("enrolments.tsv")

# Define a function to map taxa to the common name
sp2common <- function(sp){
	out <- sci2comm(get_uid(sp))[[1]]
	out <- c(out, "") # Add a blank field in case it comes back empty
	out[[1]]
}

# Map each student to a species
set.seed(7005)
id2sp <- data_frame(ID = paste0("a", ids$Emplid)) %>%
	mutate(species = sample(sp$species, size = nrow(.))) %>%
	left_join(sp) %>%
	mutate(Name = vapply(species, sp2common, character(1)),
				 Name = str_to_title(Name)) 

id2sp %>%
	rename(Species = species,
				 `Taxonomy ID` = taxonomyid,
				 `Common Name` = Name) %>%
	arrange(ID) %>%
	pander( justify = "llrl", split.tables = Inf, style = "rmarkdown")
