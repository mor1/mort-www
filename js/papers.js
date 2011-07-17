/* Copyright (C) 2010 Richard Mortier <mort@cantab.net>.  All Rights
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

    var entry = function (e) {
        var authors = e.author.map(function (a, _) {
            var name = a.replace(/\b(\w)\w+ /, "$1. ").replace(/(\w\.) (\w\.)/, "$1$2").replace(/(\w\.) (\w\.)/, "$1$2");
            
            if (a in _authors) name = link(name, _authors[a]);
            return span("author", name)            
        });
        var venue = (function (e) {
            switch (e._venue) {
            case "workshop": 
            case "conference":
                return e.booktitle; break;

            }
        })(e);
        var links = "links: ";
        return div("paper", 
                   (span("title", e.title)+'<br>'
                    +authors.join(", ")+'<br>'
                    +span("venue", venue)+'<br>'
                    +span("links", links)
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
            var entries = {}, years = [];;
            $.when.apply(null, _promises).then(function () {
                $(tgt).html('');

                $.each(_papers.records, function (_, e) {
                    var y = e['year'];
                    if (!entries[y]) entries[y] = [];
                    entries[y].push(e);
                });
                
                for (var y in entries) years.push(y);
                years.sort().reverse();
                
                $.each(years, function (i, y) { 
                    $(tgt).append(div("year", y));
                    $.each(entries[y], function (i, e) {
                        $(tgt).append(entry(e));
                    });
                });
            });
        }
    };
    return me;
})();