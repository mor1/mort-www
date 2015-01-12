---
layout: default
section: research
title: research
parent: mort
---

# Codes

Most of the code I write is available via my [Github][] account -- pull requests always welcome! -- but I thought I'd collate links to some of the larger codebases I've been involved with as well as some of the Github organisations I'm involved in.

[github]: https://github.com/mor1

## [Dataware][dataware-git] <small>2011--2014</small>

Developed through [Horizon Digital Economy Research][horizon], Dataware represents a set of prototype services enabling control over access to personal data. Presents data via web services, and controls access via a personal catalogue. Third-parties access personal data by requesting permission via the catalogue, allowing accesses to be audited and managed.

[dataware-git]: http://github.com/dataware
[horizon]: http://www.horizon.ac.uk/

## [Homework][homework-git] <small>2010--2013</small>

Developed during the [Homework][] project, the Homework router reconstructs the home router informed by ethnographic study of home networks 'in the wild'. Uses OpenFlow (Open vSwitch and NOX/POX) to provide novel interrogation, control and policy interfaces to a home router.

[homework-git]: http://github.com/mor1/homework/
[homework]: http://homenetworks.ac.uk/

## [Karaka][karaka-git] <small>2007--2009</small>

Developed at Vipadia Limited, this is a scalable software system
implementing a distributed Skype-XMPP gateway released under the
GPLv2.  Copyright was acquired by Voxeo Corp. in January 2010.

[karaka-git]: http://github.com/mor1/karaka/

## [PyRT][pyrt-git] <small>2001--2002</small>

I developed the Python Routeing Toolkit while at Sprint ATL, who released it under the GPLv2. It comprises code for collecting and analysing routeing data. This package currently collects BGPv4 and ISIS, and dumps and parses MRTD files including MRTD `TABLE_DUMP` files (as available from, e.g., [RouteViews][] and [RIPE/RIS][ripe-ris]). A number of utilities for manipulating these dumps are also provided. Since the code on [Sprint's website][pyrt] appears to be orphaned, I have created a [github repository here][pyrt-git] for it. I have also subsequently written an [OCaml][ocaml-mrt] MRT dump parser as a learning exercise.

[pyrt-git]: http://github.com/mor1/pyrt/
[pyrt]: https://research.sprintlabs.com/pyrt/
[routeviews]: http://www.routeviews.org/
[ripe-ris]: http://www.ripe.net/data-tools/stats/ris/ris-raw-data
[ocaml-mrt]: https://github.com/mor1/ocaml-mrt
