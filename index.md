---
title: home
layout: default
---

<div class="magellan-container" data-magellan-expedition="fixed">
  <dl class="sub-nav">
    <dd data-magellan-arrival="top"><a href="#top">top</a></dd>
  </dl>
</div>

<h1 data-magellan-destination="top" id="top">mythography</h1>

<ul class="plain">
  {% for post in site.posts %}
  <li class="clearfix">
    <div class="date">
      <div class="month">{{ post.date | date:"%b" }}</div>
      <div class="day">{{ post.date | date:"%d" }}</div>
      <div class="year">{{ post.date | date:"%Y" }}</div>
    </div>
    <h4>
      <a href="{{ post.url }}">{{ post.title }}</a><br />
      {{ post.subtitle }}
    </h4>
  </li>
  {% endfor %}
</ul>
