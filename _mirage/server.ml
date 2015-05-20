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

open Mirage
open Printf

let httpd_port = 80
let ns_port = 53

let red fmt    = sprintf ("\027[31m"^^fmt^^"\027[m")
let green fmt  = sprintf ("\027[32m"^^fmt^^"\027[m")
let yellow fmt = sprintf ("\027[33m"^^fmt^^"\027[m")
let blue fmt   = sprintf ("\027[36m"^^fmt^^"\027[m")
let grey fmt   = sprintf (""^^fmt^^"")

module Main (C: CONSOLE) (SITE: KV_RO) (ZONE: KV_RO) (S: STACKV4) = struct

  module U = S.UDPV4
  module DNS = Dns_server_mirage.Make(ZONE)(S)

  let start c site zonefile stack =
    let log msg = C.log_s c msg in

    let read_site name =
      SITE.size site name >>= function
      | `Error (SITE.Unknown_key _) -> fail (Failure ("size " ^ name))
      | `Ok size ->
        SITE.read site name 0 (Int64.to_int size) >>= function
        | `Error (SITE.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in
    let read_zone name =
      ZONE.size zone name >>= function
      | `Error (ZONE.Unknown_key _) -> fail (Failure ("size " ^ name))
      | `Ok size ->
        ZONE.read site name 0 (Int64.to_int size) >>= function
        | `Error (ZONE.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let dnsd =
      let t = DNS.create s k in
      DNS.serve_with_zonebuf t ~port ~zonefile
    in

    let httpd =
      let rec dispatcher = function
        | [] | [""] -> dispatcher ["index.html"]
        | segments ->
          let path = String.concat "/" segments in
          try_lwt
            read_site path >>= fun body ->
            HTTP.respond_string ~status:`OK ~body ()
          with exn ->
            let path = path ^ "/index.html" in
            try_lwt
              read_site path >>= fun body ->
              HTTP.respond_string ~status:`OK ~body ()
            with exn ->
              HTTP.respond_not_found ()
      in

      let callback conn_id request body =
        let uri = HTTP.Request.uri request in
        dispatcher (Config.split "/" uri)
      in

      let conn_closed (_, conn_id) =
        let cid = Cohttp.Connection.to_string conn_id in
        C.log c (Printf.sprintf "conn %s closed" cid)
      in

      http (HTTP.make ~callback ~conn_closed ())
    in

    dnsd <?> httpd

end
