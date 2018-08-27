* TOC
{:toc}

# NGS Data 

Next-generation sequencing (NGS) has become an important tool in assessing biological signal within an organism or population. Stemming from previous low-throughput technologies that were costly and time-consuming to run, NGS platforms are relatively cheap and enable the investigation of the genome, transcriptome, methylome etc at extremely high resolution by sequencing large numbers of RNA/DNA fragments simultaneously. 
The high-throughput of these machines also has unique challenges, and it is important that scientists are aware of the potential limitations of the platforms and the issues involved with the production of good quality data.

In this course, we will introduce the key file types used in genomic analyses, illustrate the fundamentals of Illumina NGS technology (the current market leader in the production of sequencing data), describe the affect that library preparation can have on downstream data, as well as running through a basic workflow used to analyse NGS data.

Before we can begin to explore any data, it is helpful to understand how it was generated. Whilst there are numerous platforms for generation of NGS data, today we will look at the Illumina Sequencing by Synthesis method, which is one of the most common methods in use today.  Many of you will be familiar with the process involved, but it may be worth looking at the following [5-minute video from Illumina:](https://youtu.be/fCd6B5HRaZ8).


This video picks up *after* the process of fragmentation, as most strategies require DNA/RNA fragments within a certain size range. This step may vary depending on your experiment, but the important concept to note during sample preparation is that the DNA insert has multiple sequences ligated to either end. These include 1) the sequencing primers, 2) index & /or barcode sequences, and 3) the flow-cell binding oligos.


### Barcodes Vs Indexes

In the video, you may have noticed an index sequence being mentioned which was within the sequencing primers \& adapters ligated to each fragment.
Under this approach, a unique index is added to each sample during library preparation and these are used to identify which read came from which sample.
This is a common strategy in RNA-Seq libraries and many other analyses with relatively low replicate numbers (i.e <= 16 transcriptomes).
Importantly, the index will not be included in either the forward or reverse read.

A common alternative for analyses such as RAD-seq or GBS-seq, where population level data is being sequenced using a reduced representation approach.
In these strategies, a *barcode* is added *in-line* and is directly next to the restriction site used to fragment the data (if a restriction enzyme approach was used for fragmentation).
These barcodes are included next to the genomic sequence, and will be present in either or both the forward or reverse reads, depending on the barcoding strategy being used.
A single barcode is shown in B) of the following image (taken from https://rnaseq.uoregon.edu/), whilst a single index is shown in C).

![](https://big-sa.github.io/Intro-NGS-July-2018/images/libprep.jpg)


## FASTQ File Format

As the sequences are extended during the sequencing reaction, an image is recorded which is effectively a movie or series of frames at which the addition of bases is recorded & detected.  We mostly don’t deal with these image files, but will handle data generated from these in *fastq* format, which can commonly have the file suffix .fq or .fastq. As these files are often very large, they will often be zipped using `gzip` or `bzip`.  Whilst we would instinctively want to unzip these files using the command gunzip, most NGS tools are able to work with zipped fastq files, so decompression (or extraction) is not usually necessary.  This can save considerable hard drive space, which is an important consideration when handling NGS datasets as the quantity of data can easily push your storage capacity to it’s limit.

The data for today's practical may not have been copied successfully during the VM setup, so let's get the files we need for today.
This may take a couple of minutes

```
cd ~/NGS_Practical/01_rawData/fastq/
wget https://universityofadelaide.box.com/shared/static/nqf2ofb28eao26adxxillvs561w7iy5s.gz -O subData.tar.gz
tar -xzvf subData.tar.gz
rm subData.tar.gz
mv chrI.fa ../..
```

The command `zcat` unzips a file & prints the output to the terminal, or standard output (stdout).  If we did this to these files, we would see a stream of data whizzing past in the terminal, but instead we can just pipe the output of zcat to the command head to view the first 8 lines of a file.

```
zcat SRR2003569_sub_1.fastq.gz | head -n8
```

In the above command, we have used a trick commonly used in Linux systems where we have taken the output of one command (`zcat SRR2003569_sub_1.fastq.gz`) and sent it to another command (`head`) by using the pipe symbol (`|`). This is literally like sticking a pipe on the end of a process & redirecting the output to the input another process (you should remember this from your Introduction to Bash Sessions).  
Additionally, we gave the argument `-n8` to the command head to ensure that we only printed the first eight lines.

In the output from the above terminal command, we have obtained the first 8 lines of the gzipped fastq file. This gives a clear view of the fastq file format, where each individual read spans four lines.  These lines are:

1. The read identifier
2. The sequence read
3. An alternate line for the identifier (commonly left blank as just a + symbol acting as a placeholder)
4. The quality scores for each position along the read as a series of ascii text characters. Let’s have a brief look at each of these lines and what they mean.

### 1. The read identifier
{:.no_toc}

This line begins with an @ symbol and although there is some variability between dirrerent sequencing platforms and software versions, it traditionally has several components.  Today’s data have been sourced from an EBI data repository with the identifier SRR065388.  For the first sequence in this file, we have the full identifier `@SRR2003569.1 JLK5VL1:245:D1DF6ACXX:6:1101:4181:2239/1` which has the following components:

| @SRR2003569.1 | The aforementioned EBI identifier & the sequence ID within the file.  As this is the first read, we have the number 1.  NB: This identifier is not present when data is obtained directly from the machine or service provider. |
| JLK5VL1:245:D1DF6ACXX | The unique machine ID |
| 6    | The flowcell lane |
| 1101 | The tile within the flowcell lane |
| 4181 | The x-coordinate of the cluster within the tile |
| 2239 | The y-coordinate of the cluster within the tile |
| /1   | Indicates that this is the first read in a set of paired-end reads |

As seen in the subsequent sections, these pieces of information can be helpful in identifying if any spatial effects have affected the quality of the reads.  By and large you won’t need to utilise most of this information, but it can be handy for times of serious data exploration.

While we are inspecting our data, have a look at the beginning of the second file.

```
zcat SRR2003569_sub_2.fastq.gz | head -n8
```

Here you will notice that the information in the identifier is identical to the first file we inspected, with the exception that there is a `/2` at the end.  This indicates that these reads are the second set in what are known as paired-end reads, as were introduced in the above video.  The two files will have this identical structure where the order of the sequences in one is identical to the order of the sequences in the other.  This way when they are read as a pair of files, they can be stepped through read-by-read & the integrity of the data will be kept intact.


### 2. The Sequence Read
{:.no_toc}

This is pretty obvious, and just contains the sequence generated from each cluster on the flow-cell.
Notice, that after this line is one which just begins with the `+` symbol and is blank.
In early versions of th technology, this repeated the sequence identifier, but this is now just a placeholder.

### 3. Quality Scores
{:.no_toc}

The only other line in the fastq format that really needs some introduction is the quality score information. These  are  presented  as  single *ascii* text characters for simple visual alignment with the sequence.
In the ascii text system, each character has a numeric value which we can interpret as an integer, and in this context is the quailty score for the corresponding base. Head to the website with a description of these at [ASCII Code table](http://en.wikipedia.org/wiki/ASCII#ASCII_printable_code_chart).

The first 31 ASCII characters are non-printable & contain things like end-of-line marks and tab spacings, and note that the first printable character after the space (character 32) is "!"  which corresponds to the value 33.  In short, the values 33-47 are symbols like \!, \#, \$ etc, whereas the values 48-57 are the characters 0-9.  Next are some more symbols (including @ for the value 64), with the upper case characters representing the values 65-90 & the lower case letters representing the values 97-122.

## The PHRED +33/64 Scoring System

Now that we understand how to turn the quality scores from an ascii character into a numeric value, we need to know what these numbers represent.  The two main systems in common usage are PHRED +33 and PHRED +64 and for each of these coding systems we either subtract 33 or 64 from the numeric value associated with each ascii character to give us a PHRED score. As will be discussed later, this score ranges between 0 and about 41.

The PHRED system used is determined by the software installed on the sequencing machine, with early machines using PHRED+64 (casava \<1.5), and more recent machines tending to use PHRED+33.  For example, in PHRED+33, the @ symbol corresponds to Q = 64 - 33 = 31, whereas in PHRED +64 it corresponds to Q = 64 - 64 = 0.

The following table demonstrates the comparative coding scale for the different formats:

```
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS.....................................................
..........................XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX......................
...............................IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII......................
.................................JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ......................
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL....................................................
!"#$%&’()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]ˆ_‘abcdefghijklmnopqrstuvwxyz{|}~
|                         |    |        |                              |                     |
33                       59   64       73                             104                   126
S - Sanger Phred+33, raw reads typically (0, 40)
X - Solexa Solexa+64, raw reads typically (-5, 40)
I - Illumina 1.3+ Phred+64, raw reads typically (0, 40)
J - Illumina 1.5+ Phred+64, raw reads typically (3, 40)
L - Illumina 1.8+ Phred+33, raw reads typically (0, 41)
```

### Interpretation of PHRED Scores
{:.no_toc}

The quality scores are related to the probability of calling an incorrect base through the
formula  

*Q =* −10log<sub>10</sub>*P*  

where *P* is the probability of calling the incorrect base.
This is more easily seen in the following table:

| PHRED Score | Probability of Incorrect Base Call | Accuracy of Base Call |
|:----------- |:---------------------------------- |:----------------------|
| 0           | 1 in 1          | 0%          |
| 10          | 1 in 10         | 90%         |
| 20          | 1 in 100        | 99%         |
| 30          | 1 in 1000       | 99.9%       |
| 40          | 1 in 10000      | 99.99%      |

#### Questions
{:.no_toc}

1. Which coding system do you think has been used for the reads that we
have?
2. In the PHRED +33 coding system, the character ‘@’ is used. Can you think of any
potential issues this would cause when searching within a fastq file?
3. A common threshold for inclusion of a sequence is a Q score >20. Considering the
millions of sequences obtained from a flowcell, do you think that NGS is likely to be
highly accurate?

# Quality Control

## Using FastQC

A common tool for checking the quality of a fastq file is the program FastQC.
As with all programs on the command line, we need to see how it works before we use it.
The following command will open the help file in the less pager which we used earlier.
To navigate through the file, use the `<spacebar>` to move forward a page, `<b>` to move back a page & `<q>` to exit the manual.

```
fastqc -h | less
```

FastQC will create an html report for each file you provide, which can then be opened from any web browser such as firefox.
As seen in the help page, FastQC can be run from the command line or from a graphic user interface (GUI).
Using a GUI is generally intuitive so today we will look at the command line usage, as that will give you more flexibility & options going forward.
Some important options for the command can be seen in the manual.
As you will see in the manual, setting the `-h` option as above will call the help page.
Look up the following options to find what they mean.

| Option | Usage |
|:------ |:------|
| -o     |       |
| -t     |       |


As we have two files, we will first need to create the output directory, then we can run fastqc using 2 threads which will ensure the files are processed in parallel.
This can be much quicker when dealing with large experiments.

```
cd ~/NGS_Practical/01_rawData/
mkdir FastQC
cd fastq
fastqc -o ../FastQC -t 2 *gz
```

It’s probably a good idea to scribble a note next to each line if you didn’t understand what you did.
If you haven’t seen the command `mkdir` before, check the help page `man mkdir`.

The above command:

1. Gave both files to `fastqc` using `*gz`
2. Specified where to write the output (`-o  ̃FastQC`) &
3. Requested two threads (`-t 2`).

Let's see what we have:

```
cd ../FastQC
ls -lh
```

The reports are in `html` files, which may be in the `FastQC` directory, or may be in the directories for the individual files, (depending on your version of FastQC).
When working on your won data, you'll find the `html` files then open using your favourite browser.
The best browser for those on the VMs is `firefox`, so we can open them in Ubuntu using the following command.

```
firefox *html &
```

## Inspecting a FastQC Report

The left hand menu contains a series of click-able links to navigate through the report, with a quick guideline about each section given as a tick, cross or exclamation mark.
Two hints which may make your inspection of these files easier are:

1. To zoom out in firefox use the shortcut `Ctrl-`. Reset using `Ctrl0` and zoom in using `Ctrl+`
2. You can open these directly from a traditional directory view by double clicking on the .html file.

If your terminal seems busy after you close firefox, use the `Ctrl C` shortcut to stop whatever is keeping it busy.

#### Questions
{:.no_toc}

1. *How many sequences are there in both files?*
2. *How long are the sequences in these files?*

## Interpreting the FASTQC Report

As we work through the QC reports we will develop a series of criteria for filtering and cleaning up our files.
There is usually no perfect solution, we just have to make the best decisions we can based on the information we have.
Some sections will prove more informative than others, and some will only be helpful if we are drilling deeply into our data.
Firstly we’ll just look at a selection of the plots.
We’ll investigate some of the others with some ‘bad’ data later.

### Per Base Sequence Quality
{:.no_toc}

Both of the files should be open in firefox in separate tabs.
Perform the following steps on both files.
Click on the `Per base sequence quality` hyperlink on the left of the page & you will see a boxplot of the QC score distributions for every position in the read.
This is the first plot that bioinformaticians will look at for making informed decisions about later stages of the analysis.

*What do you notice about the QC scores as you progress through the read?*

We will deal with trimming the reads in a later section, but start to think about what you should do to the reads to ensure the highest quality in your final alignment & analysis.

**Per Tile Sequence Quality**
This section just gives a quick visualisation about any physical effects on sequence quality due to the tile within the each flowcell or lane.
Most of the time we don't use this plot for many trimming or filtering decisions, however it can alert us to any problems with the flow cell, or camera, or if there's been a blockage in the lane.
If we see clear spatial effects, we may think about contacting the sequence provider for a repeat run of our material.

**Per Sequence Quality Scores** This is just the distribution of average quality scores for each sequence.
There’s not much of note for us to see here.

**Per Base Sequence Content** This will often show artefacts from barcode sequences or adapters early in the reads, before stabilising to show a relatively even distribution of the bases.

**Sequence Length Distribution** This shows the distributions of sequence lengths in our data. Here we have sequences that are all the same lengths, however if the length of your reads is vital (e.g. smallRNA data), then this can also be an informative plot.

**Sequence Duplication Levels** This plot shows about what you’d expect from a typical NGS experiment.
There are a few duplicated sequences (rRNA, highly expressed genes etc.) and lots of unique sequences represented the diverse transcriptome.
This is only calculated on a small sample of the library for computational efficiency and is just to give a rough guide if anything unusual stands out.

**Overrepresented Sequences** Here we can see any sequence which are more abundant than would be expected. Sometimes you'll see sequences here that match the adapters used, or you may see highly expressed genes here.

**Adapter Content** This can give a good guide as to our true fragment lengths. If we have read lengths which are longer than our original DNA/RNA fragments (i.e. inserts) then the sequencing will run into the adapters.
If you have used custom adapters, you may need to supply them to `FastQC` as this only searches for common adapter squences.

**Kmer Content**
This plot was not particularly informative and has been dropped in FastQC >= 0.11.6.
Statistically over-represented `k`-mers can be seen here & often they will overlap.
In our first plot, the black & blue `k`-mers are the same motif, just shifted along one base.
No information is given as to the source of these sequences, and you would expect to see barcode sequences or motifs that correspond to any digestion protocols here.

## Some More Example Reports

Let’s head to another sample plot at the [FastQC homepage](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/bad_sequence_fastqc.html)

**Per Base Sequence Quality** Looking at the first plot, we can clearly see this data is
not as high quality as the one we have been exploring ourselves.

**Per Tile Sequence Quality** Some physical artefacts are visible & some tiles seem to
be consistently lower quality. Whichever approach we take to cleaning the data will more
than likely account for any of these artefacts. Sometimes it’s just helpful to know where a
problem has arisen.

**Overrepresented Sequences** Head to this section of the report & scan down the
list. Unlike our sample data, there seem to be a lot of enriched sequences of unknown
origin. There is one hit to an Illumina adapter sequence, so we know at least one of the
contaminants in the data. Note that some of these sequences are the same as others on
the list, just shifted one or two base pairs. A possible source of this may have been non-random fragmentation.


Interpreting the various sections of the report can take time & experience.
A description of each of the sections [is available from the fastqc authors](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/) which can be very helpful as you're finding your way.

Another interesting report is available at http://www.bioinformatics.babraham.ac.uk/projects/fastqc/RNA-Seq_fastqc.html.
Whilst the quality scores generally look pretty good for this one, see if you can find a point of interest in this data.
This is a good example, of why just skimming the first plot may not be such a good idea.

## Working With Larger Datasets

In our dataset of two samples it is quite easy to think about the whole experiment & assess the overall quality.

*What about if we had 100 samples?*

Each .zip archive contains text files with the information which can easily be parsed into an overall summary.
We could write a script to extract this information if we had the time.
However, some members of the Bioinformatics Hub have been writing an `R` package to help with this, which is available from https://github.com/UofABioinformaticsHub/ngsReports.

* TOC
{:toc}

# Trimming and Quality Filtering of NGS data

Once we have inspected our data & have an idea of how accurate our reads are, as well as any other technical issues that may be within the data, we may need to trim adaper sequences or filter the reads to make sure we are aligning or analysing sequences that accurately represent our source material.  
As we’ve noticed, the quality of reads commonly drops off towards the end of the reads, and dealing with this behaviour is an important part of most  processing pipelines.  Sometimes we will require reads of identical lengths for our downstream analysis, whilst other times we can use reads of varying lengths.  The data cleaning steps we choose for our own analysis will inevitably be influenced by our downstream requirements.

## The Basic Workflow

Data cleaning & pre-processing can involve many steps, and today we will use the basic work-flow as outlined below.  Every analysis is slightly different so some steps may or may not be required for your own data.  Some steps do have a little overlap, and some pipelines may perform some of these steps for you.

Using today’s datasets, we will take one sequencing experiment hrough demultiplexing and adapter removal, and then use our *C. elegans* WGS to run genome mapping and alignment filtering. We will perform most steps on files at this stage, rather than on a complete library, but the principle is essentially the same.

*A basic workflow is:*

1. **Remove Low Quality Reads** (`fastq_illumina_filter`). *As discussed earlier, this may or may not be required*
2. **Remove Adapters** (`cutadapt` or `Adapter Removal`)
3. **Remove Low Quality Bases**. This is usually done by our adapter removal tools, and can be performed by trimming:
    1. based on quality scores
    2. to a fixed length
4. **Demultiplexing** (`sabre`, `fastq_multx` or `process_radtags`).
5. **Alignment** to a reference (`bwa`, `bowtie2`, `STAR`)
6. **Post-alignment QC** (`picard markDuplicates`, `IGV`)


## Demultiplexing

In the first section we discussed the difference between an *index* and a *barcode*. If you use an indexed adapter to distinguish samples on an Illumina sequencing run, the demultiplexing is *usually* done on the sequencing machine. However, sometimes it makes sense to use a barcode (or sometimes called "inline barcode"), to further multiplex samples onto one sequencing run.

While barcodes can be incredibly useful, it is important to note that Illumina cycle calibration and cluster calling is done in the first 4 cycles (first four base-pairs of read 1). It also is used to establish other metrics (e.g., signal thresholds) for base-calling.
Therefore it is essential that the first four base pairs are "diverse" (i.e. no particular nucleotide is over-represented in the first four base-pairs). Designing the right barcodes to add to the start of your reads extremely important!

To demonstrate demultiplexing we will use the a sequencing run with two samples that have a 7bp barcode.
These are in the folder `~/multiplexed/01_rawData/fastq`, with the barcodes being in `~/multiplexed/barcodes_R1.txt`


Again, these were not successfully copied onto your machines during setup, so let's download the required files for this section.

```
cd ~/NGS_Practical/01_rawData/fastq
wget https://universityofadelaide.box.com/shared/static/0w0fgnm94w18ixh1z0dkmh5e0xht1ajf.gz -O multiplexed.tar.gz
tar -xzvf multiplexed.tar.gz
rm multiplexed.tar.gz
mv barcodes_R1.txt  ../..
```

Our barcode sequences should be "GCGTAGT" (for bc1) and "CCTCGTA" (for bc2). Lets first see what possible barcodes are available in the first 7bp of our dataset and see if it matches what we expect:

```
zcat Run1_R1.fastq.gz | sed -n '2~4p' | cut -c 1-7 | sort | uniq -c | sort -nr | head -n10
```

What top 5 barcodes are found in our data? Do the top two reflect our the barcodes we should have?

The command above is quite long and contains multiple unix commands that are separated by a pipe. What does each command do?

| Command | Explanation |
|---------|-------------|
| `zcat Run1_R1.fastq.gz` | Prints the compressed fastq file to screen |
| `sed -n '2~4p'` | Prints the second line (sequence of each fastq file) |
| `cut -c 1-7` | Get the first 7 characters |
| `sort` | sort the sequences |
| `uniq -c` | Find the unique 7 characters are count them |
| `sort -nr` | sort the sequences and reverse the order |
| `head -n10` | Print the top 10 |

Our real barcodes are actually in a file called barcodes_R1.txt. Unfortunately, `sabre` only runs with uncompressed data, so to run this program we'll need to ungzip our fastq files.

```
gunzip Run1_R1*
```

Now we've succesfully perfored this step, we can run `sabre`.
Before we run this let's check the help page

```
sabre --help
```

Unfortunately the installation of `sabre` we've used is not behaving correctly.
Please try running all this code before moving on.
Note the use of `sudo` before some of these commands.
This stands for *superuser do*  and is basically running as the systems admin.
You'll need the password the first time you type a command preceded by `sudo`.
Please ignore any `Could not resolve host` or similar messages.

```
conda remove sabre
cd /opt
sudo wget https://github.com/najoshi/sabre/archive/master.zip
sudo unzip master.zip
sudo mv master sabre
cd sabre
sudo make
cd /usr/local/bin
sudo ln -s /opt/sabre/sabre ./sabre
```

If you ask us, this isn't helpful and this is a common problem with tools for NGS data.
As we're going to to be using this tool in paired-end mode we can find the help we need using

```
sabre pe --help
```

Many NGS (and other) tools use this strategy of having a sub-command following the main command which tells the main tool (`sabre`) to operate in a specific stage or mode (`pe`).
We can then call the specific help page for this mode.

```
mkdir -p ../../02_demultiplexedData/fastq
cd ../../02_demultiplexedData/fastq
sabre pe -m 1 -f ../../01_rawData/fastq/Run1_R1.fastq -r ../../01_rawData/fastq/Run1_R2.fastq -b ../../barcodes_R1.txt -u unknown_R1.fastq -w unknown_R2.fastq 
```

How many read pairs were extracted in each sample?

Run the command again without the one mismatch. How many read are now in each?

Note the clear directory structure that we've used.
This can lead to a command that is tricky to understand at first, but try to keep track of the file paths.
*Why do you think we might use this particular file structure?*
In a real-world context, we'd probably script this too so file paths may be declared as variables.

<!---
If we're having trouble with sabre on the VMs, it may be due to the conda installation behaving strangely
```
cd /opt
wget https://github.com/najoshi/sabre/archive/master.zip
unzip sabre-master.zip
mv sabre-master sabre
cd sabre
make
cd /usr/local/bin
ln -s /opt/sabre/sabre ./sabre
```
--->

## Removal of Low Quality Reads and Adapters

Adapter removal is an important step in many sequencing projects, mainly projects associated with small DNA/RNA inserts. For example, a common RNAseq experiment is to sequence small non-coding RNAs that are generated by an indvidual to regulate other coding sequences. These small RNAs (namely miRNAs, snoRNAs and/or siRNAs) are generally between 19-35bp, which is significantly smaller than the shortest, standard read length of most Illumina MiSeq/NextSeq/HiSeq machines (usually have read length settings such as 50, 75, 100, 125, 250 or 300bp). Therefore it is important to trim adapters accurately to ensure that the genome mapping and other downstream analyses are accurate.

Previously we would run multiple steps to remove both low-quality reads, but today's trimming algorithms have become better at removing low-quality data and the same time as removing adapters.

The tool we'll use today is `cutadapt` \& it's one of the few bioinformatics tools to have a helpful webpage, [so head to the site](http://cutadapt.readthedocs.org/).


Now we can trim the raw data using the Illumina Nextera paired-end adapters obtained from [this website](https://support.illumina.com/bulletins/2016/12/what-sequences-do-i-use-for-adapter-trimming.html)
These are commonly used in Illumina projects.

Before we perform adapter trimming, look at the following code.

```
cd ~/NGS_Practical
mkdir -p 02_trimmedData/fastq
cutadapt -m 35 -q 20 -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT \
    -o 02_trimmedData/fastq/SRR2003569_sub_1.fastq.gz -p 02_trimmedData/fastq/SRR2003569_sub_2.fastq.gz \
    01_rawData/fastq/SRR2003569_sub_1.fastq.gz 01_rawData/fastq/SRR2003569_sub_2.fastq.gz > cutadapt.log
```

#### Question
{:.no_toc}
*1. What did the settings* `-m 35` *and* `q 20` *do in the above?*

The `cutadapt` tool produces a large amount of information about the trimming process
In the above we wrote this output to a log file using the `>` symbol to redirect `stdout` to a file.
Let's have a look in the file to check the output.

```
less cutadapt.log
```

As these were a good initial sample, it's not surprising that we didn't lose many sequences.
Notice that many reads were trimmed, but were still long enough and high enough quality to be retained.

The relatively even spread of A/C/G/T bases after the adapters also indicates that we've not missed anything.
Sometimes, if we've missed a base in the adapter you'll see a strong bias in the first base after adapter removal.

### FastQC

Before moving on, we need to check the quality of the trimmed sequences, so let's run `fastqc` on these files to check them out.
*Make sure you're in the corect directory first!*

```
mkdir -p 02_trimmedData/FastQC
fastqc -o 02_trimmedData/FastQC -t 2 02_trimmedData/fastq/*gz
```
#### Question
{:.no_toc}
*Was there much of an improvement in the trimmed data?*
