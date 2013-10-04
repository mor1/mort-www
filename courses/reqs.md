---
layout: plain
stylesheet: [courses]
title: inter-module requisites, 2013/14
js: [d3.v3.min, reqs]
ns: ['xmlns:xlink="http://www.w3.org/1999/xlink"']
---

<style>

.node {
  font: 6px sans-serif;
}

.link {
  stroke: steelblue;
  stroke-opacity: .4;
  fill: none;
}

.background {
  fill: #eee;
}

line {
  stroke: #fff;
}

text.active {
  font-weight: bold;
}

text.inactive {
  fill: #BBB;
}

body {
  font-size: 10px;
}

</style>


# Module Pre-/Co-requisites<br /><small>School of Computer Science</small>

+-- {.lead .span10 .offset1}

A simple visualisation of inter-module requisites for Computer Science. Entries should be read as "row depends-on column", with red squares indicating a pre-requisite dependency, and orange squares indicating a co-requisite dependency.

Not definitive -- consult the Module Catalogue entries for definitive details.

[Please contact me](mailto:richard.mortier@nottingham.ac.uk) with any queries.

=--

<div id="reqs">
  <p>Loading...</p>
</div>

<script type="text/javascript">
  $(window).load(function () {
    window.reqs.matrix("#reqs");
  });
</script>
