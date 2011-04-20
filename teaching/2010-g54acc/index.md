---
layout: summarise
section: teaching
title: g54acc
parent: teaching &laquo; mort
---

G54ACC - Advanced Computer Communications
=========================================

I am teaching this course in conjunction with [Prof. Derek
McAuley][mac] -- contact him with questions about his part of the
course.  If you have any questions or errata for my parts of the
course, or for these web pages, please [mail me][mail].

[mac]: http://www.cs.nott.ac.uk/~drm/
[mail]: mailto:richard.mortier@nottingham.ac.uk?subject=g54acc
[rmm]: http://www.cs.nott.ac.uk/~rmm/

+-- {.section}
Topics
======

Computer networking topics at L3/Network layer and above, including:
naming and addressing; switching and routing; IP/TCP/UDP; presentation
encoding, services, application protocols; security; network
management.

Admin
=====

+-- {.summarise .hidden}
+ [Computer Science module list](http://www.nottingham.ac.uk/ugstudy/modules.php?code=000319)
+ [Official module catalog entry](http://modulecatalogue.nottingham.ac.uk/Nottingham/asp/ModuleDetails.asp?crs_id=021237&year_id=000110)
+ [Reading list](http://www.nottingham.ac.uk/is/gateway/readinglists/local/displaylist?module=G54ACC)
+ [G53ACC][], last year's course, but note that this year's course,
  G54ACC, is **new** for 2010/2011
+ [G52CCN][], the prerequisite course for this one

[g53acc]: http://www.cs.nott.ac.uk/~drm/G53ACC/index.html
[g52ccn]: http://www.cs.nott.ac.uk/~mvr/G52CCN/
=-- {.summarise .hidden}
=-- {.section}

Lectures
--------

Lecture notes made available here for teaching purposes only.  

+-- {.section}


IP and Down
===========

Lectured by [Prof. Derek McAuley][mac], Fridays, 14.00--15.00 in
JC-EXCHGE-B.LT1.

+-- {.summarise .visible}
[Lecture 1](./lectures/ip-and-down/01ipdown.pdf) **Network---IP**
---------------------------
+-- {.twocol-list}
+ Internetworking
+ IP to datalink mapping
+ ARP/connection setup
+ e.g., Ethernet, ADSL, Mobile, Wireless
+ MPLS (e.g., 21CN)

<br />
=-- {.twocol-list}


[Lecture 2 & 3](./lectures/ip-and-down/02mux.pdf)  **Multiplexing**
----------------------------
+-- {.twocol-list}
+ TDM variants
+ Statistcial multiplexing
+ Hello to Queuing theory
+ CDMA

<br />
=-- {.twocol-list}


[Lecture 4 & 5](./lectures/ip-and-down/03phy.pdf) **Physical**
-----------------------
+-- {.twocol-list}
+ Modulation
+ Coding, blocks/scramblers
+ Error correction/detection

<br />
=-- {.twocol-list}


[Lecture 6](./lectures/ip-and-down/04optical.pdf) **Optical**
-----------------------
+-- {.twocol-list}
+ Ethernet phyiscal
+ Optical transmission
+ Frequency response
+ WDM

<br />
=-- {.twocol-list}


[Lecture 7 & 8](./lectures/ip-and-down/05ether.pdf) **Ethernet**
-----------------------
+-- {.twocol-list}
+ Coax, hubs, switches
+ Broadcast
+ Multicast
+ CGE, DCE

<br />
=-- {.twocol-list}


[Lecture 9] (./lectures/ip-and-down/06adsl.pdf) **ADSL**
-------------------
+-- {.twocol-list}
+ Coding
+ ATM
+ VPs / VCs
+ Aggregation
+ Segmentation
+ History and modern day

<br />
=-- {.twocol-list}


[Lectures 10] (./lectures/ip-and-down/07switch.pdf) **Switching**
------------------------------
+-- {.twocol-list}
+ Switch architectures
+ Buffering
+ Queuing
+ QoS
+ NPUs

<br />
=-- {.twocol-list}

<!--
Lectures 7 & 8. **Wireless**
----------------------------
+-- {.twocol-list}
+ Mobile & 802.11
+ Coding
+ Radio issues
+ Timing, movements and slots
+ Channels

<br />
=-- {.twocol-list}
-->

=-- {.summarise .visible}

-----------

IP and Up
=========

Lectured by [me][rmm], Mondays, 17.00--18.00 in JC-BSSOUTH-A25.

+-- {.summarise .visible}

[Lecture 1](./lectures/ip-and-up/01-TheInternetProtocol.pdf) **Internetworking**
------------------------------
+-- {.twocol-list}
+ Encapsulation
+ Addressing 
+ Address aggregation
+ Routing _vs_. forwarding
+ Address management
+ ICMP
+ Alternatives

<br />
=-- {.twocol-list}

### Related:

[Impact of offload](http://www.informatics.sussex.ac.uk/research/projects/ngn/slides/msn10talks/watson-stack.pdf)
    ([cached](./material/watson-stack.pdf)),
[IPv6 transition](http://ccr.sigcomm.org/drupal/?q=node/622)
    ([cached](./material/p18-2v40n3e-guerinA.pdf))

<p> </p>


[Lecture 2](./lectures/ip-and-up/02-Routing.pdf) **Routing**
----------------------
+-- {.twocol-list}
+ Link-state
+ Distance-vector
+ Comparison
+ Interior _vs_. exterior routing
+ BGP
+ Peering, settlement
+ Alternatives

<br />
=-- {.twocol-list}

<p> </p>

### Related:
[OpenFlow](http://openflow.org/),
[OpenVSwitch](http://openvswitch.org/),
[NoX](http://noxrepo.org/),
[PyRT](http://github.com/mor1/pyrt/),
[BGP statistics](http://bgp.potaroo.net/),
McQuillan *et al*, [An overview of the new routing algorithm for the ARPANET](http://dx.doi.org/10.1145/205447.205453)
        ([cached](./material/p54-mcquillan.pdf))

[Lecture 3](./lectures/ip-and-up/03-Transport.pdf) **Transport: Basics**
--------------------------------
+-- {.twocol-list}
+ Process multiplexing
+ UDP
+ TCP headers
+ TCP state machine
+ Priority and precedence
+ TCP flow control

<br />
=-- {.twocol-list}

### Related: 
[Scalable Stream Transport](http://ccr.sigcomm.org/online/?q=node/272)
        ([cached](./material/fp240-ford.pdf))

<p> </p>


[Lecture 4](./lectures/ip-and-up/04-TransportAdvanced.pdf) **Transport: Advanced**
----------------------------------
+-- {.twocol-list}
+ Achieving reliability
+ Congestion collapse
+ Congestion control
+ Multimedia and TCP fairness

<br />
=-- {.twocol-list}

### Related: 
[TCP congestion control survey](http://dx.doi.org/10.1109/SURV.2010.042710.00114) 
        ([cached](./material/Host-to-host%20congestion%20control%20for%20TCP.pdf))
[TCP
visualization](http://research.swtch.com/2010/12/visualizing-tcp.html)
[TCP/IP protocol sequence diagrams](http://www.eventhelix.com/EventStudio/tcp_ip_sequence_diagrams/)

<p> </p>


[Lecture 5](./lectures/ip-and-up/05-Connecting.pdf) **Connecting**
-------------------------
+-- {.twocol-list}
+ Address translation
+ Layer violation
+ Naming
+ DNS
+ QOS: IntServ, DiffServ

<br />
=-- {.twocol-list}

### Related:
[End-to-end argument](http://doi.acm.org/10.1145/357401.357402) 
        ([cached](./material/p277-saltzer.pdf))

<p> </p>


[Lecture 6](./lectures/ip-and-up/06-Applications.pdf) **Applications**
----------------------------------------
+-- {.twocol-list}
+ Session, presentation layers
+ HTTP
+ Requests, responses
+ Cookies, pipelining
+ XMPP
+ BOSH
+ Peer-to-peer
+ Active networks

<br />
=-- {.twocol-list}

### Related:
[Sample HTTP trace](http://www.rogerclarke.com/II/IPrimerhttp-dump.html)

<p> </p>


[Lecture 7](./lectures/ip-and-up/07-Management.pdf) **Management**
-------------------------
+-- {.twocol-list}
+ Network management
+ ISO FCAPS, TMN EMS
+ Building an IP network
+ Network design
+ Device configuration
+ ICMP, ping, traceroute
+ SNMP
+ An hypothetical network management system

<br />
=-- {.twocol-list}

### Related:
[NANOG](http://nanog.org/)
[UKNOF](http://uknof.org.uk/)

<p> </p>


[Lecture 8](./lectures/ip-and-up/08-Programming.pdf) **Network Programming**
----------------------------------
+-- {.twocol-list}
+ Berkeley sockets
+ Endianness
+ Multiplexing
+ XML-RPC, SOAP, RESTful
+ Cloud computing

<br />
=-- {.twocol-list}

### Related:

[Creating a REST protocol](http://bitworking.org/news/How_to_create_a_REST_Protocol),
[REST and WS](http://bitworking.org/news/125/REST-and-WS),
[A more complex REST example](http://bitworking.org/news/201/RESTify-DayTrader),
[RESTful JSON](http://bitworking.org/news/restful_json)
[How Google Builds
APIs](http://www.google.com/events/io/2010/sessions/how-google-builds-apis.html)
([cached](./material/googleapis-how-google-builds-apis.pdf)) 
[Please drop the
SOAP!](http://thecoffman.com/2011/01/please-drop-the-soap/)

<p> </p>


[Lecture 9](./lectures/ip-and-up/09-Security.pdf) **Security**
-----------------------
+-- {.twocol-list}
+ Common requirements
+ Network security
+ Security of the network
+ Generic techniques
+ OpenID
+ OAuth
+ TLS/SSL/HTTPS

<br />
=-- {.twocol-list}


<p> </p>


[Lecture 10](./lectures/ip-and-up/10-Abstractions.pdf) **Abstractions & 3G Evolution**
-----------------------
+-- {.twocol-list}
+ System design
+ Common techniques
+ 3G data network
+ Signal measurement
+ Idle mode
+ Tracking areas
+ Pooling

<br />

=-- {.twocol-list}

<p> </p>


[Lecture 11](./lectures/ip-and-up/11-Revision.pdf) **Feedback, &c**
-----------------------
+-- {.twocol-list}
+ SET/SEM Feedback feedback
+ Sample exam question
+ Revision topics

<br />

=-- {.twocol-list}

<p> </p>

=-- {.summarise .hidden}

-----------

=-- {.section}



Lab Exercises
-------------

Note that these are not assessed, but are intended for your education
only.  As a result, I place no constraint on which programming
language you select for any of the programming exercises.  Go wild!

+-- {.summarise .hidden}
+-- {.section}
    
Exercise 1.  **Tools**
----------------------

Read the `man` pages for 
* `arp(8)`, 
* `ifconfig` (if on Unix) or `ipconfig` (if on Windows),
* `netstat(1)`,
* `ping(8)`,
* `whois(1)`,
* `traceroute(8)` or `tracert` on Windows.

Experiment running them and interpreting their output.  Note that the
University firewall prevents ICMP from escaping the university
network.  Investigate using the looking glasses at
<http://www.traceroute.org/>.

Implement basic `ping` and `traceroute` functionality in a language of
your choice.


Exercise 2.  **Packets**
------------------------

Read the `man` pages for `tcpdump`.  Experiment running it to observe 
+ different ICMP exchanges, 
+ `traceroute` operation (increasing TTLs, &c),
+ behaviour when you unplug/replug your network interface,
+ TCP connection establishment and teardown,
+ TCP retransmission of both SYNs and data,
+ TCP self-clocking behaviour (`ackno`, `seqno` relationships).

Using `tcpdump` capture a reasonable duration period of network
traffic.  In a language of your choice, implement code to parse the
resulting PCAP file, reassembling data successfully transferred in all
TCP flows (i.e., ignore retransmissions).  Print statistics concerning
flow duration, size, bandwidth, loss.

If you find yourself unable to run `tcpdump` directly, consider using
some publicly available dataset from, e.g.,
[Crawdad](http://crawdad.cs.dartmouth.edu/data.php), or the [UMass
Trace
Repository](http://traces.cs.umass.edu/index.php/Network/Network).

[Iain Fraser](http://www.cs.nott.ac.uk/~ikf/) has kindly taken some
traces as directed above for reference: the parsed traces are
[here](./material/tcpdump-traces.zip).


Exercise 3.  **Routes**
-----------------------

Using (or implementing!) a library of your choice, examine routing
data held by the [RouteViews](http://routeviews.org/) or
[RIPE/RIS](http://www.ripe.net/projects/ris/rawdata.html) projects.
Suggestions
+ extract and plot BGP dynamics for given prefixes (withdraw/update), 
+ extract and plot behaviour over time of the AS_PATH attribute and
  its manipulation, 
+ reconstruct the RIBs and FIBs that would pertain at any point,
+ extract and plot the evolution of the Internet's AS structure.

References: [PyRT](http://github.com/mor1/pyrt)


Exercise 4.  **Web services**
-----------------------------

Implement a simple base-N encode/decode RESTful webservice that limits
a given user to 10 operations and is resilient to client failure.  Do
_not_ use any system, runtime or third-party libraries that directly
provide either base-N encoding or UUID generation.  As a minimum,
support N=64, 32, 16.

References: [RFC4122](http://ietf.org/rfc/rfc4122.txt),
[RFC4648](http://ietf.org/rfc/rfc4648.txt). 

=-- {.summarise .hidden}
=-- {.section}

Books
-----

+-- {.summarise .hidden}
Many of the following assume some knowledge of the C programming
language.  No individual book is followed directly, but all of these
contain excellent background information, related content, and
extension work.

+-- {.section}

General
=======

These books are good general background textbooks on computer
communications.  They all cover material from the course, much of
which will be in more detail or with more examples than we have time
to go into during lectures.


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


Top-Down Approach
-----------------

[Computer Networking: A Top-Down Approach, 4th Edition][topdown] by
[Jim Kurose][kurose] and [Keith Ross][ross], 2007.


A Systems Approach
------------------

[Computer Networks - A Systems Approach, 4th Edition][systemsapproach]
by [Larry L. Peterson][peterson] and [Bruce S. Davie][davie], Morgan
Kaufmann, 2007.


Stallings
---------

[Data and Computer Communication Networks, sixth edition][dcc] by
[William Stallings][stallings], Prentice Hall, 2011.  ISBN:
978-0-13-139205-2.


Topic Specific
==============

These books provide more detail on particular elements covered within
the course.  
           

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

=-- {.section}
=-- {.summarise .hidden}

External Links
--------------

+-- {.summarise .hidden}
Note that these take you away from University of Nottingham pages.  I
am not responsible for any of the content linked.  They generally
contain material relevant to the topics covered.

+-- {.section}
Internet Administration
-----------------------

+ The [Internet Assigned Numbers Authority, IANA][iana] manages
  Internet number allocations such as TCP/UDP ports and IP address
  blocks.
+ The [Internet Engineering Task Force, IETF][ietf] documents and
  standardises Internet protocols, primarily through the [Internet
  Requests for Comment, RFCs][rfcs] series, which subsumed the
  [Internet Engineering Notes, IENs][iens] ([mirror][iens-mirror]).
+ The [North American Network Operators Group, NANOG][nanog] is the
  community of network admins, predominantly for Internet providers
  based in North America.

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
+ University of Berkeley, Graduate Computer Networks [CS268
  (2003)][ee122-09]  
+ University of Cambridge, [Network Architecture][cucl-r02] (primarily
  a paper-reading/research based course).

[ee122-09]: http://inst.eecs.berkeley.edu/~ee122/fa09/
[ee122-10]: http://inst.eecs.berkeley.edu/~ee122/fa10/
[cs268-03]: http://inst.eecs.berkeley.edu/~cs268/sp03/
[cucl-r02]: http://www.cl.cam.ac.uk/teaching/1011/R02/papers/

Miscellaneous
-------------

+ Several of the major network-vendor websites have informative data
  sheets, product specs and manuals.  Among the major players are
  [Cisco][] [Juniper][] [Extreme][] [Avaya][] and [Brocade][].

[cisco]: http://cisco.com/
[juniper]: http://juniper.com/
[extreme]: http://extremenetworks.com/
[avaya]: http://avaya.com/
[brocade]: http://brocade.com/

+ [routergod.com][routergod] is a bit of fun.

[routergod]: http://routergod.com/

=-- {.section}
=-- {.summarise .hidden}
