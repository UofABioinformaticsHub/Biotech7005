# Week 4 Practicals
{:.no_toc}

* TOC
{:toc}

# More Command Line Tips & Tricks

## Text In the Terminal
We can display a line of text in `stdout` by using the command `echo`.
The most simple function that people learn to write in most languages is called `Hello World` and we'll do the same thing today.

```
echo 'Hello World'
```

That's pretty amazing isn't it & you can make the terminal window say anything you want without meaning it.

```
echo 'This computer will self destruct in 10 seconds!'
```

There are a few subtleties about text which are worth noting.
Inspect the `man echo` page & note the effects of the `-e` option.
This allows you to specify tabs, new lines & other special characters by using the backslash to signify these characters.
This is an important concept & the use of a backslash to *escape* the normal meaning of a character is very common.
Try the following three commands & see what effects these special characters have.

```
echo 'Hello\tWorld'
echo -e 'Hello\tWorld'
echo -e 'Hello\nWorld'
```


As we've seen above, the command `echo` just repeats any subsequent text.
Now enter
```
echo ~
```

*Why did this happen?*

## Sending Output To A File

### Using the `>` symbol

So far, the only output we have seen has been in the terminal, which is known as the *standard output*, or `stdout` for short.
Similar to the pipe command, we can redirect the output of a command to a file instead of to standard output, and we do this using the greater than symbol (>), which we can almost envisage as an arrow.

Let's get a file to work with for today.
**Make sure you are in your `Bash_Practical` directory**, then donload the following file using `wget`

```
wget ftp://ftp.ensembl.org/pub/release-89/fasta/drosophila_melanogaster/ncrna/Drosophila_melanogaster.BDGP6.ncrna.fa.gz
```

After you've downloaded this file, unzip it usin `gunzip`.

This file is all the `ncrna` sequences from the current build of *D. melanogaster* in `fasta` format.
Each sequence has a header row which begins with `>` so if we wanted to just collect the sequence headers we could use `egrep` and write the output to a file.
To get the sequence header rows, we first need to use `egrep` to extract these lines.

```
egrep '^>' Drosophila_melanogaster.BDGP6.ncrna.fa
```

This will just dump the information to `stdout`, and will appear as a stream of identiiers.
If we want to capture `stdout` and send it to a file, we can use the `>` symbol at the end of the above command, and provide a filename to write to.
This will create the file as an empty file, then add the data strem from `stdout` to the blank file.

```
egrep '^>' Drosophila_melanogaster.BDGP6.ncrna.fa > SeqIDs.txt
less SeqIDs.txt
```
Once you've had a quick look at the file, exit the less pager and delete the file using the `rm` command.

### Using the `>>` symbol

Another alternative is to use the `>>` symbol, which doesn't create an empty file first, but instead adds the data from `stdout` to the end of any existing data.

```
echo -e '# Sequence identifiers for all ncrna in dm6' > SeqIDs.txt
```

In this command, we've created a header for the file, and we can now add the information we need after this using the `>>` symbol.
First let's add another row describing where we've obtained the data from.

```
echo -e '# Obtained from ftp://ftp.ensembl.org/pub/release-89/fasta/drosophila_melanogaster/ncrna/Drosophila_melanogaster.BDGP6.ncrna.fa.gz on 2017-08-14' >> SeqIDs.txt
```

Have a look at the file using `less`

```
less SeqIDs.txt
```

Now we can add the sequence identifiers

```
egrep '^>' Drosophila_melanogaster.BDGP6.ncrna.fa >> SeqIDs.txt
```

## Redirection Using The Pipe Symbol

Sometimes we need to build up our series of commands & send the results of one to another.
The *pipe* symbol (|) is the way we do this & it can literally be taken as placing the output from one command into a pipe & redirecting it somewhere new.

As a simple example, we could take the output from an `ls` command & send it to the pager `less`.

```
ls -lh /usr/bin | less
```

Page through the output until you get bored, then hit `q` to quit.

Now we'll download the file GCF_000182855.2_ASM18285v1_genomic.gff for *Lactobacillus amylovorus* from the NCBI database.

```
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/182/855/GCF_000182855.2_ASM18285v1/GCF_000182855.2_ASM18285v1_genomic.gff.gz
gunzip GCF_000182855.2_ASM18285v1_genomic.gff.gz
```

The first 5 lines of this file is what we refer to as a *header*, which contains important information about how the file was generated in a standardised format.
Many file formats have these structures at the beginning but for our purposes today we don't need to use any of this information so we can move on.
Have a look at the beginning of the file just to see what it looks like.

```
head GCF_000182855.2_ASM18285v1_genomic.gff
```

Notice the header lines begin with one or two hash symbols, and the remainder of the file contains information about the genomic features.
As there is a lot of information about each fature, note that each line will wrap onto a second line within bash.
The first feature is annotated as a *region* in the third field, whilst the second feature is annotated as a *gene*.

#### Question
{:.no_toc}

- *How many features are contained in this file?*
- *If we tried the following*: `wc -l GCF_000182855.2_ASM18285v1_genomic.gff` *would it be correct?*

This will give 4444, but we know the first 5 lines are header lines.
To count the non-header lines you could try several things:

```
grep -vc '^#' GCF_000182855.2_ASM18285v1_genomic.gff
```
or

```
grep -c '^[^#]' GCF_000182855.2_ASM18285v1_genomic.gff
```

**Make sure you understand both of the above commands!**

As mentioned above, this file contains multiple features such as *regions*, *genes*, *CDSs*, *exons* or *tRNAs*.
If we wanted to find how many regions are annotated in this file we could use the processes we've learned above:

```
grep -c 'region' GCF_000182855.2_ASM18285v1_genomic.gff
```

If we wanted to count how many genes are annotated, the first idea we might have would be to do something similar using a search for the pattern `'gene'`.

#### Question
{:.no_toc}

*Do you think this is the number of genes?*

- Try searching for the number of coding DNA sequences using the same approach (i.e. CDS) & then add the two numbers?
- *Is this more than the total number of features we found earlier?*
- *Can you think of a way around this using regular expressions?*


Some of the occurrences of the word *gene* appears in many lines which are not genes.
We could restrict the search to one of the tab-separated fields by including a white-space character in the search.
The command:

```
egrep -n '\sgene\s' GCF_000182855.2_ASM18285v1_genomic.gff | wc -l
```

will give a different result again as now we are searching for the word gene surrounded by white-space.

### Using `cut`

Alternatively, there is a command `cut` available.
Call the manual page (`man cut`) and inspect the option `-f`.

```
man cut
```

We can simply extract the 3rd field of this tab-delimited file by using the `f3` option.

```
cut -f3 GCF_000182855.2_ASM18285v1_genomic.gff | head
```

However, this hasn't cut the third field from the header rows as they are not tab-delimited.
To remove these we need to add one further option.
Call up the `man` page and look at the `-s` option.
This might seem a bit confusing, but this means *don't print lines without delimiters* which would be the comment lines in this file.

```
cut -f3 -s GCF_000182855.2_ASM18285v1_genomic.gff | head
```

Now we could use our `egrep` approach and we know we're counting the correct field.

```
cut -f3 -s GCF_000182855.2_ASM18285v1_genomic.gff | egrep -c 'gene'
```

A similar question would be: *How many* **types** *of features are in this file?*

The commands `cut`, along with `sort` and `uniq` may prove to be useful when answering this

```
cut -f3 -s GCF_000182855.2_ASM18285v1_genomic.gff | sort | uniq | wc -l
```

In the above some of the advantages of the pipe symbol can clearly be seen.
Note that we haven't edited the file on disk, we've just streamed the data contained in the file into various commands.


# sed: The Stream Editor

One very useful command in the terminal is `sed`, which is short for *stream editor*.
Instead of the `man` page for `sed` the `info sed` page is larger but a little easier to digest.
This is a very powerful command which can be a little overwhelming at first.
If using this for your own scripts & you can't figure something out, remember 'Google is your friend' & sites like \url{www.stackoverflow.com} are full of people wrestling with similar problems to you.
These are great places to start looking for help & even advanced programmers use these tools.

For today, there are two key `sed` functionalities that we want to introduce.

1. Using `sed` to alter the contents of a file/input;
2. Using `sed` to print regions of a file

## For those using OSX
{:.no_toc}

- You will need to install a different version of `sed` to the default.
- Please enter the following in your terminal

```
brew install gnu-sed --with-default-names
```

Ask for help if this doesn't work.


## Altering a file or other input

`sed` uses *regular expressions* that we have come across under the `grep` section, and we can use these to replace strings or characters within a text string.
The command works in the form `sed 'SCRIPT' INPUT`, and the script section is where all the action happens.
Input can be given to `sed` as either a file, or just as a text stream via the *pipe* that we have already introduced.

In the following example the script begins with an `s` to indicate that we are going to make a substitution.
The beginning of the first pattern (i.e. the *regexp* we are searching for) is denoted with the backslash, with the identical delimiter indicating the replacement pattern, and this is in turn completed with the same delimiter.
Try this simple example from the link \url{http://www.grymoire.com/Unix/Sed.html} which is a very detailed & helpful resource about the usage `sed`.
Here we are sending the input to the command via the pipe, so no `INPUT` section is required:

```
echo Sunday | sed 's/day/night/'
```

Here you are passing `sed` the string Sunday, and `sed` takes day and turns it into night.  
`sed` will only replace the first instance of the string on any line, so try:

```
echo Sundayday | sed 's/day/night/'
```

It only replaced the first instance of day and left the second.  You can make it 'global', where it switches every instance by using the `g` option at the end of the pattern like this:

```
echo Sundayday | sed 's/day/night/g'
```

You can 'capture' parts of the pattern in parentheses and access that in the second part of the regular expression (what you are switching to) using \1, \2, etc., to denoted the number of the captured string.
If you wanted to match `ATGNNNTGA`, where `N` is any base, and just output these three bases you could try the following

```
echo 'ATGCCAGTA' | sed -r 's/ATG(.{3})GTA/\1/g'
```

Or if we needed to replace those three bases with an expanded repeat of them, you could do the following where we capture the undefined string between `ATG` & `GTA`, and expand it to three times:

```
echo 'ATGCCAGTA' | sed -r 's/ATG(.{3})GTA/ATG\1\1\1GTA/g'
```

The `\1` entry takes the contents of the first parenthesis and uses it in the substitution, even though you don't know what the bases are.
Note that the `-r` option was set for these operations, which turns on extended regular expression capabilities.
This can be a powerful tool & multiple parentheses can also be used:

```
echo 'ATGCCAGTA' | sed -r 's/(ATG)(.{3})(GTA)/\3\2\2\1/g'
```

In this command we captured each codon separately, then switched the order of the first & last triplet and expanded the middle unknown string twice.
*Note how quickly this starts to look confusing though!*
Taking care to be clear when writing these types of procedures can be an important idea when you have to go back & re-read your code a year or two later.
(Yes this will happen a lot!!!)


## Displaying a region from a file

The command `sed` can also be used to replicate the functionality of the `head` & grep commands, but with a little more power at your fingertips.
By default `sed` will print the entire input stream it receives, but setting the option `-n` will turn this off.
Try this by adding an `n` immediately after the `-r` in one of the above lines & you will notice you receive no output.
This is useful if we wish to restrict our output to a subset of lines within a file, and by including a `p` at the end of the script section, only the section matching the results of the script will be printed.

Make sure you are in the `Bash_Practical` directory & we can look through the file `Drosophila_melanogaster.BDGP6.ncrna.fa` again.

```
sed -n '1,10 p' Drosophila_melanogaster.BDGP6.ncrna.fa
```

This will print the first 10 lines, like the `head` command will by default.
However, we could now print any range of lines we choose.
Try this by changing the script to something interesting like `101,112 p`.
We could also restrict the range to specific lines by using the `sed` increment operator `~`.

```
sed -n '1~4p' Drosophila_melanogaster.BDGP6.ncrna.fa
```
This will print every 4th line, beginning at the first, and is very useful for files with multi-line entries.
The `fastq` file format from NGS data, and which we'll look at in week 6 will use this format.




We can also make sed operate like `grep` by making it only print the lines which match a pattern.
```
sed -rn '/TGCAGGCTC.+(GA){2}.+/ p' Drosophila_melanogaster.BDGP6.ncrna.fa
```

Note however, that the line numbers are not present in this output, and the pattern highlighting from `grep` is not present either.

# Writing Scripts

Sometimes we need to perform repetitive tasks on multiple files, or need to perform complex series of tasks and writing the set of instructions as a script is a very powerful way of performing these tasks.
They are also an excellent way of ensuring the commands you have used in your research are retained for future reference.
Keeping copies of all electronic processes to ensure reproducibility is a very important component of any research.
Writing scripts requires an understanding of several key concepts which form the foundation of much computer programming, so let's walk our way through a few of them.

## Some Important Concepts

Two of the most widely used techniques in programming are that of the `for` loop, and logical tests using an `if` statement.

### `for` Loops

A `for` loop is what we use to cycle through an input one item at a time

```
for i in 1 2 3; do (echo -e $i^2 = $(($i*$i))); done
```

In the above code the fragment before the semi-colon asked the program to cycle through the values 1, 2 & 3, letting the variable `i` take each value in order of appearance.

- Firstly: i = 1, then i = 2 & finally i = 3.
- After that was the instruction on what to do for each value, where we multiplied it by itself to give $i^2$

Note that the value of the variable `i` was *prefaced by the dollar sign ($).*
**This is how the bash shell knows it is a variable, not the letter `i`.**
The command `done` then finished the `do` command.
All commands like `do`, `if` or `case` have completing statements, which respectively are `done`, `fi` & `esac`.

An important concept which was glossed over in the previous paragraph is that of a *variable*.
These are essentially just *placeholders* which have a value that can change, much like an object in `R`.
In the above loop, the same operation was performed on the variable `i`, but the value changed from 1 to 2 to 3.
Variables in shell scripts can hold numbers or text strings and don't have to be formally defined as in some other languages.

### `If` Statements

If statements are those which only have a binary `yes' or `no' response.
For example, we could specify things like:

- **if** (`i>1`) then `do` something, or
- **if** (`fileName==bob.txt`) then `do` something else


Notice that in the second `if` statement, there was a double equals sign (`==`).
This is the programmers way of saying *compare* the first argument with the second argument.
A single equals sign is generally interpreted by a program as *assign* the first argument to be what is given in the second argument.
This use of *double operators* is very common, notably you will see `&&` to represent the command *and*, and `||` to represent *or*.

A final useful trick to be aware of is the use of an exclamation mark to reverse a command.
A good example of this is the use of the command `!=` as the representation of *not equal to* in a logical test.


## awk: A command and a language

Another powerful command is `awk` which can be used as a command, as well as functioning as it's own language.
We'll just use it as a command today, and it is extremely useful for dealing with tab- or comma-separated files, such as we often see in biological data.

The basic structure of an `awk` command is:
<center>
`awk '/<pattern>/' file`
</center>

`awk` will then search the file and output any line containing the regular expression pattern (kind of like `grep)`.
With `awk`, you can also do:

<center>
`awk {<code> file}`
</center>

where you can put a little awk program in the curly braces.
You can specify values from different columns of the file as $1, $2, etc., (or you can use $0 for the whole line).

We have the file `GCF_000182855.2_ASM18285v1_genomic.gff` and we've already looked at it at little, so let's pull out some particular features!
Make your terminal as wide as the screen, then change into the appropriate directory & enter

```
awk '{if  ($3=="rRNA")  print $0}' GCF_000182855.2_ASM18285v1_genomic.gff
```

Here we've specified that the third field must be an rRNA, so this will give us all of the ribosomal RNAs annotated in the file.

We could make it a little more complex and just look for genes in a given region:

```
awk '{if ( ($3=="gene") && ($4 > 10000) && ($4 < 20000) ) print $0}' GCF_000182855.2_ASM18285v1_genomic.gff
```

- In the above code, `$3=="gene"` asks for the entry in the third field to be `gene`.
- The next code fragment requested the value in the fourth field (i.e. $4) to be `> 10000`
- The third code fragment requested that the value in the fourth field also be `< 20000`, effecively restrictin this to a genomic range.

Thus we have found all the features annotated as genes in a 10,000bp region of this genome.
Notice that each these three commands were enclosed in a pair of brackets within an outer pair of brackets.
This gave a command of the form:
`( (Condition1) && (Condition2) && (Condition3) )`
After this came the fragment `print \$0` which asked `awk` to print the entire line if the 3 conditions are true.
**You've just written (& hopefully understood) a computer program!**

*Another example (what does this do?):*

```
awk '{if (($5 - $4 > 1000) && ($3 == "gene")) print $0}' NC_001318.gff
```

If you don't want to output all of the columns, you can specify which ones to output.  
While we're at it, let's save the output as a file:

```
awk '{if (($5 - $4 > 1000) && ($3 == "gene")) print $1, $2, $4, $5, $9}' GCF_000182855.2_ASM18285v1_genomic.gff > awkout.txt
```


# Shell Scripts

Now that we've been through just some of the concepts & tools we can use when writing scripts, it's time to tackle one of our own where we can bring it all together.

Every bash shell script begins with what is known as a *shebang*, which we would commonly recognise as a hash sign followed by an exclamation mark, i.e `\#!`.
This is immediately followed by `/bin/bash`, which tells the interpreter to run the command `bash ` in the directory `/bin`.
This opening sequence is vital & tells the computer how to respond to all of the following commands.
As a string this looks like:

```
\#!/bin/bash
```

The hash symbol generally functions as a comment character in scripts.
Sometimes we can include lines in a script to remind ourselves what we're trying to do, and we can preface these with the hash to ensure the interpreter doesn't try to run them.
It's presence as a comment here, followed by the exclamation mark, is specifically looked for by the interpreter but beyond this specific occurrence, comment lines are generally ignored by scripts & programs.

## An Example Script
Let's now look at some simple scripts.
These are really just examples of some useful things you can do & may not really be the best scripts from a technical perspective.
Hopefully they give you some pointers so you can get going

**Don't try to enter these commands directly in the terminal!!!**
They are designed to be placed in a script which we will do after we've inspected the contents of the script (see next page).
First, let's just have a look through the script & make sure we understand what the script is doing.

# NEEDS EDITING FROM HERE


```
#!/bin/bash
FILE=$1
LENGTHS=$(sed -n '2~4p' ${FILE} | awk '{print length($1)}' | sort | uniq)

echo -e "Read length\tTotal Number"

for l in ${LENGTHS}
do
	COUNT=$(sed -n '2~4p' ${FILE} | awk '{print length($1)}' | grep -c ${l})
	echo -e "${l}\t${COUNT}"
done
```


Note that in the above script every time the value of a variable was used, it was prefaced by the \$ symbol, and the name was enclosed in curly brackets.
The \$ symbol is essential to identify a variable as opposed to a normal text character, but the brackets are just a personal habit to make identification of variables easier as you skim through the code.
Similarly, the variables were defined as all capital letters for ease of identification.
It may be worth noting that most commands are strictly lower case.


\subsubsection*{Understanding This Script}
Note that after the shebang, there was a variable `FILE` which took the value `\$1`.
This means that after we call the script, we specify a filename to assign to the variable `FILE`.
For example, we could run the script as:
`./scriptName.sh \~{`/Data/week2/seqData.fastq}.
This would execute the script on that file.


Now use the text editor `gedit` to write this script & save it as `findLengths.sh` in your home folder.


\begin{questions}
What have we assigned to the variable `LENGTHS`?
\begin{answer}
This will give a vector with all of the unique values corresponding to the read lengths in the file
\end{answer}

What do you think the script will actually do?
\begin{answer}
Counts how many reads there of each specific length
\end{answer}

Where will the script send the output to?
\begin{answer}
stdout.
\end{answer}

How would we write the output to a file?
\begin{answer}
Use the $>$ symbol to assign it to a filename
\end{answer}
\end{questions}

\subsubsection{Changing File Permissions}

In the directory you have saved the script, enter the `ls -l` command.
You should see the series of triplets we discussed in Chapter 1 as `-rw-r-{`-r-{}-}, indicating that it is writeable by you only, but is readable by all users.
Enter the command:
```
chmod +x findLengths.sh
```
Now repeat the `ls -l` command and you will see that the third entry in every triplet is now `x` instead of `-`.
This means that all users can now execute the file.
It is now a live computer program just waiting to be run!
If we wish to run it and we are in the same directory, we need to preface it with `./` to indicate that we are running it from this directory.
This is a security measure to make it more difficult to automatically run a script from a folder.
Lets run it on the file `seqData.fastq`, but don't forget to write the output  to a file.


\begin{questions}
Inspect the file using `gedit`, or the `less` pager.
Did it look like you expected?
Is this a tab-separated file, or a comma or space separated file?
\end{questions}

\begin{bonus}
Try running it on the `RAD_R1.fq` & `RAD_R2.fq` files.
\begin{questions}
Is that what you expected?
\begin{answer}
All the reads should've been the same length...
\end{answer}
\end{questions}
\end{bonus}

\begin{note}
Don't forget to look at `man chmod` to figure out what you did earlier.
This is a little too complex to spend time with now, but will be important to learn sooner rather than later.
\end{note}

\clearpage
\subsubsection*{A more complicated script}

Here's a more complicated script with some more formal procedures.
This is a script which will extract only the CDS features from the .gff file we have been working with, and export them to a separate file.
Look through each line carefully & make write down your understanding of what each line is asking the program to do.

```
#!/bin/bash

# Declare some helpful variables
FILEDIR=~/nectar-workshop-template/examples/intro_ubuntu_2015/files
FILENAME=GCF_000182855.2_ASM18285v1_genomic.gff
OUTFILE=NC_015214_CDS.txt

# Make sure the directory exists
if [ -d ${FILEDIR} ];
  then
    echo Changing to ${FILEDIR}
    cd ${FILEDIR}
  else
    echo Cannot find directory ${FILEDIR}
    exit 1
fi

# If the file exists, extract the important CDS data
if [ -a ${FILENAME} ];
  then
    echo Extracting CDS data from ${FILEDIR}/${FILENAME}
    echo "SeqID Source Start Stop Strand Tags" > ${OUTFILE}
    awk '{if (($3=="CDS")) print $1, $2, $4, $5, $7, $9}' ${FILENAME} >> ${OUTFILE}
  else
    echo Cannot find ${FILENAME}
    exit 1
fi
```

Notice that this time we didn't require a file to be given to the script.
We defined it within the script, as we did for the output file.


The directory & file checking stages were of the form if [...].
This is a curious command that checks for the presence of something.
The options -d & -a specify a directory or file respectively.


\begin{questions}
Will the above script generate a tab, comma or space delimited text file?
\begin{answer}
It will be space delimited.
We could have specified tab delimited by inserting ``\textbackslash t'' between each field.
\end{answer}
\end{questions}


Open the `gedit` text editor & save the blank file in your directory as *extract_CDS.sh*.
Now write this above script into the editor, but *taking care to use the directory where you have the .gff file stored in the appropriate place.*
Once you have written the script, save it & close it.


\clearpage
\section*{Assignment Challenges}
\begin{warning}
Now that we have written our first couple of scripts, the challenge  will to be create your own scripts from scratch.
You can use the gedit text editor for this & it will automatically colour code as you go, which can be very helpful for seeing where you are as you write code.
\end{warning}

**Task 1**
The restriction site for the RAD-Seq dataset we have is TGCAG.
In the `~/Data/week1` folder, we have both pairs of reads.

Your first challenge is to write a script to find:

\item How many reads there are in each .fq file
\item How many reads begin with the restriction site
\item Output this into a new file, with appropriate column headings.




Why would this be useful in the real world?
In this type of data, both the forward & reverse reads should start with the restriction site.
We may decide to exclude reads which don't have this feature as they may be unreliable, or we may have reduced confidence about their origin.


**Task 2**
The .fq files we have were processed by a program that has done strange things to the identifiers.
Each piece of information is separated by underscores, which should be colons, as specified by the defined fastq format \url{https://en.wikipedia.org/wiki/FASTQ_format#Illumina_sequence_identifiers}.
The digit indicating which member of a pair the sequence belongs to should also be of a different format, as seen in the given definition.


Our second  task is to write a script which will change these identifiers back to the correct format?
You can omit the machine identifier, or just make a name up if you feel like it.



Why would this be useful in the real world?
Some bioinformatics tools check the structure of the read identifiers.
As they are, these reads would cause some alignment tools to fail.
It's amazing how common these types of issues are.
