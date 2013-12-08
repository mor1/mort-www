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
    copyright: Html.t;
    sidebar: Html.t;
    trailer: Html.t;
  }

  let render ~config ~body =
    <:html<
      <!-- header -->
      <div class="row">
        <div class="small-12 columns">
          $config.heading$
        </div>
      </div>
      <div class="row top-bar">
        <div class="small-10 small-offset-1 columns"
             data-magellan-expedition="fixed">
          <ul class="sub-nav">
            <li data-magellan-arrival="research">
              <a href="/research">Research</a>
            </li>
            <li data-magellan-arrival="teaching">
              <a href="/teaching">Teaching</a>
            </li>
            <li data-magellan-arrival="me">
              <a href="/me">Me</a>
            </li>
          </ul>
        </div>
      </div>
      <!-- end header -->

      <!-- page body -->
      <div class="row">
        <div class="small-8 small-offset-1 columns" role="content">
          $body$
        </div>

        <div class="small-3 columns" role="sidebar">
          $config.sidebar$
        </div>
      </div>
      <!-- end page body -->

      <!-- page footer -->
      <footer class="row">
        <div class="large-12 columns">
          <div class="row">
            <div class="small-12 columns text-right" role="copyright">
              <small>
                <em>Copyright &copy; $config.copyright$</em>
              </small>
            </div>
            <hr />
          </div>
        </div>
      </footer>
      <!-- end page footer -->

      <!-- finally, trailer asset loading -->
      $config.trailer$
      <!-- end trailer -->
    >>

end

let recent_posts feed n =
  let open Blog in
  let entries = List.sort Entry.compare Posts.t in
  let recent =
    let rec subn acc l i = match l, i with
      | _, 0
      | [], _ -> acc

      | h::t, i -> subn (h :: acc) t (i-1)
    in
    subn [] entries n
  in
  recent |> List.rev |> List.map (fun e ->
      Entry.(e.subject, Uri.of_string (permalink feed e))
    )

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

let subtitle s =
  Cow.Html.to_string <:html< $Config.title$ $str:s$ >>

let page ~title ~heading ~copyright ~trailer ~content =
  let content =
    let body = Lwt_unix.run content in
    let sidebar = Blog_template.side_nav (recent_posts Posts.feed 10) in
    let open T in
    let config = { title; heading; copyright; sidebar; trailer } in
    render config body
  in
  Foundation.(page ~body:(body ~title ~headers:[] ~content))

let read_page f = Config.read_store "pages/" f

let teaching () =
  let open Config in
  let title = subtitle " | teaching" in
  let trailer = trailer @ syntax_highlighting in
  let content = read_page "teaching.md" in
  page ~title ~heading ~copyright ~trailer ~content

let me () =
  let open Config in
  let title = subtitle " | me" in
  let trailer = trailer @ syntax_highlighting in
  let content = read_page "me.md" in
  page ~title ~heading ~copyright ~trailer ~content

let research () =
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
  let title = subtitle " | research" in
  let content = read_page "research.md" in
  page ~title ~heading ~copyright ~trailer ~content

let posts () =
  let open Config in
  let content = Blog.to_html Posts.feed Posts.t in
  let trailer = trailer @ syntax_highlighting in
  let title = subtitle " | blog" in
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
  let title = subtitle (" | blog | " ^ entry.Entry.subject) in
  page ~title ~heading ~copyright ~trailer ~content

let feed () =
  let open Config in
  let feed = Lwt_unix.run (Blog.to_atom Posts.feed Posts.t) in
  Xml.to_string (Atom.xml_of_feed feed)
