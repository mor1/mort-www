(*
 * Copyright (c) 2013-2016 Richard Mortier <mort@cantab.net>
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

open Lwt.Infix

module type HTTP = Cohttp_lwt.Server

let https_src = Logs.Src.create "https" ~doc:"HTTPS server"
module Https_log = (val Logs.src_log https_src : Logs.LOG)

let http_src = Logs.Src.create "http" ~doc:"HTTP server"
module Http_log = (val Logs.src_log http_src : Logs.LOG)

module Http
    (Clock: V1.CLOCK) (S: HTTP) (SITE: V1_LWT.KV_RO)
= struct

  module Logs_reporter = Mirage_logs.Make(Clock)

  let read_site site name =
      SITE.size site name >>= function
      | `Error (SITE.Unknown_key _) -> Lwt.fail (Failure ("size " ^ name))
      | `Ok size ->
        SITE.read site name 0 (Int64.to_int size) >>= function
        | `Error (SITE.Unknown_key _) -> Lwt.fail (Failure ("read " ^ name))
        | `Ok bufs -> Lwt.return (Cstruct.copyv bufs)

  let respond path body =
    let mime_type = Magic_mime.lookup path in
    let headers = Cohttp.Header.init () in
    let headers = Cohttp.Header.add headers "content-type" mime_type in
    S.respond_string ~status:`OK ~body ~headers ()

  let rec dispatcher site uri =
    let path = Uri.path uri in
    Http_log.info (fun f -> f "request '%s'" path);

    match path with
    | "" | "/" -> dispatcher site (Uri.with_path uri "index.html")
    | path ->
      let tail = Astring.String.head ~rev:true path in
      match tail with
      | Some '/' -> dispatcher site (Uri.with_path uri (path ^ "index.html"))
      | Some _ | None ->
        Lwt.catch
          (fun () -> read_site site path >>= fun body -> respond path body)
          (fun _exn -> S.respond_not_found ())

  let start _clock http site =
    Logs.(set_level (Some Info));
    Logs_reporter.(create () |> run) @@ fun () ->

    let callback (_, cid) request _body =
      let uri = Cohttp.Request.uri request in
      let cid = Cohttp.Connection.to_string cid in
      Http_log.info (fun f -> f "[%s] serving %s" cid (Uri.to_string uri));
      dispatcher site uri
    in
    let conn_closed (_, cid) =
      let cid = Cohttp.Connection.to_string cid in
      Http_log.info (fun f -> f "[%s] closing" cid);
    in
    let port = Key_gen.port () in
    Http_log.info (fun f -> f "listening on %d/TCP" port);

    http (`TCP port) (S.make ~conn_closed ~callback ())

end
