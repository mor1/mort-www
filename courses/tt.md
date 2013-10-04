---
layout: plain
stylesheet: [courses]
title: timetable, 2013/14
js: [tt]
---

# Module Timetable<br /><small>School of Computer Science</small>


<div id="tt">
  Loading...
</div>


<script type="text/javascript">
  $(window).load(function () {
    window.tt.fetch('../modules.json').render("#tt");
  });
</script>
