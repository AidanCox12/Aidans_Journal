---
author: kubu4
comments: true
date: 2017-10-18 22:24:03+00:00
layout: post
link: http://onsnetwork.org/kubu4/2017/10/18/fail-directory-contents-deleted/
slug: fail-directory-contents-deleted
title: Fail - Directory Contents Deleted!
wordpress_id: 2783
author:
- kubu4
categories:
- Miscellaneous
---

Uh, not sure what happened here:

[![](http://owl.fish.washington.edu/Athaliana/20171018_directory_deletion_01.png)](http://owl.fish.washington.edu/Athaliana/20171018_directory_deletion_01.png)

I was running Canu via a Docker container with a Jupyter Notebook. I previously checked on the status by looking at the Canu logs. A couple of hours later, I noticed an error message in the Jupyter terminal output. I decided to check the progress of Canu to make sure it was still running.

It turns out everything in that directory was deleted! EVERYTHING! Including the Jupyter notebook, which must be why it threw the error on the screen. Kinda scary, actually...

I guess I'll give it another go and see what happens...
