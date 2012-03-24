---
layout: default
section: teaching
title: 2011 projects
parent: teaching &laquo; mort
---

Project Proposals---2011
========================

If you're a third-year or masters student at University of Nottingham
and you wish to take on one of these projects, or have your own
project in mind, please [mail me][e].

If anyone else either implements any of these, can prove that they're
impossible, or has any other interesting comment to make, then also,
please [mail me][e].


Miscellaneous
-------------

+-- {.section}
[Personal Containers][perscon] 
----

This is one of my current research projects, and I would be interested
in hearing any ideas for related student projects.  Possible areas
include development of interesting new data sources (either native or
via shims); or development of query systems or automated code analysis or
other provenance mechanism for personal data processing code.


libpfrag
--------

libpcap is the standard packet format parser, but it's reasonably poor
at dealing with very large files (at least on Windows), with damaged
files, and with files where an incomplete snaplen was used.  Develop
and evaluate a better one in a modern language, e.g., OCaml or F#.


Facebook Translator
-----

Implement a language translator for Facebook wall posts and comments
using eg., Google Translate, either as a Facebook app or a browser
plugin.


Mailman Threading
----

[`mailman`](http://www.gnu.org/software/mailman) is a popular email
list manager.  In many cases list members would prefer not to receive
follow-up emails unless they're actually interested in the topic.
This project involves designing and adding a feature to `mailman` to
have a list send only the first email in each thread to participants
*until* a list member replies to the thread, at which point they
should receive the thread's past history, as well as any future
mails.  `mailman` is written in [Python][] so Python programming
skills would be beneficial, although Python is very easy to learn,
particularly if you have programming experience.  

=--

[Mirage][]
----------

+-- {.section}

Functional Servers
------------------

Develop and evaluate some substantial piece of systems software, e.g.,
XMPP server, Wave server, BGP router, for the [Mirage][]
platform. 

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

[perscon]: http://perscon.net/
[Python]: http://www.python.org/
[Mirage]: http://openmirage.org/
[Vyper]: http://got.net/~landauer/sw/vyper_readme.html
[e]: mailto:richard.mortier@nottingham.ac.uk
