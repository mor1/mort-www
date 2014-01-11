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

let posts readf =
  let title = subtitle "blog" in
  lwt body =
    let feed = Posts.feed (fun name -> readf ~name) in
    Cowabloga.Blog.to_html feed Posts.t
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
              <a href="$str:Posts.permalink name$">read more...</a>
            >>
      in
      return v
      )
    in
    Cowabloga.Blog.to_html feed Posts.t
  in return (render ~title ~highlight:true ~sidebar body)

let feed readf =
  lwt feed =
    let feed = Posts.feed (fun name -> readf ~name) in
    Cowabloga.Blog.to_atom feed Posts.t
  in
  return Cow.(Xml.to_string (Atom.xml_of_feed feed))

let post readf path =
  let entry = List.find (fun e -> e.Cowabloga.Blog.Entry.permalink = path) Posts.t in
  let title = subtitle (" | blog | " ^ entry.Cowabloga.Blog.Entry.subject) in
  lwt body =
    let feed = Posts.feed (fun name -> readf ~name) in
    Cowabloga.Blog.Entry.to_html ~feed ~entry
  in
  return (render ~title ~highlight:true ~sidebar body)

let dispatch unik cpts =
  let log_ok path = unik.log (Printf.sprintf "200 GET %s" path) in
  let path = String.concat "/" cpts in
  let open Cowabloga in
  match cpts with
  | [] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.html (posts unik.get_post)

  | [ "atom.xml" ] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.atom (feed unik.get_post)

  | _ ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.html (post unik.get_post path)
