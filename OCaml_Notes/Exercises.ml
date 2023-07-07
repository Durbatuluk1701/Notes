(* Tail of a List *)

let rec last l =
  match l with
  | [] -> None
  | h :: [] -> Some h
  | _ :: t -> (last t);;

assert (last ["a" ; "b" ; "c" ; "d"] = Some "d");;

assert (last [] = None);;

(* Last Two Elements of a List *)

let rec last_two l =
  match l with
  | [] -> None
  | h1 :: h2 :: [] -> Some (h1, h2)
  | _ :: t -> (last_two t);;

assert (last_two ["a"; "b"; "c"; "d"] = Some ("c", "d"));;
assert (last_two ["a"] = None);;
assert (last_two [] = None);;

(* N'th element of a list *)

let rec nth l ind =
  match l with
  | [] -> None
  | h :: t ->
      if (ind = 0) then (Some h) else (nth t (ind - 1));;

assert (nth ['a'; 'b'; 'c'; 'd'; 'e'] 2 = Some 'c');;
assert (nth ['a'] 2 = None);;

(* Length of a list *)
let rec len l =
  match l with
  | [] -> 0
  | h :: t -> 1 + len t;;

assert (len ['a'; 'b'; 'c'] = 3);;
assert (len ['a'] = 1);;
assert (len [] = 0);;

(* Reverse a list *)
let rec rev l =
  match l with
  | [] -> []
  | h :: t -> rev t @ [h];;

assert (rev ['a'; 'b'; 'c'] = ['c'; 'b'; 'a']);;
assert (rev [] = []);;

(* Palindrome *)
let is_palindrome l = (l = rev l);;

assert (is_palindrome ['a'; 'b'; 'c'; 'b'; 'a'] = true);;
assert (is_palindrome ['a'; 'b'] = false);;
assert (is_palindrome [] = true);;

(* Flatten a List *)
type 'a node =
  | One of 'a 
  | Many of 'a node list

let rec flatten (nl : 'a node list) =
  match nl with
  | [] -> []
  | h :: t ->
      (match h with
      | One h -> [h]
      | Many l -> flatten l) @ (flatten t);;

assert (flatten [One "a"; Many [One "b"; Many [One "c" ;One "d"]; One "e"]] = ["a"; "b"; "c"; "d"; "e"]);;
assert (flatten [One "a"; One "b"; Many [Many [Many [One "c"]]]] = ["a"; "b"; "c"]);;

(* Eliminate Duplicates *)
exception Excn of string;;

let tail l = 
  match l with
  | [] -> raise (Excn "Cannot take tail of []")
  | h :: t -> t;;

let head l =
  match l with
  | [] -> raise (Excn "Cannot take head of []")
  | h :: t -> h;;

let rec compress' l cur =
  match l with
  | [] -> [cur]
  | h :: t ->
      if (h = cur)
      then (compress' t cur)
      else [cur] @ (compress' t h);;

let compress l =
  if (l = [])
  then []
  else (compress' (tail l) (head l));;

assert (compress ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"] = ["a"; "b"; "c"; "a"; "d"; "e"]);;
assert (compress [] = []);;

(* Pack Consecutive Duplicates *)
let rec pack l =
  match l with
  | [] -> []
  | h :: t ->
    match t with
    | [] -> [h]
    | h' :: t' ->
        if (h = h') then 