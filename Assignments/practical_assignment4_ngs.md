

# Assignment 4 [*25 marks*]

**Due before 12pm, Friday 15th September**

Your answers to all questions should be submitted to myUni as a `.zip` file containing one bash scripts, and file containing the answers to the questions 3,4 and 5 (can be doc, text or markdown format).

The `.zip` filename must start with your student number [*1 marks*] and your bash script must be able to run without errors [*1 marks*].

## Practical questions [*18 marks*]

1. Write a script to:
    + Download the genome fasta and gff3 annotation file of the model plant _Arabidopsis thaliana_ to your current directory from the Ensembl ftp directory (link below) [*1 marks*]
    + Identify how many chromosomes are in the genome [*1 marks*]
    + How many unique genes are located in the genome? [*3 marks*]
    + Download the sequencing data contained at these links (using `curl` or `wget`): [*1 marks*]
        - [SRR5882792_1.fastq.gz](https://universityofadelaide.box.com/shared/static/iksl6s5kifvumb80ar8io037kysevg54.gz)
        - [SRR5882792_2.fastq.gz](https://universityofadelaide.box.com/shared/static/69alyh4haw8zbb1ln5in3tptchk5e9vv.gz)
    + Create a genome index [*1 marks*], trim your data for poor quality (base quality > 10) and adapters using cutadapt [*1 marks*], and align paired-end reads to the genome index using `bwa mem`, resulting in a `.bam` file [*1 marks*]
    + Create a `.bam` file that only contains mapped reads [*1 marks*]
    + How many reads were mapped? [*1 marks*]
    + How many reads were mapped as a pair? [*1 marks*]
    + How many reads were mapped as a "proper" pair? [*1 marks*]
    + Find the _Arabidopsis thaliana_ gene thats associated to your username below and identify how many inserts mapped to that region [*5 marks*]

**Note:** The answers to tasks in this question should all be answered within the script. Please make the question and answer clear. For example:

```bash
answer = that
echo "How many reads were mapped?: ${answer}"
```

## Theoretical questions [*5 marks*]

3. What is the difference between an index and a barcode? [*2 marks*]
4. What is the difference between a SAM file and a BAM file? [*1 marks*]
5. What does the CIGAR string "6M2I8M" mean? [*2 marks*]


### Gene For Question 1

*If your student number is not listed, please contact Dan to ensure you are added to the list*

|ID       |Gene         |
|:--------|:------------|
|a1735804 |AT1G05200    |
|a1696678 |AT4G08535    |
|a1611214 |AT3G16830    |
|a1691643 |AT5G35715    |
|a1667810 |AT5G50110    |
|a1733239 |AT1G45223    |
|a1718998 |AT5G07360    |
|a1731952 |AT1G21100    |
|a1710508 |AT3G13276    |
|a1690770 |AT5G19160    |
|a1652167 |AT4G20050    |
|a1714893 |AT3G62800    |
|a1702741 |AT3G11385    |
|a1701030 |AT5G07010    |
|a1662822 |AT3G63040    |
|a1606913 |AT3G05560    |
|a1731155 |AT1G50870    |
|a1713960 |AT4G35500    |
|a1674898 |AT1G03910    |
|a1729128 |AT1G77590    |
|a1719003 |AT3G26922    |
|a1660066 |AT1G05230    |
|a1710741 |AT2G19970    |
|a1673245 |AT1G77610    |
|a1701389 |AT4G27150    |
|a1701747 |AT5G02280    |
|a1643251 |AT2G36080    |
|a1735934 |AT4G33620    |
|a1738360 |AT1G29810    |
|a1619733 |AT2G15020    |
|a1683838 |AT4G22590    |

### Resources

- The genome (fasta) and annotation (gff) files for the model plant _Arabidopsis thaliana_ can be found [here: ftp://ftp.ensemblgenomes.org/pub/plants/current/fasta/arabidopsis_thaliana](ftp://ftp.ensemblgenomes.org/pub/plants/current/fasta/arabidopsis_thaliana) and [ftp://ftp.ensemblgenomes.org/pub/plants/current/gff3/arabidopsis_thaliana](ftp://ftp.ensemblgenomes.org/pub/plants/current/gff3/arabidopsis_thaliana). The are multiple versions of the same file, so take care to choose the right version to use.
    - The genome file should be "Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz" and not contain an "rm" or "sm" in the filename. These refer to the genome being "repeat-masked" i.e. all the repetitive elements have been ignored, or "soft-masked" were the repeats and low-complexity regions are in lower-case letters (acgt not ACGT)
