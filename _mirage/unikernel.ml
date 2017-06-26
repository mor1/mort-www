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

let err fmt = Fmt.kstrf failwith fmt

module Http
    (S: Cohttp_lwt.Server)
    (SITE: Mirage_types_lwt.KV_RO)
= struct

  let https_src = Logs.Src.create "https" ~doc:"HTTPS server"
  module Https_log = (val Logs.src_log https_src : Logs.LOG)

  let http_src = Logs.Src.create "http" ~doc:"HTTP server"
  module Http_log = (val Logs.src_log http_src : Logs.LOG)

  let size_then_read ~pp_error ~size ~read device name =
    size device name >>= function
    | Error e -> err "%a" pp_error e
    | Ok size ->
      read device name 0L size >>= function
      | Error e -> err "%a" pp_error e
      | Ok bufs -> Lwt.return (Cstruct.copyv bufs)

  let site_read =
    size_then_read ~pp_error:SITE.pp_error ~size:SITE.size ~read:SITE.read

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
          (fun () -> site_read site path >>= fun body -> respond path body)
          (fun _exn -> S.respond_not_found ())

  let start http site =
    Logs.(set_level (Some Info));

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
