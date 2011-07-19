/* Copyright (C) 2011 Richard Mortier <mort@cantab.net>.  All Rights
 * Reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License version
 * 2 as published by the Free Software Foundation
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 */

var papers = (function () {
    var _promises = [];
    var _authors = null;
    var _papers = null;

    var wrap = function (tag, x, cl, id) {
        var ids='', cls='';
        if (id) ids = ' id="'+id+'"';
        if (cl) cls = ' class="'+cl+'"';
        return '<'+tag+ids+cls+'>'+ x +'</'+tag+'>';
    };
    var div = function (cl, x, id) { return wrap("div", x, cl, id); };
    var span = function (cl, x) { return wrap("span", x, cl); };
    var link = function (x, u) { 
        return '<a href="'+u+'">'+ x +'</a>';
    };

    var code = function (m) {
        switch (m) {
        case "January": return "01";
        case "February": return "02";
        case "March": return "03";
        case "April": return "04";
        case "May": return "05";
        case "June": return "06";
        case "July": return "07";
        case "August": return "08";
        case "September": return "09";
        case "October": return "10";
        case "November": return "11";
        case "December": return "12";
        default: return "00";
        }
    };

    var entry = function (e) {
        var authors = e.author.map(function (a, _) {
            var name = a.replace(/\b(\w)\w+ /, "$1. ");
            name = name.replace(/(\w\.) (\w\.)/, "$1$2");
            name = name.replace(/(\w\.) (\w\.)/, "$1$2");
            
            if (a in _authors) name = link(name, _authors[a]);
            return span("author", name);
        });
        var venue = (function (e) {
            switch (e._type) {
            case "inproceedings": 
                return e.booktitle+", "+(e.month?e.month+" ":"")+e.year; 
            case "article":
                return e.journal+", "+e.volume+"("+e.number+"):"+e.pages;
            case "inbook":
                return e.title+" "+e.chapter+", "+e.publisher;
            case "techreport":
                return e.number+", "+e.institution;
            case "patent":
                return e.number+", "+e.note;
            }
            return "";
        })(e);
        var links = "links: ";
        var tags = "tags: ";
        return div("paper", 
                   (span("title", e.title)+'<br>'
                    +authors.join(", ")+'<br>'
                    +span("venue", venue)+'<br>'
                    +span("links", links)+"&nbsp;"
                    +span("tags", tags)
                   ));
    };
    
    var me = {
        fetch: function (au, pu) {
            _promises.push($.Deferred(function () {
                var promise = this;
                $.getJSON(au, function (data) {
                    _authors = data;
                    promise.resolve();
                });
            }).promise());

            _promises.push($.Deferred(function () {
                var promise = this;
                $.getJSON(pu, function (data) {
                    _papers = data; 
                    promise.resolve();
                });
            }).promise());
            return me;
        },

        render: function (tgt) {
            var entries = {}, yms = [];
            $.when.apply(null, _promises).then(function () {
                $(tgt).html('');

                $.each(_papers.records, function (k,e) { 
                    var y = e['year'];
                    var m = (e['month']? code(e['month'].split(" ")[0]) : "00");
                    var k = y+"-"+m;
                    
                    if (!entries[k]) entries[k] = [];
                    entries[k].push(e);
                });
                
                for (var ym in entries) yms.push(ym);
                yms.sort().reverse();
                
                var py = null;
                $.each(yms, function (i, ym) { 
                    var y = ym.split("-")[0];
                    if (py === null || y != py) {
                        $(tgt).append(div("year", y, "y-"+y));
                        py = y;
                    }
                    $.each(entries[ym], function (i, e) {
                        $(tgt).append(entry(entries[ym][i]));
                    });
                
                });
            });
        }
    };
    return me;
})();