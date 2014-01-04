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
open Unikernel

module Headers = struct
  (** Some default HTTP response types as HTTP headers; taken from
      http://www.iana.org/assignments/media-types/ *)

  let xhtml = ["content-type", "text/html; charset=UTF-8"]
  let css = ["content-type", "text/css; charset=UTF-8"]

  let atom = ["content-type", "application/atom+xml; charset=UTF-8"]
  let javascript = ["content-type", "application/javascript; charset=UTF-8"]

  let png = ["content-type", "image/png"]
  let jpeg = ["content-type", "image/jpeg"]

end

let dispatch unik request =
  let sp = Printf.sprintf in
  let log_ok path = unik.Unikernel.log (sp "200 GET %s" path) in

  let uri = unik.http_uri ~request in
  let path = Uri.path uri in
  let cpts =
    let rec aux = function
      | [] | [""] -> []
      | hd::tl -> hd :: aux tl
    in
    path
    |> Re_str.(split_delim (regexp_string "/"))
    |> aux
  in

  match List.filter (fun e -> e <> "") cpts with
  | []
  | [ "blog" ] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.xhtml (Page.posts unik.get_post)

  | [ "blog"; "atom.xml" ] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.atom (Page.feed unik.get_post)

  | "blog" :: tl ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.xhtml (Page.post unik.get_post path)

  | [ "research" ] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.xhtml (Page.research unik.get_page)

  | "courses" :: tl -> tl |> String.concat "/" |> Courses.dispatch unik

  | ([ "me" ] as p)
  | ([ "teaching" ] as p) ->
    log_ok path;
    let [p] = p in
    unik.http_respond_ok ~headers:Headers.xhtml (Page.static unik.get_page p)

  | _ ->
    try_lwt
      lwt body = unik.get_asset path in
      log_ok path;
      let headers =
        let endswith tail str =
          let l = String.length tail in
          let i = String.(length str - l) in
          if i < 0 then false else
            tail = String.sub str i l
        in

        if endswith ".js" path then Headers.javascript else
        if endswith ".css" path then Headers.css else
        if endswith ".png" path then Headers.png
        else []
      in
      unik.http_respond_ok ~headers (return body)

    with exn ->
      unik.log (sp "404 GET %s" path);
      unik.http_respond_notfound uri
