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

open Unikernel
open Lwt
open Cowabloga

let dispatch unik request =
  let log_ok path = unik.log (Printf.sprintf "200 GET %s" path) in

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
  | [ ] | [ "blog" ] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.html (Page.posts unik.get_post)

  | [ "blog"; "atom.xml" ] ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.atom (Page.feed unik.get_post)

  | "blog" :: tl ->
    log_ok path;
    unik.http_respond_ok ~headers:Headers.html (Page.post unik.get_post path)

  | "papers" :: tl -> Papers.dispatch unik tl

  | ([ "research" ] as p)
  | ([ "teaching" ] as p)
  | ([ "codes"    ] as p)
  | ([ "me"       ] as p) ->
    log_ok path;
    (match p with
     | [ p ] ->
       let trailer = match p with
         | "research" ->
           Page.scripts "/papers"
             [ "jquery-1.9.1.min.js"; "papers.js"; "load-papers.js" ]
         | _ -> []
       in
       unik.http_respond_ok ~headers:Headers.html (Page.static trailer unik.get_page p)
     | _ -> assert false
    )

  | "courses" :: tl -> Courses.dispatch unik tl

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
        if endswith ".json" path then Headers.json else
        if endswith ".png" path then Headers.png
        else []
      in
      unik.http_respond_ok ~headers (return body)

    with exn ->
      unik.log (Printf.sprintf "404 GET %s" path);
      unik.http_respond_notfound uri
