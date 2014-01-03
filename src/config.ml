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

let (|>) x f = f x

let mode =
  (** set Unix `FS_MODE` to fat for FAT and block device storage; anything else
      gives crunch static filesystem
  *)
  try (
    match String.lowercase (Unix.getenv "FS_MODE") with
    | "fat" -> `Fat
    | _     -> `Crunch
  ) with Not_found -> `Crunch

let fs_drivers = function
  | `Crunch ->
    let open KV_RO in
    [ { name = "assets"; dirname = "../store/assets" };
      { name = "papers";   dirname = "../store/papers"   };
      { name = "pages";  dirname = "../store/pages"  };
      { name = "posts";  dirname = "../store/posts"  };
    ]
    |> List.map (fun kvro -> Driver.KV_RO kvro)

  | `Fat ->
    let open Block in
    [ { name = "assets"; filename = "assets.img"; read_only = true };
      { name = "papers"; filename = "papers.img"; read_only = true };
      { name = "pages";  filename = "pages.img";  read_only = true };
      { name = "posts";  filename = "posts.img";  read_only = true };
    ]
    |> List.map (fun b ->
        Driver.Fat_KV_RO { Fat_KV_RO.name = b.name; block = b }
      )

let http =
  Driver.HTTP {
    HTTP.port = 80;
    address = None;
    ip = IP.local Network.Tap0;
  }

let () =
  add_to_opam_packages ["cow"; "cowabloga"];
  add_to_ocamlfind_libraries ["cow.syntax"; "cowabloga"];

  Job.register [
    "Unikernel.Main", [Driver.console; http] @ (fs_drivers mode)
  ]
