---
layout: default
section: papers
title: papers
parent: mort
js: [jquery.tmpl, papers]
---

[Visit my github BibTeX repo][r] for up-to-date citation details.
[Contact me][e] if you have any problems obtaining any of these. 

[r]: http://github.com/mor1/rmm-bibs
[e]: mailto:richard.mortier@nottingham.ac.uk

+--

Publications
============

=--

<div id="entries">
Loading...
</div>

<script type="text/javascript">
$(document).ready(function () {
    var au = SITE_ROOT+"research/papers/authors.json";
    var pu = SITE_ROOT+"research/papers/papers.json";
    papers.fetch(au, pu).render("#entries")
});
</script>

