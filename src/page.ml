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
  Cow.Html.to_string <:html< $Site_config.title$ | $str:s$ >>

let render
      ?title
      ?(heading=Site_config.heading)
      ?(copyright=Site_config.copyright)
      ?(headers=[])
      ?(highlight=false)
      ?sidebar
      ?trailer
      body
  =
  let title = match title with
    | None -> Cow.Html.to_string Site_config.title
    | Some t -> t
  in
  let sidebar = match sidebar with None -> <:html< >> | Some h -> h in
  let trailer = match trailer with None -> <:html< >> | Some h -> h in

  let navbar =
    <:html<
      <li><a href="/blog">blog</a></li>
      <li><a href="/research">research</a></li>
      <li><a href="/teaching">teaching</a></li>
      <li><a href="/codes">codes</a></li>
      <li><a href="/me">me</a></li>
    >>
  in

  let content =
    <:html<
    <div class="fixed">
    <nav class="top-bar hide-for-small" data-topbar="">
      <ul class="title-area">
        <li class="name">
          <h1><a href="/">mort's mythopoeia</a></h1>
        </li>
      </ul>

      <section class="top-bar-section hide-for-small">
        <ul class="left">
          $navbar$
        </ul>
      </section>
    </nav>
    </div>

    <div class="off-canvas-wrap">
      <div class="inner-wrap">
        <div class="fixed">
          <nav class="tab-bar hide-for-medium hide-for-large">
            <section class="left-small">
              <a class="left-off-canvas-toggle menu-icon"><span></span></a>
            </section>
            <section class="right tab-bar-section"></section>
          </nav>
        </div>

        <aside class="left-off-canvas-menu hide-for-medium hide-for-large">
          <ul class="off-canvas-list">
            <li><label>mort's mythopoeia</label></li>
            $navbar$
          </ul>
        </aside>

        <section class="main-section">

          <!-- right sidebar -->
          <div class="row">
            <div class="fixed right-sidebar">
              <div class="small-3 small-offset-9 columns" role="sidebar">
                $sidebar$
              </div>
            </div>
          </div>

          <!-- page heading -->
          <div class="row">
            <div class="small-8 small-offset-1 columns" role="heading">
              $heading$
            </div>
          </div>

          <!-- page body -->
          <div class="row">
            <div class="small-7 small-offset-1 columns" role="content">
              $body$
            </div>
          </div>

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
        </section>

        <!-- close the off-canvas menu -->
        <a class="exit-off-canvas"> </a>

      </div>
    </div>

    <!-- finally, trailer asset loading -->
    $trailer$
    >>
  in
  let highlight =
    if highlight then Some "/css/highlight/solarized_light.css" else None
  in
  let body = Foundation.body ?highlight ~title ~headers ~content () in
  Foundation.page ~body

let sidebar =
  let open Cowabloga.Blog in
  let content =
    let entries = List.sort Entry.compare Posts.t in
    let feed =
      (* since we don't need the content *)
      Posts.feed (fun _ -> return <:html< >>)
    in
    let recent =
      let rec subn acc l i = match l, i with
        | _, 0 | [], _ -> acc
        | h::t, i      -> subn (h :: acc) t (i-1)
      in
      subn [] entries Site_config.sidebar_limit
    in
    (recent |> List.rev |> List.map (fun e ->
         `link (e.Entry.subject, Uri.of_string (Entry.permalink feed e))
       ))
    @ [ `link ("more ...", Uri.of_string "/blog") ]
  in
  Cowabloga.Foundation.Sidebar.t ~title:"Posts" ~content

let scripts root jss =
  let jss = jss
            |> List.map
                 (fun js ->
                    let js = root ^ "/js/" ^ js in
                    <:html< <script src=$str:js$> </script> >>
                 )
  in
  <:html< $list:jss$ >>

let static trailer readf page =
  let title = subtitle page in
  let heading = <:html< >> in
  lwt body = readf ~name:(page ^ ".md") in
  return (render ~title ~trailer ~heading ~sidebar body)

let dispatch unik cpts =
  let log_ok path = unik.Unikernel.log (Printf.sprintf "200 GET %s" path) in
  let path = String.concat "/" cpts in
  let trailer = match cpts with
    | [ "research" ] ->
      scripts "/papers" [ "jquery-1.9.1.min.js"; "papers.js"; "load-papers.js" ]
    | _ -> []
  in
  log_ok path;
  Printf.printf "%s\n%!" (String.concat "; " cpts);
  let p = List.hd cpts in
  Unikernel.(
    unik.http_respond_ok ~headers:Headers.html (static trailer unik.get_page p)
  )
