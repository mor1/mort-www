---
layout: plain
stylesheet: [courses]
title: programmes, 2013/14
js: [courses]
---

+-- {.lead .span10 .offset1} 
This page collates course specifications for the various Postgraduate Taught Programmes of study offered by the School of Computer Science during 2013/14. _It is indicative only, and should **not** be treated as definitive_. More detailed information about specific courses or modules can be found by clicking on the appropriate link. 
=--

<div class="offset1 span10">
  <small class="muted">
    <table class="table table-condensed table-striped">
      <caption class="lead">
        <strong>
          Key to Computer Science Teaching Themes
        </strong>
      </caption>
      <tbody>
        <tr>
          <td><span class="badge red">SE</span></td>
          <td>Software Engineering</td>
          <td><span class="badge blue">FCS</span></td>
          <td>Foundations of Computer Science</td>
          <td><span class="badge teal">OSA</span></td>
          <td>Operating Systems &amp; Architecture</td>
        </tr>
        <tr>
          <td><span class="badge purple">P</span></td>
          <td>Programming</td>
          <td><span class="badge orange">NCC</span></td>
          <td>Net-Centric Computing</td>
          <td><span class="badge green">AI</span></td>
          <td>Artificial Intelligence</td>
        </tr>
        <tr>
          <td><span class="badge pink">HCI</span></td>
          <td>Human-Computer Interaction</td>
          <td><span class="badge grey">MO</span></td>
          <td>Modelling &amp; Optimisation</td>
          <td><span class="badge lightblue">GV</span></td>
          <td>Graphics &amp; Vision</td>
        </tr>
      </tbody>
    </table>
  </small>
</div>


<div class="clearfix"> </div>


<div id="courses">
  Loading...
</div>


<script type="text/javascript">
  $(window).load(function () {
    window.courses.fetch('./pgt.json').render("#courses");
  });
</script>
