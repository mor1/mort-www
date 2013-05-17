---
layout: default
section: code
title: code
parent: mort
---

<img class='inset right' 
     src='{{site.baseurl}}img/joker.png' 
     title='Richard Mortier' 
     alt='Photo of Richard Mortier' height='100px' />

Released Code
=============

+-- {.section}
[Perscon][]
========

Personal Containers are an experiment in enabling you to collate and
control your digital footprint.  At the moment the focus is on
collecting and managing your own data; future goals include developing
ways to enable others to interact with your data for mutual benefit,
while still retaining ultimate control yourself.  The code is
available under the GPLv2.

[perscon]: http://perscon.net/

[Homework][homework-git]
========

This is an experiment using [Open vSwitch][ovs] and [NoX][] to control
a wireless Linux access point as part of the wider [Homework][]
project.  The repository contains snapshots of both Open vSwitch and
NoX (as `git` *submodules* no less), as well as the Homework specific
control script which currently provides basic PERMIT/DENY
functionality based on MAC address and exposed via a simple web
services interface.

[homework-git]: http://github.com/mor1/homework/
[homework]: http://www.homenetworks.ac.uk/
[ovs]: http://openvswitch.org/
[nox]: http://noxrepo.org/

[PyRT][]
=====

I developed the Python Routeing Toolkit while at Sprint ATL, who
released it under the GPLv2.  It comprises code for collecting and
analysing routeing data.  This package currently collects BGPv4 and
ISIS, and dumps and parses MRTD files including MRTD TABLE_DUMP files
(as available from, e.g., RouteViews and RIPE/RIS).  A number of
utilities for manipulating these dumps are also provided.  Since the
code on [Sprint's website][pyrt] appears to be orphaned, I have
created a [github repository here][pyrt-gh] for it.

[Karaka][]
======

Developed at Vipadia Limited, this is a scalable software system
implementing a distributed Skype-XMPP gateway released under the
GPLv2.  Copyright was acquired by Voxeo Corp. in January 2010.
         
=--

Miscellaneous Scripts
---------------------

+-- {.section}
[Python][]
=======

bberry: *parse RIM Blackberry backup (.IPD) files, extracting contacts*<br>
bib2json: *convert BibTeX files to JSON*<br>
cal: *replacement for Unix `cal` command: similar output, more options*<br>
ghpy: *wrapper for GitHub REST API; currently can retrieve private collaborators*<br>
ip2as: *lookup the AS owning an IP address*<br>
jsonpretty: *pretty print JSON from `stdin`*<br>
num: *print number in selection of useful bases*<br>
skrype: *parse and print Skype `.dbb` logfiles*<br>
slots: *compute number of people that can make each slot of a set of available
times*<br>
tdump2txt: *filter to pretty print `tcpdump -x` output*<br>

[UoN](http://github.com/mor1/uon/)
-------

tt: *module timetables*<br>
reg: *module registrations*


[Gawk/Awk][awk]
========

rfc2bib: *convert IETF RFC index text file to BibTeX*<br>
id2bib: *convert IETF Internet Draft index text file to BibTeX*<br>

[Bash/Sh][sh]
========

envfns: *environment manipulation shell functions*<br>
filefns: *filesystem related shell functions*<br>
numfns: *number base conversion shell functions*<br>
pdfmerge: *merge set of PDFs into one*<br>

[C][cutils]
==

glob: *`glob` shell function as binary*<br>
loadup: *ensure n-of-m jobs in a batch kept running until batch completes*<br>
nohup: *`nohup` shell function as a binary*<br>
range: *Python's `range()` builtin, for command line use*<br>

=--


[pyrt]: https://research.sprintlabs.com/pyrt/
[pyrt-gh]: http://github.com/mor1/pyrt/
[karaka]: http://github.com/mor1/karaka/
[python]: http://github.com/mor1/python-scripts
[awk]: http://github.com/mor1/awk-scripts
[cutils]: http://github.com/mor1/c-utils
[sh]: http://github.com/mor1/sh-scripts
