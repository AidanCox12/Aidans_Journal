---
author: kubu4
comments: true
date: 2018-04-09 23:25:01+00:00
layout: post
link: http://onsnetwork.org/kubu4/2018/04/09/trimgalorefastqcmultiqc-auto-trim-c-virginica-mbd-bs-seq-fastq-data/
slug: trimgalorefastqcmultiqc-auto-trim-c-virginica-mbd-bs-seq-fastq-data
title: TrimGalore/FastQC/MultiQC - Auto-trim C.virginica MBD BS-seq FASTQ data
wordpress_id: 3222
author:
  - kubu4
categories:
  - Miscellaneous
tags:
  - Crassostrea virginica
  - Eastern oyster
  - FASTQC
  - MBD-Seq
  - multiqc
  - TrimGalore!
---

[Yesterday, I ran FastQC/MultiQC on the _Crassostrea virginica_ MBD BS-seq data from ZymoResearch](http://onsnetwork.org/kubu4/2018/04/09/fastqcmultiqc-c-virginica-mbd-bs-seq-data/). Steven wanted to trim it and see how things turned out.

I ran TrimGalore (using the built-in FastQC option) and followed up with MultiQC for a summary of the FastQC reports.

TrimGalore job script:





  * [20180409_trimgalore_autotrim_Cvirginica_MBD.sh](http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_trimgalore_autotrim_Cvirginica_MBD.sh)



Standard error was redirected on the command line to this file:



  * [20180409_trimgalore_autotrim_Cvirginica_MBD/stderr.log](http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/stderr.log)



MD5 checksums were generated on the resulting trimmed FASTQ files:



  * [20180409_trimgalore_autotrim_Cvirginica_MBD/checksums.md5](http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/checksums.md5)



All data was copied to my folder on Owl.

Checksums for FASTQ files were verified post-data transfer.



##### Results:



Output folder:





  * [20180409_trimgalore_autotrim_Cvirginica_MBD/](http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/)



FastQC output folder:



  * [20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_fastqc_trimgalore_autotrim_Cvirginica_MBD/](http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_fastqc_trimgalore_autotrim_Cvirginica_MBD/)



MultiQC output folder:



  * [20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_fastqc_trimgalore_autotrim_Cvirginica_MBD/multiqc_data/](http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_fastqc_trimgalore_autotrim_Cvirginica_MBD/multiqc_data/)



MultiQC HTML report:



  * [20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_fastqc_trimgalore_autotrim_Cvirginica_MBD/multiqc_data/multiqc_report.html](http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_fastqc_trimgalore_autotrim_Cvirginica_MBD/multiqc_data/multiqc_report.html)



Overall, the auto-trim didn't alter things too much. Specifically, Steven is concerned about the variability in the first 15bp ([seen in the Per Base Sequence Content section of the MultiQC output](http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_fastqc_trimgalore_autotrim_Cvirginica_MBD/multiqc_data/multiqc_report.html#fastqc_per_base_sequence_content)). It was reduced, but not greatly. Will perform an independent run of TrimGalore and employ a hard trim of the first 14bp of each read and see how that looks.

[iframe src="http://owl.fish.washington.edu/Athaliana/20180409_trimgalore_autotrim_Cvirginica_MBD/20180409_fastqc_trimgalore_autotrim_Cvirginica_MBD/multiqc_data/multiqc_report.html" width="100%" same_height_as="window" scrolling="yes"]
