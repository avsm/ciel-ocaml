(*
 * Copyright (c) 2011 Anil Madhavapeddy <anil@recoil.org>
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
 *)

open Json

type id = string

type t =
  |Concrete of Json.t
  |Future of string
  |Stream
  |Sweetheart
  |Value of id * string 
  |Completed
  |Empty

let of_tuple = function
  |Array [ String "val"; String k; String v ] -> Value (k, (Base64.decode v))
  |Array ( String "c2" :: tl) as x -> Concrete x
  |Array [ String "f2"; String id ] -> Future id
  |_ -> Empty

let of_json = function
  |Object json -> (try of_tuple (List.assoc "__ref__" json) with Not_found -> Empty)
  |_ -> Empty

let to_json t =
  let j = match t with
    |Value (k,v) -> Array [String "val"; String k; String (Base64.encode v)]
    |Concrete j -> j
    |Future id -> Array [String "f2"; String id]
    |Empty -> Null
    |_ -> failwith "Cannot handle this ref type yet" in
  Object [ "__ref__", j ]

let to_string t = Json.to_string (to_json t)
