[![Build Status](https://travis-ci.org/mor1/mor1.github.io.png?branch=master)](https://travis-ci.org/mor1/mor1.github.io)

# Mort's Web Pages

Built as a [Mirage][] appliance, and deployed to <http://mort.io/>.

I now use [Docker](https://docker.com/) containers to avoid the need to install
dependencies: [Coffeescript][], [Jekyll][], [Python][]. OPAM and Mirage
currently still need to be installed on the host however. As a simple hack to
deal with access to my `.bib` files which are elsewhere on the host, I've
hardlinked them under `_papers`.

## Targets

`make site` will invoke the [Jekyll][] container to build the site to `_site`.

`make test` will invoke the [Jekyll][] container to run the site locally for
testing.

`make configure` will invoke [Mirage][] to configure the unikernel, defaulting
to building for UNIX using the Sockets API. Alternatives include:

+ `configure.xen`, build for Xen
+ `configure.socket`, UNIX/Sockets
+ `configure.direct`, UNIX/Mirage network stack

Then `make build` to build the unikernel.

[jekyll]: http://jekyllrb.com/
[coffeescript]: http://coffeescript.org/
[mirage]: https://mirage.io/
[python]: http://python.org/

## Deployment Setup

Use Travis to build the unikernel and push it back to
a [deployment repo](https://github.com/mor1/mor1.githu.io-deployment/):

```
gem install travis
opam install travis-senv
[[ run travis to stop it whining about installing cli completion or not ]]
ssh-keygen -b 4096 -f ~/.ssh/mor1-www-key
travis-senv encrypt ~/.ssh/mor1-www-key travis-ssh-envs
cat travis-ssh-envs | travis encrypt -ps --add
```

Then take the result and past it into the `_travis.yml`
per
[this site](https://github.com/mor1/mor1.github.io/blob/master/.travis.yml#L28-L40).

# TODO

+ return pages with headers permitting caching
+ add hcard/vcard markup per <http://indiewebcamp.com/Getting_Started>
+ add rel=me links to github, twitter per <http://indiewebcamp.com/Getting_Started>

## github pdf hosting

http://webapps.stackexchange.com/questions/48061/can-i-trick-github-into-displaying-the-pdf-in-the-browser-instead-of-downloading

looks like mor1.github.{io,com} overlay each other with .io taking precedence?!
