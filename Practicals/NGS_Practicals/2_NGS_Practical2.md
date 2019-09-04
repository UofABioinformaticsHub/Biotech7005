* TOC
{:toc}

# Setup for Today

Today's practical is all about alignment of reads from a `fastq` file against a reference genome.
To complete this task we'll need to perform a few key steps

1. Setup our data folders & check our software installations
2. Copy our data
3. Clean & trim our data
4. Index the genome
5. Align to the genome

## Step 1: Setup Folders and Checking

### Step 1a: Check installations

Firstly let's double check our software installations.
Going by last week, this should be unnecessary but may be wise.
Feel free to just copy & paste this line.

```
whereis fastqc cutadapt bwa STAR freebayes bcftools
```

You should see a line of output for each one of these tools.
If you see a blank line by any of them, call a tutor over. 

### Step 1b: Directory setup

 we'll be working today in the folder `~/Practical_7`.
Please ensure you use this *exact* path as any variations will undoubtedly cause you problems & lead to unnecessary confusion.
An example data structure to use for today has already been made for you & can be obtained using the following strategy.

```
cd ~
wget https://github.com/UofABioinformaticsHub/ngsSkeleton/archive/master.zip
unzip master.zip
mv ngsSkeleton-master/ Practical_7
rm master.zip
cd Practical_7
```

Now that we've setup our directories, have a quick look using `ls` to see the top-level directories.
Here we have directories for each step as well as folders for `R` and `bash` scripts.
The directory `slurm` is where output would go from an HPC where we're required to submit jobs to queues and need specify where to write `stdout` and `stderr`.
The queuing system on the University of Adelaide's HPC (phoenix) is the `slurm` system.
We won't need that directory today

Inside each of these directories are the directories `fastq`, `FastQC`, `bam`, `log` or various directories where we'll place our output.
The more you perform bioinformatics, the more you realise how important getting your directories organised is.
Let's have a look in a few.
```
ls 0_rawData
ls 1_trimmedData
ls 2_alignedData
```

## Step 2: Copy our data across

Now we have our directories setup, we can place our data in the directory `0_rawData/fastq`.

```
cp ~/data/intro_ngs/*gz 0_rawData/fastq/
ls ls 0_rawData/fastq/
```

This should show you the output:  
`README.md  SRR2003569_sub_1.fastq.gz  SRR2003569_sub_2.fastq.gz`

From here, we're into running our workflow.

# Running Our Workflow

## Step 3: Trimming and Cleaning Our Data

As we saw last week, we need to 1) check the quality of our raw data; 2) Remove adapters and low-quality bases; 3) Check the quality of our trimmed data.

The script you'll need to run to perform these steps is given below:

```
#!/bin/bash

## Define the key directories
PROJROOT=/home/biotech7005/Practical_7
RAWFQ=${PROJROOT}/0_rawData/fastq
RAWQC=${PROJROOT}/0_rawData/FastQC
TRIMFQ=${PROJROOT}/1_trimmedData/fastq
TRIMQC=${PROJROOT}/1_trimmedData/FastQC
TRIMLOG=${PROJROOT}/1_trimmedData/log

## Check the project root exists
if [[ -d ${PROJROOT} ]]; then
  echo -e "Found ${PROJROOT}\n"
else
  echo -e "${PROJROOT} not found.\nExiting with Error code 1"
  exit 1
fi

## Check all directories exist for the raw data
if [[ -d ${RAWFQ} ]] || [[ -d ${RAWQC} ]]; then
  echo -e "Found ${RAWFQ}\nFound ${RAWQC}\n"
else
  echo -e "Raw data directories not found.\nExiting with Error code 2"
  exit 2
fi

## Check all directories exist for the trimmed data
if [[ -d ${TRIMFQ} ]] || [[ -d ${TRIMQC} ]] || [[ -d ${TRIMLOG} ]]; then
  echo -e "Found ${TRIMFQ}\nFound ${TRIMQC}\nFound ${TRIMLOG}\n"
else
  echo -e "Trimmed data directories not found.\nExiting with Error code 3"
  exit 3
fi

## Run FastQC on the raw data
fastqc -t 2 -o ${RAWQC} ${RAWFQ}/*gz

## Trim the data
echo -e "Running cutadapt\n"
cutadapt \
  -m 35 \
  -q 30 \
  -a CTGTCTCTTATACACATCT \
  -A CTGTCTCTTATACACATCT \
  -o ${TRIMFQ}/SRR2003569_sub_1.fastq.gz \
  -p ${TRIMFQ}/SRR2003569_sub_2.fastq.gz \
  ${RAWFQ}/SRR2003569_sub_1.fastq.gz ${RAWFQ}/SRR2003569_sub_2.fastq.gz > \
  ${TRIMLOG}/cutadapt.log
  
## Run FastQC on the trimmed data
fastqc -t 2 -o ${TRIMQC} ${TRIMFQ}/*gz
```

Have a look through this and make sure you understand each step.
Once you're happy, copy and paste, then save the script as the file `~/Practical_7/bash/trimData.sh`.
You can do this using `nano` or a plain text file in `RStudio`.

If you'd like to improve the comments, feel free to do so.

Once you're ready to run the script, make it executable (`chmod +x`) then run the script.

### Checking the QC

IN the above script, we've run FastQC on the raw data, then trimmed the data *without first inspecting it*.
This was just done for speed and to streamline the process.
We often do this, and if we spot anything unusual in the raw data we may choose to change some parameters and rerun the process.

First we'll check the raw data by inspecting the `FastQC` reports from the raw data.
**Did you spot anything that cuases you concern?**

Now we should inspect the results of trimming.

```
less 1_trimmedData/log/cutadapt.log
```

**Does anything look unusual here, or does this correspond with your expectations?**

Now we should check the `FastQC`reports from the trimmed data.

**Does anything look unusual here, or does this correspond with your expectations?**


# Sequence Alignment

Now we have cleaned our data of any adapters and removed the bases which are more likely to contain errors we can more confidently align our reads to a reference. 
Different experiments may have different reference sequences depending on the context. 
For example, if we have a sub-sample of the genome associated with restriction sites like RAD-Seq, we would probably align to a reference genome, or if we have RNA-Seq we might choose to align to the transcriptome as an alternative to the whole genome.
Alternatively, we might be interested in *de novo* genome or transcriptome assembly where we have no reference genome to compare our data to.

## How Aligning Works

Most fast aligners in widespread public use are based on a technique called the Burrows-Wheeler Transform, which is essentially a way of restructuring, or indexing, the genome to allow very rapid searching.
This technique comes from computer science & is really beyond the scope of what most of us need to know.
The essence of it is that we have a very fast searching method, and most aligners use a seed sequence within each read to begin the searching.  
These seeds are then expanded outwards to give the best mapping to a sequence.  
There are many different alignment tools available today & each one will have a particular strength. 
For example, bowtie is very good for mapping short reads, whilst bowtie2 or bwa is more suited to reads longer than 50bp.

#### What’s the difference

Some key differences between aligners is in the way they index the genome, and in the a way they are equipped to handle mismatches & InDels.  
Choosing an aligner can be a difficult decision with the differences often being quite subtle.  
Sometimes there is a best choice, other times there really isn’t.  
Make sure you’ve researched relatively thoroughly before deciding which to use.

## Aligning our WGS reads

### Downloading A Reference Genome

To align any reads, we first need to download the appropriate (i.e.  latest) genome \& then we can build the index to enable fast searching via the Burrows-Wheeler Transform. 
We didn't mention this in the earlier section, but our reads today come from the nematode or Roundworm (*Caenorhabditis elegans*).  

**Note**: If you want the full genome sequence you can use the command-line program `wget` to download the *C. elegans* genome sequence. 
If `wget` doesn't work for you, you can always you can always re-download the genome (like you can do with all model genomes) by opening Firefox & head to [ftp://ftp.ensembl.org/pub/release-90/fasta/caenorhabditis_elegans/](ftp://ftp.ensembl.org/pub/release-90/fasta/caenorhabditis_elegans/).  

For today's session, we've already given you just the sequence of chrI so let's move this into a useful folder for today.
It will be in the folder `~/data/intro_ngs` (where we obtained our reads from).
Call Dan or Steve over if you can't find it somewhere (use `ls ~/data/intro_ngs`).


```
mkdir -p ~/Practical_7/genome
cp ~/data/intro_ngs/chrI.fa ~/Practical_7/genome/
```

Let's have a look at this file just make sure we know what we have

```
head ~/Practical_7/genome/chrI.fa
```

Note that the first line describes the following sequence & begins with a \> symbol.  
We can use this to search within the file using regular expressions \& print all of these description lines, as we've done a few times in previous weeks.

## Building an Index

Today we will align using the tool `bwa` which is one of the original Burrows-Wheeler transformation aligners. 
`bwa` was developed in 2009 by Heng Li (Harvard/Broad Institute, USA). 
From the bwa manual, it details the three specific bwa algorithms: BWA-backtrack, BWA-SW and BWA-MEM. 
The first algorithm is designed for Illumina sequence reads up to 100bp, while the rest are for longer sequences ranging from 70bp to 1Mbp. 
BWA-MEM and BWA-SW share similar features such as long-read support and split alignment, but BWA-MEM, which is the latest, is generally recommended for high-quality queries as it is faster and more accurate. 
Today we will be using bwa-mem to align our C. elegans WGS reads. 
Once again, we need to check the help pages. 
Fortunately the bwa page is actually pretty friendly on the screen and appears without the usual -h option, but can also be viewed using `man bwa`

```
bwa
```

We should also inspect the help page for bwa index which we will use to build the index.
This is the step that makes aligning NGS data incredibly fast & marked a significant step forward from older approaches such as `blast`.

```
bwa index
```

Using this particular process you can usually just run the command on the fasta file and the index will be called by the same file-name.  
However in this case, we will name the index "Celegans_chrI" by using the `-p` flag/parameter. 
Now that we’ve had a look, type to following command which will take a few minutes to run.

```
cd genome
bwa index chrI.fa -p Celegans_chrI
```

Let’s look at what files have been created.

```
ls
```

You should be able to open a few of the files with the ”less” command, however the main files (\*.sa, \*.bwt and \*.pac) are the BWT transformed files that are in binary, so we can’t really see what they look like, but these are required by the aligner bwa.

## Aligning the reads

Because we only have a small subset of the actual sequencing run, we should be able to run this alignment in a reasonable period of time.

Now let's change back to our main project folder.

```
cd ~/Practical_7
```

The command we'll run is quite long, so please read on a little before executing this, so you understand what every section does.
This will help you figure out what is going wrong if you get some error messages.
First up here's the command 

```
bwa mem \
  -t 2 \
  genome/Celegans_chrI \
  1_trimmedData/fastq/SRR2003569_sub_1.fastq.gz \
  1_trimmedData/fastq/SRR2003569_sub_2.fastq.gz | \
  samtools view -bhS -F4 - > \ 
  2_alignedData/bam/SRR2003569_chI.bam
```

Let’s break down this main command a little. 
The first part of the command:

```
bwa mem \
  -t 2 \
  genome/Celegans_chrI \
  1_trimmedData/fastq/SRR2003569_sub_1.fastq.gz \
  1_trimmedData/fastq/SRR2003569_sub_2.fastq.gz
```

will align our compressed sequenced reads to the Celegans_chrI `bwa` index that we made, using two threads (`-t 2`).
This will write all alignments to `stdout` **NOT** a file, which is a unique behaviour of `bwa`.
Usually, you would stream this plain text output to a SAM file (see next section) to store all the alignment data.  
However, SAM files however are plain text files which can take up a significant amount of disk space, so its much more efficient to pipe it to the `samtools` command which converts between binary and plain text versions of the format, to create a compressed binary SAM file (called BAM). 
To do this, we pipe `stdout` to the program `samtools`:

```
samtools view -bh -F4 - 
```

In this context, `samtools` view is the general command that allows the conversion of the SAM to BAM. 
The *globbed* arguments are 1) `-b` [output in binary format]; and 2) `-h` include the file header, followed by the option `-F4` which only include reads with the flag bit `4` set.
(We'll discuss flags in the next section).
The binary output is then written to the file `2_alignedData/bam/SRR2003569_chI.bam` using the `>` symbol.

This process may take 10 minutes so once you run the command, be patient and read ahead.

**Note:** By using the `-t 2` parameter, we can take advantage of modern computers that allow multi-threading or parallelisation. This just means that the command can be broken up into 2 chunks and run in parallel, speeding up the process. 
If using phoenix or another HPC, this can really speed things up as more than 2 cores are available.


Once your alignments have finished, you can find out information about your alignments using `samtools stats`:

```
samtools stats 2_alignedData/bam/SRR2003569_chI.bam > \
  2_alignedData/logs/SRR2003569_chI.stats
```

This is basically the same as another command `samtools flagstat`, but it gives additional information which may be informative

### Questions
{:.no_toc}

1. How many reads aligned to our genome?
2. How many reads aligned as a pair?
3. How many aligned as a "proper" pair? ..what the hell is a proper pair anyway??


# SAM/BAM files

## The SAM/BAM file format

Reads that have been aligned to a reference are no longer stored in fastq format but are stored in either SAM or BAM format.
These two formats are virtually identical, however the SAM format is a text file which is easily readable to human eyes, whilst a BAM file is the same information converted to binary.
This conversion means that file sizes are smaller, and that computational processes can be performed more efficiently, as this is a format able to be read more quickly by a computer.
Typically, we work with BAM files as these provide gains in *storage space* & *analytic speed*.
The tools we use to inspect these files are provided in the package `samtools`, which we've already seen.


## Conversion to BAM format

The BAM format is much more convenient computationally, so we have converted our alignments into BAM format using `samtools view` during the alignment process.
SAM files are *plain text*, whilst BAM files are *compressed* and much easier for the computer to read/write.
As BAM files are in binary format they will look like gibberish if we try to read them directly.
Instead we can inspect them by using `samtools view` as mentioned above.

There is also a header section to each file which details the fasta files used in the alignments.
To view this header we use

```
samtools view -H SRR2003569_chI.bam
```

As we've only aligned to one chromosome, this is very short, but if we'd aligned to multiple chromosomes this would be far longer.


## The SAM/BAM data structure

If we understand what information is contained within a file, we can know what decisions to make as we progress with our analysis, so let's have a look at what the data structure is for a SAM/BAM file.
A SAM/BAM file is `tab-delimited`, which means that each field is separated by a tab, giving a data structure effectively consisting of columns (or fields).
In order, these are:

| 1 | QNAME | Query template/pair NAME. This is essentially the first element of the original read identifier |
| 2 | FLAG | bitwise FLAG |
| 3 | RNAME | Reference sequence NAME |
| 4 | POS | 1-based leftmost POSition/coordinate of clipped sequence |
| 5 | MAPQ | MAPping Quality (Phred-scaled) |
| 6 | CIGAR | extended CIGAR string |
| 7 | MRNM | Mate Reference sequence NaMe (`=` if same as RNAME) |
| 8 | MPOS | 1-based Mate POSition |
| 9 | TLEN | inferred Template LENgth (insert size) |
| 10 | SEQ | query SEQuence on the same strand as the reference (the sequence we aligned) |
| 11 | QUAL | query QUALity (The PHRED scores from the fastq file) |
| 12 | OPT | variable OPTional fields in the format TAG:VTYPE:VALUE |

Notice that each read is considered to be a *query* in the above descriptions, as we a querying the genome to find out where it probably came from.

Several of these fields contain useful information, so looking the the first few lines, you can see that these reads are mapped in pairs as consecutive entries in the QNAME field are often (but not always) identical.
Most of these fields are self-explanatory, but some require exploration in more detail.
Note that in the following command, each line from the file may wrap around several lines in your terminal.
If this is confusing, just select the first read only by adding the option `-n1` after your call to `head`

```
samtools view 2_alignedData/bam/SRR2003569_chI.bam | head
```

This is a lot of information, so let's step through everything carefully.

## SAM Flags

These are second field in a sam/bam file and are quite useful pieces of information, however they can be difficult at first look.
Head to http://broadinstitute.github.io/picard/explain-flags.html to see a helpful description, then try clicking on a few combinations to see how the numbers change.
The simplest way to understand these is that it is a bitwise system so that each description heading down the page increases in a binary fashion.
The first has value 1, the second has value 2, the third has value 4 & so on until you reach the final value of 2048.
The integer value contained in this file is the unique sum of whichever attributes the mapping has.
For example, if the read is paired & mapped in a proper pair, but no other attributes are set, the flag field would contain the value 3.

#### Questions
{:.no_toc}


1. *What value could a flag take if the read was 1 - paired; 2 - mapped in a proper pair; 3 - it was the first in the pair \& 4 - the alignment was a supplementary alignment.*
2. *Some common values in the bam file are 99, 147 & 145. Look up the meanings of these values.*
3. *In our very first call to* `samtools` *when we performed our alignments, we used the filter* `-F4`. *Now you understand flags, can you figure out what this was doing?*



Things can easily begin to confuse people once you start searching for specific flags, but if you remember that each attribute is like an individual flag that is either on or off (i.e. it is actually a binary bit with values 0 or 1).
If you searched for flags with the value 1, you wouldn't obtain the alignments with the exact value 1, rather you would obtain the alignments **for which the first flag is set** & these can take a range of values.


Let's try this using the command `samtools view` with the option `-f` to include reads with a flag set and the option `-F` to exclude reads with a specific flag set.
Let's get the first few reads which are mapped in a proper pair, so the flag `2` will be set.

```
cd 2_alignedData/bam
samtools view -f 2 SRR2003569_chI.bam | head
```

Note that none of the flags actually have the value 2, but if you typed the values 99, 147 or 163 into the webpage, you'll see that this flag is set for all of these values.
Similarly if we wanted to extract only the reads which are NOT mapped in a proper pair we would change the option to a upper-case F.

```
samtools view -F 2 SRR2003569_chI.bam | head
```

Again, try entering a few of these sample values into the webpage and you will see that this flag is not set for any of these values.

This can be a very helpful tool for extract subsets of your aligned reads.
For example, we can create a new BAM file with only the reads which were aligned in a proper pair by entering the following command.

```
samtools view -f 2 -bo SRR2003569_chI.bam
ls -lh
```

You can thus pull out highly specific combinations of alignments should you so choose.

## MAPQ

Hopefully the 3rd and 4th fields are self explanatory, as these can be generally interpreted as the chromosome & position in the reference where the sequence aligned.
However, the 5th field contains the `MAPQ` score which indicates how well the read aligned, and how unique each alignment is.
We won't spend much time on this as the values tend to differ between alignment tools, but in general a higher score indicates a better, more unique alignment.


## CIGAR strings

These give useful information about the type of alignment that has been performed on the read.
In the first few reads we called up earlier, most had the value `..M` where `..` is some number.
These are the perfect Matches, where the sequence has aligned exactly.
The other abbreviations in common use are I (insertion), D (deletion) & S(substitution).


#### Questions
{:.no_toc}

1. What is the interpretation of the first `CIGAR` string in your set of alignments?

# Variant Calling

While sequence alignment is potentially the most important aspect of most NGS pipelines, in whole genome sequencing (WGS) experiments, such as the *C. elegans* data that we currently have, it is crucial to not only identify where reads have mapped, but regions in which they differ. These regions are called "sequence variants", and can take many forms. Three major types of sequence variation that occur in NGS data include:

1. Single Nucleotide Polymorphisms or Variants (SNPs/SNVs): single-base pair changes. e.g. A->G
2. Insertion-Deletions (InDels): An insertion or deletion of a region of genomic DNA. e.g. AATA->A
3. Structural Variants: These are large segments of the genome that have been inserted, deleted, rearranged or inverted within the genome.

NGS has enabled sequence variants to be identified at an extremely high resolution, due to the increase of sequence *coverage* i.e. the amount of times one base of DNA has been sequenced. 
When we say "a genome has been sequenced to 10x coverage", what we mean is that each individual base in the genome has been sequenced an average of 10 times. 
Compared to previous sequencing technologies such as Sanger, which sequenced an individual region of DNA once, it was incredibly difficult to identify sequence variants and involved a lot of erroneous calls.

![Sanger vs NGS variants](https://github.com/BIG-SA/Intro-NGS-July-2018/raw/master/images/introduction-to-nextgeneration-sequencing-and-variant-calling-karin-kassahn-45-638.jpg)

## Sorting Alignments

Before we start calling variants we will need to **sort the alignments**.
The original file will contain alignments in the order they were found in the original fastq file, so sorting arranges them in *genomic order*.

```
mkdir ~/Practical_7/2_alignedData/sorted_bam
cd ~/Practical_7/2_alignedData
samtools sort bam/SRR2003569_chI.bam -o sorted_bam/SRR2003569_chI.bam
```

This helps the variant caller to run the calling algorithm efficiently and prevents additional time to be allocated to going back and forth along the genome. 
This is standard for most NGS downstream programs, such as RNA gene quantification and ChIPseq peak calling.

Once we've sorted our alignments, we usually *index* the file, which allows rapid searching of the file.
Running the following command will create an associated `bai` file which is the index associated with our sorted alignments.

```
samtools index sorted_bam/SRR2003569_chI.bam
```

---
**Note: Additional Filtering**
Ideally, before we start calling variants, there is a level of duplicate filtering that needs to be carried out to ensure accuracy of variant calling and allele frequencies. 
The duplicates we wish to remove are generated during PCR and are not biological in origin, however **we'll skip this step today**.
For future reference, the code you would use to do this is:

```
# Remove duplicates the samtools way
samtools rmdup [SORTED BAM] [SORTED RMDUP BAM]

# Remove duplicates the picard way (which uses Java)
java -jar /path/to/picard/tools/picard.jar MarkDuplicates I=[SORTED BAM] O=[SORTED RMDUP BAM] M=dups.metrics.txt REMOVE_DUPLICATES=true
```

We would probably place these in a new folder called 3_deduplicatedData/bam, however everyone does have their own unique approach to setting up directories.

---

## Variant callers

Variant callers work by counting all reference and alternative alleles at every individual site on the reference genome. 
Because there will be two alleles (e.g. A and B) for each individual reference base (assuming the organism that you are sampling is diploid), then there will be sites which are all reference (AA) or alternate (BB) alleles, which we call a homozygous site. 
If the number of sites is close to 50/50 reference and alternate alleles (AB), we have a heterozygous site.

There are many variant calling algorithms, which all have advantages and disadvantages in terms of selectivity and sensitivity. 
Many algorithms aim to detect *regions* of the genome where many variants have been called, rather than individual sites, and thus are called *haplotype callers*. 
The standard output of a variant caller is a *variant call format* (VCF) file, a tab-separated file which details information about every sequence variant within the alignment. 
It contains everything that you need to know about the sequence variant, the chromosome, position, reference and alternate alleles, the variant quality score and the genotype code (e.g. 0/0, 1/1, 0/1). 
Additionally, the VCF file can be annotated to include information on the region in which a variant was found, such as gene information, whether the variant had a ID (from major databases such as NCBI's dbSNP for example) or whether the variant changed an amino-acid codon or not (synonymous vs non-synonymous sequence variants).

![Variant Call Format](https://github.com/BIG-SA/Intro-NGS-July-2018/raw/master/images/vcfformat.jpg)

Today we are going to use the haplotype-based caller `freebayes`, which is [a Bayesian genetic variant detector designed to find small polymorphisms, specifically SNPs (single-nucleotide polymorphisms), indels (insertions and deletions), MNPs (multi-nucleotide polymorphisms), and complex events (composite insertion and substitution events) smaller than the length of a short-read sequencing alignment](https://github.com/ekg/freebayes).

Time to run the variant calling. 
All we need is a reference genome sequence (fasta file), a index of the reference genome (we can do this using `samtools`), and our BAM alignment. 
Because variant calling takes a long time to complete, we will only call variants in the first 1Mb of *C. elegans* ChrI to save time. 
To enable us to subset the command, we also need to index the alignment file:

```
# Make sure you're in the project root
cd ~/Practical_7
mkdir 2_alignedData/vcf

# Index the reference genome
samtools faidx genome/chrI.fa

# Run freebayes to create VCF file
freebayes \
  -f genome/chrI.fa \
  --region I:1-1000000 \
  2_alignedData/sorted_bam/SRR2003569_chI.bam > \
  2_alignedData/vcf/SRR2003569_chI_1Mb.vcf
```

If you're interested in getting all variants from ChrI, run the command without the `--region I:1-5000000` parameter.

## Interpreting VCF

Ok, lets have a look at our VCF file using the command `head`. 
The first part of the file is called the header and it contains all information about the reference sequence, the command that was run, and an explanation of every bit of information that's contained within the *FORMAT* and *INFO* fields of each called variant. 
These lines are denoted by two hash symbols at the beginning of the line ("\#\#"). 
The last line before the start of the variant calls is different to most of the header, as it has one \# and contains the column names for the rest of the file. 
Because we did not specify a name for this sample, the genotype field (the last field of the column line) says "unknown".

```
##fileformat=VCFv4.2
##fileDate=20190904
##source=freeBayes v1.3.1-dirty
##reference=genome/chrI.fa
##contig=<ID=I,length=15072434>
##phasing=none
##commandline="freebayes -f genome/chrI.fa --region I:1-1000000 2_alignedData/sorted_bam/SRR2003569_chI.bam"
##INFO=<ID=NS,Number=1,Type=Integer,Description="Number of samples with data">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Total read depth at the locus">
##INFO=<ID=DPB,Number=1,Type=Float,Description="Total read depth per bp at the locus; bases in reads overlapping / bases in haplotype">
```

After the header comes the actual variant calls, starting from the start of the specified genomic region (in our case: ChrI Position 1bp).
In our particular file, the header goes for 60 lines, so we may need `sed` to check this section of the file.

```
sed -n '61,64p' 2_alignedData/vcf/SRR2003569_chI_1Mb.vcf
```

```
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  unknown
I       352     .       TA      TG,TT   0.0290299       .       AB=0,0;ABP=0,0;AC=0,0;AF=0,0;AN=2;AO=2,2;CIGAR=1M1X,1M1X;DP=13;DPB=13;DPRA=0,0;EPP=3.0103,7.35324;EPPR=5.18177;GTI=0;LEN=1,1;MEANALT=2,2;MQM=11,6;MQMR=9.22222;NS=1;NUMALT=2;ODDS=5.03558;PAIRED=0.5,1;PAIREDR=0.777778;PAO=0,0;PQA=0,0;PQR=0;PRO=0;QA=66,66;QR=318;RO=9;RPL=0,0;RPP=7.35324,7.35324;RPPR=22.5536;RPR=2,2;RUN=1,1;SAF=1,0;SAP=3.0103,7.35324;SAR=1,2;SRF=6;SRP=5.18177;SRR=3;TYPE=snp,snp     GT:DP:AD:RO:QR:AO:QA:GL 0/0:13:9,2,2:9:318:2,2:66,66:0,-1.31131,-5.26205,-2.25752,-5.39282,-6.16753
I       359     .       A       T       1.91348e-08     .       AB=0.222222;ABP=27.1378;AC=1;AF=0.5;AN=2;AO=8;CIGAR=1X;DP=36;DPB=36;DPRA=0;EPP=20.3821;EPPR=16.6021;GTI=0;LEN=1;MEANALT=2;MQM=17.25;MQMR=10.9259;NS=1;NUMALT=1;ODDS=19.2582;PAIRED=0.125;PAIREDR=0.592593;PAO=0;PQA=0;PQR=0;PRO=0;QA=298;QR=1004;RO=27;RPL=0;RPP=20.3821;RPPR=61.6401;RPR=8;RUN=1;SAF=8;SAP=20.3821;SAR=0;SRF=20;SRP=16.6021;SRR=7;TYPE=snp   GT:DP:AD:RO:QR:AO:QA:GL 0/1:36:27,8:27:1004:8:298:-1.98135,0,-15.6069
I       362     .       C       T       0       .       AB=0;ABP=0;AC=0;AF=0;AN=2;AO=5;CIGAR=1X;DP=50;DPB=50;DPRA=0;EPP=13.8677;EPPR=22.751;GTI=0;LEN=1;MEANALT=2;MQM=28.2;MQMR=13.0227;NS=1;NUMALT=1;ODDS=43.9933;PAIRED=0.4;PAIREDR=0.545455;PAO=0;PQA=0;PQR=0;PRO=0;QA=171;QR=1620;RO=44;RPL=0;RPP=13.8677;RPPR=98.5551;RPR=5;RUN=1;SAF=5;SAP=13.8677;SAR=0;SRF=32;SRP=22.751;SRR=12;TYPE=snp    GT:DP:AD:RO:QR:AO:QA:GL   0/0:50:44,5:44:1620:5:171:0,-4.42149,-39.0258
```


### Questions

1. How many variants were called in region ChrI:1-1Mb?

2. The VCF file above shows three variants from the called VCF. What types of variants are they, and are they homozygous or heterozygous?

3. Which INFO field contains information about the variant allele-frequency?


If you have made it this far & wish to keep going, there is an optional section of [Bonus Material](2a_NGS_Bonus).
None of this material will be referenced in future sessions, however you may find it interesting.
