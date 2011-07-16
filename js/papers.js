var papers = (function () {
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
            $.getJSON(
    "/research/papers/authors.json",
//    "https://raw.github.com/mor1/rmm-bibs/master/rmm-conference.bib?callback=?",
    function (data) {
        console.log(data);
    });
$.getJSON(
    "/research/papers/papers.json",
//    "https://raw.github.com/mor1/rmm-bibs/master/rmm-conference.bib?callback=?",
    function (data) {
        console.log(data);
    });

        }
    };
})();

papers.render();
