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
  let content =
    <:html<
      <!-- header -->
      <div class="row">
        <div class="small-12 columns">
          $heading$
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
  let body = Foundation.body
               ~highlight:"/css/highlight/solarized_light.css"
               ~title ~headers ~content
               ()
  in
  Foundation.page ~body

let static readf page =
  let title = subtitle page in
  let heading = <:html< $str:page$ >> in
  lwt md = readf ~name:(page ^ ".md") in
  let body = Cow.Markdown.of_string md in
  return (render ~title ~heading body)

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

(*

let read_page f = return <:html< <p>read_page $str:f$</p> >> (*  Config.read_store "pages/" f *)


let teaching () =
  let open Site in
  let title = subtitle " | teaching" in
  let trailer = trailer @ syntax_highlighting in
  let content = read_page "teaching.md" in
  let heading = <:html< teaching >> in
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
  let open Site in
  let title = subtitle " | research" in
  let content = read_page "research.md" in
  page ~title ~heading ~copyright ~trailer ~content

let posts () =
  let open Site in
  let content = return <:html< blog_posts >> (* Blog.to_html Posts.feed Posts.t *) in
  let trailer = trailer @ syntax_highlighting in
  let title = subtitle " | blog" in
  page ~title ~heading ~copyright ~trailer ~content

let post path () =
  let open Site in
  let open Blog in
  let entry = List.find (fun e -> e.Entry.permalink = path) Posts.t in
  let content =
    lwt content = return <:html< posts_feed_content >> in (* Posts.feed.read_entry  entry.Entry.body in *)
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

(*
let feed () =
  let open Config in
  let feed = Lwt_unix.run (Blog.to_atom Posts.feed Posts.t) in
  Xml.to_string (Atom.xml_of_feed feed)
*)
*)
