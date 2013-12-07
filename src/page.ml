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
    trailer: Html.t;
  }

  let render ~config ~body =
    <:html<
      <!-- header -->
      <div class="row">
        <div class="small-10 small-offset-2 columns">
          $config.heading$
        </div>
      </div>
      <hr />
      <!-- end header -->

      <!-- page body -->
      <div class="row">
        <div data-magellan-expedition="fixed">
          <ul class="side-nav">
            <li data-magellan-arrival="build"><a href="#build">Build with HTML</a></li>
            <li data-magellan-arrival="js"><a href="#js">Arrival 2</a></li>
          </ul>
        </div>

        <div class="small-8 small-offset-2 columns" role="content">
          $body$
        </div>

        <div class="small-2 columns" role="sidebar">
          <p>sidebar</p>
        </div>
      </div>
      <!-- end page body -->

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
      $config.trailer$

      <!-- end trailer -->
    >>

end

let trailer =
  <:html<
    <script src="/js/jquery.js"> </script>
    <script src="/js/foundation.min.js"> </script>
    <script src="/js/init.js"> </script>
  >>

let syntax_highlighting =
  <:html<
    <link rel="stylesheet" href="/css/highlight/solarized_light.css"> </link>
    <script src="/js/highlight.pack.js"> </script>
    <script>hljs.initHighlightingOnLoad();</script>
  >>

let page ~title ~heading ~copyright ~trailer ~content =
  let content =
    let body = Lwt_unix.run content in
    let open T in
    let config = { title; heading; copyright; trailer } in
    render config body
  in
  Foundation.(page ~body:(body ~title ~headers:[] ~content))

let read_page f = Config.read_store "pages/" f

let about () =
  let open Config in
  let title = title ^ " | about" in
  let content = read_page "about.md" in
  page ~title ~heading ~copyright ~trailer:[] ~content

let papers () =
  let trailer =
    let jss = List.map
        (fun js ->
           let js = "/js/" ^ js ^ ".js" in
           <:html< <script src=$str:js$> </script> >>
        )
        [ "jquery-1.9.1.min"; "papers"; "load-papers" ]
    in
    trailer @ <:html< $list:jss$ >>
  in
  let open Config in
  let title = title ^ " | papers" in
  let content = read_page "papers.md" in
  page ~title ~heading ~copyright ~trailer ~content

let posts () =
  let open Config in
  let content = Blog.to_html Posts.feed Posts.t in
  let trailer = trailer @ syntax_highlighting in
  let title = Posts.feed.Blog.title in
  page ~title ~heading ~copyright ~trailer ~content

let post path () =
  let open Config in
  let open Blog in
  let entry = List.find (fun e -> e.Entry.permalink = path) Posts.t in
  let content =
    lwt content = Posts.feed.read_entry entry.Entry.body in
    let date = Date.html_of_date entry.Entry.updated in
    let author =
      let open Cow.Atom in
      Entry.(
        entry.author.name,
        Uri.of_string (match entry.author.uri with Some x -> x | None -> "")
      )
    in
    let title = Entry.(entry.subject, Uri.of_string entry.permalink) in
    return (Blog_template.post ~title ~author ~date ~content)
  in
  let trailer = trailer @ syntax_highlighting in
  let title = title ^ " | " ^ entry.Entry.subject in
  page ~title ~heading ~copyright ~trailer ~content

let feed () =
  let open Config in
  let feed = Lwt_unix.run (Blog.to_atom Posts.feed Posts.t) in
  Xml.to_string (Atom.xml_of_feed feed)
