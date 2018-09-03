* TOC
{:toc}

# Sequence Alignment

Once we have cleaned our data of any contaminating sequences, and removed the bases which are more likely to contain errors we can more confidently align our reads to a reference.  Different experiments may have different reference sequences depending on the context.  For example, if we have a sub-sample of the genome associated with restriction sites like RAD-Seq, we would probably align to a reference genome, or if we have RNA-Seq we might choose to align to the transcriptome instead of the whole genome.  Alternatively, we might be interested in *de novo* genome or transcriptome assembly where we have no reference genome to compare our data to.

## How Aligning Works

Most fast aligners in widespread public use are based on a technique called the Burrows-Wheeler Transform, which is essentially a way of restructuring, or indexing, the genome to allow very rapid searching.  This technique comes from computer science & is really beyond the scope of what most of us need to know.  The essence of it is that we have a very fast searching method, and most aligners use a seed sequence within each read to begin the searching.  These seeds are then expanded outwards to give the best mapping to a sequence.  There are many different alignment tools available today & each one will have a particular strength. For example, bowtie is very good for mapping short reads, whilst bowtie2 or bwa is more suited to reads longer than 50bp.

#### What’s the difference

Some key differences between aligners is in the way they index the genome, and in the a way they are equipped to handle mismatches & InDels.  Choosing an aligner can be a difficult decision with the differences often being quite subtle.  Sometimes there is a best choice, other times there really isn’t.  Make sure you’ve researched relatively thoroughly before deciding which to use.

## Aligning our WGS reads

### Downloading A Reference Genome

To align any reads, we first need to download the appropriate (i.e.  latest) genome \& then we can build the index to enable fast searching via the Burrows-Wheeler Transform. Like we’ve seen in the previous sections, our reads today come from the nematode or Roundworm (*Caenorhabditis elegans*).  

**Note**: If you want the full genome sequence you can use the command-line program `wget` to download the *C. elegans* genome sequence. If `wget` doesn't work for you, you can always you can always re-download the genome (like you can do with all model genomes) by opening Firefox & head to [ftp://ftp.ensembl.org/pub/release-90/fasta/caenorhabditis_elegans/](ftp://ftp.ensembl.org/pub/release-90/fasta/caenorhabditis_elegans/).  

For today's workshop, we've given you just the sequence of chrI in one of last week's downloads.
It should have been placed in the folder `~/NGS_Practical` but given the varibility we saw last week it may be somewhere else. Cal Dan or Steve over if you can't find it somewhere.


```
# Have a look at the first few lines
cd ~/NGS_Practical
head chrI.fa
```

Note that the first line describes the following sequence & begins with a \> symbol.  We can use this to search within the file using regular expressions \& print all of these description lines.

Let's place this in it's own folder called `Ref/Celegans`

```
mkdir -p Ref/Celegans
mv chrI.fa Ref/Celegans
```


## Building an Index

We will align using the tool `bwa` which is one of the original Burrows-Wheeler transformation mappers. `bwa` was developed in 2009 by Heng Li (Harvard/Broad Institute, USA). From the bwa manual, it details the three specific bwa algorithms: BWA-backtrack, BWA-SW and BWA-MEM. The first algorithm is designed for Illumina sequence reads up to 100bp, while the rest are for longer sequences ranging from 70bp to 1Mbp. BWA-MEM and BWA-SW share similar features such as long-read support and split alignment, but BWA-MEM, which is the latest, is generally recommended for high-quality queries as it is faster and more accurate. 
Today we will be using bwa-mem to align our C. elegans WGS reads. Once again, we need to check the help pages. Fortunately the bwa page is actually pretty friendly on the screen and appears without the usual -h option.

```
bwa
```

We should also inspect the help page for bwa index which we will use to build the index.

```
bwa index
```

Using this particular process you can usually just run the command on the fasta file and the index will be called by the same file-name.  However in this case, we will name the index "Celegans_chrI" by using the `-p` flag/parameter Now that we’ve had a look, type to following command which will take a few minutes to run.

```
cd Ref/Celegans
bwa index chrI.fa -p Celegans_chrI
```

Let’s look at what files have been created.

```
ls
```

You should be able to open a few of the files with the ”less” command, however the main files (\*.sa, \*.bwt and \*.pac) are the BWT transformed files that are in binary, so we can’t really see what they look like, but these are required by the aligner bwa.

## Aligning the reads

Because we only have a small subset of the actual sequencing run, we should be able to run this alignment in a reasonable period of time.
First we'll create a folder to output the alignments.

```
cd ~/NGS_Practical
mkdir -p 03_alignedData/bam
```

Now let's change into the folder where our trimmed data *should* be. 
If yours are somewhere else, change into that directory

```
cd ~/NGS_Practical/02_trimmedData/fastq
```

The command we'll run is quite long, so please read on a little before executing this, so you understand what every seciton does.
This will help you figure out what is going wrong if you get some error messages.
First up here's the command

```
bwa mem -t 2 ~/NGS_Practical/Ref/Celegans/Celegans_chrI SRR2003569_sub_1.fastq.gz SRR2003569_sub_2.fastq.gz | samtools view -bhS -F4 - > SRR2003569_chI.bam
mv SRR2003569_chI.bam ../../03_alignedData/bam
```

Let’s break down this main command a little.  The first part of the command:

```
bwa mem -t 2 ~/NGS_Practical/Celegans_chrI SRR2003569_sub_1.fastq.gz SRR2003569_sub_2.fastq.gz
```

will align our compressed sequenced reads to the Celegans_chrI `bwa` index that we made. Usually you can create a SAM file (see next section) to store all the alignment data.  SAM files however are text files which can take up a significant amount of disk space, so its much more efficient to pipe it to the `samtools` command and create a compressed binary SAM file (called BAM). To do this, we run the program `samtools`:

```
samtools view -bhS - > SRR2003569_chI.bam
```

In this context, `samtools` view is the general command that allows the conversion of the SAM to BAM. There is another more compressed version of the SAM file, called CRAM, which you can also create using `samtools` view.  However, we will not use that today.

**Note:** By using the `-t 2` parameter, we can take advantage of modern computers that allow multi-threading or parallelisation. This just means that the command can be broken up into 2 chunks and run in parallel, speeding up the process. 
If using phoenix or another HPC, this can really speed things up as more than 2 cores are available.

From there we moved our alignments into a more appropriate directory (`mv SRR2003569_chI.bam ../../03_alignedData/bam`).
We could've written to this directory directly, and would usually do this in a full analysis, but the command was already getting rather lengthy.

To find out information on your resulting alignment you can `samtools`:

```
cd ~/NGS_Practical/03_alignedData/bam
samtools stats SRR2003569_chI.bam
```

This is basically the same as another command `samtools flagstat`, but it gives additional information.

### Questions
{:.no_toc}

1. How many reads aligned to our genome?

2. How many reads aligned as a pair?

3. What information does `samtools stats` provide that `samtools flagstat` does not?

4. How many aligned as a "proper" pair? ..what the hell is a proper pair anyway??


# SAM/BAM files

## The SAM/BAM file format

Reads that have been aligned to a reference are no longer stored in fastq format but are stored in either SAM or BAM format.
These two formats are virtually identical, however the SAM format is a text file which is easily readable to human eyes, whilst a BAM file is the same information converted to binary.
This conversion means that file sizes are smaller, and that computational processes can be performed more efficiently, as this is a format able to be read more quickly by a computer.
Typically, we work with BAM files as these provide gains in storage space & analytic speed.
The tools we use to inspect these files are provided in the package samtools, which has been installed on your VM.

The reads from the dataset which mapped to *chrI* of *C. elegans* are in the folder `~/NGS_Practical/02_trimmedData/fastq`

```
cd ~/NGS_Practical/02_trimmedData/fastq
ls
```

## Conversion to BAM format

The BAM format is much more convenient computationally, so we have converted our alignments into BAM format using `samtools view` during the alignment process.
SAM files are *plain text*, whilst BAM files are *compressed* and much easier for the computer to read/write.
As BAM files are in binary format they will look like gibberish if we try to read them directly.
Instead we can inspect them by using `samtools view` as in the line above.

There is also a header seection to each file which details the fasta files used in the alignments.
To view this header we use

```
samtools view SRR2003569_chI.bam | head
```

To view the entire header and not the alignments, we can use 

```
samtools view -H SRR2003569_chI.bam
```

As this data can easily spill across lines, it might be helpful to maximise your terminal to see the complete line structure.

## The SAM/BAM data structure

If we understand what information is contained within a file, we can know what decisions to make as we progress with our analysis, so let's have a look at what the data structure is for a SAM/BAM file.
A SAM/BAM file is `tab-delimited`, which means that each field is separated by a tab, giving a data structure effectively consisting of columns (or fields).
In order, these are:

| 1 | QNAME | Query template/pair NAME |
| 2 | FLAG | bitwise FLAG |
| 3 | RNAME | Reference sequence NAME |
| 4 | POS | 1-based leftmost POSition/coordinate of clipped sequence |
| 5 | MAPQ | MAPping Quality (Phred-scaled) |
| 6 | CIGAR | extended CIGAR string |
| 7 | MRNM | Mate Reference sequence NaMe (`=` if same as RNAME) |
| 8 | MPOS | 1-based Mate POSistion |
| 9 | TLEN | inferred Template LENgth (insert size) |
| 10 | SEQ | query SEQuence on the same strand as the reference |
| 11 | QUAL | query QUALity (ASCII-33 gives the Phred base quality) |
| 12 | OPT | variable OPTional fields in the format TAG:VTYPE:VALUE |

Notice that eachread is consideredto be a *query* in the above descriptions, as we a querying the genome to find out where it probably came from.

Several of these fields contain useful information, so looking the the first few lines which we displayed above, you can see that these reads are mapped in pairs as consecutive entries in the QNAME field are often (but not always) identical.
Most of these fields are self-explanatory, but some require exploration in more detail.


## SAM Flags

These are quite useful pieces of information, but can be difficult at first look.
Head to http://broadinstitute.github.io/picard/explain-flags.html to see a helpful description, then try clicking on a few combinations to see how the numbers change.
The simplest way to understand these is that it is a bitwise system so that each description heading down the page increases ina binary fashion.
The first has value 1, the second has value 2, the third has value 4 & so on until you reach the final value of 2048.
The integer value contained in this file is the unique sum of whichever attributes the mapping has.
For example, if the read is paired \& mapped in a proper pair, but no other attributes are set, the flag field would contain the value 3.

#### Questions
{:.no_toc}


1. *What value could a flag take if the read was 1 - paired; 2 - mapped in a proper pair; 3 - it was the first in the pair \& 4 - the alignment was a supplementary alignment.*
2. *Some common values in the bam file are 99, 147 & 145. Look up the meanings of these values.*



Things can easily begin to confuse people once you start searching for specific flags, but if you remember that each attribute is like an individual flag that is either on or off (i.e. it is actually a binary bit with values 0 or 1).
If you searched for flags with the value 1, you wouldn't obtain the alignments with the exact value 1, rather you would obtain the alignments **for which the first flag is set** & these can take a range of values.


Let's try this using the command `samtools view` with the option `-f` to include reads with a flag set and the option `-F` to exclude reads with a specific flag set.
Let's get the first few reads which are mapped in a proper pair, so the flag `2` will be set.

```
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

You can pull out highly specific combinations of alignments should you so choose


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

NGS has enabled sequence variants to be identified at an extremely high resolution, due to the increase of sequence *coverage* i.e. the amount of times one base of DNA has been sequenced. When we say "a genome has been sequenced to 10x coverage", what we mean is that each individual base in the genome has been sequenced an average of 10 times. Compared to previous sequencing technologies such as Sanger, which sequenced an individual region of DNA once, it was incredibly difficult to identify sequence variants and involved a lot of erroneous calls.

![Sanger vs NGS variants](https://github.com/BIG-SA/Intro-NGS-July-2018/raw/master/images/introduction-to-nextgeneration-sequencing-and-variant-calling-karin-kassahn-45-638.jpg)

However, before we start calling variants we will need to **sort the alignments**.
The original file will contain alignments in the order they were found inthe original fastq file, so sorting arranges them in *genomic order*.

```
samtools sort SRR2003569_chI.bam SRR2003569_chI.sorted
```

This helps the variant caller to run the calling algorithm efficiently and prevents additional time to be allocated to going back and forth along the genome. This is command for most NGS downstream programs, such as RNA gene quantification and ChIPseq peak calling.

---
**Note: Additional Filtering**
Ideally, before we start calling variants, there is a level of duplicate filtering that needs to be carried out to ensure accuracy of variant calling and allele frequencies. The duplicates we wish to remove are generated during PCR and are not biological in origin, however **we'll skip this step today**.
For future reference, the code you would use to do this is:

```
# Remove duplicates the samtools way
samtools rmdup [SORTED BAM] [SORTED RMDUP BAM]

# Remove duplicates the picard way (which uses Java)
java -jar /path/to/picard/tools/picard.jar MarkDuplicates I=[SORTED BAM] O=[SORTED RMDUP BAM] M=dups.metrics.txt REMOVE_DUPLICATES=true
```

---

## Variant callers

Variant callers work by counting all reference and alternative alleles at every individual site on the reference genome. Because there will be two alleles (e.g. A and B) for each individual reference base (assuming the organism that you are sampling is diploid), then there will be sites which are all reference (AA) or alternate (BB) alleles, which we call a homozygous site. If the number of sites is close to 50/50 reference and alternate alleles (AB), we have a heterozygous site.

There are many variant calling algorithms, which all have advantages and disadvantages in terms of selectivity and sensitivity. Many algorithms aim to detect *regions* of the genome where many variants have been called, rather than individual sites, and thus are called *haplotype callers*. The standard output of a variant caller is a *variant call format* (VCF) file, a tab-separated file which details information about every sequence variant within the alignment. It contains everything that you need to know about the sequence variant, the chromosome, position, reference and alternate alleles, the variant quality score and the genotype code (e.g. 0/0, 1/1, 0/1). Additionally, the VCF file can be annotated to include information on the region in which a variant was found, such as gene information, whether the variant had a ID (from major databases such as NCBI's dbSNP for example) or whether the variant changed an amino-acid codon or not (synonymous vs non-synonymous sequence variants).

![Variant Call Format](https://github.com/BIG-SA/Intro-NGS-July-2018/raw/master/images/vcfformat.jpg)

Today we are going to use the haplotype-based caller `freebayes`, which is [a Bayesian genetic variant detector designed to find small polymorphisms, specifically SNPs (single-nucleotide polymorphisms), indels (insertions and deletions), MNPs (multi-nucleotide polymorphisms), and complex events (composite insertion and substitution events) smaller than the length of a short-read sequencing alignment](https://github.com/ekg/freebayes).

Time to run the variant calling. All we need is a reference genome sequence (fasta file), a index of the reference genome (we can do this using `samtools`), and our BAM alignment. Because variant calling takes a long time to complete, we will only call variants in the first 1Mb of *C. elegans* ChrI to save time. To enable us to subset the command, we also need to index the alignment file:

```
# Index the reference genome
samtools faidx chrI.fa

# Index the alignment file
samtools index SRR2003569_chI.sorted.bam

# Run freebayes to create VCF file
freebayes -f chrI.fa --region I:1-1000000 SRR2003569_chI.sorted.bam > SRR2003569_chI_1Mb.sorted.vcf
```

If you're interested in getting all variants from ChrI, run the command without the `--region I:1-5000000` parameter.

## Interpreting VCF

Ok, lets have a look at our VCF file. The first part of the file is called the header and it contains all information about the reference sequence, the command that was run, and an explanation of every bit of information that's contained within the *FORMAT* and *INFO* fields of each called variant. These lines are denoted by two hash symbols at the beginning of the line ("\#\#"). The last line before the start of the variant calls is different to most of the header, as it has one \# and contains the column names for the rest of the file. Because we did not specify a name for this sample, the genotype field (the last field of the column line) says "unknown".

```
##fileformat=VCFv4.2
##fileDate=20170924
##source=freeBayes v1.1.0-9-g09d4ecf
##reference=chrI.fa
##contig=<ID=I,length=15072434>
##phasing=none
##commandline="freebayes -f chrI.fa --region I:1-1000000 SRR2003569_chI.sorted.bam"
##INFO=<ID=NS,Number=1,Type=Integer,Description="Number of samples with data">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Total read depth at the locus">
...
##FORMAT=<ID=MIN_DP,Number=1,Type=Integer,Description="Minimum depth in gVCF output block.">
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  unknown
```

After the header comes the actual variant calls, starting from the start of the specified genomic region (in our case: ChrI Position 1bp).

```
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  unknown
I       359     .       A       T       1.53071e-06     .       AB=0.205128;ABP=32.4644;AC=1;AF=0.5;AN=2;AO=8;CIGAR=1X;DP=39;DPB=39;DPRA=0;EPP=20.3821;EPPR=17.1973;GTI=0;LEN=1;MEANALT=2;MQM=21.5;MQMR=10.0667;NS=1;NUMALT=1;ODDS=14.8585;PAIRED=0.25;PAIREDR=0.566667;PAO=0;PQA=0;PQR=0;PRO=0;QA=297;QR=1097;RO=30;RPL=0;RPP=20.3821;RPPR=68.1545;RPR=8;RUN=1;SAF=8;SAP=20.3821;SAR=0;SRF=22;SRP=17.1973;SRR=8;TYPE=snp       GT:DP:AD:RO:QR:AO:QA:GL 0/1:39:30,8:30:1097:8:297:-2.627,0,-15.4132
I       384     .       A       T       11.6927 .       AB=0.303371;ABP=62.7868;AC=1;AF=0.5;AN=2;AO=54;CIGAR=1X;DP=178;DPB=178;DPRA=0;EPP=49.4959;EPPR=38.7602;GTI=0;LEN=1;MEANALT=2;MQM=21.2222;MQMR=10.4228;NS=1;NUMALT=1;ODDS=2.622;PAIRED=0.407407;PAIREDR=0.617886;PAO=0;PQA=0;PQR=0;PRO=0;QA=2002;QR=4545;RO=123;RPL=0;RPP=120.27;RPPR=261.486;RPR=54;RUN=1;SAF=44;SAP=49.4959;SAR=10;SRF=83;SRP=35.653;SRR=40;TYPE=snp   GT:DP:AD:RO:QR:AO:QA:GL 0/1:178:123,54:123:4545:54:2002:-38.3333,0,-56.9841
I       437     .       T       A       26.7335 .       AB=0.444444;ABP=3.25157;AC=1;AF=0.5;AN=2;AO=4;CIGAR=1X;DP=9;DPB=9;DPRA=0;EPP=5.18177;EPPR=13.8677;GTI=0;LEN=1;MEANALT=1;MQM=16.25;MQMR=11.4;NS=1;NUMALT=1;ODDS=6.15346;PAIRED=0.75;PAIREDR=0.4;PAO=0;PQA=0;PQR=0;PRO=0;QA=128;QR=161;RO=5;RPL=4;RPP=11.6962;RPPR=13.8677;RPR=0;RUN=1;SAF=3;SAP=5.18177;SAR=1;SRF=5;SRP=13.8677;SRR=0;TYPE=snp   GT:DP:AD:RO:QR:AO:QA:GL 0/1:9:5,4:5:161:4:128:-3.05744,0,-2.49224
```


### Questions

1. How many variants were called in region ChrI:1-1Mb?

2. The VCF file above shows three variants from the called VCF. What types of variants are they, and are they homozygous or heterozygous?

3. Which INFO field contains information about the variant allele-frequency?

## Filtering the VCF

While we seem to have called a lot of variants on chrI, have a look at the sequence that the chromosome starts off with:

```
head chrI.fa
```

What can you say about the sequence?

Just because a variant is called, does not mean that it is a true positive! Each variant called within the file holds a variant quality score (found in the *QUAL* field). [From the VCF format specifications](http://www.internationalgenome.org/wiki/Analysis/vcf4.0):

```
QUAL phred-scaled quality score for the assertion made in ALT. i.e. give -10log_10 prob(call in ALT is wrong). If ALT is ”.” (no variant) then this is -10log_10 p(variant), and if ALT is not ”.” this is -10log_10 p(no variant). High QUAL scores indicate high confidence calls. Although traditionally people use integer phred scores, this field is permitted to be a floating point to enable higher resolution for low confidence calls if desired. (Numeric)
```


To weed out the low confidence calls in our VCF file we need to filter by QUAL. This can be done using the `bcftools` program that's included within the `samtools` suite of tools. All these tools can run on gzip-compressed files which saves a lot of space on your computer.

```
gzip SRR2003569_chI_1Mb.sorted.bam.vcf
```

Ok lets filter by QUAL. We can do this with the `bcftools filter` or  `bcftools view` commands which allows you to run an expression filter. This means you can either exclude (`-e`) or include (`-i`) variants based on a certain criteria. In our case, lets exclude all variants that have a QUAL < 30.

```
bcftools filter -e 'QUAL < 30' SRR2003569_chI_1Mb.sorted.vcf.gz -Oz -o SRR2003569_chI_1Mb.sorted.q30.vcf.gz

# You can pipe to grep and wc to remove the header
#   and count your remaining variants after filtering too
bcftools filter -e 'QUAL < 30' SRR2003569_chI_1Mb.sorted.vcf.gz | grep -v "^#" | wc -l
```

How many variants greater than QUAL 30 do you have? How about the number of heterozygous variants that have a QUAL>30?

```
bcftools filter -i 'QUAL>30 && GT="0/1"' SRR2003569_chI_1Mb.sorted.vcf.gz
```

The `bcftools view` commands gives a lot of additional filtering options.


### Questions

1. Use the `bcftools view` or `bcftools filter` command to count the number of:
   a. SNPs
   b. homozygous variants

2. Depth is also a common filtering characteristic that many people use to remove low confidence variants. If you have low coverage of a variant, it lowers your ability to accurately call a heterozygotic site (especially if you are confident that you sequenced the sample the an adequate depth!). Find the number of SNPs that have a depth that is equal to or greater than 30 and a quality that is greater than 30.

## Genomic VCF

While we can identify variants easily, what happens with the other regions? Do we know that there is no variants in regions that are not called? What happens if there is low genome sequence coverage in those regions? How can we be sure that we are not identifying variants in those regions?

Using `freebayes` (and other haplotype/variant callers), we are able to create a *genomic* VCF or GVCF, which includes coverage information of the uncalled regions.

```
freebayes -f chrI.fa --region I:1-1000000 SRR2003569_chI.sorted.bam --gvcf > SRR2003569_chI_1Mb.sorted.gvcf
```

Lets have a look at the GVCF file and see how it differs from VCF

```
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  unknown
I       2       .       C       <*>     0       .       DP=0;END=358;MIN_DP=0   GQ:DP:MIN_DP:QR:QA      6842.23:0:0:7068:225.773
I       359     .       A       T       1.53071e-06     .       AB=0.205128;ABP=32.4644;AC=1;AF=0.5;AN=2;AO=8;CIGAR=1X;DP=39;DPB=39;DPRA=0;EPP=20.3821;EPPR=17.1973;GTI=0;LEN=1;MEANALT=2;MQM=21.5;MQMR=10.0667;NS=1;NUMALT=1;ODDS=14.8585;PAIRED=0.25;PAIREDR=0.566667;PAO=0;PQA=0;PQR=0;PRO=0;QA=297;QR=1097;RO=30;RPL=0;RPP=20.3821;RPPR=68.1545;RPR=8;RUN=1;SAF=8;SAP=20.3821;SAR=0;SRF=22;SRP=17.1973;SRR=8;TYPE=snp       GT:DP:AD:RO:QR:AO:QA:GL 0/1:39:30,8:30:1097:8:297:-2.627,0,-15.4132
I       360     .       A       <*>     0       .       DP=104;END=383;MIN_DP=39        GQ:DP:MIN_DP:QR:QA      83975.4:104:39:87242:3266.63
I       384     .       A       T       11.6927 .       AB=0.303371;ABP=62.7868;AC=1;AF=0.5;AN=2;AO=54;CIGAR=1X;DP=178;DPB=178;DPRA=0;EPP=49.4959;EPPR=38.7602;GTI=0;LEN=1;MEANALT=2;MQM=21.2222;MQMR=10.4228;NS=1;NUMALT=1;ODDS=2.622;PAIRED=0.407407;PAIREDR=0.617886;PAO=0;PQA=0;PQR=0;PRO=0;QA=2002;QR=4545;RO=123;RPL=0;RPP=120.27;RPPR=261.486;RPR=54;RUN=1;SAF=44;SAP=49.4959;SAR=10;SRF=83;SRP=35.653;SRR=40;TYPE=snp   GT:DP:AD:RO:QR:AO:QA:GL 0/1:178:123,54:123:4545:54:2002:-38.3333,0,-56.9841
I       385     .       G       <*>     0       .       DP=280;END=436;MIN_DP=81        GQ:DP:MIN_DP:QR:QA      521301:280:81:529404:8103.11
```

The first called line shows that between Position 2 till Position 358, there was no coverage (depth == 0). Therefore no variant could be called in that region. However two lines later we see that there is a region from between Position 360 till 383 which has extremely good coverage (depth of 104 with a minimum depth of 39), meaning that we can be sure that we only find the reference allele in that block.

### Why are Genomic VCFs important?

In large scale human genomics or whole genome sequencing used to diagnose a patient in the clinic, it is important that you are sure that you are not only identifying high-quality variants, but that you are not missing potentially pathogenic sequence variants in those regions that are difficult to sample. Its also important to note that the human reference genome is not exactly ethnically diverse (most of the genome is sequenced from European Individuals), meaning that one population's reference allele could easily be an alternate allele in another. GVCFs enable the user to derive the maximum amount of genomics information as possible from the variant caller.

---

# Viewing the alignments

A common tool used for viewing alignments is IGV browser.
Before we can view the alignments we need to sort and index the alignments.
We should have already sorted them, but indexing them simply enables IGV to know exactly where to look in the file to find reads from our requested region.
Although our files today are small, this is very important in a real world context where file can be much larger

```
samtools sort SRR2003569_chI.bam > SRR2003569_chI.sorted.bam
samtools index SRR2003569_chI.sorted.bam
```

Now we can open IGV by entering `igv` in the terminal.
This will open in a new window which may take a moment or two.

```
igv
```

Once you've opened IGV, go to the `Genomes` menu & select `Load genome from file`.
Navigate to where you have `chrI.fa` and load this file.
Although this isn't the full genome, it will have everything we've aligned.

Now go to the `File` menu and select `Load from File` and navigate to your alignments.
Unfortunately you won't see anything until you zoom in.
This is so IGV doesn't hold the entire set of alignments in memory which would slow your computer to a stand-still.
Keep zooming in until some alignments appear then have a look around.


#### Questions
{:.no_toc}

1. *What does all of the information mean when you hover over an alignment?*
2. Using the variant locations in your VCF, choose a selection of variants, and see if you canfind them using IGV. Do you agree with all of the identified variants?
3. Would we need to set any different parameters when calling variants on the autosomes or the mitochondria?


