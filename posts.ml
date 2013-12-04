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
open Cow
open Lwt

module Authors = struct
  let mort = {
    Atom.name = "Richard Mortier";
    uri       = Some "http://mort.io/";
    email     = Some "mort@cantab.net";
  }
end

module Entries = struct
  let t =
    let open Cowabloga in
    [ { Blog.updated = Date.date (2013, 10, 14, 10, 46);
        author = Authors.mort;
        subject = "A 21st Century IDE";
        body = "...";
        permalink = "/2013/10/13/21st-century-ide/";
      };
    ]
end

let read_entry ent =
  match_lwt Store.read ent with
  | None -> return <:html<$str:"???"$>>
  | Some b ->
    let string_of_stream s = Lwt_stream.to_list s >|= Cstruct.copyv in
    lwt str = string_of_stream b in
    return Cow.(Markdown.to_html (Markdown.of_string str))

let config = Config.({ Blog.title; subtitle; base_uri; rights; read_entry })

let posts =
  Lwt_unix.run (Blog.entries_to_html config Entries.t)

let page =
  let content =
    let recent_posts = Blog.recent_posts config Entries.t in
    let sidebar =
      Blog_template.Sidebar.t ~title:"recent posts" ~content:recent_posts
    in
    let { Blog.title; subtitle } = config in
    Config.(Blog_template.t ~title ~subtitle ~nav_links:nav_links ~sidebar ~posts ~copyright ())
  in

  let body = Foundation.body ~title:"myths & legends" ~content:content in
  Foundation.page ~body
