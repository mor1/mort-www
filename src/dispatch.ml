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

(** Represents the (stateless) {! Unikernel} as the set of permitted Mirage
    Driver interactions. *)
type t = {
  log: msg:string -> unit Lwt.t;           (** Console logging *)

  get_asset: name:string -> string Lwt.t;  (** Read static asset *)
  get_page: name:string -> string Lwt.t;   (** Read page *)
  get_papers: name:string -> string Lwt.t; (** Access papers data *)
  get_blog: name:string -> string Lwt.t;   (** Read blog posts *)

  http_respond_ok: ?headers:(string*string) list
    -> string Lwt.t
    -> (Cohttp.Response.t * Cohttp_lwt_body.t) Lwt.t;
  (** Standard HTTP 200 OK aresponse *)

  http_uri: request:Cohttp.Request.t -> Uri.t;
}

module Headers = struct
  (* http://www.iana.org/assignments/media-types/ *)

  let xhtml = ["content-type", "text/html; charset=UTF-8"]
  let css = ["content-type", "text/css; charset=UTF-8"]

  let atom = ["content-type", "application/atom+xml; charset=UTF-8"]
  let javascript = ["content-type", "application/javascript; charset=UTF-8"]

  let png = ["content-type", "image/png"]
  let jpeg = ["content-type", "image/jpeg"]

end

let dispatch unik request =
  let path = unik.http_uri ~request |> Uri.path in
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
  >>
  match List.filter (fun e -> e <> "") cpts with
  | []
  | [ "me" ] -> unik.http_respond_ok (Page.me ())

(*
    | [ "blog" ] -> http_respond ~body:(Page.posts ())
    | [ "research" ] -> http_respond ~body:(Page.research ())
    | [ "teaching" ] -> http_respond ~body:(Page.teaching ())

    | [ "blog"; "atom.xml" ] -> http_respond ~headers ~body:(Page.feed ())

    | "blog" :: tl ->
      respond_string ~status:`OK ~body:(Page.post path ()) ()


    | _ ->
      let fname = resolve_file ~docroot:"store" ~uri in
      respond_file ~fname ()
*)

