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

wrap = (tag, s, cl, id) ->
  cl = if cl? then "class='#{cl}'" else ""
  id = if id? then "id='#{id}'" else ""
  "<#{tag} #{id} #{cl}>#{s}</#{tag}>"

div = (cl, s, id) -> wrap "div", s, cl, id
span = (cl, s) -> wrap "span", s, cl
ul = (cl, lis) -> wrap "ul", lis, cl
li = (s) -> wrap "li", s
hd = (n, s) -> wrap "h#{n}", s

link = (s, u) -> """<a href="#{u}">#{s}</a>"""
tab = (s, u) -> """<a href="#{u}" data-toggle="tab">#{s}</a>"""

abbrev = (s) -> s
  .replace(/Bachelor of Science/i, "BSc")
  .replace(/Master in Science/i, "MSc")
  .replace(/with (Joint )*Honours/i, "(Hons)<br />")
  
tabbed = (content...) ->
  tabs = (content.map ([title, label, _unused]) ->
      li (tab "#{title}", "##{label}")).join("\n")
  panes = (content.map ([title, label, content]) ->
      div "tab-pane fade", content, label).join("\n")
  
  div "tabbable tabs", 
    (ul "nav nav-tabs", tabs) +
    (div "tab-content", panes)

module = (m) ->
  code = if m.url? and m.url.length > 0 then link m.code, m.url else m.code
    
  """
  <tr>
    <td>
      #{code}<br />(<em>#{m.credits}&nbsp;credits</em>)
    </td>
    <td>#{m.title}</td>
  </tr>"""

part = (t, p) ->
  if (p.c.length == 0 && p.o.length == 0)
    ""
  else
    """
    <table class="table">
      <thead><tr>
          <th colspan="2"><p>#{t}</p></th>
      </tr></thead>
      <tbody>
        <table class="table table-striped span6">
          <thead><tr><th colspan="2"><p class="text-center">compulsory</p></th></tr></thead>
          <tbody>#{(p.c.map ((m) -> (module m))).join("")}</tbody>
        </table>
        <table class="table table-striped span5">
          <thead><tr><th colspan="2"><p class="text-center">optional</p></th></tr></thead>
          <tbody>#{(p.o.map ((m) -> (module m))).join("")}</tbody>
        </table>
      </tbody>
    </table>
    """

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

        title = """
        <p class="lead">
          #{link (abbrev course.title), course.url}
          <br />
          <p class="muted">#{course.type}, #{course.mode}</p>
        </p>
        """
        aims = div "aims", course.aims.replace(/|/g, "")

        modules = """
          <div class="row-fluid"><div class="span12">
            #{part "Year 1", course.modules.part_q}
            #{part "Year 2", course.modules.part_i}
            #{part "Year 3", course.modules.part_ii}
            #{part "Year 4", course.modules.part_iii}
          </div></div>
        """
        
        $(tgt).append div "course",
          "<hr />" +
          div "row-fluid",
            (div "span3", title) +
            (div "span9",
              (tabbed ["aims", "#{code}-aims", aims],
                ["modules", "#{code}-modules", modules])
            )
          course.code
    @

self.courses = courses
