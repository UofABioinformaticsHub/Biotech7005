* TOC
{:toc}

# System Dependencies

## Gdebi

This just makes installing from `*.deb` files much simpler

```
sudo apt-get install gdebi-core
```

# R Installation For Ubuntu 16.04

- This install will setup R in your apt sources, and will automaticaly update to the latest R on each release.
- For installation using 14.04 or any other release, change `xenial` in the below code to `trusty` or whichever release is required.
- You will need to be connected to the internet for the following steps

## Add the R repository

First, we need to add a line to our `/etc/apt/sources.list` file. 
This can be accomplished with the following. 
Note the “xenial” in the line, indicating Ubuntu 16.04. If you have a different version, just change that.

```
sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
```

## Add R to Ubuntu Keyring

```
 gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
 gpg -a --export E084DAB9 | sudo apt-key add -
 ```
 
## Install R-Base

```
sudo apt-get update
sudo apt-get install r-base r-base-dev
```

# Installing R-Studio

```
wget https://download1.rstudio.org/rstudio-1.0.143-amd64.deb
sudo gdebi -n rstudio-1.0.143-amd64.deb
rm rstudio-1.0.143-amd64.deb
```


[Back To Main Page](../index)
