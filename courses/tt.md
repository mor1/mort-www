---
layout: plain
stylesheet: [courses]
title: timetable, 2012/13
js: [tt]
---

# Module Timetable<br /><small>School of Computer Science</small>


<div id="tt">
  Loading...
</div>


<script type="text/javascript">
  $(window).load(function () {
    window.tt.fetch('../tt.json').render("#tt");
  });
</script>
