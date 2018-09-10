

# Assignment 4 [*34 marks*]

**Due before 12pm, Friday 21th September**

Your answers to all questions should be submitted to myUni as a `.zip` file containing three bash scripts, and a single file containing the answers to the questions 3,4 and 5 (can be in any readable format). [*1 marks*]

The `.zip` filename must start with your student number [*1 marks*] and your bash script must be able to run without errors.
Meaningful comments are strongly advised [*1 mark*]

For all scripts, please use the directory `~/Assignment4` as the parent directory for all downloads and analysis.
**You will be expected to hard code this into your script.**
All other folders must be created as subdirectories of this. [*1 mark*]


## Practical questions [*25 marks*]

1. Write a script to:
    + Download the genomic sequence (i.e. fasta file) and annotation (i.e. gff file) of the model plant _Arabidopsis thaliana_ to the subdirectory `Refs/Athaliana` from the Ensembl ftp directory (link below) [*2 marks*]
    + Identify how many chromosomes are in the genome, and write this information to standard output (`stdout`) [*2 marks*]
    + Identify how many unique genes are located in the genome, and send this information to `stdout`? [*2 marks*]
    + Create a genome index [*1 marks*]
2. Write a second script to download the sequencing data contained at these links (using `curl` or `wget`) to the directory `01_rawData/fastq`: [*2 marks*]
    - [SRR5882792_10M_1.fastq.gz](https://universityofadelaide.box.com/shared/static/egl3n16r0ziaxlvbs9074xqd1liktnuz.gz)
    - [SRR5882792_10M_2.fastq.gz](https://universityofadelaide.box.com/shared/static/g2ly4kzz1blus5juy426i37zl45o38pu.gz)
    + Trim your data for poor quality bases and remove adapters using cutadapt. Write your output to the directory `02_trimmedData/fastq` [*3 marks*]
    + Align paired-end reads to the genome index using `bwa mem`, resulting in a single `.bam` file in the directory `03_alignedData/bam`. Ensure there are no intermediary `.sam` files saved. [*3 marks*]
    + Sort and index your bam file [*2 marks*]
3. Write a third script to export the following information as a tab-delimited file to the parent directory. Include the category as the first column, and the numbers as the second column
    + How many reads were mapped in total? [*1 marks*]
    + How many reads were mapped as a pair? [*1 marks*]
    + How many reads were mapped as a "proper" pair? [*1 marks*]
    + Find the _Arabidopsis thaliana_ gene associated with your ID below and identify how many inserts mapped to that region [*5 marks*]


## Theoretical questions [*5 marks*]

4. What is the difference between an index and a barcode? [*2 marks*]
5. What is the difference between a SAM file and a BAM file? [*1 marks*]
6. What does the CIGAR string "26M2I78M" mean? [*2 marks*]


### Genes For Question 1

*If your student number is not listed, please contact Steve to ensure you are added to the list*

| ID       | Gene      |
|:---------|:----------|
| a1751618 | AT5G37280 |
| a1760769 | AT1G67110 |
| a1762813 | AT1G70640 |
| a1759891 | AT2G03340 |
| a1077937 | AT5G38317 |
| a1689798 | AT3G55220 |
| a1679812 | AT2G07628 |
| a1729553 | AT2G43970 |
| a1745148 | AT5G49980 |
| a1711220 | AT5G54830 |
| a1737886 | AT3G61680 |
| a1737554 | AT5G48150 |
| a1733230 | AT5G04240 |
| a1755150 | AT1G21660 |
| a1761942 | AT1G09300 |
| a1653192 | AT5G39380 |
| a1606913 | AT4G13330 |
| a1760382 | AT2G14070 |
| a1742674 | AT3G14870 |
| a1680333 | AT1G26650 |
| a1711935 | AT2G22410 |
| a1619861 | AT5G53190 |
| a1634284 | AT1G16850 |
| a1614956 | AT3G15480 |
| a1737558 | AT1G64150 |
| a1739624 | AT1G15920 |
| a1752614 | AT1G68670 |
| a1711533 | AT2G46500 |
| a1731217 | AT4G29340 |
| a1688727 | AT1G16440 |
| a1743741 | AT3G23130 |
| a1733253 | AT4G22220 |
| a1735373 | AT1G16570 |
| a1696632 | AT4G06688 |
| a1715156 | AT4G29580 |


### Resources

- The genome (fasta) and annotation (gff) files for the model plant _Arabidopsis thaliana_ can be found [here: ftp://ftp.ensemblgenomes.org/pub/plants/current/fasta/arabidopsis_thaliana](ftp://ftp.ensemblgenomes.org/pub/plants/current/fasta/arabidopsis_thaliana) and [ftp://ftp.ensemblgenomes.org/pub/plants/current/gff3/arabidopsis_thaliana](ftp://ftp.ensemblgenomes.org/pub/plants/current/gff3/arabidopsis_thaliana). The are multiple versions of the same file, so take care to choose the right version to use.
- The genome file should be "Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz" and not contain an "rm" or "sm" in the filename. These refer to the genome being "repeat-masked" i.e. all the repetitive elements have been ignored, or "soft-masked" were the repeats and low-complexity regions are in lower-case letters (acgt not ACGT)
