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

let dispatch unik cpts =
  match cpts with
  | [ ]
  | ["ugt"]
  | ["pgt"]
  | ["tt"] ->
    let path = String.concat "/" cpts in
    let body =
      return (Cow.Html.to_string <:html< COURSES.DISPATCH $str:path$ >>)
    in
    unik.Unikernel.http_respond_ok ~headers:[] body

  | ["index.html"] ->
    unik.Unikernel.http_respond_redirect ~uri:(Uri.of_string "/courses")
  | ["ugt"; "index.html"] ->
    unik.Unikernel.http_respond_redirect ~uri:(Uri.of_string "/courses/ugt")
  | ["pgt"; "index.html"] ->
    unik.Unikernel.http_respond_redirect ~uri:(Uri.of_string "/courses/pgt")
  | ["tt"; "index.html"] ->
    unik.Unikernel.http_respond_redirect ~uri:(Uri.of_string "/courses/tt")
