---
layout: plain
stylesheet: [courses]
title: programmes, 2013/14
js: [courses]
---

# Taught Programmes<br /><small>School of Computer Science</small>

+-- {.lead .span10 .offset1} 
This page collates course specifications for the various [undergraduate](./ugt.html) and [postgraduate](./pgt.html) programmes of study offered by the School of Computer Science during 2013/14. _It is indicative only, and should **not** be treated as definitive_. More detailed information about specific courses or modules can be found by clicking on the appropriate link. 

Note that:
+ all single honours BSc programmes _except joint honours Computer Science and Management Studies (GN42)_ currently have a common year 1 (G400, G4G7, G601); and
+ the single honours MSci programmes (G404, G4G1) follow the same course structures as their respective BSc programmes (G400, G4G7) for years 1 & 2.

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
        </tr>
        <tr>
          <td><span class="badge purple">PR</span></td>
          <td>Programming</td>
          <td><span class="badge orange">NCC</span></td>
          <td>Net-Centric Computing</td>
        </tr>
        <tr>
          <td><span class="badge green">AI</span></td>
          <td>Artificial Intelligence</td>
          <td><span class="badge pink">HCI</span></td>
          <td>Human-Computer Interaction</td>
        </tr>
        <tr>
          <td><span class="badge brown">PJ</span></td>
          <td>Projects</td>
          <td><span class="badge teal">OSA</span></td>
          <td>Operating Systems &amp; Architecture</td>
       </tr>
        <tr>
          <td><span class="badge grey">MO</span></td>
          <td colspan="3">Modelling &amp; Optimisation</td>
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
    window.courses.fetch('./courses.json').render("#courses");
  });
</script>
