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

let dispatch unik segments =
  let read_md ~name =
    lwt body = unik.get_courses ~name in
    return (Cow.Markdown.of_string body)
  in
  match segments with
  (* root page is the complete courses list *)
  | [ ] -> return (`Html (page read_md ["courses.js"] "all"))

  (* specific pages *)
  | ("ugt" as p) :: []
  | ("pgt" as p) :: []
    -> return (`Html (page read_md ["courses.js"] p))

  | ["tt"]
    -> return (`Html (page read_md ["tt.js"] "tt"))
  | ["reqs"]
    -> return (`Html (page read_md ["d3.v3.min.js"; "reqs.js"] "reqs"))

  (* handle legacy URIs via redirects *)
  | ["index.html"] -> return (`Redirect "/courses")

  | ["ugt.html"]
  | ["ugt"; "index.html"] -> return (`Redirect "/courses/ugt")

  | ["pgt.html"]
  | ["pgt"; "index.html"] -> return (`Redirect "/courses/pgt")

  | ["tt"; "index.html"] -> return (`Redirect "/courses/tt")

  | _ ->
    let path = String.concat "/" segments in
    try_lwt
      lwt body = unik.get_courses path in
      return (`Asset (return body))
    with exn ->
      return (`Not_found ("/courses/" ^ path))
