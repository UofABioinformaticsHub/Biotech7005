# Week 3 Practicals
{:.no_toc}

* TOC
{:toc}

# Introduction to Bash

## Introduction

Over the first two weeks we introduced the language `R`, which is heavily used in bioinformatics.
`R` is particularly effective for interacting with and visualising data, as well as performing statistical analyses.
However, in modern bioinformatics `R` is commonly used in the middle to late stage of many analyses.
An important step in many analyses is moving data around on a high-performance computer (HPC), and setting jobs running than can take hours, days or even weeks to perform.
For this, we need to learn how to write scripts which perform these actions, and the primary language for this is `bash`.

We can utilise `bash`in two primary ways:

1. Interactively through the terminal
2. Through a script which manages various stages of an analysis

For much of today we will work interactively, however a complete analysis should be scripted so we have a record of everything we do.
This is often referred to as *Reproducible Research*, and in reality, our scripts are like an electronic lab book and can be used to protect our discoveries when we all patent our cures for cancer.

## Setup

We have instantiated a separate virtual machine for all of you, which will be yours for the remainder of the semester.
Your IP address will be given to you in the class, as well as the login information in terms of your username and password.

These machines will be identical and allow us to all work in the same environment and layout, and all are running Ubuntu which is a commonly used flavour of the Linux operating system.
Most HPC systems you use will require a knowledge of Linux so these practicals will give you the basics skills for working in this environment.

### Accessing Your VM

For the remainder of the course, we will be able to access our VMs using the software [X2Go](https://wiki.x2go.org/doku.php/download:start).
You will need to install this on your laptop so please do so before proceeding further.

Once you have this installed, please follow these steps:

1. Open the X2Go Software
2. Enter “Biotech7005” or something similar in the Session name field at the top
3. Enter your assigned IP address in the Host field
4. Enter `biotech7005` as the Login. *Note that this is case sensitive*
5. Under `Session Type`, use the drop-down menu to select `XFCE`
6. Enter OK

This will not log you in, but will have setup the “session” which is the basic login configuration, and a link to this will have appeared in the top-right of the X2Go program window.
Once you’ve figured out what we mean, click this link and you will be taken to a login which requires you to enter your password.
Enter the password provided to you and you should be connected to your VM desktop, with layout as below.

![](https://big-sa.github.io/Intro-NGS-July-2018/images/VM_Desktop.png)

We encourage you to maximise your screen containing the VM desktop, and to switch between your browser & the VM, please use `Alt+Tab`.

Also note that those of you on OSX may already have used `bash` in your terminal.
Whilst the vast majority of commands are compatible between OSX and Linux, there are occasionally some subtle differences in the arguments supplied to commands.
If something works on your VM but doesn't on your Mac, this will likely be one of those few differences.

### Changing your password
{:.no_toc}

We **strongly advise changing your password as the first thing you do**, to provide a level of security.
To change your password, open a terminal inside your VM by clicking the terminal icon at the bottom of your screen.
Then type

```bash
passwd
```
and enter your initial password, followed by your new password as instructed.
You will need to use this new password every time you login.
Please remember this as *we will not have it on record anywhere*.


## Initial Goals

Now we have setup our VM connection, the basic aims of the following sessions are:

1. Gain familiarity and confidence within the Linux command-line environment
2. Learn how to navigate directories, as well as to copy, move & delete the files within them
3. Look up the name of a command needed to perform a specified task

---

## Finding your way around

Firstly we need to open a terminal as described above, or just keep working on the one you opened when you changed your password.
You will notice some text describing your computer of the form

```
biotech7005@biotech7005-xx:~$
```

The tilde represents your current directory (see below), whilst the dollar sign just indicates the end of this path & the beginning of where you will type commands.
This is the standard interface for the Bourne-again Shell, or `bash`.
In some material you may see online, `bash` examples are given on lines beginning with `$`.
We never really need to use this at the beginning of a line, so please do be aware of this.

Historically, `bash` is a replacement for the earlier Bourne Shell, written by Stephen Bourne, so the name is actually a hilarious joke.
We'll explore a few important commands below, and the words *shell* and *bash* will often be used interchangeably with the terminal window.
Our apologies to any purists.

If you've ever heard of the phrase **shell scripts**, this refers to a series of commands like we will learn, strung together into a text file, which is then able to be run as a single process.

#### Where are we?
{:.no_toc}

Type the command `pwd` in the terminal and you will see the output which describes the `home` directory for your login.

```bash
pwd
```

The command `pwd` is what we use to __p__rint the current (i.e. __w__orking) __d__irectory.
By default `bash` will open in a directory that will be referred to as your *home* directory for the remainder of the workshop.
This may vary a little depending on your operating system, but on Linux computers this is usually `/home/username`, whilst on Mac this will be `/Users/username`
This is also the information that the tilde (`~`) represents as a shorthand version, so whenever you see `~` in a directory path, it is interpreted as this directory.

In output from `pwd`, the home directory began with a slash, i.e. `/`.
On a unix-based system (i.e. Mac & Linux), this is considered to be the root directory of the file system.
Windows users would be more familiar with seeing `C:\` as the root of the computer, and this is an important difference in the two directory structures.
Note also that whilst Windows uses the backslash (\\) to indicate a new directory, a Linux-based system uses the forward slash (/), or more commonly just referred to simply as "slash", marking another but very important difference between the two.

Another bash command is `cd` which we use to __c__hange __d__irectory.
No matter where we are in a file system, we can move up a directory in the hierarchy by using the command

```bash
cd ..
```

The string `..` is the convention for *one directory above*, whilst a single dot represents the current directory.


Enter the above command and notice that the location immediately to the left of the \$ has now changed.
This is also what will be given as the output if we entered the command `pwd` again.
If we now enter
```bash
cd ..
```
one more time we should be in the root directory of the file system.
Try this and print the working directory again (`pwd`).
The output should be the root directory given as `/`.
(Again, this may vary a little if using `git bash`)

We can change back to the original location by entering one of either:

```bash
cd ~
```
or
```bash
cd
```


The approach taken above to move through the directories used what we refer to as a __relative path__, where each move was made *relative to the current directory*.
An __absolute path__ on Linux/Mac will always begin with the root directory symbol `/`.

For example, `/foo` would refer to a directory called `foo` in the root directory of the file system (NB: This directory doesn't really exist, it's an example).
In contrast, a *relative path* can begin with either the current directory (indicated by `./`) or a higher-level directory (indicated by `../` as mentioned above).
A subdirectory `foo` of the current directory could thus be specified as `./foo`, whilst a subdirectory of the next higher directory would be specified by `../foo`.
Another common absolute path is the one mentioned right at the start of the session, specified with `~`, which stands for your home directory.

We can also move through multiple directories in one command by separating them with the forward slash `/`.
For example, we could also get to the root directory from our home directory by typing
```bash
cd ../../
```

Return to your home directory using `cd`.

In the above steps, this has been exactly the same as clicking through directories in our familiar folder interface that we're all familiar with.
Now we know how to navigate folders using `bash` instead of the GUI.
This is an essential skill when logged into a High Performance Computer (HPC) or a Virtual Machine (VM) as the vast majority of these run using Linux.

### Important
{:.no_toc}

*Although we haven't directly discovered it yet, a Unix-based file system such as Ubuntu or Mac OS-X is* **case-sensitive**, whilst **Windows is not**.
For example, the command `PWD` is completely different to `pwd` and if `PWD` happened to be the name of a command which has been defined in your shell, you would get completely different results than from the intended `pwd` command.
Most `bash` tools are named using all lower-case, but there are exceptions.

### Looking at the Contents of a Directory

There is another built-in command (`ls`) that we can use to **list** the contents of a directory.
This is a way to get our familiar folder view in the terminal.
Enter the `ls` command as it is and it will print the contents of the current directory.
```bash
ls
```

This is the list of files that we normally see in our graphical folder view.
Check using this method if you'd like by navigating to the same folder that you are in using the GUI.

Alternatively, we can specify which directory we wish to view the contents of, without having to change into that directory.
We simply type the `ls` command, followed by a space, then the directory we wish to view the contents of.
To look at the contents of the root directory of the file system, we simply add that directory after the command `ls`.

```bash
ls /
```

Here you can see a whole raft of directories which contain the vital information for the computer's operating system.
Among them should be the `/home` directory (or `/Users`) which is one level above your own home directory, and where the home directories for all users are located on a Linux system.

#### Question
{:.no_toc}

 Try to think of two ways we could inspect the contents of the `/` directory from your own home directory.

*Hint:
When working in the terminal, you can scroll through your previous commands by using the up arrow to go backward, and the down arrow to move forward.
This can be a big time saver if you've typed a long command with a simple typo, or if you have to do a series of similar commands.*

### Creating a New Directory

Now we know how to move around and view the contents of a directory, we should learn how to create a new directory using bash instead of the GUI folder you are used to.
If you already have a directory for this course, **navigate to this directory using the `cd` command**, remembering that your home directory is represented by the `~` symbol.

Now we are in a suitable location, let's create a directory called `Bash_Practical`, just like we did for the `R_Practicals`.
To do this we use the `mkdir` command as follows:

```bash
mkdir Bash_Practical
```

Importantly, this command can only make a directory directly below the one we are currently in.
If automating this process via a script it is very important to understand the difference between *absolute* and *relative* paths, as discussed above.

### Adding Options To Commands

So far, the commands we have used were given either without the use of any subsequent arguments, e.g. `pwd` & `ls`, or with a specific directory as the second argument, e.g. `cd ../` & `ls /`.
Many commands have the additional capacity to specify different options as to how they perform, and these options are often specified between the command name, and the file (or path) being operated on.
Options are commonly a single letter prefaced with a single dash (`-`), or a word prefaced with two dashes (`--`).
The `ls` command can be given with the option `-l` specified between the command & the directory and gives the output in what is known as *long listing* format.

*Inspect the contents of your current directory using the long listing format.
Please make sure you can tell the difference between the characters `l` & `1`.*

```bash
ls -l
```

The above will give one or more lines of output, and one of the first lines should be something similar to:

`drwxrwxr-x 2 biotech7005 biotech7005 4096 Aug 6 hh:mm Bash_Practical`

where `mmm dd hh:mm` are time and date information.

The letter `d` at the beginning of the initial string of codes `drwxr-xr-x` indicates that this is a directory.
Most often, these letters are known as flags which identify key attributes about each file or directory, and beyond the first flag (`d`) they appear in strict triplets.
The first entry shows the file type and for most common files this entry will be `-`, whereas for a directory we will commonly see `d`.
Beyond this first position, the triplet of values `rwx` simply refer to who is able to read, write or execute the contents of the file or directory.
These triplets refer to 1) the file's owner, 2) the group of users that the owner belongs to & 3) all users, and will only contain the values "r" (read), "w" (write), "x" (execute) or "-" (not enabled).
These are very helpful attributes for data security, protection against malicious software, and accidental file deletions.

The entries `biotech7005 biotech7005` respectively refer to who is the owner of the directory (or file) & to which group of users the owner belongs.
Again, this information won't be particularly relevant to us today, but this type of information is used to control who can read and write to a file or directory.
Finally, the value `4096` is the size of the directory structure in bytes, whilst the date & time refer to when the directory was created.

Let's look in your home directory (`~`).

```bash
ls -l ~
```

This directory should contain numerous files and folders.
There is a `-` instead of a `d` at the beginning of the initial string of flags indicates the difference between files and folders.
On Ubuntu or git bash, files and folders should also be displayed with different colours, but this may or may not be the case for those of you on OSX.
**Can you see only folders, or do you have any files present in your home directory?**

There are many more options that we could specify to give a slightly different output from the `ls` command.
Two particularly helpful ones are the options `-h` and `-R`.
We could have specified the previous command as

```bash
ls -l -h ~
```

This will change the file size to `human-readable` format, whilst leaving the remainder of the output unchanged.
Try it & you will notice that where we initially saw `4096` bytes, the size is now given as `4.0K`, and other file sizes will also be given in Mb etc.
This can be particularly helpful for larger files, as most files in bioinformatics are very large indeed.

The additional option `-R` tells the `ls` command to look through each directory recursively.
If we enter

```bash
ls -l -R ~
```

the output will be given in multiple sections.
The first is what we have seen previously, but following that will be the contents of each sub-directory.
It should become immediately clear that the output from setting this option can get very large & long depending on which directory you start from.
It's probably not a good idea to enter `ls -l -R /` as this will print out the entire contents of your file system.

In the case of the `ls` command we can also *glob* all the above options together in the command

```bash
ls -lhR ~
```

This can often save some time, but it is worth noting that not all programmers write their commands in such a way that this convention can be followed.
The built-in shell commands are usually fine with this, but many NGS data processing functions do not accept this convention.

#### How To Not Panic
{:.no_toc}

It's easy for things to go wrong when working in the command-line, but if you've accidentally:

- set something running which you need to exit or
- if you can't see the command prompt, or
- if the terminal is not responsive

there are some simple options for stopping a process & getting you back on track.
Some options to try are: \\

| Command  | Result |
|:-------- |:------ |
| `Ctrl+c` | Kill the current job |
| `Ctrl+d` | End of input         |
| `Ctrl+z` | Suspend current job  |

`Ctrl+c` is usually the first port of call when things go wrong.
However, sometimes `Ctrl+c` doesn't work but `Ctrl+d` or `Ctrl+z` does.

## Manuals and Help Pages

### Accessing Manuals

In order to help us find what options are able to be specified, every command built-in to the shell has a manual, or a help page which can take some time to get familiar with.
*These help pages are displayed using the pager known as* `less` which essentially turns the terminal window into a text viewer so we can display text in the terminal window, but with no capacity for us to edit the text, almost like primitive version of Acrobat Reader.

To display the help page for `ls` enter the command

```bash
man ls
```

As beforehand, the space between the arguments is important & in the first argument we are invoking the command `man` which then looks for the *manual* associated with the command `ls`.
To navigate through the manual page, we need to know a few shortcuts which are part of the `less` pager.

Although we can navigate through the `less` pager using up & down arrows on our keyboards, some helpful shortcuts are:

| Command    | Action |
|:---------- |:------ |
| `<enter>`  | go down one line |
| `spacebar` | go down one page (i.e. a screenful) |
| `b`        | go **b**ackwards one page |
| `<`        | go to the beginning of the document |
| `>`        | go to the end of the document |
| `q`        | quit |


Look through the manual page for the `ls` command.

#### Question
{:.no_toc}

*If we wanted to hide the group names in the long listing format, which extra options would we need set when searching our home directory?*

We can also find out more about the `less` pager by calling it's own `man` page.
Type the command:

```bash
man less
```
and the complete page will appear.
This can look a little overwhelming, so try pressing `h` which will take you to a summary of the shortcut keys within `less`.
There are a lot of them, so try out a few to jump through the file.

A good one to experiment with would be to search for patterns within the displayed text by prefacing the pattern with a slash (`/`).
Try searching for a common word like *the* or *to* to see how the function behaves, then try searching for something a bit more useful, like the word *move*.

### Accessing Help Pages

As well as entering the command `man` before the name of a command you need help with, you can often just enter the name of the command with the options `-h` or `--help` specified.
Note the convention of a single hyphen which indicates an individual letter will follow, or a double-hyphen which indicates that a word will follow.
Unfortunately the methods can vary a little from command to command, so if one method doesn't get you the manual, just try one of the others.

Sometimes it can take a little bit of looking to find something and it's important to be realise we won't break the computer or accidentally launch a nuclear bomb when we look around.
It's very much like picking up a piece of paper to see what's under it.
If you don't find something  at first, just keep looking and you'll find it eventually.


#### Questions
{:.no_toc}

Try accessing the manual for the command `man` all the ways you can think of.
*Was there a difference in the output depending on how we asked to view the manual?*

*Could we access the help page for the command `ls` all three ways?*


## Some More Useful Tricks & Commands

### A series of commands to look up

So far we have explored the commands `pwd`, `cd`, `ls` & `man` as well as the pager `less`.
Inspect the `man` pages for the commands in the following table  & fill in the appropriate fields.
Have a look at the useful options & try to understand what they will do if specified when invoking the command.
Write your answers on a piece of paper, or in a plain text file.

| **Command** | **Description of function**   | **Useful options** |
|:----------- |:----------------------------- |:------------------ |
| `man`       | Display on-line manual        | -k                 |
| `pwd`       | Print working directory, i.e show where you are | none commonly used |
| `ls`        | List contents of a directory  | -a, -h, -l         |
| `cd`        | Change directory              | (scroll down in `man builtins` to find `cd`) |
| `mv`        |                               | -b, -f, -u         |
| `cp`        |                               | -b, -f, -u         |
| `rm`        |                               | -r (careful...)    |
| `rmdir`     |                               |                    |
| `mkdir`     |                               | -p                 |
| `cat`       |                               |                    |
| `less`      |                               |                    |
| `wc`        |                               | -l                 |
| `head`      |                               | -n# (e.g., -n100)  |
| `tail`      |                               | -n# (e.g., -n100)  |
| `echo`      |                               |  -e                |
| `cut`       |                               | -d, -f, -s         |
| `sort`      |                               |                    |
| `uniq`      |                               |                    |


Sometimes the side effects of a command can also be useful.
For example, we can also use `touch` to create an empty file using the command string `touch filename`.

### Tab auto-complete

A very helpful & time-saving tool in the command line is the ability to automatically complete a command, file or directory name using the `<tab>` key.
Move to the directory above the `Bash_Practical` directory using the `cd` command.
(If you're already in this directory, you'll simply need `cd ..`).

Now try typing `ls Bash` & then hit the `<tab>` key.
Notice how `Bash_Practical` is completed automatically!
This functionality will automatically fill as far as it can until conflicting options are reached.
In this case, there was only one option so it was able to complete all the way to the end of the file path.
Where multiple options are present, you can hit the `<tab>` key twice and all options will be given to you.

This can be used to also find command names.
Type in `he` followed by two strike of the `<tab>` key and it will show you all of the commands that being with the string `he`, such as `head`, `help` or any others that may be installed on your computer.
If we'd hit the `<tab>` key after typing `hea`, then the command `head` would have auto-completed, although clearly this wouldn't have saved you any typing.

## Putting It All Together

Now we've learned about a large number of commands, let's try performing something useful.
We'll download a file from the internet, then look through the file.
**In each step remember to add the filename if it's not given!**

1. Use the `cd` command to **make sure you are in the folder** `Bash_Practical`
2. Use the command `wget` to download the `gff` file `ftp://ftp.ensembl.org/pub/release-89/gff3/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.89.gff3.gz`
3. Now unzip this file using the command `gunzip`.
(Hint: After typing `gunzip`, use tab auto-complete to add the file name.)
4. Change the name of the file to `dm6.gff` using the command `mv Drosophila_melanogaster.BDGP6.89.gff3 dm6.gff`
5. Look at the first 10 lines using the `head` command
6. Change this to the first 5 lines using `head -n5`
7. Look at the end of the file using the command `tail`
8. Page through the file using the pager `less`
9. Count how many lines are in the file using the command `wc -l`

---

# Regular Expressions

## Introduction
Regular expressions are a powerful & flexible way of searching for text strings amongst a large document or file.
Most of us are familiar with searching for a word within a file, but regular expressions allow us to search for these with more flexibility, particularly in the context of genomics.
We briefly saw this idea in the `R` practical using the functions `str_extract()` and `str_replace()`.
Instead of searching strictly for a word or text string, we can search using less strict matching criteria.
For example, we could search for a sequence that is either `AGT` or `ACT` by using the patterns  `A[GC]T` or  `A(G|C)T`.
These two patterns will search for an  `A`, followed by either a  `G` or  `C`, then followed strictly by a  `T`.
Similarly a match to `ANNT` can be found by using the patterns `A[AGCT][AGCT]T` or  `A[AGCT]{2}T`.
We'll discuss that syntax below, so don't worry if those patterns didn't make much sense.

Whilst the bash shell has a great capacity for searching a file to matches to regular expressions, this is where languages like *perl* and *python* offer a great degree more power.
The commands `awk` & `sed` which we will look at later also implement regular expressions to great effect.

## The command `grep`
The built-in command which searches using regular expressions in the terminal is `grep`, which stands for `g`lobal `r`egular `e`xpression `p`rint.
This function searches a file or input on a line-by-line basis, so patterns contained within a line can be found, but patterns split across lines are more difficult to find.
This can be overcome by using regular expressions in a programming language like Python or Perl.  

The `man grep` page (`grep --help | less` for those without `man` pages) contains more detail on regular expressions under the `REGULAR EXPRESSIONS` header (scroll down a few pages).  
As can be seen in the `man` page, the command follows the form `grep [OPTIONS] 'pattern' filename`

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
First **change into your `Bash_Practical` directory** using the `cd` command, then enter the following, depending on your operating system:

```bash
cp /usr/share/dict/words words
```


Now page through the first few lines of the file using `less` to get an idea about what it contains.

Let's try a few searches, and to get a feel for the basic syntax of the command, try to describe what you're searching for on your notes **BEFORE** you enter the command.
Do the results correspond with what you expected to see?

```bash
grep -E 'fr..ol' words
```
```bash
grep -E 'fr.[jsm]ol' words
```
```bash
grep -E 'fr.[^jsm]ol' words
```
```bash
grep -E 'fr..ol$' words
```
```bash
grep -E 'fr.+ol$' words
```
```bash
grep -E 'cat|dog' words
```
```bash
grep -E '^w.+(cat|dog)' words
```

In the above, we were changing the pattern to extract different results from the files.
Now we'll try a few different options to change the output, whilst leaving the pattern unchanged.
If you're unsure about some of the options, don't forget to consult the `man` page.

```bash
grep -E 'louse' words
```
```bash
grep -Ew 'louse' words
```
```bash
grep -Ewn 'louse' words
```
```bash
grep -EwC2 'louse' words
```
```bash
grep -c 'louse' words
```


In most of the above commands we used the option `-E` to specify the extended version of `grep`.
An alternative to this is to use the command `egrep`, which is the same as `grep -E`.
Repeat a few of the above commands using `egrep` instead of `grep -E`.
