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

open Mirage

let kv_ro_of dir =
  let mode =
    (** set Unix `FS_MODE` to fat for FAT and block device storage; anything
        else gives crunch static filesystem
    *)
    try (
      match String.lowercase (Unix.getenv "FS_MODE") with
      | "fat" -> `Fat
      | _     -> `Crunch
    ) with Not_found -> `Crunch
  in
  let fat_ro dir = kv_ro_of_fs (fat_of_files ~dir ()) in
  match mode with
    | `Fat -> fat_ro ("../store/" ^ dir)
    | `Crunch -> crunch ("../store/" ^ dir)

let server =
  let ipaddr =
    let open Site_config in
    let i s = Ipaddr.V4.of_string_exn s in
    Mirage.IPv4 { address = i "46.43.42.137";
                  netmask = i "255.255.255.128";
                  gateway = [i "46.43.42.129"];
                }
  in
  http_server Site_config.port (ipaddr [tap0])

let main =
  let packages = ["cow"; "cowabloga"] in
  let libraries = ["cow.syntax"; "cowabloga"] in
  foreign ~libraries ~packages "Server.Main"
    (console @-> http
     @-> kv_ro @-> kv_ro @-> kv_ro @-> kv_ro @-> kv_ro @-> kv_ro
     @-> job)

let () =
  register "mort-io" [
    main $ default_console $ server $ (kv_ro_of "assets")
    $ (kv_ro_of "pages")
    $ (kv_ro_of "posts")
    $ (kv_ro_of "courses")
    (* XXX hack for now, until FAT32 supported; pr could perhaps use the mux
       combinator? *)
    $ (kv_ro_of "papers")
    $ (kv_ro_of "big-pdfs")
  ]
