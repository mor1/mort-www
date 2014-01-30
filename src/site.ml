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
module C = Cowabloga

let dispatch unik request =
  let uri = unik.http_uri ~request in
  let io = { C.Dispatch.
             log = unik.log;
             ok = unik.http_respond_ok;
             notfound = unik.http_respond_notfound;
             redirect = unik.http_respond_redirect;
           }
  in
  let dispatcher = (function
      | [ ] -> return (`Page (Blog.excerpts unik.get_post))

      | "blog" :: tl -> Blog.dispatch unik tl
      | "papers" :: tl -> Papers.dispatch unik tl
      | "courses" :: tl -> Courses.dispatch unik tl

      | [ "research" ]
      | [ "teaching" ]
      | [ "codes" ]
      | [ "me" ] as segments
        -> Page.dispatch unik segments

      | segments ->
        let path = String.concat "/" segments in
        try_lwt
          lwt body = unik.get_asset ~name:path in
          return (`Asset (return body))
        with exn ->
          return (`Not_found path)
    )
  in
  C.Dispatch.f io dispatcher uri
