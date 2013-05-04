---
layout: plain
stylesheet: [courses]
title: programmes, 2013/14
js: [courses]
---

+-- {.lead} 
This page collates course specifications for the various programmes of study offered by the School of Computer Science during 2013/14. _It is indicative only, and should **not** be treated as definitive_. More detailed information about specific courses or modules can be found by clicking on the appropriate link. 
=--

<div id="courses">
  Loading...
</div>


<script type="text/javascript">
  $(window).load(function () {
    window.courses.fetch('./courses.json').render("#courses");
  });
</script>
