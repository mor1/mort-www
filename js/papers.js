// Generated by CoffeeScript 1.12.5
(function() {
  var code, div, entry, link, p, span, wrap,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  wrap = function(tag, x, cl, id) {
    var cls, ids;
    ids = '';
    cls = '';
    if (id != null) {
      ids = " id='" + id + "'";
    }
    if (cl != null) {
      cls = " class='" + cl + "'";
    }
    return "<" + tag + " " + ids + " " + cls + ">" + x + "</" + tag + ">";
  };

  div = function(cl, x, id) {
    return wrap("div", x, cl, id);
  };

  p = function(cl, x) {
    return wrap("p", x, cl);
  };

  span = function(cl, x) {
    return wrap("span", x, cl);
  };

  link = function(cl, x, u) {
    return wrap("span", "<a href='" + u + "'>" + x + "</a>", cl);
  };

  code = function(m) {
    switch (m) {
      case "January":
        return "01";
      case "February":
        return "02";
      case "March":
        return "03";
      case "April":
        return "04";
      case "May":
        return "05";
      case "June":
        return "06";
      case "July":
        return "07";
      case "August":
        return "08";
      case "September":
        return "09";
      case "October":
        return "10";
      case "November":
        return "11";
      case "December":
        return "12";
      default:
        return "00";
    }
  };

  entry = function(as, e) {
    var address, authors, date, issn, linkbar, links, note, publisher, ref, tags, ttag, venue;
    authors = $.map(e.authors, function(a, _) {
      var name;
      name = a.replace(/\b(\w)\w+ /, "$1. ").replace(/(\w\.) (\w\.)/, "$1$2").replace(/(\w\.) (\w\.)/, "$1$2");
      name = (a in as ? link(name, name, as[a]) : name);
      return span("author", name);
    }).join(", ");
    venue = (function() {
      switch (e._type) {
        case "inproceedings":
          return e.booktitle;
        case "article":
          return e.journal + ", " + e.volume + " (" + e.number + "): " + e.pages;
        case "inbook":
          return e.title + " " + e.chapter + ", " + e.publisher;
        case "techreport":
          return e.number + ", " + e.institution;
        case "patent":
          return e.number;
        default:
          return "";
      }
    })();
    date = e.month ? e.month + " " + e.year + "." : e.year + ".";
    links = "links: ";
    links += e.url != null ? link("url", "url", e.url) : "";
    links += e.html != null ? link("url html", "html", e.html) : "";
    links += e.pdf != null ? link("url pdf", "pdf", "http://mor1.github.io/publications/" + e.pdf) : "";
    links += e.doi != null ? link("url doi", "doi", "http://dx.doi.org/" + e.doi) : "";
    ttag = (function() {
      switch (e._type) {
        case "inproceedings":
          return "conference";
        case "article":
          return "journal";
        case "inbook":
          return "chapter";
        case "techreport":
          return "tr";
        case "patent":
          return "patent";
        default:
          return "";
      }
    })();
    tags = [span('tag', ttag)].concat((ref = e.tags) != null ? ref.map(function(t) {
      return span('tag', t);
    }) : void 0).join('; ');
    issn = e.issn != null ? "issn: " + (span('issn', e.issn)) : "";
    publisher = e.publisher ? span("publisher", e.publisher + ".") : "";
    address = e.address ? span("address", e.address + ".") : "";
    note = e.note ? e.note + ". " : "";
    linkbar = div('linkbar', (span('links', links)) + " " + issn + " tags: " + (span('tags', tags)));
    return div("paper " + e._venue, (span('title', e.title)) + "<br> " + authors + "<br> " + (span("venue", venue)) + ". " + note + "<br> " + date + " " + publisher + " " + address + "<br> " + linkbar);
  };

  $(document).ready(function() {
    var authors, papers, records, yms;
    authors = $.getJSON("papers/authors.json");
    papers = $.getJSON("papers/papers.json");
    records = {};
    yms = [];
    return $.when(authors, papers).done(function(arg, arg1) {
      var as, oy, ps, tgt, tool;
      as = arg[0];
      ps = arg1[0];
      tool = link('', ps.tool.name, ps.tool.url);
      tgt = $("#entries");
      tgt.html('').after(div('tool', p('', "Generated by " + tool + " on " + ps.date + ".")));
      $.each(ps.records, function(_, e) {
        var k, m;
        m = e.month ? code(e.month.split(" ")[0]) : "00";
        k = e.year + "-" + m;
        if (!(k in records)) {
          records[k] = [];
        }
        records[k].push(e);
        if (indexOf.call(yms, k) < 0) {
          return yms.push(k);
        }
      });
      oy = "";
      yms.sort().reverse();
      return $.each(yms, function(_, ym) {
        var y;
        console.log(ym);
        y = ym.split("-")[0];
        if (oy === "" || y !== oy) {
          if (oy !== "") {
            tgt.append(div('break', ''));
          }
          tgt.append(div("year", y, "y-" + y));
        }
        oy = y;
        return $.each(records[ym], function(i, e) {
          return tgt.append(entry(as, records[ym][i]));
        });
      });
    });
  });

}).call(this);