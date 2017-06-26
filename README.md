[![Build Status](https://travis-ci.org/mor1/mor1.github.io.png?branch=master)](https://travis-ci.org/mor1/mor1.github.io)

# Mort's Web Pages

I use [Docker](https://docker.com/) containers to avoid the need to install
dependencies: [Coffeescript][], [Jekyll][], [Python][]. OPAM and Mirage
currently still need to be installed on the host however. As a simple hack to
deal with access to my `.bib` files which are elsewhere on the host, I've
hardlinked them under `_papers` but `git` ignore that directory. Pushing
triggers a Travis build of my JavaScript papers renderer from CoffeeScript
input.

## Targets

Site build and test is done via [Jekyll]:

  * `make site` invokes the [Jekyll] container to build the site to `_site`
  * `make test` invokes the [Jekyll] container to run the site locally for
    testing
  * `make drafts` will do as `make test` but also display draft posts

The site is deployed as a [Mirage] unikernel at <http://mort.io>. Building the
unikernel version uses my [`dommage` scripts][dommage] and can be performed via:

  * `make configure FLAGS=...` to configure the unikernel and install
    dependencies
  * `make build` to build the unikernel

Finally, there are some helper targets to assist in managing the build
containers:

  * `make publish` to commit the current build container state and publish;
    unless you have write access to my [Docker Hub][hub] org, you will need to
    edit the Makefile to issue this
  * `make destroy` kills the current build container but leaves the dependency
    on the same image
  * `make run` to invokve the target unikernel from inside the build container

[jekyll]: http://jekyllrb.com/
[coffeescript]: http://coffeescript.org/
[mirage]: https://mirage.io/
[python]: http://python.org/
[dommage]: https://github.com/mor1/dommage

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

Then take the result and paste it into your `_travis.yml`
per
[this site](https://github.com/mor1/mor1.github.io/blob/master/.travis.yml#L37-L49).

# TODO

+ Return pages with headers permitting caching
+ Add hcard/vcard markup per <http://indiewebcamp.com/Getting_Started>
+ Add rel=me links to github, twitter
  per <http://indiewebcamp.com/Getting_Started>

## github pdf hosting

http://webapps.stackexchange.com/questions/48061/can-i-trick-github-into-displaying-the-pdf-in-the-browser-instead-of-downloading

looks like mor1.github.{io,com} overlay each other with .io taking precedence?!
