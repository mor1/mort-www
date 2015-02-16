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
      | `Error (SITE.Unknown_key _) ->
        fail (Failure ("read_site_size " ^ name))
      | `Ok size ->
        SITE.read site name 0 (Int64.to_int size) >>= function
        | `Error (SITE.Unknown_key _) ->
          fail (Failure ("read_site " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let callback conn_id req body =
      let path = req |> S.Request.uri |> Uri.path in
      C.log c (Printf.sprintf "URL: '%s'" path);

      try_lwt
        read_site path >>= fun body ->
        S.respond_string ~status:`OK ~body ()
      with
      | Failure m ->
        Printf.printf "CATCH: '%s'\n%!" m;
        let cpts = path
                   |> Re_str.(split_delim (regexp_string "/"))
                   |> List.filter (fun e -> e <> "")
        in
        match cpts with
        | [] | [""] -> S.respond_string ~status:`OK ~body:Content.body ()
        | x -> S.respond_not_found ~uri:(S.Request.uri req) ()
    in

    let conn_closed (_, conn_id) =
      let cid = Cohttp.Connection.to_string conn_id in
      C.log c (Printf.sprintf "conn %s closed" cid)
    in

    http (S.make ~callback ~conn_closed ())

end
