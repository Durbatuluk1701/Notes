Require Import String.
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