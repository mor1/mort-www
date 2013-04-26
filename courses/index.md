---
layout: plain
stylesheet: [bootstrap,courses]
title: programmes
js: [courses]
---

This page collates the course specifications for the various degree programmes run by the School of Computer Science. _It is provided for guidance only, and should **not** be treated as definitive_.


<div id="courses">
Loading...
</div>


<script type="text/javascript">
  $(window).load(function () {
    window.courses.fetch('./courses.json').render("#courses");
  });
</script>
