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

open Cowabloga
open Cow
open Lwt

module T = struct
  type t = {
    title: string;
    heading: Html.t;
    copyright: string;
    jss: string list;
  }

  let render ~config ~content =
    let jss = List.map
        (fun js ->
           let js = "/js/" ^ js ^ ".js" in
           <:html< <script src=$str:js$> </script> >>
        )
        config.jss
    in
    <:html<
      <!-- header -->
      <div class="row">
        <div class="large-12 columns">
          $config.heading$
        </div>
      </div>
      <!-- end header -->

      <!-- page content -->
      <div class="row">
        <div class="large-9 columns" role="content">
          $content$
        </div>
      </div>
      <!-- end page content -->

      <!-- page footer -->
      <footer class="row">
        <div class="large-12 columns">
          <hr />
          <div class="row">
            <div class="large-6 columns">
              <p>Copyright &copy; $str:config.copyright$</p>
            </div>
          </div>
        </div>
      </footer>
      <!-- end page footer -->

      <!-- finally, trailer asset loading -->
      <link rel="stylesheet" href="/css/highlight/solarized_light.css"> </link>
      <script src="/js/highlight.pack.js"> </script>
      <script>hljs.initHighlightingOnLoad();</script>

      $list:jss$
      <!-- end trailer -->
    >>

end

let page ~title ~heading ~copyright ~jss ~f =
  let content = Lwt_unix.run
      (match_lwt Store.read ("pages/" ^ f) with
       | None -> return <:html<$str:"???"$>>
       | Some  b ->
         let string_of_stream s = Lwt_stream.to_list s >|= Cstruct.copyv in
         lwt str = string_of_stream b in
         return (Markdown_omd.of_string str)
      )
  in
  let content =
    T.(render { title; heading; copyright; jss } content)
  in
  Foundation.(page ~body:(body ~title ~headers:[] ~content))

let about =
  let open Config in
  let title = title ^ " | about" in
  page ~title ~heading ~copyright ~jss:[] ~f:"about.md"

let papers =
  let open Config in
  let title = title ^ " | papers" in
  let jss = [ "jquery-1.9.1.min"; "papers"; "load-papers" ] in
  page ~title ~heading ~copyright ~jss ~f:"papers.md"
