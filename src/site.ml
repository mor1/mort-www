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
open Lwt
open Cohttp_lwt_unix

let log = Printf.printf

let callback conn_id ?body req =
  let open Server in

  let uri = Request.uri req in
  let path = Uri.path uri in
  log "# path:'%s'\n%!" path;

  let cpts = Re_str.(split (regexp "/") path) in
  match List.filter (fun e -> e <> "") cpts with
  | [] | [ "blog" ] ->
    respond_string ~status:`OK ~body:(Page.posts ()) ()

  | [ "blog"; "atom.xml" ] ->
    respond_string ~status:`OK ~body:(Page.feed ()) ()

  | "blog" :: tl ->
    respond_string ~status:`OK ~body:(Page.post path ()) ()

  | [ "research" ] ->
    respond_string ~status:`OK ~body:(Page.research ()) ()

  | [ "teaching" ] ->
    respond_string ~status:`OK ~body:(Page.teaching ()) ()

  | [ "me" ] ->
    respond_string ~status:`OK ~body:(Page.me ()) ()

  | _ ->
    let fname = resolve_file ~docroot:"store" ~uri in
    respond_file ~fname ()
