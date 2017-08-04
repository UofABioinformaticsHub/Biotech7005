* TOC
{:toc}

# Installation For Windows

`R` can be notoriously difficult to install on Windows.
One of the biggest issues is computers where the `My Documents` folder is backed up on a networked drive.
Security settings on these folders prevent installation of numerous packages and can create a seemingly endless supply of headaches.
It's important to note that these problems generally don't occur on a stand-alone Windows machine, it's the **networked drives causing the issues** and their inability to 'play well' with the default `R` settings.

For this reason, please follow these instructions carefully.
An inattentive install may cause a series of cascading problems which can be difficult to resolve.

## Create A Local Folder For R

We will install R to it's own folder, **NOT** `C:\Program Files`.
A simple option is to create the folder `C:\R`.

## Create an Environment Variable

This variable (`R_LIBS_USER`) will live permanently in your Windows Environment and simply tells Windows where to place `R` packages.
By default `R` will try to place them in `Documents and Settings` and this is the source of most setup problems.
Network administrators wisely back this folder up, but this is simply not required for `R` packages.

To create this variable:

### Windows 10 and Windows 8

1. In Search, search for and then select: System (Control Panel)
2. Click the Advanced system settings link.
3. Click Environment Variables.
4. In the User Variables Section, click New...
5. Name the New Variable `R_LIBS_USER` and specify the value C:\R

### Windows 7

1. From the desktop, right click the Computer icon.
2. Choose Properties from the context menu.
3. Click the Advanced system settings link.
4. Click Environment Variables.
5. In the User Variables Section, click New...
6. Name the New Variable `R_LIBS_USER` and specify the value `C:\R`

## Install R

`R` Version 3.4.1 is now available from https://cran.r-project.org/bin/windows/base/
Download this file and begin the installation by double-clicking on the file
**When prompted to select the location of the installation, choose `C:\R`**

## Install R Studio

The version we need is the Desktop version, which is available [here](https://www.rstudio.com/products/rstudio/download/#download)
The installer itself is also available [here](https://download1.rstudio.org/RStudio-1.0.143.exe).
Download and install using the default settings.


## Installing packages

Once you have R and RStudio installed, please copy the following code into R

```
install.packages(c("dplyr", "reshape2", "ggplot2"))
```