# Assignment 2 [*25 marks*]

**Due before 12pm, Monday 21st August**

Your answers to all questions should be submitted to myUni as a `.zip` file containing both scripts, and the answers to the statistics questions in Rmarkdown format.

## Required scripts [*13 marks*]

1. Write a script to:
    + Download the gff3 file for your assigned species (see bottom of page) to your current directory from  [*1 mark*]
    + Count how many of each feature type there is [*2 marks*]
    + Export the results to a file with a name of the form `species_gff_features.txt` [*1 mark*]
    + Include one or more comment lines before the table detailing which build of the genome was used, and the code executed to generate the summary [*2 marks*]

2. For the file we used in the practicals (Drosophila_melanogaster.BDGP6.ncrna.fa), add to the final practical script provided so that:
    + the output contains a meaningful header [*1 mark*]
    + the output contains column names [*2 marks*]
    + the output includes: a) gene id; b) chromosome; c) start; d) stop; e) strand and f) gene_biotype [*3 marks*]
    + Any comments which make the script easier to understand [*1 mark*]

## Statistics questions [*12 marks*]

In a single Rmarkdown file answer the following questions:

1. Two strains of barley have bene genotyped at 100,000 SNPs. Differences between strains at each SNP are unknown, and of great interest to researchers investigating drought tolerance. 50 plants from each strain have been genotyped to estimate SNP frequencies between the two populations.
    a) For an individual SNP, what test would be appropriate for this comparison? [*1 mark*]
    b) Define $H_0$ and $H_A$ for each individual SNP. [*2 marks*]
    c) If there was no true difference in any SNP frequencies s between the two strains, how many p-values would you expect to see < 0.05 [*1 mark*]
    d) Using Bonferroni's method, what would a suitable cutoff value be to consider a SNP to have different frequencies betwen strains, i.e. to reject $H_0$ [*1 mark*]

2. An experiment was repeated 5 times, in which GFP fluorescence was measured in a cell culture as a measurement of gene expression, both *before* and *after* treatment with rapamycin.
GFP was present on a plasmid as a reporter for activity at a specific promoter.
The change in fluorescence obtained were the following values, presented on the log2 scale.

```{r}
x <- c(3, 1.9, 2.7, 3.4, 4.1)
```

    a) Define $H_0$ and $H_A$ [*2 marks*]
    b) Calculate the sample mean and sample variance? [*2 marks*]
    c) Calculate the *T*-statistic. [*1 mark*]
    d) What would the degrees of freedom be for a *t*-test? [*1 mark*]
    e) Calculate the *p*-value using `R` [*1 mark*]

## Species For Question 1

*If your student number is not listed, please contact Dan to ensure you are added to the list*

|      ID|Organism     |Species                    |
|-------:|:------------|:--------------------------|
| 1735804|Cat          |Felis catus                |
| 1696678|Fugu         |Takifugu rubripes          |
| 1611214|Olive baboon |Papio anubis               |
| 1691643|Spotted gar  |Lepisosteus oculatus       |
| 1667810|Rat          |Rattus norvegicus          |
| 1733239|Duck         |Anas platyrhynchos         |
| 1718998|Tilapia      |Oreochromis niloticus      |
| 1731952|Xenopus      |Xenopus tropicalis         |
| 1710508|Opossum      |Monodelphis domestica      |
| 1690770|Coelacanth   |Latimeria chalumnae        |
| 1652167|Pig          |Sus scrofa                 |
| 1714893|Platypus     |Ornithorhynchus anatinus   |
| 1702741|Mouse        |Mus musculus               |
| 1701030|Orangutan    |Pongo abelii               |
| 1662822|Hyrax        |Procavia capensis          |
| 1606913|Human        |Homo sapiens               |
| 1731155|Anole lizard |Anolis carolinensis        |
| 1713960|Zebrafish    |Danio rerio                |
| 1674898|Macaque      |Macaca mulatta             |
| 1729128|C.savignyi   |Ciona savignyi             |
| 1719003|Squirrel     |Ictidomys tridecemlineatus |
| 1660066|Armadillo    |Dasypus novemcinctus       |
| 1710741|Dolphin      |Tursiops truncatus         |
| 1673245|Flycatcher   |Ficedula albicollis        |
| 1701389|Cave fish    |Astyanax mexicanus         |
| 1701747|Chimpanzee   |Pan troglodytes            |
| 1643251|Gorilla      |Gorilla gorilla gorilla    |
| 1735934|Rabbit       |Oryctolagus cuniculus      |
| 1738360|Megabat      |Pteropus vampyrus          |
| 1619733|Ferret       |Mustela putorius furo      |
| 1683838|Mouse Lemur  |Microcebus murinus         |
