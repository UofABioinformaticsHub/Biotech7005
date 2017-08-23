# Evolutionary Processes assignment (21/9/2017)

## Prepare the sequence data

Get the sequences from the [Biotech7005 repository](bovidea_118_mtDNA.fa).

### Multiple alignment

In order to construct a phylogenetic tree, we need to provide positional information to the tree reconstruction program so that related positions are comparable.
This is done by constructing a multiple sequence alignment.
There are many programs that can be used to do this; two fast programs are MUSCLE and MAFFT

Run the following two commands:

```
muscle -in bovidea_118_mtDNA.fa -out bovidea_118_mtDNA-muscle.mfa
```

```
mafft bovidea_118_mtDNA.fa > bovidea_118_mtDNA-mafft.mfa
```

Have a look at the resulting alignments using `jalview`.
Decide *subjectively* which alignment you think will be better to use (the following instructions assume MUSCLE).

### Remove non-conserved blocks

Many programs unfortuately have name lenght limitations.
One of the programs we will be using (Gblocks) cannot have long sequence identifiers and is not open source, so we cannot fix it.
To get around this problem we will shorten the identifiers in a meaningful way.

Run the following command to change the sequence IDs:
```
sed -e 's/^>[^ ]\+ \([^ ]\+\) \([^ ]\+\).*$/>\1_\2/g' bovidea_118_mtDNA-muscle.mfa > bovidea_118_mtDNA-named.mfa
```

**What does this command do?**

### Reduced the size of the dataset

This is done now due to time constraints.

Run the following command using your student number for id:
```
subset -id aXXXXXXX -n 50 -in bovidea_118_mtDNA-named.mfa > bovidea_50_mtDNA-named.mfa
```

This selects 50 sequences from the input alignment according to your student number and writes them to a new file.
This is nor normal practice, and is only necessary because of prac time limits.

Now we can use Gblocks to remove the non-conserved regions of the alignment.
This will give you a file `bovidea_50_mtDNA-named.mfa-gb`.

**Why do we need to do this? (*Hint:read the [Gblocks documentation](http://molevol.cmima.csic.es/castresana/Gblocks.html)*)**

Open the original aligned data (the file output by the multiple alignment program) using Seaview by entering the following command into a terminal.

```
seaview bovidea_118_mtDNA-muscle.mfa
```

Look at the alignment. At the beginning of the alignment and near the end there are regions that have large gaps and very poor conservation.

**What is the reason for this? (*Hint: use the accession numbers in the name to search [Entrez](https://www.ncbi.nlm.nih.gov/genome/) for the annotation.*)**

### Convert to NEXUS format

The program we will be using to perform phylogenetic reconstruction uses a sequence (and other character) format called NEXUS.
The NEXUS format is fairly widely used for phylogenetic data as it can be used to encode a variety characters, not limited to sequence data.
Unfortunately there is no simple command line tool to convert from FASTA to NEXUS (it would be easy to write), so we will use SeaView.
Start SeaView by entering `seaview bovidea_50_mtDNA-named.mfa-gb` into a terminal.
Save this file as a NEXUS file, the save file dialogue will suggest "bovideai\_50\_mtDNA-named.nxs", use that.

Note that SeaView can be used as an interface to the program PhyML which does Maximum Likelihood phylogenetic tree reconstruction.
However, the communication between SeaView and PhyML appears to be broken as the work done by PhyML is dropped on the floor by SeaView after completion.

## Run Mr Bayes

Mr Bayes is a program for performing phylogenetic tree reconstruction from multiple sequence alignments using a Bayesean inference.
The Bayesean approach to reconstruction is based on using a likelihood function to estimate posterior probabilities for trees and model parameters.
There are concerns in the literature about the validity of Bayesean reconstruction, but Mr Bayes provides a good environment to do the practical and Baysean inference works for many data sets.

A manual for Mr Bayes is available from [here](http://mrbayes.sourceforge.net/mb3.2_manual.pdf).

Start Mr Bayes by entering the following command into a terminal:

```
mb
```

This will give you a Mr Bayes prompt that should look like this.



```

                            MrBayes v3.2.6 x64

                      (Bayesian Analysis of Phylogeny)

              Distributed under the GNU General Public License


               Type "help" or "help <command>" for information
                     on the commands that are available.

                   Type "about" for authorship and general
                       information about the program.


MrBayes > 
```

If you enter `help` at the prompt you will get a list of topics that can be read, for example `help execute`.


### Load sequence data

First you will need to load the data set that you prepared.

Use the `execute` command to load the NEXUS sequence file you created with SeaView.

**How many taxa were read into memory? How many characters are being used?**

### Set options

For the practical you are to perform 2 reconstructions, choosing from substitution models with 1, 2, 6 or mixed.
Each run takes about an hour, so you will have time to work on other parts of the practical while it is running.

First you need to set the number of substitution rate parameters used in the model.
Before you do this, see what the values of parameters are by default in the likelihood setting.

```
help lset
```

You can see that the default rate matrix is 4 by 4 which corresponds to nucleotide.

**What substitution models does the default number of substitution types correspond to?**

Set the number of substitution types to the number you have chosen (written below as `<num>`).

```
lset nst=<num>
```

### Run Monte-Carlo Markov Chain analysis

The next thing to do is start the tree reconstruction analysis.
This is done using the `mcmc` (Markov chain Monte Carlo) command.
Before you do this, you will need to set some options.
First examine the defaults.

```
help mcmc
```

You can see here that the default analysis runs for 1,000,000 iterations, retaining every 500th iteration for tree reconstruction.
You can also see that the first 25% of samples are discarded by default.

We don't have enough time to run for 1e6 generations, we want to see the convergence behaviour and we want to specify the output file name (again `<num>` is the model subtitution type number), so start the analysis with the following command.

```
mcmc ngen=50000 relburnin=no burnin=0 filename=model-<num>
```

This will take some time (the remaining time is shown to the right of the output).
You will see in the output the log likelihoods of the trees being considered (2 runs by 4 chains) in the analysis, and every 5 lines the variance between the two runs is output to give an indication of how far the trees have converged.
You can see that as the run continues the average standard deviation of split frequencies decreases, showing that the two runs are converging on the same tree or similar trees.

### Examine convergence

After the MCMC has completed the 50,000 iterations, it will output the final average standard deviation of split frequencies and ask if the run is to be continued.
Answer "no".

See the Mr Bayes [tutorial](http://mrbayes.sourceforge.net/wiki/index.php/Tutorial#When_to_Stop_the_Analysis) for a more complete explanation of how to decide the answer to this question.

When you stop the runs, Mr Bayes will output summary data from the analysis.

To look at the convergence, execute the following command.

```
sump
```

**Describe what the output graph shows.**

Find where the plateau starts by choosing different burnin lengths (note that the burnin describes the number of leading sample to discard, not the number of MCMC iterations).

**Approximately when does the plateau start in terms of number of samples?**

### Examine trees

When you are happy with the burnin - that the log likelihood has pateaued - you can get the consensus tree to be calculated.

```
sumt
```

This will output a large quantity of data about the estimated paramaters and the statistical support for branch nodes, and two trees, one showing the consensus branch lengths and one showing the branch node support.
It will also output a consensus tree file called "model-\<num\>.con.tre".

Repeat the analysis with another model and compare the trees using the Archeopteryx program.

**Do the trees from the two models differ? How does the branch support differ between the two trees? Do the trees agree with the known taxonomic groupings?**

#### Nuclear tree from Decker *et al.* 2009 doi:[10.1073/pnas.0904691106](https://doi.org/10.1073/pnas.0904691106)

![Decker *et al.* 2009 10.1073/pnas.0904691106](nuclear-tree.jpg)

## Tasks (due 25/8/2017)

### Practical questions

Answer the questions in **bold** above.

### Maximum parsimony

Given the phylogenetic tree below:
1. How many positions can be unambiguously determined using the Fitsch algorithm?
2. Calculate the Fitsch score for the tree; and
3. the Sankoff (Generalised Parsimony) score for the tree and the root sequence.

![Parsimony Tree and Scores](parsimony-tree.png)

### Bayesean Trees with whole mitochondrian genomes

Produce a Bayesean tree for the whole miotochondrial genome of Marsupials.

1. What two species are the best to use as an outgroup?
2. Which two leaves are the closest related/have the shortest branch? How may differences are there between these two leaves?
3. Which of the following two species are more closely related?
    1. silky-shrew oppossum
    2. Tasmanian wolf
    3. koala
    4. platypus

