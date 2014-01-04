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

let subtitle s =
  Cow.Html.to_string <:html< $Site.Config.title$ | $str:s$ >>

let render
      ?title
      ?(heading=Site.Config.heading)
      ?(copyright=Site.Config.copyright)
      ?(headers=[])
      ?(highlight=false)
      ?sidebar
      ?trailer
      body
  =
  let title = match title with
    | None -> Cow.Html.to_string Site.Config.title
    | Some t -> t
  in
  let sidebar = match sidebar with None -> <:html< >> | Some h -> h in
  let trailer = match trailer with None -> <:html< >> | Some h -> h in

  let navbar =
    <:html<
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
    >>
  in

  let content =
    <:html<
      <!-- header -->
      <div class="row top-bar">
        <div class="small-10 small-offset-1 columns"
             data-magellan-expedition="fixed">
          $navbar$
        </div>
      </div>
      <!-- end header -->

      <div class="row">
        <div class="small-11 small-offset-1 columns" role="heading">
          <h1>$heading$</h1>
        </div>
      </div>

      <!-- page body -->
      <div class="row">
        <div class="small-8 small-offset-1 columns" role="content">
          $body$
        </div>

        <div class="small-3 columns" role="sidebar">
          $sidebar$
        </div>
      </div>
      <!-- end page body -->

      <!-- page footer -->
      <footer class="row">
        <div class="large-12 columns">
          <div class="row">
            <div class="small-12 columns text-right" role="copyright">
              <small>
                <em>Copyright &copy; $copyright$</em>
              </small>
            </div>
            <hr />
          </div>
        </div>
      </footer>
      <!-- end page footer -->

      <!-- finally, trailer asset loading -->
      $trailer$
      <!-- end trailer -->
    >>
  in
  let highlight =
    if highlight then Some "/css/highlight/solarized_light.css" else None
  in
  let body = Foundation.body ?highlight ~title ~headers ~content () in
  Foundation.page ~body

let posts readf =
  let title = subtitle "blog" in
  lwt body =
    let feed = Posts.feed (fun name -> readf ~name) in
    Blog.to_html feed Posts.t
  in
  return (render ~title ~highlight:true body)

let feed readf =
  lwt feed =
    let feed = Posts.feed (fun name -> readf ~name) in
    Blog.to_atom feed Posts.t
  in
  return (Xml.to_string (Atom.xml_of_feed feed))

let post readf path =
  let entry = List.find (fun e -> e.Blog.Entry.permalink = path) Posts.t in
  let title = subtitle (" | blog | " ^ entry.Blog.Entry.subject) in
  lwt body =
    let feed = Posts.feed (fun name -> readf ~name) in
    Blog.Entry.to_html ~feed ~entry
  in
  return (render ~title ~highlight:true body)

let static readf page =
  let title = subtitle page in
  let heading = <:html< $str:(String.capitalize page)$ >> in
  lwt body = readf ~name:(page ^ ".md") in
  return (render ~title ~heading body)

let research readf =
  let trailer =
    let jss = List.map
                (fun js ->
                   let js = "/papers/js/" ^ js in
                   <:html< <script src=$str:js$> </script> >>
                )
                [ "jquery-1.9.1.min.js"; "papers.js"; "load-papers.js" ]
    in
    <:html< $list:jss$ >>
  in
  let title = subtitle "research" in
  lwt body = readf ~name:"research.md" in
  return (render ~title ~trailer body)


(*

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

*)
