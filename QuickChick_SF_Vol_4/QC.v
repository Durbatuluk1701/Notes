Require Import String.
From QuickChick Require Import QuickChick.
Open Scope string_scope.

Class Show A : Type :=
{
  show : A -> string
}.

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