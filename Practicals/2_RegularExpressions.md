# Week 3 Practicals: Regular Expressions
{:.no_toc}

* TOC
{:toc}

## Introduction
Regular expressions are a powerful & flexible way of searching for text strings amongst a large document or file.
Most of us are familiar with searching for a word within a file, but regular expressions allow us to search for these with more flexibility, particularly in the context of genomics.
We briefly saw this idea in the `R` practical using he functions `str_extract()` and `str_replace()`.
Instead of searching strictly for a word or text string, we can search using less strict matching criteria.
For example, we could search for a sequence that is either `AGT` or `ACT` by using the patterns  `A[GC]T` or  `A(G|C)T`.
These two patterns will search for an  `A`, followed by either a  `G` or  `C`, then followed strictly by a  `T`.
Similarly a match to `ANNT` can be found by using the patterns `A[AGCT][AGCT]T` or  `A[AGCT]{2}T`.

Whilst the bash shell has a great capacity for searching a file to matches to regular expressions, this is where languages like *perl* and *python* offer a great degree more power.
The commands `awk` & `sed` which we will look at later also use regular expressions to great effect.

## The command `grep`
The built-in command which searches using regular expressions in the terminal is `grep`.
This function searches a file or input on a line-by-line basis, so patterns contained with a linecan be found, but patterns split across lines are more difficult to find.
This can be overcome by using regular expressions in a programming language like Python or Perl.  

The `man grep` page contains more detail on regular expressions under the `REGULAR EXPRESSIONS` header (scroll down a few pages).  
As can be seen in the `man` page, the command follows the form

```
grep [OPTIONS] 'pattern' filename
```
The option `-E` is preferable as it it stand for *Extended*, which we can also think of as *Easier*.
As well as the series of conventional numbers and characters that we are familiar with, we can match to characters with special meaning, as we saw above where enclosing the two letters in brackets gave the option of matching either.

| Special Character | Meaning |
|:----------------- |:------- |
| \w                | match any letter or digit, i.e. a word character |
| \s                | match any white space character, includes spaces, tabs & end-of-line marks |
| \d                | match any digit from 0 to 9 |
| .                 | matches any single character |
| +                 | matches one or more of the preceding character (or pattern) |
| *                 | matches zero or more of the preceding character (or pattern) |
| ?                 | matches zero or one of the preceding character (or pattern)  |
| {x} or {x,y}      | matches x or between x and y instances of the preceding character
| ^                 | matches the beginning of a line (when not inside square brackets) |
| $                 | matches the end of a line |
| ()                | contents of the parentheses treated as a single pattern |
| []                | matches only the characters inside the brackets |
| [^]               | matches anything other than the characters in the brackets |
| &#124;            | either the string before or the string after the "pipe" (use parentheses) |
| \\                | don't treat the following character in the way you normally would.<br> This is why the first three entries in this table started with a backslash, as this gives them their "special" properties.<br> In contrast, placing a backslash before a `.` symbol will enable it to function as an actual dot/full-stop. |


## Pattern Searching
In this section we'll learn the basics of using the `grep` command & what forms the output can take.
Firstly, we'll need to get the file that we'll search in this section.
First change into your `Bash_Practical` directory, then enter the following command, depending on your computer:

- OSX: `cp /usr/share/dict/words words`
- Ubuntu: `cp /usr/share/dict/words words`
- Git Bash: Download the file from `http://www-01.sil.org/linguistics/wordlists/english/wordlist/wordsEn.txt` into your `Bash_Practical` directory, then rename using `mv wordsEn.txt words`

Now page through the first few lines of the file using `less` to get an idea about what it contains.

Let's try a few searches, and to get a feel for the basic syntax of the command, try to describe what you're searching for on your notes **BEFORE** you enter the command.
Do the results correspond with what you expected to see?

```
grep -E 'fr..ol' words
```
```
grep -E 'fr.[jsm]ol' words
```
```
grep -E 'fr.[^jsm]ol' words
```
```
grep -E 'fr..ol$' words
```
```
grep -E 'fr.+ol$' words
```
```
grep -E 'cat|dog' words
```
```
grep -E '^w.+(cat|dog)' words
```

In the above, we were changing the pattern to extract different results from the files.
Now we'll try a few different options to change the output, whilst leaving the pattern unchanged.
If you're unsure about some of the options, don't forget to consult the `man` page.

```
grep -E 'louse' words
```
```
grep -Ew 'louse' words
```
```
grep -Ewn 'louse' words
```
```
grep -EwC2 'louse' words
```
```
grep -c 'louse' words
```


In most of the above commands we used the option `-E` to specify the extended version of `grep`.
An alternative to this is to use the command `egrep`, which is the same as `grep -E`.
Repeat a few of the above commands using `egrep` instead of `grep -E`.

## Pattern Matching in DNA sequences

Now we can have a look through the RAD-Seq file that we moved & renamed earlier.
Before we search the the file `RADSeq_R1.fq`, we should know what we this data actually is.
These are a small subset of 100bp reads from a RAD-Seq experiment & are from the first sample in a set of paired reads.
(Actually it's a GBS dataset, if you're aware of the differences.)
Although we can't tell this directly from this file, the sequences were obtained from a rabbit affected by *calicivirus*.


Change into the directory we created earlier using your name.
Obviously, you'll need to type your name here, not ```firstname`".
```
cd ~/firstname
```



If you inspect the data using the `head` command, you'll notice that the file is in sets of four lines, as we have mentioned earlier.
The first line contains a *sequence identifier*, the second line is the *sequence* itself, the third line is simply the `+' symbol & the final line is a set of characters which correspond to *quality scores* for each base.
We'll spend more time discussing this format in week 3, however the important thing for now is that the sequence is contained in the second line of each set of four lines.


\begin{questions}
As these reads are from the first sample in a set of paired reads, the final value in the sequence identifier is `_1`.
How could we search for a pattern just to extract the sequence identifiers?
\begin{answer}
`grep -E `\^{`@.+_1\$' RADSeq_R1.fq}
\end{answer}

How could we check for any sequences which may accidentally be included from the second sample in the pair of reads?
Hint: These identifiers would finish with `_2`
\begin{answer}
I'm hoping they will try to search for the incorrect string
`grep -E `\^{`@.+_2' RADSeq_R1.fq}.
The correct command should be:
`grep -E `\^{`@.+_2\$' RADSeq_R1.fq}
which should give no results.
\end{answer}

Did you find any reads from the other sample?
\begin{answer}
Hopefully not. Otherwise something's gone really weird...
\end{answer}
\end{questions}


Now we'll try searching for some sequences, so try the following search string.
Does the output match what you expected?
`grep -En `TGCAGGCTCT' RADSeq_R1.fq`


This should give lines 774, 3382, 3758, 7326, 7594 & 9566 along with the sequence information and matching fragment highlighted in red.

\begin{questions}
For the following search string
`grep -En `TGCAGGCTCT.+(GA)\{2\`.+A\{3\}' RADSeq_R1.fq}
What do the following components of the pattern match to:
``.+'`
\begin{answer}
This matches an unspecified length of any character, until the next key match is found.
\end{answer}

`(GA)\{2\`}
\begin{answer}
This matches to two repeats of the pattern GA.
\end{answer}

`A\{3\`}
\begin{answer}
This matches three `A's in a row.
\end{answer}

How could you find the sequence identifier for the above match?
Hint: You'll need to look at the manual for `grep`.
\begin{answer}
`grep -EnC1 `TGCAGGCTCT.+(GA)\{2\`.+A\{3\}' RADSeq_R1.fq} or
`grep -EnB1 `TGCAGGCTCT.+(GA)\{2\`.+A\{3\}' RADSeq_R1.fq}
\end{answer}
\end{questions}
