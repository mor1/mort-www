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

open Lwt
open Unikernel
open Cowabloga

(* push into Cowabloga.Foundation *)

let page readf scripts md =
  let render ~title ~trailer body =
    let content =
      <:html<
        $body$
        $trailer$
      >>
    in
    let body = Bootstrap.body ~title ~headers:[] content in
    Bootstrap.page body
  in
  let trailer = Page.scripts "/courses" scripts in
  let title = Page.subtitle ("courses | " ^ md) in
  lwt body = readf ~name:(md ^ ".md") in
  return (render ~title ~trailer body)

let dispatch unik cpts =
  let log_ok path = unik.log (Printf.sprintf "200 GET %s" path) in
  let path = String.concat "/" cpts in
  let read_md ~name =
    lwt body = unik.get_courses ~name in
    return (Cow.Markdown.of_string body)
  in
  match cpts with
  (* root page is the complete courses list *)
  | [ ] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.html
      (page read_md ["courses.js"] "all")

  (* specific pages *)
  | (["ugt"] as p)
  | (["pgt"] as p) ->
    log_ok path;
    (match p with
     | [ p ] ->
       unik.http_respond_ok ~headers:Headers.html
         (page read_md ["courses.js"] p)
     | _ -> assert false
    )

  | ["tt"] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.html (page read_md ["tt.js"] "tt")

  | ["reqs"] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.html
      (page read_md ["d3.v3.min.js"; "reqs.js"] "reqs")

  (* handle legacy URIs via redirects *)
  | ["index.html"] ->
    unik.http_respond_redirect ~uri:(Uri.of_string "/courses")
  | ["ugt.html"]
  | ["ugt"; "index.html"] ->
    unik.http_respond_redirect ~uri:(Uri.of_string "/courses/ugt")
  | ["pgt.html"]
  | ["pgt"; "index.html"] ->
    unik.http_respond_redirect ~uri:(Uri.of_string "/courses/pgt")
  | ["tt"; "index.html"] ->
    unik.http_respond_redirect ~uri:(Uri.of_string "/courses/tt")

  (* default: assume it's a standard file fetch; break this into Cowabloga.Foundation *)
  | _ ->
    try_lwt
      lwt body = unik.get_courses path in
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
        if endswith ".json" path then Headers.json else
        if endswith ".png" path then Headers.png
        else []
      in
      unik.http_respond_ok ~headers (return body)

    with exn ->
      unik.log (Printf.sprintf "404 GET %s" path);
      unik.http_respond_notfound (Uri.of_string ("/courses/" ^ path))
