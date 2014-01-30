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

  C.Dispatch.f
    unik.log unik.get_asset unik.http_respond_ok unik.http_respond_notfound
    (fun segments -> match segments with
       | [ ] ->
         Some (C.Headers.html, (Blog.excerpts unik.get_post))

       | "blog" :: tl -> Some (Blog.dispatch unik tl)

(*
       | "papers" :: tl -> Papers.dispatch unik tl
       | "courses" :: tl -> Courses.dispatch unik tl
*)

       | [ "research" ]
       | [ "teaching" ]
       | [ "codes" ]
       | [ "me" ]
         -> Some (Page.dispatch unik segments)

       | _ -> None
    )
    uri
