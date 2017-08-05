# Biotech 7005 Practicals
{:.no_toc}

## Week 3: Introduction to Bash
{:.no_toc}

* TOC
{:toc}

### Introduction

Over the first two weeks we introduced the language `R`, which is heavily used in bioinformatics.
`R` is particularly effective for interacting with and visualising data, as well as performing statistical analyses.
However, in modern bioinformatics `R` is commonly used in the mid to late stage of many analyses.
An important step in many analyses is moving data around on a high-performance computer (HPC), and setting jobs running than can take hours, days or even weeks to perform.
For this, we need to learn how to write scripts which perform these actions, and the primary language for this is `bash`.

We can utilise `bash`in two primary ways:

1. Interactively through the terminal
2. Through a script which manages various stages of an analysis

For much of today we will work interactively, however a complete analysis should be scripted so we have a record of everything we do: *Reproducible Research*

### Setup

We will use `bash`on our own computers again for these sessions.
Window laptops may require some setup, whilst Ubuntu computers and OSX computers have `bash` already installed.

#### OSX

OSX (Mac) computers have a terminal included, which runs `bash` by default so if you have a Mac, you simply need to open a terminal.
This can be done by following the instructions in this video (https://www.youtube.com/watch?v=QROX039ckO8).

#### Windows 10

If you have Windows 10, you are able to install the additional Operating System, known as Ubuntu.
This is a Linux operating system which usually runs independently of Windows, however this version has recently been made available.
To install this, please follow this link (https://www.microsoft.com/en-au/store/p/ubuntu/9nblggh4msv6?rtc=1) and install the app.

After installation, this will open a terminal running `bash` whenever you open Ubuntu.

#### Windows 8

If you have Windows 8, you'll need to install git bash from the following link: https://git-scm.com/download/win
