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

String::upcase = -> @toUpperCase()

_promises = []
_data = null

## rendering helpers
wrap = (tag, s, {cl, id, colspan, literal}) ->
  cl = if cl? then "class='#{cl}'" else ""
  id = if id? then "id='#{id}'" else ""
  colspan = if colspan? then "colspan='#{colspan}'" else ""
  literal = if literal? then literal else ""
  "<#{tag} #{id} #{cl} #{colspan} #{literal}>#{s}</#{tag}>"

div = (o, s) -> wrap "div", s, o
span = (o, s) -> wrap "span", s, o
ul = (o, lis) -> wrap "ul", lis, o
li = (o, s) -> wrap "li", s, o
p = (o, s) -> wrap "p", s, o
small = (o, s) -> wrap "small", s, o
button = (o, s) -> wrap "button", s, o
em = (o, s) -> wrap "em", s, o

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
  .replace(/Master (in|of) Science/i, "MSc")
  .replace(/with (Joint )*Honours/i, "(Hons)")

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
  colour = switch m.theme
    when "SE" then "red"
    when "FCS" then "blue"
    when "OSA" then "teal"
    when "P" then "purple"
    when "NCC" then "orange"
    when "AI" then "green"
    when "HCI" then "pink"
    when "MO" then "grey"
    when "GV" then "lightblue"
    when "IS" then "brown"
    else ""

  badge = if m.theme? then small {},
      (span {cl:"badge #{colour}", literal:'style="letter-spacing:1px"'},
        "#{m.theme}")
    else ""
  (tr {},
    (td {}, "#{code}<br />#{badge}") +
    (td {colspan: 2},
      "#{m.title}<br />"+
      (small {cl:"muted pull-right"},
        (em {}, "#{m.taught}, #{m.credits}&nbsp;credits"))
    )
  ) 
  
part = (pt) ->
  cmp = (x,y) ->
    switch
      when x.taught == y.taught then 0
      
      when x.taught == "Full Year" then -1
      when y.taught == "Full Year" then 1

      when x.taught == "Autumn" then -1
      when y.taught == "Autumn" then 1
      
      when x.taught == "Spring" then -1
      when y.taught == "Spring" then 1
      
      when x.taught == "Summer" then -1
      when y.taught == "Summer" then 1

      else 0
      
  if (pt.c.length == 0 && pt.o.length == 0 && pt.a.length == 0)
    ""
  else
    (div {cl:"row-fluid span12"},
        (if pt.c.length == 0 then "" else
          (table {cl:"table table-striped table-condensed span4"},
            (thead {},
              (tr {},
                (th {colspan: 3},
                  (p {cl:"text-center"}, "compulsory")))) +
            (tbody {},        
               """#{(pt.c.sort(cmp).map ((m) -> (module m))).join("")}"""))) +
        (if pt.o.length == 0 then "" else
          (table {cl:"table table-striped table-condensed span4"},
            (thead {},
              (tr {},
                (th {colspan: 3},
                  (p {cl:"text-center"}, "optional")))) +
            (tbody {},        
              """#{(pt.o.sort(cmp).map ((m) -> (module m))).join("")}"""))) +
        (if pt.a.length == 0 then "" else
          (table {cl:"table table-striped table-condensed span4"},
            (thead {},
              (tr {},
                (th {colspan: 3},
                  (p {cl:"text-center"}, "alternative")))) +
            (tbody {},        
              """#{(pt.a.sort(cmp).map ((m) -> (module m))).join("")}""")))
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
        code = course.code.upcase()

        title = hd 4, {},
          (button {
             class:"btn btn-small badge-info",
             literal:
               """style="margin-right:1.5em;" type="button",
              data-toggle="collapse", data-target="##{code}" """
             },
             "+"
          ) +
          """#{code}, #{link (abbrev course.title), course.url} """ +
          small {cl:"muted"},
            """#{course.type}, #{course.mode}"""
          
        title = title.replace(/MSc/, "MSci") if is_4yearug course
        aims = div "aims", course.aims.replace(/|/g, "")

        modules = (ms) ->
          if ms.o.length > 0 || ms.c.length > 0
            div {cl:"row-fluid"},
              "#{part ms}"

        $(tgt).append div {cl:"row-fluid"},
            (div {cl:"span11 offset1"},
              (title +
              (div {cl:"collapse", id:"#{code}"},
                (tabbed [ "aims", "#{code}-aims", aims ],
                  [ "year 1", "#{code}-1-modules",
                    modules course.modules.part_q ],
                  [ "year 2", "#{code}-2-modules",
                    modules course.modules.part_i ],
                  [ "year 3", "#{code}-3-modules",
                    modules course.modules.part_ii ],
                  [ "year 4", "#{code}-4-modules",
                    modules course.modules.part_iii ]               
                  [ "modules", "#{code}-pg-modules",
                    modules course.modules.part_pg ]               
                )))
            )
    @

self.courses = courses
