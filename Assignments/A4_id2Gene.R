library(tidyverse)
library(pander)

# Run this from the project root directory

# First download the gff:
system2("wget", "ftp://ftp.ensemblgenomes.org/pub/plants/current/gff3/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.44.gff3.gz")

# Extract the gene IDs
system2("zcat",  "Arabidopsis_thaliana.TAIR10.44.gff3.gz | egrep '.+\\s.+\\sgene\\s' | cut -f9 | sed -r 's/ID=gene:([^;]+);.+/\\1/g' > Assignments/AthalianaIDs.txt")

# Now assign each student ID to a gene:
ids <- read_csv("enrolments.tsv")
genes <- readLines("Assignments/AthalianaIDs.txt")
set.seed(7005)
tibble(ID = paste0("a", ids$Emplid),
			 Gene = sample(genes, size = nrow(ids))) %>%
	pander(style = "rmarkdown",
				 justify = "ll")
