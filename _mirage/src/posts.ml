(*
 * Copyright (c) 2010-2013 Anil Madhavapeddy <anil@recoil.org>
 * Copyright (c) 2013 Richard Mortier <mort@cantab.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

module Authors = struct
  let mort = Cow.Atom.({
      name = "Richard Mortier";
      uri = Some "http://mort.io/";
      email = Some "mort@cantab.net";
    })
end

let t =
  let module Date = Cowabloga.Date in
  let open Cowabloga.Blog in
  Entry.([
      { updated = Date.date (2013, 10, 13, 10, 46);
        author = Authors.mort;
        subject = "A 21st Century IDE";
        body = "21st-century-ide.md";
        permalink = "2013/10/13/21st-century-ide";
      };
      { updated = Date.date (2013, 12, 09, 10, 10);
        author = Authors.mort;
        subject = "A Brave New World";
        body = "a-brave-new-world.md";
        permalink = "2013/12/09/a-brave-new-world";
      };
    ])
  |> List.sort Entry.compare

let id = "/blog/"
let permalink filename =
  let open Cowabloga.Blog.Entry in
  id ^ (List.find (fun e -> e.body = filename) t).permalink

let feed read_entry =
  let open Site_config in
  { Cowabloga.Atom_feed.title = Cow.Html.to_string title;
    subtitle = Some (Cow.Html.to_string subtitle);
    base_uri;
    id;
    rights;
    author = Some Authors.mort;
    read_entry
  }