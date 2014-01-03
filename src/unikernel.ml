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

open Mirage_types.V1
open Lwt


(** Represents the (stateless) {! Unikernel} as the set of permitted Mirage
    Driver interactions. *)
type t = {
  log: string -> unit Lwt.t;          (** Console logging *)

  get_asset: string -> string Lwt.t;  (** Read static asset *)
  get_page: string -> string Lwt.t;   (** Read page *)
  get_papers: string -> string Lwt.t; (** Access papers data *)
  get_blog: string -> string Lwt.t;   (** Read blog posts *)

  http_respond_ok: (string*string) list
    -> string Lwt.t
    -> (Cohttp.Response.t * Cohttp_lwt_body.t) Lwt.t;
  (**  *)

  http_uri: Cohttp.Request.t -> Uri.t;
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

let dispatch unik req =
  let path = req |> unik.http_uri |> Uri.path in
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
  | [ "me" ] -> unik.http_respond_ok [] (Page.me ())

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

module Main
         (C: CONSOLE) (HTTP: Cohttp_lwt.Server)
         (ASSETS: KV_RO) (PAGES: KV_RO) (PAPERS: KV_RO) (BLOG: KV_RO) = struct

  (** Functor that produces a structure representing a unikernel given the
      driver structures specified in [config.ml]. Instantiated via e.g.,
      {! Lwt_unix.run} or as a Xen VM. *)

  let start c http assets pages papers blog =
    (** Unikernel entry point. *)

    (** First, project all the required methods we'll need from the Mirage
        Driver modules. *)

    let http_respond_ok headers body =
      body >>= fun body ->
      let status = `OK in
      let headers = Cohttp.Header.of_list headers in
      HTTP.respond_string ~headers ~status ~body ()
    in

    let http_uri request = HTTP.Request.uri request in

    let get_asset name =
      ASSETS.size assets name
      >>= function
      | `Error (ASSETS.Unknown_key _) -> fail (Failure ("get_asset " ^ name))
      | `Ok size ->
        ASSETS.read assets name 0 (Int64.to_int size)
        >>= function
        | `Error (ASSETS.Unknown_key _) -> fail (Failure ("get_asset " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let get_papers name =
      PAPERS.size papers name
      >>= function
      | `Error (PAPERS.Unknown_key _) -> fail (Failure ("get_papers " ^ name))
      | `Ok size ->
        PAPERS.read papers name 0 (Int64.to_int size)
        >>= function
        | `Error (PAPERS.Unknown_key _) -> fail (Failure ("get_papers " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let get_page name =
      PAGES.size pages name
      >>= function
      | `Error (PAGES.Unknown_key _) -> fail (Failure ("get_page " ^ name))
      | `Ok size ->
        PAGES.read pages name 0 (Int64.to_int size)
        >>= function
        | `Error (PAGES.Unknown_key _) -> fail (Failure ("get_page " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let get_blog name =
      BLOG.size blog name
      >>= function
      | `Error (BLOG.Unknown_key _) -> fail (Failure ("get_blog " ^ name))
      | `Ok size ->
        BLOG.read blog name 0 (Int64.to_int size)
        >>= function
        | `Error (BLOG.Unknown_key _) -> fail (Failure ("get_blog " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let callback conn_id ?body req =
      let unik = {
        log = (fun msg -> C.log_s c msg);
        get_asset; get_page; get_papers; get_blog;
        http_respond_ok;
        http_uri;
      } in
      dispatch unik req
    in
    let conn_closed conn_id () =
      Printf.eprintf "conn %s closed\n%!" (Cohttp.Connection.to_string conn_id)
    in
    http { Cohttp_mirage.Server.callback = callback; conn_closed }

end
