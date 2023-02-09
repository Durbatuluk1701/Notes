Require Import String.
From QuickChick Require Import QuickChick.
Open Scope string_scope.

Local Instance showBool : Show bool := 
{
  show := fun b : bool => if b then "true" else "false"
}.

Local Instance showBool' : Show bool.
constructor; intros b; destruct b eqn:B.
- (* b = true *) apply "true".
- (* b = false *) apply "false".
Defined.

Local Instance showStr : Show string.
constructor. intros s; apply s.
Defined.

(* NOTE:
  This is copied directly from Software Foundations 
  in Volume 4 QuickChick > Typeclasses chapter 
*)
Fixpoint string_of_nat_aux (time n : nat) (acc : string) : string :=
  let d := match (Nat.modulo n 10) with
           | 0 => "0" | 1 => "1" | 2 => "2" | 3 => "3" | 4 => "4" | 5 => "5"
           | 6 => "6" | 7 => "7" | 8 => "8" | _ => "9"
           end in
  let acc' := d ++ acc in
  match time with
    | 0 => acc'
    | S time' =>
      match (Nat.div n 10) with
        | 0 => acc'
        | n' => string_of_nat_aux time' n' acc'
      end
  end.
Definition string_of_nat (n : nat) : string :=
  string_of_nat_aux n n "".

Local Instance showNat : Show nat :=
{
  show := string_of_nat
}.

Compute (show true).
Compute (show "hello").
Compute (show 103).

(* Notice here that we can make this function completely arbitrary,
for any type A, so long as it has an instance of Show associated with it

The "`" mark allow for Coq to automatically search for and place in the corresponding Show Typeclass for A *)
Definition show_class_constraint {A : Type} `{HShow : Show A} (a : A) : string :=
  "The value for the argument is '" ++ show a ++ "'".

Compute (show_class_constraint 42).

(** QuickChick *)
Conjecture nat_lte_true : forall n : nat, n <= n.

QuickChick nat_lte_true.


(** Summary **)

Inductive Tree (A : Type) :=
| Leaf : Tree A 
| Node : A -> Tree A -> Tree A -> Tree A.
Arguments Leaf {A}.
Arguments Node {A} _ _ _.

Inductive Plc :=
| Plc_Str : string -> Plc
| Plc_nat : nat -> Plc.

Fixpoint longest_depth {A : Type} (t : Tree A) : nat :=
  match t with
  | Leaf => 0
  | Node a tl tr => 
      let l_depth := longest_depth tl in
      let r_depth := longest_depth tr in
      if (Nat.leb l_depth r_depth) then r_depth else l_depth
  end.

Conjecture all_trees_depth : forall (p : Plc) (tl tr : Tree Plc),
  longest_depth tl < longest_depth (Node p tl tr).

(*
This is the chain of commands we needed to derive necessary typeclasses
*)
Derive Arbitrary for ascii.
Derive Arbitrary for string.
Derive Show for Plc.
Derive Arbitrary for Plc.
Derive Show for Tree.
Derive Arbitrary for Tree.

(* Set Typeclasses Debug. *)
QuickChick all_trees_depth.
