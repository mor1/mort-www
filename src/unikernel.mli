(*
 * Copyright (c) 2014 Richard Mortier <mort@cantab.net>
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

open Cow

(** Represents the {! Unikernel} as the set of permitted Mirage Driver
    interactions. *)
type t = {
  log: msg:string -> unit; (** Console logging *)

  get_asset: name:string -> string Lwt.t;   (** Read static asset *)
  get_page: name:string -> Html.t Lwt.t;    (** Read page *)
  get_post: name:string -> Html.t Lwt.t;    (** Read blog posts *)
  get_courses: name:string -> string Lwt.t; (** Read courses element *)
  get_papers: name:string -> string Lwt.t;  (** Read papers element *)
  get_bigpapers: name:string -> string Lwt.t;  (** hack *)

  http_respond_ok: ?headers:(string*string) list
    -> string Lwt.t
    -> (Cohttp.Response.t * Cohttp_lwt_body.t) Lwt.t;
  (** Standard HTTP 200 OK response (optional headers plus content *)

  http_respond_notfound: uri:Uri.t
    -> (Cohttp.Response.t * Cohttp_lwt_body.t) Lwt.t;
  (** Standard HTTP 404 Not Found *)

  http_respond_redirect: uri:Uri.t
    -> (Cohttp.Response.t * Cohttp_lwt_body.t) Lwt.t;
  (** Standard HTTP 302 Found (temporary redirect) *)

}
