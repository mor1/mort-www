###
# 
# Copyright (C) 2013 Richard Mortier <mort@cantab.net>.
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published by
# the Free Software Foundation
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA.
# 
###

self = exports ? this

_promises = []
_data = null

## rendering helpers
wrap = (tag, s, {cl, id, colspan}) ->
  cl = if cl? then "class='#{cl}'" else ""
  id = if id? then "id='#{id}'" else ""
  colspan = if colspan? then "colspan='#{colspan}'" else ""
  "<#{tag} #{id} #{cl} #{colspan}>#{s}</#{tag}>"

div = (o, s) -> wrap "div", s, o
span = (o, s) -> wrap "span", s, o
ul = (o, lis) -> wrap "ul", lis, o
li = (o, s) -> wrap "li", s, o
p = (o, s) -> wrap "p", s, o

table = (o, s) -> wrap "table", s, o
tbody = (o, s) -> wrap "tbody", s, o
thead = (o, s) -> wrap "thead", s, o
th = (o, s) -> wrap "th", s, o
tr = (o, s) -> wrap "tr", s, o
td = (o, s) -> wrap "td", s, o

hd = (n, o, s) -> wrap "h#{n}", s, o

link = (s, u) -> """<a href="#{u}">#{s}</a>"""
tab = (s, u) -> """<a href="#{u}" data-toggle="tab">#{s}</a>"""

## increase legibility
abbrev = (s) -> s
  .replace(/Bachelor of Science/i, "BSc")
  .replace(/Master in Science/i, "MSc")
  .replace(/with (Joint )*Honours/i, "(Hons)<br />")

## take a set of triples and render to tabbed panes
tabbed = (content...) ->
  tabs = (content.map ([title, label, content]) ->
    if content?
      li {},
        (tab "#{title}", "##{label}")).join("\n")
  panes = (content.map ([title, label, content]) ->
    if content?
      div {cl:"tab-pane fade", id:label},
        content
    ).join("\n")
  
  div {cl:"tabbable tabs"}, 
    (ul {cl:"nav nav-tabs"}, tabs) \
    + (div {cl:"tab-content"}, panes)

module = (m) ->
  code = if m.url? and m.url.length > 0 then link m.code, m.url else m.code
  tr {},
    (td {},
      "#{code}<br />(<em>#{m.credits}&nbsp;credits</em>)") +
    (td {},
      "#{m.title}")

part = (pt) ->
  if (pt.c.length == 0 && pt.o.length == 0)
    ""
  else
    table {cl:"table"},
      (tbody {},
        (table {cl:"table table-striped span6"},
          (thead {},
            (tr {},
              (th {colspan: 2},
                (p {cl:"text-center"}, "compulsory")))) \
          +
          (tbody {},        
            """#{(pt.c.map ((m) -> (module m))).join("")}""")) \
        +
        (table {cl:"table table-striped span5"},
          (thead {},
            (tr {},
              (th {colspan: 2},
                (p {cl:"text-center"}, "optional")))) \
          +
          (tbody {},        
            """#{(pt.o.map ((m) -> (module m))).join("")}"""))
      )

is_4yearug = (c) ->
  c?.modules.part_iii.o.length != 0 || c?.modules.part_iii.c.length != 0
       
courses = 
  fetch: (url) ->
    _promises.push $.Deferred (promise) -> 
      $.getJSON url, (data) ->
        _data = data
        promise.resolve()
    @
 
  render: (tgt) ->
    $.when.apply(null, _promises).then =>
      $(tgt).html('')
      for course in _data
        code = course.code

        title = p {cl: "lead"},
          (link (abbrev course.title), course.url) \
          +
          "<br />" \
          +
          (p {cl:"muted"},
            """#{course.type}, #{course.mode}""")
        title = title.replace(/MSc/, "MSci") if is_4yearug course
        aims = div "aims", course.aims.replace(/|/g, "")

        modules = (ms) ->
          if ms.o.length > 0 || ms.c.length > 0
            div {cl:"row-fluid"},
              (div {cl:"span12"},
                "#{part ms}")
        
        $(tgt).append div {cl:"course"},
          "<hr />" +
          div {cl:"row-fluid"},
            (div {cl:"span3"}, title) +
            (div {cl:"span9"},
              (tabbed [ "aims", "#{code}-aims", aims ],
                [ "year 1", "#{code}-1-modules",
                  modules course.modules.part_q ],
                [ "year 2", "#{code}-2-modules",
                  modules course.modules.part_i ],
                [ "year 3", "#{code}-3-modules",
                  modules course.modules.part_ii ],
                [ "year 4", "#{code}-4-modules",
                  modules course.modules.part_iii ]               
              )
            )
          course.code
    @

self.courses = courses
