# Assignment 2 [*29 marks*]

**Due before 12pm, Monday 2nd September**

Your answers to all questions should be submitted to myUni as a `.zip` file containing three files:
1) a bash script for Q1 2) a bash script for Q2, and 3) the answers to the statistics questions (Q3 and Q4) in a single Rmarkdown document.
Note that the file `my_species_gff_features.txt` is not required as part of your submission for Q1, **only the script which will generate this file**!
Similarly, for Q2, only the script is required.

## Required scripts [*14 marks*]

1. Write a script to:
    + Download the gff3 file for your assigned species ([see bottom of page](#species-for-question-1)) to your current directory from Ensembl [*1 mark*]
    + Count how many of each feature type there is, sorted in numerical order [*3 marks*]
    + Export the results to a file with a name of the form `my_species_gff_features.txt` **where you use your assigned species name instead of** `my_species` [*1 mark*].
    NB: If your actual species is not included in the name, no marks will be given.
    + Include one or more comment lines before the table detailing which build of the genome was used, and the code executed to generate the summary [*2 marks*]

2. For the file we used in the practicals (Drosophila_melanogaster.BDGP6.ncrna.fa), add to the final practical script provided so that:
    + the output contains a meaningful header [*1 mark*]
    + the output contains column names [*2 marks*]
    + the output includes: a) gene id; b) chromosome; c) start; d) stop; e) strand and f) gene_biotype [*3 marks*]
    + Appropriate comments which make the script easier to understand [*1 mark*]
    
NB: If identical comments are identified in any submissions, a mark of zero will be given for this question for all suspicious submissions.

## Statistics questions [*15 marks*]

In a single rmarkdown file answer the following questions:

3. Two groups of people have volunteered to take part in a genetic study. Group 1 (n = 126) are volunteers with no history of Type I Diabetes in their immediate family, whilst Group 2 (n = 183) have all been diagnosed with Type I Diabetes. A genotyping study was undertaken on these volunteers using 25,786 SNPs selected due to their proximity to key immune genes.
Researchers are looking to identify any SNP genotypes which may increase the risk of Type I Diabetes. In your answer, consider the reference SNP allele as `A` and the alternate SNP allele as `B`, using the genotypes `AA`, `AB` and `BB`.

    a. For an individual SNP, what test would be appropriate for this comparison? [*1 mark*]  
    b. Define H~0~ and H~A~ for the genotype at each individual SNP. [*2 marks*]  
    c. If there was no true difference in any genotypes between the two groups, how many p-values would you expect to see < 0.05? [*1 mark*]  
    d. Using Bonferroni's method, what would a suitable cutoff value be to consider a SNP as being associated with an increased risk of Type I diabetes, i.e. to reject H~0~ [*1 mark*]
    e. Given the following genotype table, would you accept or reject H~0~? Provide your working and a full explanation. [*3 marks*]

| Group | AA   | AB  | BB |
| ----- | ---- | --- | --- |
| Control | 25 | 60  | 41 |
| T1D     | 21 | 55 | 103 |


4. An experiment was repeated multiple times, in which GFP fluorescence was measured in a cell culture as a measurement of gene expression, both *before* and *after* viral transfection.
GFP was present on a plasmid as a reporter for activity at a specific promoter.
The change in fluorescence values obtained for each repeat are given [below as the vector `x`](#values-for-question-4), presented on the log2 scale for your individual subset of experiments.  

    a. Define H~0~ and H~A~ [*2 marks*]  
    b. Calculate the sample mean and sample variance in `R` [*2 marks*]  
    c. Calculate the *T*-statistic using `R`. [*1 mark*]
    d. What would the degrees of freedom be for your *t*-test? [*1 mark*]  
    e. Calculate the *p*-value using `R` [*1 mark*]

Show all working & code.

## Species For Question 1

*If your student number is not listed, please contact Dan to ensure you are added to the list*

| ID       | Species                  | Taxonomy ID | Common Name               |
|:---------|:-------------------------|------------:|:--------------------------|
| a1202401 | Pogona vitticeps         |      103695 | Central Bearded Dragon    |
| a1646510 | Otolemur garnettii       |       30611 | Small-Eared Galago        |
| a1655317 | Xiphophorus maculatus    |        8083 | Southern Platyfish        |
| a1662216 | Nothoprocta perdicaria   |       30464 | Chilean tinamou           |
| a1679475 | Saccharomyces cerevisiae |        4932 | Baker's Yeast             |
| a1705074 | Erinaceus europaeus      |        9365 | Western European Hedgehog |
| a1739682 | Apteryx haastii          |        8823 | Great Spotted Kiwi        |
| a1755783 | Fukomys damarensis       |      885580 | Damara Mole-Rat           |
| a1758223 | Neovison vison           |      452646 | American Mink             |
| a1758382 | Mastacembelus armatus    |      205130 | Zig-Zag Eel               |
| a1758693 | Astatotilapia calliptera |        8154 | Eastern Happy             |
| a1759893 | Bos mutus                |       72004 | Wild Yak                  |
| a1762813 | Panthera tigris          |        9694 | Tiger                     |
| a1768114 | Meleagris gallopavo      |        9103 | Turkey                    |
| a1768183 | Microcebus murinus       |       30608 | Gray Mouse Lemur          |
| a1769266 | Cynoglossus semilaevis   |      244447 | Tongue Sole               |
| a1770716 | Mus musculus             |       10090 | House Mouse               |
| a1771465 | Capra hircus             |        9925 | Goat                      |
| a1775769 | Xiphophorus couchianus   |       32473 | Monterrey Platyfish       |
| a1776430 | Scleropages formosus     |      113540 | Asian Bonytongue          |
| a1776494 | Ochotona princeps        |        9978 | American Pika             |
| a1776998 | Monopterus albus         |       43700 | Swamp Eel                 |
| a1778287 | Microtus ochrogaster     |       79684 | Prairie Vole              |
| a1778618 | Cavia aperea             |       37548 | Brazilian Guinea Pig      |
| a1779205 | Cercocebus atys          |        9531 | Sooty Mangabey            |
| a1779487 | Procavia capensis        |        9813 | Cape Rock Hyrax           |
| a1779493 | Anser brachyrhynchus     |      132585 | Pink-Footed Goose         |
| a1780859 | Ciona intestinalis       |        7719 | Vase Tunicate             |
| a1781873 | Theropithecus gelada     |        9565 | Gelada                    |
| a1781987 | Mus spretus              |       10096 | Western Wild Mouse        |
| a1783535 | Rattus norvegicus        |       10116 | Norway Rat                |
| a1785118 | Phascolarctos cinereus   |       38626 | Koala                     |
| a1789486 | Apteryx rowi             |      308060 | Okarito Brown Kiwi        |
| a1789913 | Rhinopithecus roxellana  |       61622 | Golden Snub-Nosed Monkey  |
| a1790457 | Ornithorhynchus anatinus |        9258 | Platypus                  |
| a1791647 | Canis lupus              |        9612 | Gray Wolf                 |

## Values For Question 4

*If your student number is not listed, please contact Dan to ensure you are added to the list*

The results you are analysing for Q4 are as follows.
You can simply paste these values into your RMarkdown document as the object `x` and perform all of you analysis on these values.

| ID       | Values                                                                                      |
|:---------|:--------------------------------------------------------------------------------------------|
| a1202401 | x <- c(-0.9513, 1.6303, -0.045, -0.7745, 0.4975, 0.548)                                     |
| a1646510 | x <- c(0.2462, -0.3341, 2.782, 1.3727, -2.2463, -1.302, -0.8207, 1.8788, 0.9241, 3.5149)    |
| a1655317 | x <- c(0.9843, -0.9625, -2.3058, 3.4175, 0.9395, 1.304, -1.5199, -1.0382)                   |
| a1662216 | x <- c(2.1101, 2.6845, -0.6054, 3.2921, 0.5918, -1.3179)                                    |
| a1679475 | x <- c(2.8489, -1.169, 0.194, 2.1414, 1.1182, 0.8952, 1.7453, 2.2781)                       |
| a1705074 | x <- c(1.4906, -1.91, -0.3847, 1.8721, 0.0724, -0.2576, 0.7764, -0.2081, 1.6768, 0.5433)    |
| a1739682 | x <- c(-0.0698, -0.0496, 1.0847, -1.8116, 1.9262, -0.4381, 0.8199, -1.7124, 0.9042)         |
| a1755783 | x <- c(0.9639, 2.7818, 3.1581, -0.9618, 0.899)                                              |
| a1758223 | x <- c(2.4081, -0.1234, 1.0343, 0.1866, 1.2536, 3.0342, 1.3065, 1.9026, 1.9277, 0.8871)     |
| a1758382 | x <- c(0.9154, 3.0455, 0.9424, 0.2602)                                                      |
| a1758693 | x <- c(0.8874, -1.2703, 1.5661, -1.4728, 0.3263, -0.5432, 1.2529, -1.058, 1.3997)           |
| a1759893 | x <- c(2.2414, -1.086, -0.736, -0.8501, 2.5435, 1.3077, 0.8503, 1.3841, 1.362)              |
| a1762813 | x <- c(1.5863, 1.8493, 0.148, 0.9625)                                                       |
| a1768114 | x <- c(-1.2482, 1.5015, 0.4375, -0.8861, 2.2182, -3.4134, 1.2606, 1.3364)                   |
| a1768183 | x <- c(2.3343, 4.2557, 1.4483, -1.1698, 2.9268)                                             |
| a1769266 | x <- c(2.0184, -2.5565, 0.828, 0.7598, 2.4209, 0.9782)                                      |
| a1770716 | x <- c(0.9099, 1.5083, 3.8821, 1.857, -1.2774, -2.4848)                                     |
| a1771465 | x <- c(-2.1028, 2.2444, 0.2528, 0.4546, 0.5281, 1.9097)                                     |
| a1775769 | x <- c(2.1548, 2.6573, 0.0405, 1.8806, 1.2804)                                              |
| a1776430 | x <- c(1.1573, 0.9534, 1.6556, 0.3031, -0.7595)                                             |
| a1776494 | x <- c(-1.2097, -0.3836, -0.9921, 3.163)                                                    |
| a1776998 | x <- c(1.17, 1.5779, 2.1255, 0.2414, -0.2254, 3.6169, -0.4608)                              |
| a1778287 | x <- c(2.191, -1.2205, -0.1718, -0.8329, 1.3216, -0.2207, -0.4791, -1.6403, 1.4002)         |
| a1778618 | x <- c(0.2766, 0.9948, 1.0277, 1.446, 0.5142, -2.3367, 2.7549)                              |
| a1779205 | x <- c(0.6059, 0.3204, 2.9613, 2.4011)                                                      |
| a1779487 | x <- c(1.2239, 1.6841, 3.9703, 1.4247, 1.6411, 3.3794, 1.6216)                              |
| a1779493 | x <- c(1.3704, 1.2877, -0.4828, 1.4835, 1.0138, 1.3534, -0.5702, -0.6986, -0.8718)          |
| a1780859 | x <- c(0.9849, 3.2516, -0.6605, -1.7701, 1.8174, 1.407, 0.998, 0.7658, 3.4027)              |
| a1781873 | x <- c(2.6989, -0.2447, -1.1002, 3.2813, 0.8118, 2.8494, 3.4665, -0.7619, -0.3138, 1.3657)  |
| a1781987 | x <- c(2.2343, 2.2869, 0.9392, 0.0993, -2.5061)                                             |
| a1783535 | x <- c(-0.7149, -0.507, 2.0843, 0.7257, -0.4206, 1.5086, 0.4469, -0.0513)                   |
| a1785118 | x <- c(0.6829, -3.1075, 0.6059, 1.1283, -0.1458, 2.3641, -1.7658, -0.7718)                  |
| a1789486 | x <- c(0.2182, -1.0116, 1.0219, -1.0481, -0.2522, 0.0143, 0.8276, -1.4257, 2.3013)          |
| a1789913 | x <- c(1.6467, 2.8552, -3.5222, 0.1931)                                                     |
| a1790457 | x <- c(1.1158, 1.5058, -0.3448, -1.2364, 2.6939, 0.4026, -3.2485, -1.8346, -0.6862, 0.6051) |
| a1791647 | x <- c(-0.2645, -0.9827, 1.5949, -0.2736, -1.448, 1.8688, -0.0686)                          |
