# Mort's Web Pages

[![Build Status](https://travis-ci.org/mor1/mort-www.png?branch=master)](https://travis-ci.org/mor1/mort-www)

Built as a [Mirage][] appliance.

[mirage]: http://openmirage.org/

## Dependencies

    $ sudo apt-get install coffeescript

    $ cd mirage && opam pin mirage .
    $ cd ocaml-fat && opam pin fat-filesystem .
    $ opam install mirage fat-filesystem


## Targets

Invoke Jekyll to build the static site:

    $ make site

Invoke [Mirage][] to configure using local stacks during development:

    $ make configure

Alternatively, invoke [Mirage][] to configure for UNIX using Mirage stacks:

    $ FS=crunch NET=direct make configure

Finally, invoke [Mirage][] to configure to build for Xen:

    $ MODE=xen make configure

In all cases, having configured the unikernel, build it:

    $ make build

And finally, run it (unless on Xen):

    $ sudo ./_mirage/mir-mortio


# Notes

gem install travis
opam install travis-senv
[[ run travis to stop it whining about installing cli completion or not ]]
generate passwordless keypair

ssh-keygen -b 4096 -f ~/.ssh/mor1-www-key

travis-senv encrypt ~/.ssh/mor1-www-key travis-ssh-envs

cat travis-ssh-envs | travis encrypt -ps --add

## VirtualBox Development Environment

manual:

vbox -- create linux 64bit vm -- attach netboot iso (debian 7.4.0) -- boot --
install

homebrew/vagrant:

use-rvm

gem install veewee

git clone ...vagrant-vms && cd vagrant-vms
mv ~/Desktop/debian-7.4.0-amd64-netinst.iso ./iso

veewee vbox build 'debian-7.4.0-xen'
veewee vbox export 'debian-7.4.0-xen'

mv *.box boxes

vagrant box add debian-7.4.0 boxes/debian-7.4.0.box
vagrant box add 'debian-7.4.0-xen'
'/Users/mort/research/projects/mirage/src/vagrant-vms/boxes/debian-7.4.0-xen.box'


vagrant init 'debian-7.4.0-xen'
vagrant up
vagrant ssh


sudo apt-get install -y build-essential m4 ocaml ocaml-native-compilers git
camlp4-extra aspcud


wget
https://github.com/ocaml/opam/releases/download/1.1.1/opam-full-1.1.1.tar.gz
tar xzvf opam-full-1.1.1.tar.gz

cd opam-full-1.1.1 && ./configure && make && make install

opam init
opam switch 4.01.0


## TODO

+ return pages with headers permitting caching
+ add hcard/vcard markup per <http://indiewebcamp.com/Getting_Started>
+ add rel=me links to github, twitter per <http://indiewebcamp.com/Getting_Started>

## github pdf hosting

http://webapps.stackexchange.com/questions/48061/can-i-trick-github-into-displaying-the-pdf-in-the-browser-instead-of-downloading

looks like mor1.github.{io,com} overlay each other with .io taking precedence?!
