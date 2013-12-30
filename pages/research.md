## Reseach 

---
layout: default
section: research
title: research
parent: mort
---

Research
========

The breadth of the Horizon Digital Economy Research programme of work means
that I'm involved to a greater or lesser extent in a wide range of projects,
including supervising several excellent [students][]. I list my primary
projects below, but others span topics from mixed reality urban games to use
of bio-sensing in TV production to infrastructure support for tracking
physical objects ranging from tableware to smart buildings.

[students]: students/

For a complete list of my publications, [click here](../papers/).

+-- {.section}

[Dataware](http://perscon.net/overview/dataware.html)
====

is a framework to enable individuals to give controlled access to
their personal data for processing by third parties.  This will
provide the basic infrastructure on which we can build a socially
acceptable personal data marketplace.  This work is taking place
within the context of the [Personal Containers](http://perscon.net/)
project.  

[Homework](http://www.homenetworks.ac.uk/)
====

is taking a comprehensive look at the problems users face in
managing their home network infrastructure.  [We've built a novel
Linux-based home router](https://github.com/homework/) using a custom
monitoring platform and a control infrastructure built using [Open
vSwitch][ovs] and [NOX][]. 

[Mirage](http://www.openmirage.org)
====

is an exokernel for constructing secure, high-performance network
applications across a variety of cloud computing and mobile platforms.
Code is developed in OCaml on a normal OS such as Linux or MacOS X,
and then compiled into a fully-standalone, specialised microkernel
that runs under the Xen hypervisor. 

=--

[e]: mailto:richard.mortier@nottingham.ac.uk
[ovs]: http://openvswitch.org/
[nox]: http://noxrepo.org/


### Students

---
layout: default
section: research
title: students
parent: research &laquo; mort
---

Students
========

If you are interested in a Ph.D. position with me then please contact me by
email, indicating what you would be interested in working on and what you hope
the outcome of your work would be. I have been fortunate to have worked, and
continue to work, with a number of excellent students on a wide range of
topics, many of whom are currently with the Ubiquitous Computing Doctoral
Training Centre here at Nottingham.

Current
-------

Sultan Alanazi (2012), co-supervised with [Prof. Derek McAuley][mac]. Recommendation systems using rich personal data.

Anthony Brown (2010), co-supervised with [Prof. Tom Rodden][tom]. 
Securing the domestic network.
 
Liz Dowthwaite (2012), co-supervised with [Dr Robert Houghton][rob]. 
Social networks around web comics.

Marjan Falahrastegar (2012) at Queen Mary, University of London, co-supervised
with [Prof. Steve Uhlig][uhlig] and [Dr Hamed Haddadi][hamed].
 
Ewa Luger (2009), co-supervised with [Prof. Tom Rodden][tom]. 
Understanding consent in ubiquitous computing.

Steven Luland (2013), co-supervised with [Prof. Derek McAuley][mac].

Dominic Price (2013), co-supervised with [Prof. Chris Greenhalgh][chris].

Jianhua Shao (2010), co-supervised with [Dr George Kuk][george].
Investigating markets in personal data.

Robert Spencer (2011), co-supervised with [Prof. Tom Rodden][tom]. 
History and reconciliation in domestic network configuration.



Completed
---------

[Dr Hamed Haddadi][hamed], UCL. Graduated 2008. Dissertation titled
"Topological Characteristics of IP Networks". Invited to join Hamed's
supervision team while I was at Microsoft, my co-supervisors were Drs Andrew
W. Moore and Miguel Rio.

[hamed]: http://www.eecs.qmul.ac.uk/~hamed/
[uhlig]: http://www.eecs.qmul.ac.uk/~steve/
[george]: http://www.nottingham.ac.uk/business/LIZGK.html
[rob]: http://www.nottingham.ac.uk/engineering/people/robert.houghton
[tom]: http://www.cs.nott.ac.uk/~tar/
[mac]: http://www.cs.nott.ac.uk/~drm/
[chris]: http://www.cs.nott.ac.uk/~cmg/

## PApers


[Visit my github BibTeX repo][r] for up-to-date citation details.
[Contact me][e] if you have any problems obtaining any of these.

[r]: http://github.com/mor1/rmm-bibs
[e]: mailto:richard.mortier@nottingham.ac.uk

Publications
============

<div id="entries">
Loading...
</div>

## Codes

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

[Python][]

[Scrapers][]

[Gawk/Awk][awk]

[Bash/Sh][sh]

[C][cutils]

[pyrt]: https://research.sprintlabs.com/pyrt/
[pyrt-gh]: http://github.com/mor1/pyrt/
[karaka]: http://github.com/mor1/karaka/
[python]: http://github.com/mor1/python-scripts
[awk]: http://github.com/mor1/awk-scripts
[cutils]: http://github.com/mor1/c-utils
[sh]: http://github.com/mor1/sh-scripts
