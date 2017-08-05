# Week 3 Practicals: Introduction to Bash
{:.no_toc}

* TOC
{:toc}

## Introduction

Over the first two weeks we introduced the language `R`, which is heavily used in bioinformatics.
`R` is particularly effective for interacting with and visualising data, as well as performing statistical analyses.
However, in modern bioinformatics `R` is commonly used in the mid to late stage of many analyses.
An important step in many analyses is moving data around on a high-performance computer (HPC), and setting jobs running than can take hours, days or even weeks to perform.
For this, we need to learn how to write scripts which perform these actions, and the primary language for this is `bash`.

We can utilise `bash`in two primary ways:

1. Interactively through the terminal
2. Through a script which manages various stages of an analysis

For much of today we will work interactively, however a complete analysis should be scripted so we have a record of everything we do: *Reproducible Research*

## Setup

We will use `bash`on our own computers again for these sessions.
Window laptops may require some setup, whilst Ubuntu computers and OSX computers have `bash` already installed.

### OSX

OSX (Mac) computers have a terminal included, which runs `bash` by default so if you have a Mac, you simply need to open a terminal.
This can be done by following the instructions in this video (https://www.youtube.com/watch?v=QROX039ckO8).

### Windows 10

If you have Windows 10, you are able to install the additional Operating System, known as Ubuntu.
This is a Linux operating system which usually runs independently of Windows, however this version has recently been made available.
To install this, please follow this link (https://www.microsoft.com/en-au/store/p/ubuntu/9nblggh4msv6?rtc=1) and install the app.

After installation, this will open a terminal running `bash` whenever you open Ubuntu.

### Windows 8

If you have Windows 8, you'll need to install git bash from the following link: https://git-scm.com/download/win

## Initial Goals

1. Gain familiarity and confidence within the Linux command-line environment
2. Learn how to navigate directories, as well as to copy, move \& delete the files within them
3. Look up the name of a command needed to perform a specified task

## Finding your way around

Firstly we need to open a terminal as described above
You will notice some text describing your computer of the form

 `user@computer:~$`


The tilde represents your current directory (see below), whilst the dollar sign just indicates the end of the address & the beginning of where you will type commands.
This is the standard interface for the Bourne-again Shell, or `bash`.
(Historically, `bash` is a replacement for the earlier Bourne Shell, written by Stephen Bourne, so the name is actually a hilarious pun.)
We'll explore a few important commands below, and the words shell and bash will often be used interchangeably with the terminal window.
Our apologies to any purists.

If you've ever heard of the phrase `shell scripts`, this refers to a series of commands strung together into a text file which is then able to be run as a single process.

### Where are we?

Type the command `pwd` in the terminal and you will see the output which describes the `home` directory for your login.

```
pwd
```

The command `pwd` is what we use to **p**rint the current (i.e. **w**orking) **d**irectory.
This is what will be referred to as your *home* directory for the remainder of the workshop.
This is also the information that the tilde represents as a shorthand version, so whenever you see the tilde in a directory path, it is interpreted as this directory.

In the above command, the home directory began with a slash, i.e. `/`.
On a Linux-based system, this is considered to be the root directory of the file system.
Windows users would be more familiar with seeing `C:\` as the root of the drive, and this is an important difference in the two directory structures.
Note also that whilst Windows uses the backslash (\\) to indicate a new directory, a Linux-based system uses the forward slash (/), or more commonly just referred to simply as ``slash'', marking another but very important difference between the two.

Another built-in command is `cd` which we use to **c**hange **d**irectory.
No matter where we are in a file system, we can move up a directory in the hierarchy by using the command

```
cd ..
```
The string `..` is the convention for *one directory above*, whilst a single dot represents the current directory.


Enter the above command and notice that the location immediately to the left of the \$ has now changed.
This is also what will be given as the output if we enterd the command `pwd` again.
If we now enter
```
cd ..
```
one more time we should be in the root directory of the file system.
Try this and print the working directory again (`pwd`).
The output should be the root directory given as `/`.

We can change back to the original location by entering one of either:

```
cd /home/your_login_name
```
or
```
cd ~
```
or even just
```
cd
```


The approach taken above to move through the directories used what we refer to as a *relative path*, where each move was made relative to the current directory.
An *absolute path* on Linux/Mac will always begin with the root directory symbol `/`.

For example, `/path` would refer to a directory called `path` in the root directory of the file system (NB: This directory doesn't really exist, it's an example).
In contrast, a *relative path* can begin with either the current directory (indicated by `./`) or a higher-level directory (indicated by `../` as mentioned above).
A subdirectory `path` of the current directory could thus be specified as `./path`, whilst a subdirectory of the next higher directory would be specified by `../path`.
Another common relative path is the one mentioned right at the start of the session, specified with `~`, which stands for your home directory.

We can also move through multiple directories in one command by separating them with the forward slash `/`.
For example, we could also get to the root directory from our home directory by typing
```
cd ../../
```

Using the above process, return to your home directory `/home/your_login_name`.

In the above steps, this has been exactly the same as clicking through directories in our familiar folder interface that we're all familiar with.
Now we know how to navigate folders using `bash` instead of the GUI.
This is an essential skill when logged into an HPC or a VM.

### Important

Although we haven't directly discovered it yet, a Linux-based file system such as Ubuntu or Mac OS-X is also *case-sensitive*, whilst Windows is not.
For example, the command `PWD` is completely different to `pwd` and if `PWD` is the name of a command which has been defined in your shell, you will get completely different results than from the intended `pwd` command.

### Looking at the Contents of a Directory

There is another built-in command `ls` that we can use to **list** the contents of a directory.
Enter the `ls` command as it is and it will print the contents of the current directory.
```
ls
```

Alternatively, we can specify which directory we wish to view the contents of, without having to change into that directory.
We simply type the `ls` command, followed by a space, then the directory we wish to view the contents of.
To look at the contents of the root directory of the file system, we simply add that directory after the command `ls`.

```
ls /
```

Here you can see a whole raft of directories which contain the vital information for the computer's operating system.
Among them should be the `/home` directory which is one level above your own home directory, and where the home directories for all users are located.

#### Questions
 Try to think of two ways we could inspect the contents of the `/home` directory from your own home directory.

<div id="arrowHint">
     When working in the terminal, you can scroll through your previous commands by using the up arrow to go backward, and the down arrow to move forward.
     This can be a big time saver if you've typed a long command with a simple typo, or if you have to do a series of similar commands.
</div>
<button id="button" onclick="showhide()">Click For a Hint</button>
