---
author: kubu4
comments: true
date: 2018-05-23 16:17:57+00:00
layout: post
link: http://onsnetwork.org/kubu4/2018/05/23/software-installation-repeatmasker-v4-0-7-on-emuroadrunner-continued/
slug: software-installation-repeatmasker-v4-0-7-on-emuroadrunner-continued
title: Software Installation – RepeatMasker v4.0.7 on Emu/Roadrunner Continued
wordpress_id: 3376
author:
- kubu4
categories:
- Miscellaneous
tags:
- emu
- RepeatMasker
- rmblastn
- roadrunner
- TE
- transposable elements
---

[After yesterday's difficulties getting RMblast to compile](http://onsnetwork.org/kubu4/2018/05/22/software-installation-repeatmasker-v4-0-7-on-emuroadrunner/), I deleted the folder and went through the build process again.

This time it worked, but it did _not_ put rmblastn in the specified location (`/home/shared/rmblast`).

This fact took me a fair amount of time to figure out. Finally, after a couple of different re-builds, I ran `find` to see if rmblastn existed somewhere I wasn't looking:

![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_01.png)

Additionally, I couldn't find the location of the various BLAST executables. Some internet sleuthing led me to the [NCBI page on installing BLAST+ from source](https://www.ncbi.nlm.nih.gov/books/NBK279671/), which indicates that the executables are stored in:


    
    <code>ncbi-blast-VERSION+-src/c++/ReleaseMT/bin/</code>



How intuitive! /s

In order to improve readability and usability of the `/home/shared/` directory, I renamed the `/home/shared/rmblast` directory to reflect the BLAST version and created a symbolic link in that directory to the `rmlbastn` executable:



##### Symbolic link to RMBLAST



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_02.png)



#### Initiate RepeatMasker configuration





* * *





##### Confirm perl install location:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_03.png)



* * *





##### Confirm RepeatMasker install location:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_04.png)



* * *





##### Specify TRF install location:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_05.png)



* * *





##### Hmmm, TRF error. Looking for file called `trf`:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_06.png)



* * *





##### Renamed TRF file to `trf` and now it's automatically found:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_07.png)



* * *





##### Set RMBlast as search engine:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_08.png)



* * *





##### Set RMBlast install location:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_09.png)



* * *





##### Set RMBlast as default search engine:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_10.png)



* * *





##### Confirmation of RMBlast as default search engine and successful installation of RepeatMasker:



![](http://owl.fish.washington.edu/Athaliana/20180523_rmblast_install_12.png)



* * *
