var papers = (function () {

    var bibfiles = [ 
//        "https://github.com/mor1/rmm-bibs/blob/master/strings.bib",
            "https://github.com/mor1/rmm-bibs/blob/master/rmm-conference.bib",
            "https://github.com/mor1/rmm-bibs/blob/master/rmm-workshop.bib",
            "https://github.com/mor1/rmm-bibs/blob/master/rmm-journal.bib",
            "https://github.com/mor1/rmm-bibs/blob/master/rmm-patents.bib",
            "https://github.com/mor1/rmm-bibs/blob/master/rmm-techreport.bib",
            "https://github.com/mor1/rmm-bibs/blob/master/rmm-unpublished.bib"
    ];
    var promises = [];
    var entries  = [];

    parse = function (input) {
        var raw = input
            .replace(/\<div\>|\<\/div\>/gm,"")
            .replace(/  |\n/gm," ");
        var bt = new BibTex();
        bt.content = raw;
        bt.parse();
        $(bt.data).each(
            function(i,v) {
                $(v.author).each(
                    function (ii,vv) {
                        if (/ |~/.test(vv.last)) {
                            var ns = vv.last.split(/ |~/);
                            vv.first = ns[0];
                            vv.last = ns.slice(1,ns.length).join(" ");
                        }
                    });
                entries.push(v);
            });
    };

    fetch = function (_, url) {
        promises.push(
            $.Deferred(
                function (promise) {
/*
                    $.yql('select * from html where url=@url and xpath=@xpath',
                          {
                              'url': url,
                              'xpath': "//div[@class=\'highlight']/pre"
                          },
                          function (data) {
                              parse(data.query.results.pre.content);
                              promise.resolve();
                          });
 */
                }
            ).promise()
        );
    };

    render_entry = function (_, entry) {
        var format_author = function (a) {
            return a.first[0]+". "+a.last;
        };
         var fentry = {};
        fentry.title = entry.title.replace(/{|}/g, "");
        fentry.authors = $.map(entry.author, format_author).join(", ");
        fentry.booktitle = entry.booktitle;
         return $.tmpl(
            '<div class="entry">'
                + '<span class="title">${title}</span><br />'
                + '<span class="authors">${authors}</span><br />'
                + '<span class="venue">${booktitle}</span>'
                + '</div>', fentry).insertAfter("#publications");
    };

    return {
        render : function () {
            $.each(bibfiles, fetch);
            $.when.apply(null, promises).then(
                function () {
                    $.each(entries, render_entry);
                });
        }
    };
})();

$.getJSON(
    "https://api.github.com/repos/swanson/swanson.github.com/git/trees/master",
//    "https://raw.github.com/mor1/rmm-bibs/master/rmm-conference.bib?callback=?",
    function (data) {
        console.log(data);
    });
