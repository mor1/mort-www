---
layout: default
section: admin
title: programmes
parent: mort
js: [courses]
---

This page collates the course specifications for the various degree programmes run by the School of Computer Science. _It is provided for guidance only, and should **not** be treated as definitive_.

[Contact me][e] with any questions.

[e]: mailto:richard.mortier@nottingham.ac.uk


<div id="courses">
Loading...
</div>

<script type="text/javascript">
$(window).load(function () {
    var u = SITE_ROOT+"courses/courses.json";
    alert("hello!");
    window.fetch(u).render("#courses");
});
</script>

