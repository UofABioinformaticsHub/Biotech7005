# Assignment 2 [*29 marks*]

**Due before 12pm, Tuesday 21st August**

Your answers to all questions should be submitted to myUni as a `.zip` file containing separate scripts for Q1 and Q2, and the answers to the statistics questions (Q3 and Q4) in a single Rmarkdown document.
Note that the file `my_species_gff_features.txt` is not required as part of your submission for Q1, only the script which will generate this file.
Similarly, for Q2, only the script is required.

## Required scripts [*14 marks*]

1. Write a script to:
    + Download the gff3 file for your assigned species ([see bottom of page](#species-for-question-1)) to your current directory from Ensembl [*1 mark*]
    + Count how many of each feature type there is, sorted in numerical order [*3 marks*]
    + Export the results to a file with a name of the form `my_species_gff_features.txt` **where you use your assigned species name instead of** `my_species` [*1 mark*]
    + Include one or more comment lines before the table detailing which build of the genome was used, and the code executed to generate the summary [*2 marks*]

2. For the file we used in the practicals (Drosophila_melanogaster.BDGP6.ncrna.fa), add to the final practical script provided so that:
    + the output contains a meaningful header [*1 mark*]
    + the output contains column names [*2 marks*]
    + the output includes: a) gene id; b) chromosome; c) start; d) stop; e) strand and f) gene_biotype [*3 marks*]
    + Any comments which make the script easier to understand [*1 mark*]

## Statistics questions [*15 marks*]

In a single Rmarkdown file answer the following questions:

3. Two groups of people have volunteered to take part in a genetic study. Group 1 (n = 126) are volunteers with no history of Type I Diabetes in their immediate family, whilst Group 2 (n = 183) have all been diagnosed with Type I Diabetes. A genotyping study was undertaken on these volunteers using 25,786 SNPs selected due to their proximity to key immune genes.
Researchers are looking to identify any SNP genotypes which may increase the risk of Type I Diabetes. In your answer, consider the reference SNP allele as `A` and the alternate SNP allele as `B`, using the genotypes `AA`, `AB` and `BB`.

    a. For an individual SNP, what test would be appropriate for this comparison? [*1 mark*]  
    b. Define H~0~ and H~A~ for the genotype at each individual SNP. [*2 marks*]  
    c. If there was no true difference in any genotypes between the two groups, how many p-values would you expect to see < 0.05 [*1 mark*]  
    d. Using Bonferroni's method, what would a suitable cutoff value be to consider a SNP as being associated with an increased risk of Type I diabetes, i.e. to reject H~0~ [*1 mark*]
    e. Given the following genotype table, would you accept or reject H~0~?[*3 marks*]

| Group | AA   | AB  | BB |
| ----- | ---- | --- | --- |
| Control | 23 | 61  | 42 |
| T1D     | 23 | 56 | 104 |


4. An experiment was repeated 7 times, in which GFP fluorescence was measured in a cell culture as a measurement of gene expression, both *before* and *after* viral transfection.
GFP was present on a plasmid as a reporter for activity at a specific promoter.
The change in fluorescence values obtained are given below as the vector `x`, presented on the log~2~ scale.  

    a. Define H~0~ and H~A~ [*2 marks*]  
    b. Calculate the sample mean and sample variance in `R` [*2 marks*]  
    c. Calculate the *T*-statistic using `R`. [*1 mark*]
    d. What would the degrees of freedom be for a *t*-test? [*1 mark*]  
    e. Calculate the *p*-value using `R` [*1 mark*]


```{r}
x <- c(3.1, 2.9, 0.7, 3.4, -0.2, 2.6, 1.9)
```


## Species For Question 1

*If your student number is not listed, please contact Dan to ensure you are added to the list*

| ID       | Species                  | Taxonomy ID | Common Name                    |
|:---------|:-------------------------|------------:|:-------------------------------|
| a1077937 | Rattus norvegicus        |       10116 | Norway Rat                     |
| a1606913 | Sarcophilus harrisii     |        9305 | Tasmanian Devil                |
| a1614956 | Gasterosteus aculeatus   |       69293 | Three-Spined Stickleback       |
| a1619861 | Pan troglodytes          |        9598 | Chimpanzee                     |
| a1634284 | Astyanax mexicanus       |        7994 | Mexican Tetra                  |
| a1653192 | Papio anubis             |        9555 | Olive Baboon                   |
| a1679812 | Drosophila melanogaster  |        7227 | Fruit Fly                      |
| a1680333 | Callithrix jacchus       |        9483 | White-Tufted-Ear Marmoset      |
| a1688727 | Petromyzon marinus       |        7757 | Sea Lamprey                    |
| a1689798 | Mus caroli               |       10089 | Ryukyu Mouse                   |
| a1696632 | Latimeria chalumnae      |        7897 | Coelacanth                     |
| a1711220 | Rhinopithecus roxellana  |       61622 | Golden Snub-Nosed Monkey       |
| a1711533 | Erinaceus europaeus      |        9365 | Western European Hedgehog      |
| a1711935 | Dasypus novemcinctus     |        9361 | Nine-Banded Armadillo          |
| a1715156 | Macaca mulatta           |        9544 | Rhesus Monkey                  |
| a1729553 | Gorilla gorilla          |        9593 | Western Gorilla                |
| a1731217 | Microcebus murinus       |       30608 | Gray Mouse Lemur               |
| a1733230 | Oryctolagus cuniculus    |        9986 | Rabbit                         |
| a1733253 | Macaca nemestrina        |        9545 | Pig-Tailed Macaque             |
| a1735373 | Aotus nancymaae          |       37293 | Ma's Night Monkey              |
| a1737554 | Procavia capensis        |        9813 | Cape Rock Hyrax                |
| a1737558 | Cercocebus atys          |        9531 | Sooty Mangabey                 |
| a1737886 | Tetraodon nigroviridis   |       99883 | Spotted Green Pufferfish       |
| a1739624 | Peromyscus maniculatus   |       10042 | North American Deer Mouse      |
| a1742674 | Heterocephalus glaber    |       10181 | Naked Mole-Rat                 |
| a1743741 | Gallus gallus            |        9031 | Chicken                        |
| a1745148 | Rhinopithecus bieti      |       61621 | Black Snub-Nosed Monkey        |
| a1751618 | Saccharomyces cerevisiae |        4932 | Baker's Yeast                  |
| a1752614 | Tupaia belangeri         |       37347 | Northern Tree Shrew            |
| a1755150 | Caenorhabditis elegans   |        6239 |                                |
| a1759891 | Dipodomys ordii          |       10020 | Ord's Kangaroo Rat             |
| a1760382 | Danio rerio              |        7955 | Zebrafish                      |
| a1760769 | Ciona savignyi           |       51511 | Pacific Transparent Sea Squirt |
| a1761942 | Anolis carolinensis      |       28377 | Green Anole                    |
| a1762813 | Colobus angolensis       |       54131 | Angolan Colobus                |
