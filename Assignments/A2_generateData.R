# This is to assign each student to a different species for Assignment 2

library(AnnotationHub)
library(pander)
library(taxize)
library(magrittr)
library(tidyverse)

# Q1

# Get the species with a gtf in release 96
ah <- AnnotationHub()
sp <- ah %>% 
	subset(dataprovider == "Ensembl") %>%
	subset(rdataclass == "GRanges") %>%
	query(".gtf") %>%
	mcols() %>%
	as.data.frame() %>%
	filter(grepl("release-96", rdatapath)) %>%
	distinct(species, taxonomyid) %>%
	as_tibble()

# Load the students
ids <- read_tsv("VMs.tsv")

# Define a function to map taxa to the common name
sp2common <- function(sp){
	out <- sci2comm(get_uid(sp))[[1]]
	out <- c(out, "") # Add a blank field in case it comes back empty
	out[[1]]
}

# Map each student to a species
set.seed(7005)
id2sp <- tibble(ID = paste0(ids$Emplid)) %>%
    distinct(ID) %>%
	mutate(species = sample(sp$species, size = nrow(.), replace = FALSE)) %>%
	left_join(sp) %>%
	mutate(
	    Name = vapply(species, sp2common, character(1)),
	    Name = str_to_title(Name),
	    Name = case_when(
	        species == "Nothoprocta perdicaria" ~ "Chilean tinamou",
	        species != "Nothoprocta perdicaria" ~ Name
	    )
	) 

id2sp %>%
	rename(
	    Species = species,
	    `Taxonomy ID` = taxonomyid,
	    `Common Name` = Name
	) %>%
    arrange(ID) %>%
    pander( justify = "llrl", split.tables = Inf, style = "rmarkdown")

# Q4:

ids$Emplid %>%
    sort() %>%
    unique() %>%
    str_remove("a") %>%
    na.omit() %>%
    lapply(function(x){
        set.seed(as.integer(x))
        n <- sample(4:10, 1)
        tibble(
            ID = paste0("a", x),
            Values = paste0(
                "x <- c(",
                rnorm(n, 0.7, 1.5) %>% round(4) %>% paste0(collapse = ", "),
                ")")
        )
    }) %>%
    bind_rows() %>%
    pander(
        split.tables = Inf,
        style = "rmarkdown",
        justify = "ll"
    )
