---
author: kubu4
comments: true
date: 2016-06-09 23:16:35+00:00
layout: post
link: http://onsnetwork.org/kubu4/2016/06/09/docker-one-liner-to-create-docker-container/
slug: docker-one-liner-to-create-docker-container
title: Docker - One liner to create Docker container
wordpress_id: 2146
author:
  - kubu4
categories:
  - Miscellaneous
tags:
  - computing
  - docker
  - one liner
  - roadrunner
---

One liner to create Docker container for Jupyter notebook usage and data analysis on roadrunner (Xserve):


    
    <code>docker run -p 8888:8888 -v /Users/sam/gitrepos/LabDocs/jupyter_nbs/sam/:/notebooks -v /Users/sam/data/:/data -v /Users/sam/analysis/:/analysis -it kubu4/bioinformatics:v11 /bin/bash</code>



This does the following:




    
  * Maps roadrunner port 8888 to Docker container port 8888 (for Jupyter notebook access outside of the Docker container)

    
  * Mounts my local Jupyter notebooks directory to the

    
    <code>/notebooks</code>


directory in the Docker container

    
  * Mounts my local data directory to the

    
    <code>/data</code>


directory in the Docker container

    
  * Mounts my local analysis directory to the

    
    <code>/analysis</code>


directory in the Docker container



These commands allow me to interact with data outside of the Docker container.
