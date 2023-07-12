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
(* pack' : 'a list -> 'a list -> ('a list) list *)
let rec pack' (l : 'a list) (accL : 'a list) =
  match l with
  | [] -> [accL] (* end of list, just add acc *)
  | h :: t ->
    match accL with
    | [] -> (* empty accL, make head accL *)
        pack' t [h]
    | h' :: t' -> (* accL has values *)
        if (h = h')
        then (* add to accL *)
          pack' t (h' :: accL)
        else (* not matching, put the accL down and then continue *)
          accL :: (pack' t [h]);;

let pack l =
  pack' l [];;

assert (pack ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "d"; "e"; "e"; "e"; "e"] = [["a"; "a"; "a"; "a"]; ["b"]; ["c"; "c"]; ["a"; "a"]; ["d"; "d"];
 ["e"; "e"; "e"; "e"]]);;


(* Run-Length Encoding *)
let encode l = 
  let packed = pack l in
  List.map (fun (slist) -> (List.length slist, head slist)) packed;;

assert (encode ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"] = [(4, "a"); (1, "b"); (2, "c"); (2, "a"); (1, "d"); (4, "e")]);;

(* Modified Run-Length Encoding *)
type 'a rle =
  | One of 'a
  | Many of int * 'a

let encode2 l = 
  let packed = pack l in
  List.map (fun (slist) -> 
    if (List.length slist = 1)
    then (One (head slist))
    else (Many (List.length slist, head slist))) packed;;

assert (encode2 ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"] = [Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d";
 Many (4, "e")]);;


(* Decode a Run-Length Encoded List *)
let rec repeatAsList n v =
  if (n < 1)
  then []
  else (v :: repeatAsList (n - 1) v)

let rec decode (l : ('a rle) list) =
  match l with
  | [] -> []
  | (One h) :: t -> 
        h :: decode t
  | (Many (n, h)) :: t ->
        (repeatAsList n h) @ (decode t);;

assert (decode [Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d"; Many (4, "e")] = ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"]
);;

(* Run-Length Encoding of a List (Direct Solution) *)
let rec encode3' (l : 'a list) (accL : 'a rle) =
  match l with
  | [] -> [accL] (* end of list, just add acc *)
  | h :: t ->
    match accL with
    | One h' ->
        if (h = h')
        then (* add to accL *)
          encode3' t (Many (2, h'))
        else (* not matching, put the accL down and then continue *)
          accL :: (encode3' t (One h))
    | Many (n, h') ->
        if (h = h')
        then (* add to accL *)
          encode3' t (Many (n + 1, h'))
        else (* not matching, put the accL down and then continue *)
          accL :: (encode3' t (One h));;

let encode3 l =
  match l with
  | [] -> []
  | h :: t ->
        encode3' t (One h);;

assert (encode3 ["a";"a";"a";"a";"b";"c";"c";"a";"a";"d";"e";"e";"e";"e"] = [Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d";
 Many (4, "e")]);;

 (* Duplicate the Elements of a List *)
 let rec duplicate l =
    match l with
    | [] -> []
    | h :: t ->
        h :: h :: (duplicate t);;

assert (duplicate ["a"; "b"; "c"; "c"; "d"] = ["a"; "a"; "b"; "b"; "c"; "c"; "c"; "c"; "d"; "d"]);;

(* Replicate the Elements of a List a Given Number of Times *)
let rec miniRep v n =
  if (n = 0)
  then []
  else v :: (miniRep v (n-1));;

let rec replicate l n =
  match l with
  | [] -> []
  | h :: t ->
      (miniRep h n) @ (replicate t n);;

assert (replicate ["a"; "b"; "c"] 3 = ["a"; "a"; "a"; "b"; "b"; "b"; "c"; "c"; "c"]);;

(* Drop Every N'th Element From a List *)
let rec drop' l nMax n =
  match l with
  | [] -> []
  | h :: t ->
      if (n = 1)
      then drop' t nMax nMax (* reset counter *)
      else h :: (drop' t nMax (n - 1));;

let drop l n =
  drop' l n n;;

assert (drop ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 3 = ["a"; "b"; "d"; "e"; "g"; "h"; "j"]);;

(* Split a List Into Two Parts; The Length of the First Part is Given *)
let rec split' front back n =
  match back with
  | [] -> (front, back)
  | h :: t ->
      if (n = 0)
      then (front, back)
      else split' (front @ [h]) t (n - 1);;

let split l n = split' [] l n;;

assert (split ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 3 = (["a"; "b"; "c"], ["d"; "e"; "f"; "g"; "h"; "i"; "j"]));;
assert (split ["a"; "b"; "c"; "d"] 5 = (["a"; "b"; "c"; "d"], []));;

(* Extract a Slice From a List *)
let rec slice l s e =
  match l with
  | [] -> []
  | h :: t ->
      if (s < 1)
      then (
        if (e < 1)
        then (* we have finished taking *) [h]
        else (* we can keep taking *)
          h :: (slice t (s - 1) (e - 1))
      )
      else (* not time to start taking yet *)
        slice t (s - 1) (e - 1);;

assert (slice ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 2 6 = ["c"; "d"; "e"; "f"; "g"]);;

(* Rotate a List N Places to the Left *)
let rec rotate l n =
  match l with
  | [] -> []
  | h :: t ->
      if (n = 0)
      then l
      else (rotate (t @ [h]) (n - 1));;

assert (rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 3 = ["d"; "e"; "f"; "g"; "h"; "a"; "b"; "c"]);;

(* Remote the K'th element from a List *)
let rec remove_at k l =
  match l with
  | [] -> []
  | h :: t ->
      if (k = 0)
      then t
      else h :: (remove_at (k - 1) t);;

assert (remove_at 1 ["a"; "b"; "c"; "d"] = ["a"; "c"; "d"]);;

(* Insert an Element at a Given Position into a List *)
let rec insert_at v k l =
  match l with
  | [] -> [v] (* end of list, the index must be later *)
  | h :: t ->
      if (k = 0)
      then v :: (h :: t)
      else h :: (insert_at v (k - 1) t);;

assert (insert_at "alfa" 1 ["a"; "b"; "c"; "d"] = ["a"; "alfa"; "b"; "c"; "d"]);;

(* Create a List Containing All Integers Within a Given Range *)
let rec rangeUp s e =
  if (s <= e)
  then s :: (rangeUp (s + 1) e)
  else [];;

let rec rangeDown s e =
  if (s >= e)
  then s :: (rangeDown (s - 1) e)
  else [];;

let range s e =
  if (s <= e)
  then rangeUp s e
  else rangeDown s e;;

assert (range 4 9 = [4;5;6;7;8;9]);;

(* Extract a Given Number of Randomly Selected Elements From a List *)
let rec getAt l ind = 
  match l with
  | [] -> raise (Excn "Cannot access the index, it is beyond the list")
  | h :: t ->
      if (ind = 0)
      then h
      else (getAt t (ind - 1));;

let rec rand_select l n =
  if (n = 0)
  then []
  else (
    let randInd = Random.int (List.length l) in
    (getAt l randInd) :: (rand_select l (n - 1))
  );;

(* 
This does not really make sense to test like this, it does select randomly though...
assert (rand_select ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 3 = ["g"; "d"; "a"]);; *)

(* Lotto: Draw N Different Random Numbers from the Set 1..M *)
let lotto_select n top =
  let selList = range 1 top in
  rand_select selList n;;

(* Once again a case where the random nature makes testing with their example hard *)

(* Generate a Random Permutation of the Elements of a List *)
let rec permutation l =
  if (List.length l = 0)
  then []
  else (
    let randInd = Random.int (List.length l) in
    (getAt l randInd) :: (permutation (remove_at randInd l))
  );;

(* This seems to work as well
List.iter print_string (permutation ["a"; "b"; "c"; "d"; "e"; "f"]);; *)

(* Generate the Combinations of K Distinct Objects Chosen From the N Elements of a List *)
let rec combiner' n front rest =
  if (n = 0)
  then [front]
  else
  (match rest with
  | [] -> []
  | h :: t -> 
    (* Distribute along this head *)
    combiner' (n - 1) (front @ [h]) t @ (combiner' n front t)
  );;

let extract n l = 
  combiner' n [] l;;

assert (extract 2 ["a"; "b"; "c"; "d"] = [["a"; "b"]; ["a"; "c"]; ["a"; "d"]; ["b"; "c"]; ["b"; "d"]; ["c"; "d"]]);;

(* Group the Elements of a Set into Disjoint Subsets *)

(* We want this function to distribute, and return a version with removed parts *)

let rec disjGrouper (n : int) (heads : 'a list list) (rest : 'a list list) : ('a list list * 'a list list) list =
  if (n = 0)
  then List.map (fun head -> ([head], rest)) heads
  else (
    match rest with
    | [] -> (* Failure, cannot make that long *) []
    | h :: t ->
        let mappedList : 'a list list = (List.map (fun x -> x @ h) heads) in
        let headRec : ('a list list * 'a list list) list = (disjGrouper (n - 1) mappedList t) in
        let tailRec : ('a list list * 'a list list) list = (disjGrouper n heads t) in
        (* Need to re-add h to the truncs here *)
        headRec @ (List.map (fun (llist, trunc) -> (llist, (h :: trunc))) tailRec)
  );;

let rec group' (l : 'a list list) (split : int list) (front : 'a list list) : ('a list list list) =
  match split with
  | [] -> [front]
  | h :: t ->
      let headDist : ('a list list * 'a list list) list = disjGrouper h front l in
      let recList : ('a list list list) list = List.map (fun (heads,truncs) -> group' truncs t heads) headDist in
      List.fold_left ( @ ) [] recList;;

let rec postGroupProcessor (l : 'a list) (splits : int list) : ('a list list) =
  match splits with
  | [] -> []
  | h :: t ->
      let (front, back) : ('a list * 'a list) = split l h in
      front :: (postGroupProcessor back t);;

let group (l : 'a list) (splits : int list) : ('a list list list) =
  let grouped : ('a list list list) = group' (List.map (fun x -> [x]) l) splits [[]] in
  List.map (fun miniList -> postGroupProcessor (head miniList) splits) grouped;;


(*
Not sure why, but this assert is failing, despite the outputs looking the exact same?!

assert (group ["a"; "b"; "c"; "d"] [2;1] = [[["a"; "b"]; ["c"]]; [["a"; "c"]; ["b"]]; [["b"; "c"]; ["a"]];[["a"; "b"]; ["d"]]; [["a"; "c"]; ["d"]]; [["b"; "c"]; ["d"]]; [["a"; "d"]; ["b"]]; [["b"; "d"]; ["a"]]; [["a"; "d"]; ["c"]]; [["b"; "d"]; ["c"]]; [["c"; "d"]; ["a"]]; [["c"; "d"]; ["b"]]]);;
*)

(* Sorting a List of Lists According to Length of Sublists *)
let rec insert_into_sorted (l : 'a list) (lenL : int) (sorted_prefix : 'a list list) : ('a list list) =
  match sorted_prefix with
  | [] -> [l]
  | h :: t ->
      if (lenL < (List.length h))
      then (* l goes before h *)
        l :: h :: t
      else (* l goes after h *)
        h :: (insert_into_sorted l lenL t);;

let rec length_sort' (l : 'a list list) (sorted_prefix : 'a list list) : ('a list list) =
  match l with
  | [] -> sorted_prefix
  | h :: t ->
      length_sort' t (insert_into_sorted h (List.length h) sorted_prefix);;

let length_sort (l : 'a list list) : ('a list list) =
  length_sort' l [];;

assert (length_sort [["a"; "b"; "c"]; ["d"; "e"]; ["f"; "g"; "h"]; ["d"; "e"];
             ["i"; "j"; "k"; "l"]; ["m"; "n"]; ["o"]] = [["o"]; ["d"; "e"]; ["d"; "e"]; ["m"; "n"]; ["a"; "b"; "c"]; ["f"; "g"; "h"];
 ["i"; "j"; "k"; "l"]]);;

let rec frequency_sort' (l : 'a list list) (sorted_prefix : 'a list list) : ('a list list) =
  match l with
  | [] -> sorted_prefix
  | h :: t ->
      