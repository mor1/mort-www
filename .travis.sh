#
# Copyright (c) 2012--2015 Richard Mortier <mort@cantab.net>. All Rights
# Reserved.
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright
# notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

set -ex

## remove old ubuntu rubies
sudo apt-get -y remove ruby ruby1.8 ruby1.9.1
sudo apt-get -y autoremove

## use rvm and a modern-ish ruby
source ~/.rvm/scripts/rvm
rvm --default use 2.1

## check that worked
which ruby
ruby --version

## install jekyll and github-pages
gem install jekyll --no-rdoc --no-ri
gem install github-pages --no-rdoc --no-ri
jekyll -v

## build site
make site

## use forks if specified
fork_user=${FORK_USER:-ocaml}
fork_branch=${FORK_BRANCH:-master}
get () {
    wget https://raw.githubusercontent.com/${fork_user}/ocaml-travisci-skeleton/${fork_branch}/$@
}

## go!
get .travis-mirage.sh
sh  .travis-mirage.sh
