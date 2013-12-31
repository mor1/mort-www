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

let respond ?(headers=[]) req body =
  body >>= fun body ->
  let status = `OK in
  let headers = Cohttp.Header.of_list headers in
  respond_string ~headers ~status ~body ()

module Headers = struct
  (* http://www.iana.org/assignments/media-types/ *)

  let xhtml = ["content-type", "text/html; charset=UTF-8"]
  let css = ["content-type", "text/css; charset=UTF-8"]

  let atom = ["content-type", "application/atom+xml; charset=UTF-8"]
  let javascript = ["content-type", "application/javascript; charset=UTF-8"]

  let png = ["content-type", "image/png"]
  let jpeg = ["content-type", "image/jpeg"]

end

let f unik req =
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
  unik.log (Printf.sprintf "URL: %s" path)
  >> try_lwt
    lwt body = unik.get_asset path in
    respond body
  with exn -> match List.filter (fun e -> e <> "") cpts with
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
