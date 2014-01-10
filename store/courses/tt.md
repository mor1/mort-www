# Module Timetable<br /><small>School of Computer Science</small>

<div media:type="text/omd" class="lead span10 offset1">

Simple collation of timetable entries for CS modules. Not definitive -- consult the University Timetable for definitive details.

[Please contact me](mailto:richard.mortier@nottingham.ac.uk) with any queries.

</div>

<div class="clearfix"> </div>

<div id="tt">
  Loading...
</div>

<script src="/courses/js/jquery-1.9.1.min.js"> </script>
<script type="text/javascript">
  // <![CDATA[
    $(window).load(function () {
      window.tt.fetch('/courses/data/modules.json').render('#tt');
    });
  // ]]>
</script>
