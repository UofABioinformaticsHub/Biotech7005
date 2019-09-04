* TOC
{:toc}

# Biotech 7005: Practical 7 Bonus material
Jimmy Breen & Steve Pederson

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

To weed out the low confidence calls in our VCF file we need to filter by QUAL. This can be done using the `bcftools` program that's included within the `samtools` suite of tools. 
All these tools can run on gzip-compressed files which saves a lot of space on your computer.

```
gzip SRR2003569_chI_1Mb.vcf
```

Ok lets filter by QUAL. We can do this with the `bcftools filter` or  `bcftools view` commands which allows you to run an expression filter. This means you can either exclude (`-e`) or include (`-i`) variants based on a certain criteria. In our case, lets exclude all variants that have a QUAL < 30.

```
bcftools filter -e 'QUAL < 30' SRR2003569_chI_1Mb.vcf.gz -Oz -o SRR2003569_chI_1Mb.sorted.q30.vcf.gz

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



---

# Viewing the alignments

A common tool used for viewing alignments is IGV browser.
We haven't installed this on your VM as it really needs to run a local machine (i.e. your workstation or laptop).
This can be installed by following the instructions [here](https://software.broadinstitute.org/software/igv/download).

Additionally, we'll need to copy our bam files from the VM to our local machine.
To do this we'll need [FileZilla](https://filezilla-project.org/).
Once you have this installed, connect to your VM using your IP address (without the :8787), and use your `biotech7005` login.
Then you'll be able to copy files easily between your local machine and the VM.
You'll need to download 1) your sorted bam file; 2) the index for the sorted bam file and 3) your reference `chrI.fa`.
Place these in all in the same folder & open IGV.


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
2. Using the variant locations in your VCF, choose a selection of variants, and see if you can find them using IGV. Do you agree with all of the identified variants?
3. Would we need to set any different parameters when calling variants on the autosomes or the mitochondria?

