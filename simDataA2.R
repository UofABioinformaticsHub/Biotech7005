#' Assign species to each student for A2

library(dplyr)
library(magrittr)
library(readr)

enrolments <- read_tsv("enrolments.tsv")
species <- read_tsv("SpeciesList.tsv")
n <- nrow(enrolments)
set.seed(1735804)
id2species <- sample.int(nrow(species), n)
data_frame(ID = paste0("a", enrolments$Emplid),
           Organism = species$Organism[id2species],
           Species = species$Species[id2species]) %>%
  knitr::kable()