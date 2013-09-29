---
layout: plain
stylesheet: [courses]
title: programmes, 2013/14
js: [d3.v3.min, reqs]
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
  fill: red;
}

body {
  font-size: 10px;
}

</style>

<div id="reqs">
  <p>Loading...</p>
</div>

<script type="text/javascript">
  $(window).load(function () {
    window.reqs.matrix("#reqs");
  });
</script>
