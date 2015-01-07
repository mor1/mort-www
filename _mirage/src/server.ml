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

(* XXX needs to plumb the failing name through somehow *)
let (>>>) x f =
  x >>= function
  | `Error _ -> fail (Failure "name")
  | `Ok x    -> f x

module Main
         (C: V1_LWT.CONSOLE) (S: Cohttp_lwt.Server) (ASSETS: V1_LWT.KV_RO)
         (PAGES: V1_LWT.KV_RO) (POSTS: V1_LWT.KV_RO) (COURSES: V1_LWT.KV_RO)
         (PAPERS: V1_LWT.KV_RO) (BIGPAPERS: V1_LWT.KV_RO)

  = struct

    (** Functor that produces a structure representing a unikernel given the
        driver structures specified in [config.ml]. Instantiated via e.g.,
        {! Lwt_unix.run} or as a Xen VM. *)

    let start c http assets pages posts courses papers bigpapers =
      (** Unikernel entry point. *)

      (** First, project all the required methods we'll need from the Mirage
          Driver modules. *)

      let http_respond_ok ?(headers=[]) body =
        body >>= fun body ->
        let status = `OK in
        let headers = Cohttp.Header.of_list headers in
        S.respond_string ~headers ~status ~body ()
      in
      let http_respond_redirect ~uri = S.respond_redirect ~uri () in
      let http_respond_notfound ~uri = S.respond_not_found ~uri () in

      let get_asset ~name =
        ASSETS.size assets name                       >>> fun size ->
        ASSETS.read assets name 0 (Int64.to_int size) >>> fun bufs ->
        return (Cstruct.copyv bufs)
      in

      let get_page ~name =
        PAGES.size pages name                       >>> fun size ->
        PAGES.read pages name 0 (Int64.to_int size) >>> fun bufs ->
        return (Cow.Markdown.of_string (Cstruct.copyv bufs))
      in

      let get_post ~name =
        POSTS.size posts name                       >>> fun size ->
        POSTS.read posts name 0 (Int64.to_int size) >>> fun bufs ->
        return (Cow.Markdown.of_string (Cstruct.copyv bufs))
      in

      let get_courses ~name =
        COURSES.size courses name                       >>> fun size ->
        COURSES.read courses name 0 (Int64.to_int size) >>> fun bufs ->
        return (Cstruct.copyv bufs)
      in

      let get_papers ~name =
        PAPERS.size papers name                       >>> fun size ->
        PAPERS.read papers name 0 (Int64.to_int size) >>> fun bufs ->
        return (Cstruct.copyv bufs)
      in

      let get_bigpapers ~name =
        BIGPAPERS.size bigpapers name                       >>> fun size ->
        BIGPAPERS.read bigpapers name 0 (Int64.to_int size) >>> fun bufs ->
        return (Cstruct.copyv bufs)
      in

      let callback conn_id ?body request =
        let uri = S.Request.uri request in
        let unik = {
          Unikernel.log = (fun ~msg -> C.log c msg);
          get_asset; get_page; get_post; get_courses; get_papers; get_bigpapers;
          http_respond_ok; http_respond_redirect; http_respond_notfound;
        } in
        Site.dispatch unik uri
      in
      let conn_closed conn_id () =
        let cid = Cohttp.Connection.to_string conn_id in
        C.log c (Printf.sprintf "conn %s closed" cid)
      in
      http { S.callback = callback; conn_closed }

  end
