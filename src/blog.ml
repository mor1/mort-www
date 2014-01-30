(*
 * Copyright (c) 2014 Richard Mortier <mort@cantab.net>
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

open Lwt
open Unikernel
open Page
module C = Cowabloga

let posts readf =
  let title = subtitle "blog" in
  lwt body =
    let feed = Posts.feed (fun name -> readf ~name) in
    C.Blog.to_html feed Posts.t
  in
  return (render ~title ~highlight:true ~sidebar body)

let excerpts readf =
  let title = Cow.Html.to_string Site_config.title in
  lwt body =
    let feed = Posts.feed (fun name ->
        lwt post = readf ~name in
        let v = match post with
          | [] -> []
          | p1 :: [] -> [p1]
          | p1 :: p2 :: [] -> [p1; p2]
          | p1 :: p2 :: p3 :: _ ->
            p1 :: p2 :: p3 ::
              <:html<
                <a class="secondary round label right"
                   href="$str:Posts.permalink name$">
                   more&nbsp;&raquo;
                </a>
              >>
        in
        return v
      )
    in
    C.Blog.to_html feed Posts.t
  in return (render ~title ~highlight:true ~sidebar body)

let feed readf =
  lwt feed =
    let feed = Posts.feed (fun name -> readf ~name) in
    C.Blog.to_atom feed Posts.t
  in
  return Cow.(Xml.to_string (Atom.xml_of_feed feed))

let post readf segments =
  let path = String.concat "/" segments in
  let entry = List.find (fun e -> e.C.Blog.Entry.permalink = path) Posts.t in
  let title = subtitle (" | blog | " ^ entry.C.Blog.Entry.subject) in
  lwt body =
    let feed = Posts.feed (fun name -> readf ~name) in
    C.Blog.Entry.to_html ~feed ~entry
  in
  return (render ~title ~highlight:true ~sidebar body)

let dispatch unik = function
  | []           -> return (`Page (posts unik.get_post))
  | ["atom.xml"] -> return (`Atom (feed unik.get_post))
  | segments     -> return (`Page (post unik.get_post segments))
