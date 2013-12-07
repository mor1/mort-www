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

open Cowabloga

module Authors = struct
  let mort = Cow.Atom.({
      name = "Richard Mortier";
      uri = Some "http://mort.io/";
      email = Some "mort@cantab.net";
    })
end

let t = Blog.Entry.([
    { updated = Date.date (2013, 10, 14, 10, 46);
      author = Authors.mort;
      subject = "A 21st Century IDE";
      body = "posts/21st-century-ide.md";
      permalink = "/blog/2013/10/13/21st-century-ide/";
    };
  ])

let feed =
  let open Config in
  let title = title ^ " | myths & legends" in
  let read_entry f = read_store "" f in
  { Blog.title;
    subtitle = None;
    base_uri;
    id = "/blog";
    rights = Some "All rights reserved";
    read_entry
  }
