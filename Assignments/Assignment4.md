

# Assignment 4 [*34 marks*]

**Due before 5pm, Monday 23rd September**

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


### Genes For Question 3

*If your student number is not listed, please contact Dan to ensure you are added to the list*

| ID       | Gene      |
|:---------|:----------|
| a1762813 | AT5G39980 |
| a1202401 | AT3G19540 |
| a1776494 | AT3G27570 |
| a1778618 | AT4G05470 |
| a1705074 | AT5G42410 |
| a1790457 | AT1G63340 |
| a1758382 | AT4G14350 |
| a1789913 | AT5G55530 |
| a1776998 | AT1G78670 |
| a1776430 | AT5G66320 |
| a1770716 | AT4G13130 |
| a1739682 | AT1G62450 |
| a1758693 | AT1G20720 |
| a1781987 | AT5G45000 |
| a1768114 | AT2G36210 |
| a1700271 | AT4G18590 |
| a1646510 | AT1G72390 |
| a1779487 | AT4G35987 |
| a1778287 | AT1G49700 |
| a1783535 | AT3G12990 |
| a1789486 | AT1G47640 |
| a1758223 | AT3G23175 |
| a1769266 | AT5G61580 |
| a1771465 | AT3G28674 |
| a1768183 | AT1G48770 |
| a1781873 | AT1G03390 |
| a1755783 | AT3G12210 |
| a1679475 | AT1G49100 |
| a1662216 | AT2G23540 |
| a1780859 | AT3G29180 |
| a1775769 | AT1G55270 |



### Resources

- The genome (fasta) and annotation (gff) files for the model plant _Arabidopsis thaliana_ can be found [here: ftp://ftp.ensemblgenomes.org/pub/plants/current/fasta/arabidopsis_thaliana](ftp://ftp.ensemblgenomes.org/pub/plants/current/fasta/arabidopsis_thaliana) and [ftp://ftp.ensemblgenomes.org/pub/plants/current/gff3/arabidopsis_thaliana](ftp://ftp.ensemblgenomes.org/pub/plants/current/gff3/arabidopsis_thaliana). The are multiple versions of the same file, so take care to choose the right version to use.
- The genome file should be "Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz" and not contain an "rm" or "sm" in the filename. These refer to the genome being "repeat-masked" i.e. all the repetitive elements have been ignored, or "soft-masked" were the repeats and low-complexity regions are in lower-case letters (acgt not ACGT)
