// Generated by CoffeeScript 1.7.1

/*
 *
 * Copyright (C) 2013 Richard Mortier <mort@cantab.net>.
 * All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published by
 * the Free Software Foundation
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 */

(function() {
  var reqs, self;

  self = typeof exports !== "undefined" && exports !== null ? exports : this;

  reqs = {
    matrix: function(tgt) {
      var height, margin, svg, width, x;
      margin = {
        top: 80,
        right: 0,
        bottom: 10,
        left: 80
      };
      width = height = 960;
      x = d3.scale.ordinal().rangeBands([0, width], 0.1, 0);
      d3.select("" + tgt + " > p").remove();
      svg = d3.select(tgt).insert("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + ", " + margin.top + ")");
      return d3.json("/courses/data/modules.json", function(modules) {
        var column, index, matrix, n, nodes, row, unseen;
        matrix = [];
        nodes = modules.modules.filter(function(v) {
          return v.school === "Computer Science";
        }).sort(function(a, b) {
          return d3.ascending(a.code, b.code);
        });
        n = nodes.length;
        x.domain(d3.range(n));
        unseen = {};
        d3.range(n).forEach(function(_, i) {
          return unseen[i] = 0;
        });
        index = {};
        nodes.forEach(function(v, i) {
          index[v.code] = i;
          v.index = i;
          return matrix[i] = d3.range(n).map(function(j) {
            return {
              x: j,
              y: i,
              z: 0
            };
          });
        });
        nodes.forEach(function(v, i) {
          v.coreqs.filter(function(v) {
            return v in index;
          }).forEach(function(o, j) {
            matrix[i][index[o]].z = 1;
            if (i in unseen) {
              delete unseen[i];
            }
            if (index[o] in unseen) {
              return delete unseen[index[o]];
            }
          });
          return v.prereqs.filter(function(v) {
            return v in index;
          }).forEach(function(o, j) {
            matrix[i][index[o]].z = 2;
            if (i in unseen) {
              delete unseen[i];
            }
            if (index[o] in unseen) {
              return delete unseen[index[o]];
            }
          });
        });
        svg.append("rect").attr("class", "background").attr("width", width).attr("height", height);
        row = svg.selectAll(".row").data(matrix).enter().append("g").attr("class", "row").attr("transform", function(d, i) {
          return "translate(0," + (x(i)) + ")";
        }).each(function(row) {
          var cell;
          return cell = d3.select(this).selectAll(".cell").data(row.filter(function(d) {
            return d.z;
          })).enter().append("rect").attr("class", "cell").attr("x", function(d) {
            return x(d.x);
          }).attr("width", x.rangeBand()).attr("height", x.rangeBand()).style("fill", function(d) {
            switch (d.z) {
              case 1:
                return "orange";
              case 2:
                return "red";
            }
          }).on("mouseover", function(p) {
            d3.selectAll(".row text").classed("active", function(d, i) {
              return i === p.y;
            }).classed("inactive", function(d, i) {
              return i !== p.y;
            });
            return d3.selectAll(".column text").classed("active", function(d, i) {
              return i === p.x;
            }).classed("inactive", function(d, i) {
              return i !== p.x;
            });
          }).on("mouseout", function() {
            return d3.selectAll("text").classed("active", false).classed("inactive", false);
          });
        });
        row.append("line").attr("x2", width);
        row.append("svg:a").attr("target", "_blank").attr("xlink:xlink:href", function(d, i) {
          return nodes[i].url;
        }).append("text").attr("x", -6).attr("y", x.rangeBand() / 2).attr("dy", ".32em").attr("text-anchor", "end").text(function(d, i) {
          return nodes[i].code;
        });
        column = svg.selectAll(".column").data(matrix).enter().append("g").attr("class", "column").attr("transform", function(d, i) {
          return "translate(" + (x(i)) + ")rotate(-90)";
        });
        column.append("line").attr("x1", -width);
        return column.append("svg:a").attr("target", "_blank").attr("xlink:xlink:href", function(d, i) {
          return nodes[i].url;
        }).append("text").attr("x", 6).attr("y", x.rangeBand() / 2).attr("dy", ".32em").attr("text-anchor", "start").text(function(d, i) {
          return nodes[i].code;
        });
      });
    }
  };

  self.reqs = reqs;

}).call(this);