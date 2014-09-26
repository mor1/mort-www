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
footer = (o, s) -> wrap "footer", s, o
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

themes = {
  # http://gamedev.stackexchange.com/questions/46463/is-there-an-optimum-set-of-colors-for-10-players
  SE: "red",        # FF0000
  FCS: "blue",      # 0000FF
  OSA: "teal",      # 008080
  PR: "purple",     # 800080
  NCC: "orange",    # FFA500
  AI: "green",      # 00FF00
  HCI: "pink",      # FAAFBE
  MO: "grey",       # 736F6E
  GV: "lightblue",  # ADD8E6
  PJ: "brown",      # A52A2A
  }

## increase legibility
abbrev = (s) ->
  s
  .replace(/Bachelor of Science/i, "BSc")
  .replace(/Master (in|of) Science/i, "MSc")
  .replace(/with (Joint )*Honours/i, "(Hons)")

## take a set of triples and render to tabbed panes
tabbed = (content...) ->
  tabs = ($.map(content, ([title, label, content]) ->
    if content?
      li {},
        (tab "#{title}", "##{label}")).join("\n"))
  panes = ($.map(content, ([title, label, content]) ->
    if content?
      div {cl:"tab-pane fade", id:label},
        content
    ).join("\n"))

  div {cl:"tabbable tabs"},
    (ul {cl:"nav nav-tabs"}, tabs) \
    + (div {cl:"tab-content"}, panes)

module = (m) ->
  code = if m.url? and m.url.length > 0 then link m.code, m.url else m.code
  colour = if themes[m.theme] then themes[m.theme] else ""

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
      when x.taught == y.taught
        if x.theme?
          if y.theme?
            x.theme.localeCompare y.theme
          else
            -1
        else
          if y.theme? then 1 else 0

      when x.taught == "Full Year" then -1
      when y.taught == "Full Year" then 1

      when x.taught == "Autumn" then -1
      when y.taught == "Autumn" then 1

      when x.taught == "Spring" then -1
      when y.taught == "Spring" then 1

      when x.taught == "Summer" then -1
      when y.taught == "Summer" then 1

      else x.theme.localeCompare y.attr

  if (pt.c.length == 0 && pt.o.length == 0 && pt.a.length == 0)
    ""
  else
    os = pt.o.concat(pt.a)
    (div {cl:"row-fluid span12"},
      (if pt.c.length == 0 then "" else
        (table {cl:"table table-striped table-condensed span6"},
          (thead {},
            (tr {},
              (th {colspan: 3},
                (p {cl:"text-center"}, "compulsory")))) +
          (tbody {},
            """#{($.map(pt.c.sort(cmp), ((m) -> module m)).join(""))}"""))) +
      (if pt.o.length == 0 then "" else
        (table {cl:"table table-striped table-condensed span6"},
          (thead {},
            (tr {},
              (th {colspan: 3},
                (p {cl:"text-center"}, "optional")))) +
          (tbody {},
            """#{($.map(os.sort(cmp), ((m) -> module m)).join(""))}""")))
    )

is_4yearug = (c) ->
  c?.modules.part_iii.o.length != 0 || c?.modules.part_iii.c.length != 0

theme_summary = (ms) ->
  summary = {
    C0: {t:0}, O0: {t:0},
    C1: {t:0}, O1: {t:0},
    C2: {t:0}, O2: {t:0},
    C3: {t:0}, O3: {t:0},
    C4: {t:0}, O4: {t:0},
  }

  for t of themes
    for k of summary
      summary[k][t] = 0

  for m in ms.part_q.c
    summary.C0[m.theme] += parseInt(m.credits, 10)
    summary.C0.t += parseInt(m.credits, 10)
  for m in ms.part_q.o
    summary.O0[m.theme] += parseInt(m.credits, 10)
    summary.O0.t += parseInt(m.credits, 10)
  for m in ms.part_q.a
    summary.O0[m.theme] += parseInt(m.credits, 10)
    summary.O0.t += parseInt(m.credits, 10)

  for m in ms.part_i.c
    summary.C1[m.theme] += parseInt(m.credits, 10)
    summary.C1.t += parseInt(m.credits, 10)
  for m in ms.part_i.o
    summary.O1[m.theme] += parseInt(m.credits, 10)
    summary.O1.t += parseInt(m.credits, 10)
  for m in ms.part_i.a
    summary.O1[m.theme] += parseInt(m.credits, 10)
    summary.O1.t += parseInt(m.credits, 10)

  for m in ms.part_ii.c
    summary.C2[m.theme] += parseInt(m.credits, 10)
    summary.C2.t += parseInt(m.credits, 10)
  for m in ms.part_ii.o
    summary.O2[m.theme] += parseInt(m.credits, 10)
    summary.O2.t += parseInt(m.credits, 10)
  for m in ms.part_ii.a
    summary.O2[m.theme] += parseInt(m.credits, 10)
    summary.O2.t += parseInt(m.credits, 10)

  for m in ms.part_iii.c
    summary.C3[m.theme] += parseInt(m.credits, 10)
    summary.C3.t += parseInt(m.credits, 10)
  for m in ms.part_iii.o
    summary.O3[m.theme] += parseInt(m.credits, 10)
    summary.O3.t += parseInt(m.credits, 10)
  for m in ms.part_iii.a
    summary.O3[m.theme] += parseInt(m.credits, 10)
    summary.O3.t += parseInt(m.credits, 10)

  for m in ms.part_pg.c
    summary.C4[m.theme] += parseInt(m.credits, 10)
    summary.C4.t += parseInt(m.credits, 10)
  for m in ms.part_pg.o
    summary.O4[m.theme] += parseInt(m.credits, 10)
    summary.O4.t += parseInt(m.credits, 10)
  for m in ms.part_pg.a
    summary.O4[m.theme] += parseInt(m.credits, 10)
    summary.O4.t += parseInt(m.credits, 10)

  format = (k, v) ->
    (span {cl:"badge #{themes[k]}", literal:'style="letter-spacing:1px"'},
      "#{k}: #{v}")

  (small {cl: "muted"},
    (table {cl: "table table-condensed table-striped"},
      (thead {}, "") +
      (tbody {},
        (tr {},
          (if summary.C0.t == 0 then "" else
            (td {}, "Year 1") +
            (td {}, "compulsory") +
            (td {},
              (format k, summary.C0[k] for k of themes when summary.C0[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.O0.t == 0 then "" else
            (td {}, "") +
            (td {}, "optional") +
            (td {},
              (format k, summary.O0[k] for k of themes when summary.O0[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.C1.t == 0 then "" else
            (td {}, "Year 2") +
            (td {}, "compulsory") +
            (td {},
              (format k, summary.C1[k] for k of themes when summary.C1[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.O1.t == 0 then "" else
            (td {}, "") +
            (td {}, "optional") +
            (td {},
              (format k, summary.O1[k] for k of themes when summary.O1[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.C2.t == 0 then "" else
            (td {}, "Year 3") +
            (td {}, "compulsory") +
            (td {},
              (format k, summary.C2[k] for k of themes when summary.C2[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.O2.t == 0 then "" else
            (td {}, "") +
            (td {}, "optional") +
            (td {},
              (format k, summary.O2[k] for k of themes when summary.O2[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.C3.t == 0 then "" else
            (td {}, "Year 4") +
            (td {}, "compulsory") +
            (td {},
              (format k, summary.C3[k] for k of themes when summary.C3[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.O3.t == 0 then "" else
            (td {}, "Year 4") +
            (td {}, "optional") +
            (td {},
              (format k, summary.O3[k] for k of themes when summary.O3[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.C4.t == 0 then "" else
            (td {}, "compulsory") +
            (td {},
              (format k, summary.C4[k] for k of themes when summary.C4[k] > 0).join(" ")
              ))) +
        (tr {},
          (if summary.O4.t == 0 then "" else
            (td {}, "optional") +
            (td {},
              (format k, summary.O4[k] for k of themes when summary.O4[k] > 0).join(" ")
              )))
      )))

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
      for course in _data.courses
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
        aims = div "aims",
          course.aims.replace(/|/g, "") +
          (theme_summary course.modules)

        modules = (ms) ->
          if ms.o.length > 0 || ms.c.length > 0
            div {cl:"row-fluid"},
              "#{part ms}"

        is_pg = (course.modules.part_pg.c.length +
          course.modules.part_pg.o.length +
          course.modules.part_pg.a.length > 0)

        if not is_pg
          kis_widget = """<iframe id="unistats-widget-frame"
            title="Unistats KIS Widget"
            src="http://widget.unistats.ac.uk/Widget/10007154/#{code}/vertical/Small/en-GB"
            scrolling="no"
            style="overflow: hidden; border: 0px none transparent; width: 190px; height: 500px;">
          </iframe>
          """

          kis_text = (hd 5, {}, "Key Information Sets (KIS)")+
            (p {},
              """
              KIS is an initiative that the government has introduced to allow
              you to compare different courses and universities.
              """) +
            (hd 5, {}, "How to use KIS data") +
            (p {},
              """
              We advise you consider KIS data alongside other factors,
              such as detailed course content, school or department reputation,
              study abroad opportunities, time spent in industry, available
              facilities to help you plan your career and the research interests
              of staff. Open days are an excellent opportunity to find out this
              information so come armed with questions when you visit.
              """)+
            (p {},
              """
              Graduate destinations and average starting salaries are collected
              six months after graduation. These don't take into account that
              some students travel after university, carry out voluntary work or
              study for a postgraduate degree. They also don't account for
              earning potential over the life-span of a career or show how
              quickly a graduate may have accelerated their salary from the
              initial starting point.
              """)

        $(tgt).append div {cl:"row-fluid"},
            (div {cl:"span10 offset1"},
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
                    modules course.modules.part_iii ],
                  [ "modules", "#{code}-pg-modules",
                    modules course.modules.part_pg ],
                  if not is_pg
                    [ "kis", "#{code}-kis",
                      (div {cl:"kis row-fluid span12"},
                        (div {cl:"kis-widget span5"}, kis_widget)+
                        (div {cl:"kis-text span7"}, kis_text)
                        ) ]
                  else [ "", "", "" ]
                )))
            )

      $(tgt).append (div {cl:"well well-small text-right"},
        (footer {},
          (small {cl:"muted"},
            (em {}, "Generated by #{_data.tool} on #{_data.date}."
            ))))

    @

self.courses = courses
