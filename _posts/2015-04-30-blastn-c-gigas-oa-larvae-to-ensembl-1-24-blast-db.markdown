---
author: kubu4
comments: true
date: 2015-04-30 03:15:57+00:00
layout: post
slug: blastn-c-gigas-oa-larvae-to-ensembl-1-24-blast-db
title: BLASTN - C.gigas OA Larvae to C.gigas Ensembl 1.24 BLAST DB
wordpress_id: 1290
author:
  - kubu4
categories:
  - Crassostrea gigas larvae OA (2011) bisulfite sequencing
tags:
  - BLAST
  - Crassostrea gigas
  - ipython notebook
  - jupyter notebook
  - Pacific oyster
---

In an attempt to figure out what's going on with the Illumina data we recently received for these samples, I BLASTed the 400ppm data set that had previously been _de-novo_ assembled by Steven: [EmmaBS400.fa](http://owl.fish.washington.edu/halfshell/EmmaBS400.fa).

I also created a nucleotide BLAST database (DB) from the [Crassostrea_gigas.GCA_000297895.1.24.fa](http://eagle.fish.washington.edu/trilobite/Crassostrea_gigas_ensembl_tracks/Crassostrea_gigas.GCA_000297895.1.24.fa)

Jupyter (IPython) Notebook: [20150429_Gigas_larvae_OA_BLASTn.ipynb](http://eagle.fish.washington.edu/Arabidopsis/iPythonNotebooks/20150429_Gigas_larvae_OA_BLASTn.ipynb)

Notebook Viewer: [20150429_Gigas_larvae_OA_BLASTn](http://nbviewer.ipython.org/url/eagle.fish.washington.edu/Arabidopsis/iPythonNotebooks/20150429_Gigas_larvae_OA_BLASTn.ipynb)

[iframe src="http://nbviewer.ipython.org/url/eagle.fish.washington.edu/Arabidopsis/iPythonNotebooks/20150429_Gigas_larvae_OA_BLASTn.ipynb" width="100%" same_height_as="window" scrolling="yes"]



Results:

The results are not great.

All query contigs successfully BLAST to sequences in the _C.gigas_ Ensembl BLAST DB. However, only 33 of the sequences (out of ~37,000) have an e-value of 0.0. The next best e-value for any matches is 0.001. For the uninitiated, that value is not very good, especially when you're BLASTing against the same exact species DB.

Will BLASTn the _C.gigas_ contigs against the entire GenBank nt (all nucleotides) to see what the taxonomy breakdown looks like of these sequences.
