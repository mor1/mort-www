---
layout: plain
stylesheet: [courses]
title: timetable, 2013/14
js: [tt]
---

# Module Timetable<br /><small>School of Computer Science</small>

+-- {.lead .span10 .offset1}

Simple collation of timetable entries for CS modules. Not definitive -- consult the University Timetable for definitive details.

[Please contact me](mailto:richard.mortier@nottingham.ac.uk) with any queries.

=--

<div id="tt">
  Loading...
</div>


<script type="text/javascript">
  $(window).load(function () {
    window.tt.fetch('../modules.json').render("#tt");
  });
</script>
