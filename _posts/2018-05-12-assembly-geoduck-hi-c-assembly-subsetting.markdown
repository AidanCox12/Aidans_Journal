---
author: kubu4
comments: true
date: 2018-05-12 22:16:56+00:00
layout: post
slug: assembly-geoduck-hi-c-assembly-subsetting
title: Assembly - Geoduck Hi-C Assembly Subsetting
wordpress_id: 3332
author:
  - kubu4
categories:
  - Geoduck Genome Sequencing
tags:
  - faidx
  - geoduck
  - Hi-C
  - Panopea generosa
  - phase genomics
  - QUAST
---

[Steven asked me to create a couple of subsets of our Phase Genomics Hi-C geoduck genome assembly (pga_02)](https://github.com/RobertsLab/resources/issues/259):





  * Contigs >10kbp



  * Contigs >30kbp






I used [pyfaidx](https://github.com/mdshw5/pyfaidx) on Roadrunner and the following commands:


    
    <code>faidx --size-range 10000,100000000 PGA_assembly.fasta > PGA_assembly_10k_plus.fasta
    </code>




    
    <code>faidx --size-range 30000,100000000 PGA_assembly.fasta > PGA_assembly_30k_plus.fasta
    </code>



Ran Quast afterwards to get stats on the new FastA files just to confirm that the upper cutoff value was correct and didn't get rid of the largest contig(s).



##### Results:



faidx Output folder: [20180512_geoduck_fasta_subsets/](http://owl.fish.washington.edu/Athaliana/20180512_geoduck_fasta_subsets/)



<blockquote>
  10kbp contigs (FastA): [20180512_geoduck_fasta_subsets/PGA_assembly_10k_plus.fasta](http://owl.fish.washington.edu/Athaliana/20180512_geoduck_fasta_subsets/PGA_assembly_10k_plus.fasta)
  
  30kbp contigs (FastA): [20180512_geoduck_fasta_subsets/PGA_assembly_30k_plus.fasta](http://owl.fish.washington.edu/Athaliana/20180512_geoduck_fasta_subsets/PGA_assembly_30k_plus.fasta)
</blockquote>



Quast output folder: [results_2018_05_14_06_26_26/](http://owl.fish.washington.edu/Athaliana/quast_results/results_2018_05_14_06_26_26/)

Quast report (HTML): [results_2018_05_14_06_26_26/report.html](http://owl.fish.washington.edu/Athaliana/quast_results/results_2018_05_14_06_26_26/report.html)

Everything looks good. The main thing I wanted to confirm by running Quast was that the largest contig in each subset was the same as the [original PGA assembly (95,480,635bp](http://onsnetwork.org/kubu4/2018/04/30/assembly-stats-geoduck-hi-c-assembly-comparison/).
