---
title: index
layout: default
---

<div class="magellan-container" data-magellan-expedition="fixed">
  <dl class="sub-nav">
    <dd data-magellan-arrival="top"><a href="#top">top</a></dd>
  </dl>
</div>

<h1 data-magellan-destination="top" id="top">some myths</h1>

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      {{ post.excerpt | strip_html }}
    </li>
  {% endfor %}
</ul>
