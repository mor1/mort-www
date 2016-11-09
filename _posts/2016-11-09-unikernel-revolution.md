---
title: Evolving the Unikernel Revolution!
subtitle: Revolution to evolution
layout: post
category: blog
---

I've had the pleasure of giving a couple of talks at some fun venues recently,
extolling both the virtues of [unikernels][] and talking a bit about where we
currently see them as usefully being deployed.

[unikernels]: http://unikernel.org/

Specifically, [Operability.io 2016][oio] a couple of weeks ago was enlightening
about some of the problems faced in operating production systems. Some great
audience questions and follow-ups after the talk, including some who were even
wondering when we'll see unikernels as ready for the desktop! Of course, with
the release of the [Docker for Mac][d4m] and [Docker for Windows][dfw] products,
it's arguable that we've beaten Linux to that accolade, as both products make
extensive use of [MirageOS][] unikernel libraries. Having said that, I was
pleased to be told that the message about unikernels having a range of
deployment scenarios, and particularly partial deployments into micro-service
environments made sense to many who came to speak to me afterwards.

[d4m]: https://docker.com/...
[d4w]: https://docker.com/...
[mirageos]: https://mirage.io
[oio]: https://operability.io/

This was followed by a slightly expanded version of that talk earlier today at
the [Devox Belgium][devoxx] conference. [Devoxx][] is primarily a Java community
so I was interested to see how the talk would go down given that [MirageOS][] is
staunchly OCaml-centric, and the [unikernels][] movement in general is language
specific and (at least until now) somewhat weighted toward functional
programming, our good friends at [IncludeOS][] notwithstanding.

[devoxx]: https://devoxx.be/
[includeos]: https://includeos.org/
