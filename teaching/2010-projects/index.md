---
layout: default
title: 2010 projects
parent: mort
---
[perscon]: http://perscon.net/
[Python]: http://www.python.org/
[Mirage]: http://github.com/mirage
[Vyper]: http://got.net/~landauer/sw/vyper_readme.html
[e]: mailto:richard.mortier@nottingham.ac.uk

Project Proposals---2010
========================

**Warning**: These projects all involve *substantial* coding, often in
languages, environments or at levels not commonly exercised in your
other courses.  They might all be considered difficult and some may
involve publishable research.  I would not recommend considering them
unless you are *both* a confident programmer *and* likely to perform
well in the exams.

If you're a third-year or masters student at University of Nottingham
and you *do* wish to take on one of these projects, please [mail
me][e].

If anyone else either implements any of these, can prove that they’re
impossible, or has any other interesting comment to make, then also,
please [mail me][e].


[Personal Containers][perscon]
-------------------

+-- {.section}
Perscon Talks Back
------------------

Personal Containers are a new way to store and manage your digital
footprint.  One current instantiation uses Google App Engine as a
cloud presence.  Develop and evaluate an XMPP interface enabling you
to talk to, query and control your Personal Container.

=--

+-- {.section}
IMAP Tools
----------

Gmail stores my email but does not expose the full power of, e.g.,
labelling via its IMAP interface.  Implement tools to enable me to
manipulate my email on Gmail, including importing into Perscon.
Without loss of generality this project can be attempted with other
webmail systems, e.g., Hotmail.

=--


Functional Systems
------------------

+-- {.section}
Functional Programming is Cool
------------------------------

Develop and evaluate some substantial piece of systems software, e.g.,
XMPP server, BGP router, in OCaml, suitable for use on the [Mirage][]
platform.

=--

+-- {.section}
libpfrag
--------

libpcap is the standard packet format parser, but it's reasonably poor
at dealing with very large files (at least on Windows), with damaged
files, and with files where an incomplete snaplen was used.  Develop
and evaluate a better one, preferably in a modern language, e.g.,
OCaml, F#.

=--

+-- {.section}
Snakes On the Cloud
-------------------

[Python][] is a useful language; [Mirage][] is a cool approach to
lightweight virtual machines currently relying on OCaml; [Vyper][] is
an incomplete and probably out-of-date implementation of Python in
OCaml.  Mash all this up to develop support for Python programs to run
on Mirage.

=--


Android
-------

+-- {.section}
Android Seeing Stars
--------------------

Develop and evaluate simple augmented reality application for Android
phones that shows satellites, the ISS and other objects not currently
displayed by Google Sky Maps.

=--

+-- {.section}
Signal Not Noise
----------------

Develop and evaluate a simple augmented reality application that
collects and visualises the various sources of radio signal out there,
e.g., WiFi, 3G, GPRS.  Use collected data to produce an analysis
(possibly as a tool) to better inform which data transports should be
used, when.

=--

+-- {.section}
Wassup
------

Modern kernels typically permit extensive instrumentation.  Develop a
kernel instrumentation system for Android that can be used to log UI,
system, network, power and other events.  Use it to perform some
simple benchmarking of, e.g., power consumption.

=--

+-- {.section}
Who Owns My Phone?
------------------

Android presents a capability model for applications that relies on
apps declaring what they need and the user agreeing at install time.
Produce tools to audit and visualise who can do what, who has done
what and (bonus, might be impossible) dynamically modify manifests so
that applications can be given time-limited capabilities.

=--


Mapping
-------

+-- {.section}
Time is Distance
----------------

Map distortion to use distance to represent other quantities such as
time is quite widely studied.  Develop a web service that produces
maps of the UK distorted by time.  This will involve researching,
implementing and perhaps extending existing published algorithms, as
well as building a scalable web service on top of data from, e.g.,
<http://OpenStreetMap.org/>.  

=--

+-- {.section}
Flexi-map
---------

All projections of the world's geography onto a plane introduce
distortions.  Develop a web service that produces maps using various
well known projections, oriented and centered on an arbitrary point,
able to be printed to reasonable quality.  This will involve building
a scalable web service as well as evaluating and comparing the
distortions introduced.

=--
