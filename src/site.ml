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

open Mirage_types.V1

let log = Printf.printf

module Config = struct

  let copyright = <:html< 2009&mdash;2013 Richard Mortier >>
  let title = <:html< mort&rsquo;s mythopoeia >>

  let heading =
    <:html<
      <a href="/">
        <h1>$title$<br />
          <small>because everyone needs a presence, right?</small>
        </h1>
      </a>
    >>

  let base_uri = "http://localhost:8081"
  let rights = Some "All rights reserved"

  let read_store prefix f =
    Printf.printf "[r] prefix:'%s' f:'%s'\n%!" prefix f;
    Cowabloga.Blog.read_content Store.read prefix f

end

module Main
         (C: CONSOLE) (HTTP: Cohttp_lwt.Server)
         (ASSETS: KV_RO) (DATA: KV_RO) (PAGES: KV_RO) (POSTS: KV_RO) = struct

  let start c http assets data pages posts =

    let read_assets name =
      ASSETS.size assets name
      >>= function
      | `Error (ASSETS.Unknown_key _) -> fail (Failure ("read " ^ name))
      | `Ok size ->
        AaSETS.read assets name 0 (Int64.to_int size)
        >>= function
        | `Error (ASSETS.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let read_data name =
      DATA.size data name
      >>= function
      | `Error (DATA.Unknown_key _) -> fail (Failure ("read " ^ name))
      | `Ok size ->
        DATA.read data name 0 (Int64.to_int size)
        >>= function
        | `Error (DATA.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let read_pages name =
      PAGES.size pages name
      >>= function
      | `Error (PAGES.Unknown_key _) -> fail (Failure ("read " ^ name))
      | `Ok size ->
        ASSETS.read pages name 0 (Int64.to_int size)
        >>= function
        | `Error (PAGES.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let read_posts name =
      POSTS.size posts name
      >>= function
      | `Error (POSTS.Unknown_key _) -> fail (Failure ("read " ^ name))
      | `Ok size ->
        POSTS.read posts name 0 (Int64.to_int size)
        >>= function
        | `Error (POSTS.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let callback conn_id ?body req =
      let path = Uri.path (HTTP.Request.uri req) in
      let cpts =
        let rec aux = function
          | [] | [""] -> []
          | hd::tl -> hd :: aux tl
        in
        path
        |> Re_str.(split_delim (regexp_string "/"))
        |> aux
      in
      C.log_s c (Printf.sprintf "URL: %s" path)
      >> try_lwt
        lwt body = read_asset path in
        HTTP.respond_string ~status:`OK ~body ()
      with exn -> dispatch req cpts
    in
    let conn_closed conn_id () =
      Printf.eprintf "conn %s closed\n%!" (HTTP.string_of_conn_id conn_id)
    in
    http { Server.callback = callback; conn_closed }

end
