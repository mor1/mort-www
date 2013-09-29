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

reqs =
  matrix: (tgt) ->
    margin = {top: 80, right: 0, bottom: 10, left: 80}
    width = height = 960
 
    x = d3.scale.ordinal().rangeBands([0, width], 0.1, 0)

    d3.select("#{tgt} > p").remove()
    
    svg = d3.select(tgt)
      .insert("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform", "translate(#{margin.left}, #{margin.top})")
      
    d3.json "../modules.json", (modules) ->
      matrix = []
      nodes = modules.modules
        .filter((v) -> v.school == "Computer Science")
        .sort((a,b) -> d3.ascending a.code, b.code)
      n = nodes.length
 
      x.domain(d3.range(n))
      unseen = {}
      d3.range(n).forEach (_, i) -> unseen[i] = 0 
      
      index = {}
      nodes.forEach (v, i) ->
        index[v.code] = i
        v.index = i
        matrix[i] = d3.range(n).map((j) -> {x: j, y: i, z: 0})

      nodes.forEach (v, i) ->
        v.coreqs.filter((v) -> v of index).forEach (o, j) ->          
          matrix[i][index[o]].z = 1
          delete unseen[i] if i of unseen
          delete unseen[index[o]] if index[o] of unseen
        v.prereqs.filter((v) -> v of index).forEach (o, j) ->
          matrix[i][index[o]].z = 2
          delete unseen[i] if i of unseen
          delete unseen[index[o]] if index[o] of unseen

      svg.append("rect")
        .attr("class", "background")
        .attr("width", width)
        .attr("height", height);

      row = svg.selectAll(".row")
          .data(matrix)
        .enter().append("g")
          .attr("class", "row")
          .attr("transform", (d, i) -> "translate(0,#{x(i)})")
          .each(
            (row) ->
              cell = d3.select(this).selectAll(".cell")
                .data(row.filter((d) -> d.z))
              .enter().append("rect")
                .attr("class", "cell")
                .attr("x", (d) -> x(d.x))
                .attr("width", x.rangeBand())
                .attr("height", x.rangeBand())
                .style("fill", (d) -> switch d.z
                  when 1 then "orange"
                  when 2 then "red")
                .on("mouseover", (p) ->
                  d3.selectAll(".row text")
                    .classed("active", (d, i) -> i == p.y)
                    .classed("inactive", (d, i) -> i != p.y)
                  d3.selectAll(".column text")
                    .classed("active", (d, i) -> i == p.x)
                    .classed("inactive", (d, i) -> i != p.x)
                  ) 
                .on("mouseout", () ->
                  d3.selectAll("text")
                    .classed("active", false)
                    .classed("inactive", false)
                  ))
                
      row.append("line")
        .attr("x2", width)

      row.append("text")
        .attr("x", -6)
        .attr("y", x.rangeBand() / 2)
        .attr("dy", ".32em")
        .attr("text-anchor", "end")
        .text((d, i) -> nodes[i].code)

      column = svg.selectAll(".column")
          .data(matrix)
        .enter().append("g")
          .attr("class", "column")
          .attr("transform", (d, i) -> "translate(#{x(i)})rotate(-90)")

      column.append("line")
        .attr("x1", -width);

      column.append("text")
        .attr("x", 6)
        .attr("y", x.rangeBand() / 2)
        .attr("dy", ".32em")
        .attr("text-anchor", "start")
        .text((d, i) -> nodes[i].code)


  # Hive: (tgt) ->
  #   diameter = 480
  #   radius = diameter/2
  #   innerRadius = radius-120

  #   cluster = d3.layout.cluster()
  #     .size([360, innerRadius])
  #     .sort(null)
  #     .value((d) -> d.size)

  #   bundle = d3.layout.bundle()

  #   line = d3.svg.line.radial()
  #     .interpolate("bundle")
  #     .tension(.1)
  #     .radius((d) -> d.y)
  #     .angle((d) -> d.x / 180 * Math.PI)

  #   svg = d3.select("body")
  #     .append("svg")
  #       .attr("width", diameter)
  #       .attr("height", diameter)
  #     .append("g")
  #       .attr("transform", "translate(#{radius}, #{radius})")

  #   packages = 
  #     root: (classes) ->
  #       map = {}

  #       find = (name, data) ->
  #         node = map[name]
  #         if (!node)
  #           node = map[name] = data || {name: name, children: []}
  #           if (name.length)
  #             i = name.lastIndexOf(".")
  #             node.parent = find(name.substring(0,i))
  #             node.parent.children.push(node)
  #             node.key = name.substring(i + 1)
  #         node

  #       classes.forEach (d) -> find(d.name, d)
  #       map[""]
      
  #     imports: (nodes) ->
  #       map = {}
  #       imports = []

  #       nodes.forEach (d) -> map[d.name] = d

  #       nodes.forEach (d) ->
  #         d.imports?.forEach (i) ->
  #           imports.push {source: map[d.name], target: map[i]}
  #           return
  #         return  
  #       imports

  #   d3.json "../modules.json", (error, classes) ->
  #     csms = classes.modules.filter (v) -> (v.school == "Computer Science)
      
  #     svg.selectAll(".link")
  #         .data(bundle(links))
  #       .enter().append("path")
  #         .attr("class", "link")
  #         .attr("d", line)

  #     svg.selectAll(".node")
  #         .data(nodes) #.filter((n) -> !n.children))
  #       .enter().append("g")
  #         .attr("class", "node")
  #         .attr("transform", (d) -> "rotate(#{d.x - 90})translate(#{d.y})")
  #       .append("text")
  #         .attr("dx", (d) -> d.x < 180 ? 8 : -8 )
  #         .attr("dy", ".31em")
  #         .attr("text-anchor", (d) -> d.x < 180 ? "start" : "end")
  #         .attr("transform", (d) -> d.x < 180 ? null : "rotate(180)")
  #         .text((d) -> d.key)
  #     return


      
  #   $(tgt).append (div {cl:"well well-small text-right"},
  #     (footer {},
  #       (small {cl:"muted"},
  #         (em {}, "Generated"
  #         ))))
      
  #   @

self.reqs = reqs
