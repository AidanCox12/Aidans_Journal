---
author: kubu4
comments: true
date: 2015-06-30 19:08:45+00:00
layout: post
link: http://onsnetwork.org/kubu4/2015/06/30/rnaseq-data-receipt-geoduck-gonad-rna-100bp-pe-illumina/
slug: rnaseq-data-receipt-geoduck-gonad-rna-100bp-pe-illumina
title: RNAseq Data Receipt - Geoduck Gonad RNA 100bp PE Illumina
wordpress_id: 1498
author:
- kubu4
categories:
- Protein expression profiles during sexual maturation in Geoduck
tags:
- geoduck
- Geo_pool_F
- Geo_pool_M
- gonad
- Illumina
- Panopea generosa
- RNA-seq
---

Received notification that the [samples sent on 20150601 for RNAseq](http://onsnetwork.org/kubu4/2015/06/01/sample-submission-geoduck-gonad-for-rna-seq/) were completed.

Downloaded the following files from the GENEWIZ servers using FileZilla FTP and stored them on our server ([owl/web/nightingales/P_generosa](http://owl.fish.washington.edu/nightingales/P_generosa/)):

Geo_Pool_F_GGCTAC_L006_R1_001.fastq.gz
Geo_Pool_F_GGCTAC_L006_R2_001.fastq.gz
Geo_Pool_M_CTTGTA_L006_R1_001.fastq.gz
Geo_Pool_M_CTTGTA_L006_R2_001.fastq.gz

Generated md5 checksums for each file:


    
    <code>$for i in *; do md5 $i >> checksums.md5; done</code>



Made a readme.md file for the directory.
