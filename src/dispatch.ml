
let dispatch req cpts =
  let uri = Request.uri req in
  let path = Uri.path uri in
  log "# path:'%s'\n%!" path;

  let cpts = Re_str.(split (regexp "/") path) in
  match List.filter (fun e -> e <> "") cpts with
  | [] | [ "blog" ] ->
    respond_string ~status:`OK ~body:(Page.posts ()) ()

  | [ "blog"; "atom.xml" ] ->
    respond_string ~status:`OK ~body:(Page.feed ()) ()

  | "blog" :: tl ->
    respond_string ~status:`OK ~body:(Page.post path ()) ()

  | [ "research" ] ->
    respond_string ~status:`OK ~body:(Page.research ()) ()

  | [ "teaching" ] ->
    respond_string ~status:`OK ~body:(Page.teaching ()) ()

  | [ "me" ] ->
    respond_string ~status:`OK ~body:(Page.me ()) ()

  | _ ->
    let fname = resolve_file ~docroot:"store" ~uri in
    respond_file ~fname ()
