---
title: Moving Onto Mirage
subtitle: Git Your Unikernel Here!
layout: post
category: blog
---

For a little while I've had this site running as a [MirageOS][] unikernel,
shadowing the main site hosted on [GitHub][]. I've finally decided to make the
switch, as part of moving over to take advantage of Mirage's DNS and TLS
libraries.

[MirageOS]: http://openmirage.org/
[Github]: http://github.com/
[Jekyll]: http://jekyllrb.com

Following the usual pattern, as previously explained by [Amir][], [Mindy][] and
others, the process is:

[Amir]: http://amirchaudhry.com/from-jekyll-to-unikernel-in-fifty-lines/
[Mindy]: http://www.somerandomidiot.com/blog/2014/08/19/i-am-unikernel/

+ Construct a static [Jekyll][] site.
+ Write a [Travis][] YAML file to cause [Travis][] to build the unikernel image
  and commit it back to the deployment repository.
+ Write a Git `post-merge` hook for the deployment repository, so that the
  latest unikernel is automatically booted when a merge is detected, i.e., there
  is a new unikernel image.
+ Write a `cron` job that periodically polls the deployment repository, pulling
  any changes.

Building a [Jekyll][] site is well-documented -- I did find that I had to tweak
my [`_config.yml`][jekyll-yml] so as to make sure my local toolchain matched the
one used by Github, ensuring consistency between versions of the site. For
convenience:

{% highlight bash %}
make site
{% endhighlight %}


## Bringing up the network

The [`.travis.yml`][travis-yml] file then specifies the three main targets for
the CI test build to carry out: Unix with a standard sockets backed
(`MIRAGE_BACKEND=unix`, `MIRAGE_NET=socket`) and with the Mirage network stack
(`MIRAGE_BACKEND=unix`, `MIRAGE_NET=direct`), and with the Xen backend
(`MIRAGE_BACKEND=xen`). For the latter case, we must also specify the static IP
configuration to be used (`MIRAGE_ADDR`, `..._GWS`, and `..._MASK`). The
[`.travis.sh`][travis-sh] script then calls the standard skeleton
[`.travis-mirage.sh`][travis-mirage] script after first building the site
content using Jekyll.

[jekyll-yml]: https://github.com/mor1/mor1.github.io/blob/master/_config.yml
[travis-yml]: https://github.com/mor1/mor1.github.io/blob/master/.travis.yml
[travis]: http://travis-ci.com/
[travis-sh]: https://github.com/mor1/mor1.github.io/blob/master/.travis.sh
[travis-mirage]: https://github.com/ocaml/ocaml-travisci-skeleton/blob/master/.travis-mirage.sh

This tests the three basic combinations of network backend for a Mirage
appliance:

{% highlight bash %}
$ make configure.socket build
{% endhighlight %}
+ __UNIX/socket__ requires no configuration. The network device is configured
  with the loopback address, `127.0.0.1`. Appliances can be run without
  requiring `root` privileges, assuming they only bind to non-privileged ports.

{% highlight bash %}
$ make configure.direct build
{% endhighlight %}
+ __UNIX/direct/dhcp__ requires no configuration if a DHCP server is running and
  can respond. The appliance must be run with `root` privileges to use the new
  network bridging capability of OSX 10.10, whereupon the DHCP client in the
  appliance follows the usual protocol.

{% highlight bash %}
$ make configure.xen build \
  ADDR="46.43.42.137" GWS="46.43.42.129" MASK="255.255.255.128"
{% endhighlight %}
+ __Xen__ uses the Mirage network stack and expects static configuration of the
  network device.
