(*
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
open Lwt

module Main
         (C: CONSOLE) (HTTP: Cohttp_lwt.Server)
         (ASSETS: KV_RO) (DATA: KV_RO) (PAGES: KV_RO) (POSTS: KV_RO) = struct

  type unik = {
    log: string -> unit Lwt.t;
    get_asset: string -> string Lwt.t;
    get_data: string -> string Lwt.t;
    get_page: string -> string Lwt.t;
    get_post: string -> string Lwt.t;
  }

  let start c http assets data pages posts =

    let get_asset name =
      ASSETS.size assets name
      >>= function
      | `Error (ASSETS.Unknown_key _) -> fail (Failure ("get_asset " ^ name))
      | `Ok size ->
        ASSETS.read assets name 0 (Int64.to_int size)
        >>= function
        | `Error (ASSETS.Unknown_key _) -> fail (Failure ("get_asset " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let get_data name =
      DATA.size data name
      >>= function
      | `Error (DATA.Unknown_key _) -> fail (Failure ("get_data " ^ name))
      | `Ok size ->
        DATA.read data name 0 (Int64.to_int size)
        >>= function
        | `Error (DATA.Unknown_key _) -> fail (Failure ("get_data " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let get_page name =
      PAGES.size pages name
      >>= function
      | `Error (PAGES.Unknown_key _) -> fail (Failure ("get_page " ^ name))
      | `Ok size ->
        PAGES.read pages name 0 (Int64.to_int size)
        >>= function
        | `Error (PAGES.Unknown_key _) -> fail (Failure ("get_page " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let get_post name =
      POSTS.size posts name
      >>= function
      | `Error (POSTS.Unknown_key _) -> fail (Failure ("get_posts " ^ name))
      | `Ok size ->
        POSTS.read posts name 0 (Int64.to_int size)
        >>= function
        | `Error (POSTS.Unknown_key _) -> fail (Failure ("get_posts " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let callback conn_id ?body req =
      let unik = {
        log = (fun s -> C.log_s c s);
        get_asset; get_data; get_page; get_post;
      } in
      Dispatch.f unik req
    in
    let conn_closed conn_id () =
      Printf.eprintf "conn %s closed\n%!" (HTTP.string_of_conn_id conn_id)
    in
    http { Server.callback = callback; conn_closed }

end
