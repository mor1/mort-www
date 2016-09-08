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

open Lwt
open V1_LWT

module Main (C: CONSOLE) (SITE: KV_RO) (S: Cohttp_lwt.Server) = struct

  let start c site http =
    let read_site name =
      SITE.size site name >>= function
      | `Error (SITE.Unknown_key _) -> fail (Failure ("size " ^ name))
      | `Ok size ->
        SITE.read site name 0 (Int64.to_int size) >>= function
        | `Error (SITE.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    (* Split a URI into a list of path segments *)
    let split_path uri =
      let path = Uri.path uri in
      let rec aux = function
        | [] | [""] -> []
        | hd::tl -> hd :: aux tl
      in
      List.filter (fun e -> e <> "")
        (aux (Re_str.(split_delim (regexp_string "/") path)))
    in

    (* dispatch non-file URLs *)
    let rec dispatcher = function
      | [] | [""] -> dispatcher ["index.html"]
      | segments ->
        let path = String.concat "/" segments in
        try_lwt
          read_site path >>= fun body ->
          S.respond_string ~status:`OK ~body ()
        with exn ->
          let path = path ^ "/index.html" in
          try_lwt
            read_site path >>= fun body ->
            S.respond_string ~status:`OK ~body ()
          with exn ->
            S.respond_not_found ()
    in

    let callback conn_id request body =
      let uri = Cohttp.Request.uri request in
      dispatcher (split_path uri)
    in

    let conn_closed (_, conn_id) =
      let cid = Cohttp.Connection.to_string conn_id in
      C.log c (Printf.sprintf "conn %s closed" cid)
    in

    http (`TCP 80) (S.make ~callback ~conn_closed ())

end
