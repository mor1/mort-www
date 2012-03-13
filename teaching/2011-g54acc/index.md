---
layout: summarise
section: teaching
title: g54acc
parent: teaching &laquo; mort
---

G54ACC - Advanced Computer Communications
=========================================

If you have any questions or errata for my parts of the course, or for these
web pages, please [mail me][mail].

[mail]: mailto:richard.mortier@nottingham.ac.uk?subject=g54acc
[rmm]: http://www.cs.nott.ac.uk/~rmm/

+-- {.section}
Admin
=====

+-- {.summarise .hidden}
+ [Official module catalog entry](http://modulecatalogue.nottingham.ac.uk/Nottingham/asp/ModuleDetails.asp?crs_id=021237&year_id=000111)
+ [Timetable details](http://uiwwwsci01.ad.nottingham.ac.uk:8004/reporting/Individual;module;id;021237%0D%0A?days=1-5&weeks=1-52&periods=3-20&template=SWSCUST+module+Individual&height=100&week=100) 
+ [Reading list](http://www.nottingham.ac.uk/is/gateway/readinglists/local/displaylist?module=G54ACC)
+ Notes from [last year's module](../2010-g54acc/) -- be aware that there have
  been some minor modifications to content
+ [G52CCN][], the prerequisite course for this one

[g52ccn]: http://www.cs.nott.ac.uk/~mvr/G52CCN/
=-- {.summarise .hidden}
=-- {.section}

+-- {.section}
Lectures
========

Lecture notes made available here for teaching purposes only.  

+-- {.summarise .visible}

[Lecture 1](./lectures/01-Introduction.pdf) **Introduction**
-----------
+-- {.twocol-list}
+ The IP hourglass
+ Administrative details
+ Resources and constraints
+ Classes of network
+ Why IP?
+ Layering and encapsulation

<br />
=-- {.twocol-list}

[Lecture 2](./lectures/02-InternetProtocol.pdf) **Internet Protocol**
-----------
+-- {.twocol-list}
+ IP over Ethernet
+ ARP
+ Alternatives
+ Fragmentation
+ Reassembly
+ Loss

<br />
=-- {.twocol-list}

[Lecture 3](./lectures/03-AddressingRouting.pdf) **Addressing & Routing**
-----------
+-- {.twocol-list}
+ Addressing
+ Address management
+ Routing vs. forwarding
+ Longest prefix match
+ Link state routing
+ Distance vector routing

<br />
=-- {.twocol-list}


[Lecture 4](./lectures/04-Multiplexing.pdf) **Multiplexing**
-----------
+-- {.twocol-list}
+ Simplex _vs_. duplex
+ SDM, WDM, TDM
+ STM, PTM, ATM
+ A simple stochastic process
+ CDMA
+ Direct sequence

<br />
=-- {.twocol-list}


<!--
[Lecture 5](./lectures/05-Physical.pdf) **Physical**
-----------
+-- {.twocol-list}
    
<br />
=-- {.twocol-list}
-->

[Lecture 5](./lectures/05-Physical.pdf) **Physical**
-----------
+-- {.twocol-list}
+ Modulation & detection
+ QAM constellations
+ Scramblers
+ Block codes
+ Error detection
+ CRCs

<br />
=-- {.twocol-list}


[Lecture 6](./lectures/06-Optical.pdf) **Optical**
-----------
+-- {.twocol-list}
+ Optical fibres
+ Impact
+ Multimode _vs_. single-mode
+ Attenuation
+ WDM
+ Regeneration & Amplification

<br />
=-- {.twocol-list}


[Lecture 7](./lectures/07-Switching.pdf) **Switching**
-----------
+-- {.twocol-list}
+ Types of switching element
+ First/Second/Third generations
+ Crossbars
+ Multistage switches
+ Buffering
+ Blocking

<br />
=-- {.twocol-list}

[Lecture 8](./lectures/08-Ethernet.pdf) **Ethernet**
-----------
+-- {.twocol-list}
+ Pure and slotted Aloha
+ Efficiency
+ Bridges _vs_. hubs _vs_. switches
+ Spanning Tree Protocol
+ Buffering
+ Extensions

<br />
=-- {.twocol-list}

### Related:
[Tutorial on Bridges, Routers, Switches, Oh My!](http://www.nanog.org/meetings/nanog34/presentations/perlman.routers.pdf)
([cached](./material/perlman.routers.pdf)) 


[Lecture 9](./lectures/09-ATM.pdf) **ATM**
-----------
+-- {.twocol-list}
+ B-ISDN
+ Small, fixed-size cells
+ Virtual circuits
+ Quality-of-Service
+ ATM _vs_. IP
+ ADSL

<br />
=-- {.twocol-list}


[Lecture 10](./lectures/10-Transport.pdf) **Transport: Basic**
------------
+-- {.twocol-list}
+ Transport layer
+ Port numbers
+ UDP, header & pseudo-header
+ TCP setup & teardown
+ TCP state machine
+ Priority & precedence 
+ Reliability

<br />
=-- {.twocol-list}


=-- {.summarise .visible}
=-- {.section}


+-- {.section}
Lab Exercises
=============

Note that these are not assessed, but are intended for your education only. As
a result, I place no constraint on which programming language you select for
any of the programming exercises. Go wild!

+-- {.summarise .hidden}
    
Exercise 1.  **Tools**
----------------------

Read the `man`/help pages for 
* `arp(8)`, 
* `ifconfig` (if on Unix) or `ipconfig` (if on Windows),
* `netstat(1)`,
* `ping(8)`,
* `whois(1)`,
* `traceroute(8)` (if on Unix) or `tracert` (if on Windows).

Experiment running them and interpreting their output. Note that the
University firewall prevents ICMP from escaping the university network.
Investigate using the looking glasses at <http://www.traceroute.org/>.


Exercise 2.  **Web services**
-----------------------------

Implement a simple base-N encode/decode RESTful webservice that limits a given
user to 10 operations and is resilient to client failure. Do _not_ use any
system, runtime or third-party libraries that directly provide either base-N
encoding or UUID generation. As a minimum, support N=64, 32, 16.

References: [RFC4122](http://ietf.org/rfc/rfc4122.txt),
[RFC4648](http://ietf.org/rfc/rfc4648.txt). 


Exercise 3.  **Packets**
------------------------

Read the `man` pages for `tcpdump`.  Experiment running it to observe 
+ different ICMP exchanges, 
+ `traceroute` operation (increasing TTLs, &c),
+ behaviour when you unplug/replug your network interface,
+ TCP connection establishment and teardown,
+ TCP retransmission of both SYNs and data,
+ TCP self-clocking behaviour (`ackno`, `seqno` relationships).

Using `tcpdump` capture a reasonable duration period of network traffic. In a
language of your choice, implement code to parse the resulting PCAP file,
reassembling data successfully transferred in all TCP flows (i.e., ignore
re-transmissions). Print statistics concerning flow duration, size, bandwidth,
loss.

If you find yourself unable to run `tcpdump` directly, consider using some
publicly available dataset from, e.g.,
[Crawdad](http://crawdad.cs.dartmouth.edu/data.php), or the
[UMass Trace Repository](http://traces.cs.umass.edu/index.php/Network/Network).


Exercise 4.  **Control Protocols**
----------------------------------

Implement basic `ping` and `traceroute` functionality in a language of your
choice. Note that this typically requires `root` access (or equivalent) to
make use of raw sockets.


Exercise 5.  **Routes**
-----------------------

Using (or implementing!) a library of your choice, examine routing data held
by the [RouteViews](http://routeviews.org/) or
[RIPE/RIS](http://www.ripe.net/projects/ris/rawdata.html) projects.
Suggestions
+ extract and plot BGP dynamics for given prefixes (withdraw/update), 
+ extract and plot behaviour over time of the AS_PATH attribute and its
  manipulation,
+ reconstruct the RIBs and FIBs that would pertain at any point,
+ extract and plot the evolution of the Internet's AS structure.

References: [PyRT](http://github.com/mor1/pyrt)


=-- {.summarise .hidden}
=-- {.section}


+-- {.section}
Books
=====

These books are good general background textbooks on computer communications.
They all cover material from the course, much of which will be in more detail
or with more examples than we have time to go into during lectures.  

+-- {.summarise .hidden}

Top-Down Approach
-----------------

[Computer Networking: A Top-Down Approach, 4th Edition][topdown] by
[Jim Kurose][kurose] and [Keith Ross][ross], 2007.


A Systems Approach
------------------

[Computer Networks -- A Systems Approach, 4th Edition][systemsapproach]
by [Larry L. Peterson][peterson] and [Bruce S. Davie][davie], Morgan
Kaufmann, 2007.


Network Algorithmics
--------------------

[Network Algorithmics: An Interdisciplinary Approach to Designing Fast
Networked Devices][algorithmics] by [George Varghese][varghese],
Morgan-Kaufman, 2004.  ISBN 978-0-12-088477-3.


Interconnections
----------------

[Interconnections (2nd ed.): bridges, routers, switches, and
internetworking protocols][interconnections], by [Radia
Perlman][perlman], Addison-Wesley Longman Publishing Co., Inc, 2000.
ISBN 0-201-63448-1.


Stallings
---------

[Data and Computer Communication Networks, sixth edition][dcc] by
[William Stallings][stallings], Prentice Hall, 2011.  ISBN:
978-0-13-139205-2.


Topic Specific
==============

These books provide more detail on particular elements covered within the
course.
           

UNIX Network Programming
------------------------

[UNIX Network Programming, Volume 1: The Sockets Networking API, 3rd
Edition][unp1] by [W. Richard Stevens][stevens], Bill Fenner, and
Andrew M. Rudoff, Addison-Wesley, 2003.  See also [Volume 2:
Interprocess Communications][unp2].


TCP/IP Illustrated
------------------

[TCP/IP Illustrated, Volume 1: The Protocols][illustrated1], by
[W. Richard Stevens][stevens].  See also [Volume 2: The
Implementation][illustrated2] and [Volume 3: TCP for Transactions,
HTTP, NNTP, and the UNIX Domain Protocols][illustrated3].  

Internetworking
---------------

[Internetworking With TCP/IP Volume 1: Principles Protocols, and
Architecture, 5th edition][comervol1] by [Douglas Comer][comer],
Prentice-Hall, 2006. ISBN 0-13-187671-6.  See also [Volume 2: Design,
Implementation and Internals][comervol2] and [Volume 3: Client-Server
Programming and Applications][comervol3] (different editions for
different specific platforms).

[comer]: http://www.cs.purdue.edu/people/comer
[ross]: http://cis.poly.edu/~ross/
[kurose]: http://www-net.cs.umass.edu/personnel/kurose.html
[stevens]: http://www.kohala.com/start/
[davie]: http://nms.lcs.mit.edu/~bdavie/
[peterson]: http://www.cs.princeton.edu/~llp/
[tanenbaum]: http://www.cs.vu.nl/~ast/
[stallings]: http://williamstallings.com/
[perlman]: http://labs.oracle.com/people/mybio.php?uid=28941
[varghese]: http://cseweb.ucsd.edu/users/varghese/

[comervol1]: http://www.cs.purdue.edu/homes/dec/netbooks.html#vol1
[comervol2]: http://www.cs.purdue.edu/homes/dec/netbooks.html#vol2
[comervol3]: http://www.cs.purdue.edu/homes/dec/netbooks.html#vol3.bsd
[cnaisite]: http://netbook.cs.purdue.edu/

[tcpip1]: http://www.cs.purdue.edu/people/comer
[dcc]: http://www.pearsonhighered.com/educator/product/Data-and-Computer-Communications/9780131392052.page
[topdown]: http://www.aw-bc.com/kurose_ross/
[unp1]: http://www.kohala.com/start/unpv12e.html
[unp2]: http://www.kohala.com/start/unpv22e/unpv22e.html
[illustrated1]: http://www.kohala.com/start/tcpipiv1.html
[illustrated2]: http://www.kohala.com/start/tcpipiv2.html
[illustrated3]: http://www.kohala.com/start/tcpipiv3.html
[systemsapproach]: http://www.elsevierdirect.com/product.jsp?isbn=9780123705488
[networks]: http://authors.phptr.com/tanenbaumcn4/
[interconnections]: http://portal.acm.org/citation.cfm?id=316181
[algorithmics]: http://www.elsevier.com/wps/find/bookdescription.cws_home/704109/description

=-- {.summarise .hidden}
=-- {.section}

+-- {.section}
External Links
==============

Note that these take you away from University of Nottingham pages. I am not
responsible for any of the content linked. They contain a range of material
generally relevant to the topics covered.

+-- {.summarise .hidden}
Internet Administration
-----------------------

+ The [Internet Assigned Numbers Authority, IANA][iana] manages Internet
  number allocations such as TCP/UDP ports and IP address blocks.
+ The [Internet Engineering Task Force, IETF][ietf] documents and standardises
  Internet protocols, primarily through the
  [Internet Requests for Comment, RFCs][rfcs] series, which subsumed the
  [Internet Engineering Notes, IENs][iens] ([mirror][iens-mirror]).
+ The [North American Network Operators Group, NANOG][nanog] is the community
  of network admins, predominantly for Internet providers based in North
  America.

[iana]: http://www.iana.org/
[rfcs]: http://www.rfc-editor.org/
[rfc-index]: http://www.rfc-editor.org/rfc-index.txt
[iens]: ftp://ftp.rfc-editor.org/in-notes/ien/ien-index.html
[iens-mirror]: http://www.postel.org/ien/txt/
[ien-index]: http://www.postel.org/ien/txt/ien-index.txt
[ietf]: http://www.ietf.org/
[nanog]: http://www.nanog.org/


Related Courses
---------------

+ University of Berkeley, Introduction to Communication Networks
  [EE122 (2009)][ee122-09] [EE122 (2010)][ee122-10] 
+ University of Berkeley, Graduate Computer Networks [CS268 (2003)][ee122-09] 
+ University of Cambridge, [Network Architecture][cucl-r02] (primarily a
  paper-reading/research based course).

[ee122-09]: http://inst.eecs.berkeley.edu/~ee122/fa09/
[ee122-10]: http://inst.eecs.berkeley.edu/~ee122/fa10/
[cs268-03]: http://inst.eecs.berkeley.edu/~cs268/sp03/
[cucl-r02]: http://www.cl.cam.ac.uk/teaching/1011/R02/papers/

Miscellaneous
-------------

Several of the major network-vendor websites have informative data sheets,
product specs and manuals. Among the major players are [Cisco][] [Juniper][]
[Extreme][] [Avaya][] and [Brocade][].

[cisco]: http://cisco.com/
[juniper]: http://juniper.com/
[extreme]: http://extremenetworks.com/
[avaya]: http://avaya.com/
[brocade]: http://brocade.com/

=-- {.summarise .hidden}
=-- {.section}
