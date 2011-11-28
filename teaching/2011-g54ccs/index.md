---
layout: summarise
section: teaching
title: g54ccs
parent: teaching &laquo; mort
---

G54CCS - Connected Computing at Scale
=====================================

I co-convene this module with [Dr. Martin Flintham][mdf].  If you have
any questions or errata for my parts of the course, or for these web
pages, please [mail me][mail].  

[mail]: mailto:richard.mortier@nottingham.ac.uk?subject=g54ccs
[rmm]: http://www.cs.nott.ac.uk/~rmm/
[mdf]: http://www.cs.nott.ac.uk/~mdf/
[mdf-ccs]: http://www.cs.nott.ac.uk/~mdf/teaching_G54CCS.html
                                                      

+-- {.section}
Topics
======

The concepts and challenges associated with modern cloud and mobile
computing platforms, and their development and use, including:<br />
+-- {.summarise .hidden}
The technical distinctions between software/platforms/infrastructures
"as a service"; The basics of current state-of-the-art cloud platform
implementation technologies; Technical approaches to scalability; The
risks and opportunities of cloud and mobile platforms; The impact of
mobile device resource and network limitations and availability;
Practical constraints imposed by mobile/cloud dataflow architectures,
and relationship to mobile telephony; The impact of market penetration
and platform ecologies; Mechanisms for application purchase and
deployment, and associated business models. 
=-- {.summarise .hidden}

Admin
=====

+-- {.summarise .hidden}
+ [Computer Science module list](http://www4.nottingham.ac.uk/ugstudy/module-information.php?code=021006&mod_year=optional&modcode=022256)
+ [Official module catalog entry](http://modulecatalogue.nottingham.ac.uk/Nottingham/asp/moduledetails.asp?crs_id=022256&year_id=000111)

The module involves lectures (1/week) and a series of unassesed _but
compulsory_ lab exercises (1 session/week).  Lectures are given at
0900 Mondays, A25 Business School South.  Lab sessions are 1100-1200
Thursdays, C11/B52 Computer Science.  Due to pressure of numbers, we
are attempting to schedule a second lab session.  Assessment is by
exam only, one paper.  There are no set texts for this module; links
to pertinent material will be provided as the module progresses. 
            
=-- {.summarise .hidden}
=-- {.section}

Lectures
--------

Lecture notes made available here for teaching purposes only.

Some good general background material is available at
<http://ds.informatik.rwth-aachen.de/teaching/ws0910/cloud_computing>. 

+-- {.section}
+-- {.summarise .visible}
[Lecture 1][lec01] **Housekeeping**
----
Given by [Dr. Flintham][mdf-ccs].  Due to excessive numbers, this
lecture was limited to housekeeping/admin information only, and was
cut short. 


[Lecture 2][lec02] **The Cloud**
----
Given by [Dr. Flintham][mdf-ccs].  This lecture introduces cloud
computing, its evolution, and the three main variants today (SaaS,
PaaS, IaaS).


[Lecture 3](./lectures/03-datacenters.pdf) **Datacenters**
----
+-- {.twocol-list}
+ Types of Cloud
+ From Datacenter to Blade
+ Achieving Scale
+ Homogeneity
+ Reliability
+ Physical Constraints

<br />
=-- {.twocol-list}

### Related:
[Data center density hits the wall?](http://bit.ly/qCsjsJ)
[Amazon's James Hamilton on How to Build a Better Datacenter](http://bit.ly/uIPD9S)
[James Hamilton's blog](http://bit.ly/tsvZIb)

<p> </p>

[Lecture 4](./lectures/04-virtualization.pdf) **Virtualization**
----
+-- {.twocol-list}
+ Why Virtualization?
+ Abstraction & Layering
+ The Operating System
+ Virutalization
+ Benefits

<br />
=-- {.twocol-list}

### Related:
[Why we moved off the cloud](http://bit.ly/sd8C5e)
[When "clever" goes wrong](http://bit.ly/rhdpGJ)
[HP/Calxeda ARM servers](http://engt.co/sqGJLx)

<p> </p>


[Lecture 5](./lectures/05-networking.pdf) **Networking**
----
+-- {.twocol-list}
+ Network hierarchy
+ Network resources
+ Security
+ Addressing
+ Routing & Forwarding
+ Naming

<br />
=-- {.twocol-list}

### Related:
[Current AT&T network latency](http://ipnetwork.bgtmo.ip.att.net/pws/network_delay.html)

<p> </p>

[Lecture 6](./lectures/06-storage.pdf) **Storage**
----
+-- {.twocol-list}
+ Storage
+ Disk evolution
+ Abstractions
+ SQL vs. NoSQL
+ Tradeoffs
+ Scale: Facebook Messaging

<br />
=-- {.twocol-list}

### Related:
[Eventually Consistent](http://bit.ly/qSIpxP)
[Storage infrastructure behind Facebook Messages](http://bit.ly/rt2csc)
at [HPTPS 2011](http://bit.ly/vx7JYx)

<p> </p>

[Lecture 7][lec07] **Map Reduce**
----
Given by [Dr. Flintham][mdf-ccs].  This lecture introduces cloud software
development, taking _Map Reduce_ as an example big data processing technique..


[Lecture 8][lec08] **Ajax and REST**
----
Given by [Dr. Flintham][mdf-ccs].  This lecture continues with cloud software
development, looking at highly interactive web applications.


[Lecture 9][lec09] **Separation of Concerns**
----
Given by [Dr. Flintham][mdf-ccs].  This lecture continues with cloud
development paradigms and the need for separation of concerns in particular.


=-- {.summarise .visible}
=-- {.section}

Labs
----

Some background notes, including some common "gotchas" are available at
<http://www.cs.nott.ac.uk/~rmm/teaching/2011-g54ccs/labs/README.pdf>. 

+-- {.section}
+-- {.summarise .visible}

[Lab 1][lab01] **Introducing GAE**
---

A basic introduction to developing Google App Engine web applications
in Python.  The app returns a simple static "Hello World!" page.

[Lab 2](./labs/02-python.pdf) **Some Python**
---

Making the page more dynamic, and introducing more simple Python
syntax.

[Lab 3](./labs/03-calc.pdf) **A Calculator**
---

Adding support for the user to pass parameters into your application.

[Lab 4](./labs/04-state.pdf) **Counting**
---

Using the storage backend, templates and `POST`.

[Lab 5](./labs/05-guestbook.pdf) **Guestbook**
---

An more open-ended exercise, consolidating material from labs 1--4 by building
a simple guestbook web application.

[Lab 6](./labs/06-tickets.pdf) **Tickets**
---

Introducing _tickets_, a means to get a server-generated token to identify
interaction with the webservice at some granularity.

[Lab 7](./labs/07-mashup.pdf) **External Services**
---

Using the _[Twitter Search API](http://search.twitter.com/)_, a simple example
of how to build a GAE application that makes use of a third-party webservice.


=-- {.summarise .visible}
=-- {.section}


[lec01]: http://www.cs.nott.ac.uk/~mdf/g54ccs/g54ccs_lecture01_handouts.pdf
[lec02]: http://www.cs.nott.ac.uk/~mdf/g54ccs/g54ccs_lecture02_handouts.pdf
[lec07]: http://www.cs.nott.ac.uk/~mdf/g54ccs/g54ccs_lecture07_handouts.pdf
[lec08]: http://www.cs.nott.ac.uk/~mdf/g54ccs/g54ccs_lecture08_handouts.pdf
[lec09]: http://www.cs.nott.ac.uk/~mdf/g54ccs/g54ccs_lecture09_handouts.pdf
[lab01]: http://www.cs.nott.ac.uk/~mdf/g54ccs/g54ccs_lab01.pdf
