## And... _relax_!

To celebrate the release of [Mirage 1.0][mirage], and frankly because it was simply time anyway, I've reworked my website. What do you think?

For the curious, or the technically inclined, the site now uses [ZURB Foundation][foundation] 5.0.2 (as the current downloadable release as of yesterday), with some slightly -- and, going forward, probably increasingly -- customised CSS. The site itself is largely written in [Markdown][markdown] which is parsed by the OCaml [OMD][omd] parser. The fun bit is that all that is crunched into a [Mirage KV_RO][mirage-types] filesystem which is then compiled into a type-safe, self-contained web appliance that serves these pages and no other using the OCaml [Cowabloga][], [COW][] and [CoHTTP][] libraries. And is either running as a [POSIX binary][mirage-unix] or a self-contained [Xen VM][mirage-xen] depending on how I'm feeling. Neat eh?

(And for the sceptical among you, yes, a thing _can_ be neat and yet appear curiously over-engineered at the same time... :)

Improvements I'll be making over the next few weeks include adding commenting support, improving navigation, and richer support for the data pages ([papers](/papers) and [courses](/courses)).

[foundation]: http://foundation.zurb.com/
[markdown]: http://daringfireball.net/projects/markdown/

[omd]: https://github.com/pw347/omd
[cow]: https://github.com/mirage/ocaml-cow
[cowabloga]: https://github.com/mirage/cowabloga
[cohttp]: https://github.com/mirage/ocaml-cohttp

[mirage]: http://openmirage.org/
[mirage-types]: https://github.com/mirage/mirage-types
[mirage-unix]: https://github.com/mirage/mirage-platform/tree/master/unix
[mirage-xen]: https://github.com/mirage/mirage-platform/tree/master/xen
