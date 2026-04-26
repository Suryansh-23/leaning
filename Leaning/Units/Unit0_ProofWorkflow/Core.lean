import Leaning.Basic

/-!
# Unit 0 Curated Surface

This module mirrors the foundational state-transition material from
`Leaning/Basic.lean` into a stable, namespaced surface for the book.

The live scratch file remains authoritative while learning is in motion.
This module exists so later units and docs can point at a cleaner curated
surface without copying the raw session log verbatim.
-/

namespace Leaning.Unit0

abbrev Position := _root_.Position
abbrev health := _root_.health
abbrev safe := _root_.safe
abbrev deposit := _root_.deposit
abbrev repay := _root_.repay
abbrev repayAll := _root_.repayAll
abbrev borrow := _root_.borrow
abbrev borrowIfSafe := _root_.borrowIfSafe

theorem deposit_collateral_eq (p : Position) (amount : Nat) :
    (deposit p amount).collateral = p.collateral + amount :=
  _root_.deposit_increases_collateral p amount

theorem deposit_debt_eq (p : Position) (amount : Nat) :
    (deposit p amount).debt = p.debt :=
  _root_.deposit_debt p amount

theorem repay_collateral_eq (p : Position) (amount : Nat) :
    (repay p amount).collateral = p.collateral :=
  _root_.repay_does_not_change_collateral p amount

theorem repay_debt_eq (p : Position) (amount : Nat) :
    (repay p amount).debt = p.debt - amount :=
  _root_.repay_debt p amount

theorem repay_debt_le_start (p : Position) (amount : Nat) :
    (repay p amount).debt <= p.debt :=
  _root_.repay_monotonicity p amount

theorem repay_preserves_safety (p : Position) (amount : Nat) :
    safe p -> safe (repay p amount) :=
  _root_.repay_safe p amount

theorem repayAll_preserves_safety (p : Position) :
    safe (repayAll p) :=
  _root_.repayAll_safe p

theorem repayAll_debt_eq_zero (p : Position) :
    (repayAll p).debt = 0 :=
  _root_.repayAll_debt p

theorem repayAll_collateral_eq (p : Position) :
    (repayAll p).collateral = p.collateral :=
  _root_.repayAll_collateral p

theorem repayAll_is_idempotent (p : Position) :
    repayAll (repayAll p) = repayAll p :=
  _root_.repayAll_idempotent p

theorem borrow_collateral_eq (p : Position) (amount : Nat) :
    (borrow p amount).collateral = p.collateral :=
  _root_.borrow_does_not_change_collateral p amount

theorem borrow_debt_ge_start (p : Position) (amount : Nat) :
    p.debt <= (borrow p amount).debt :=
  _root_.borrow_increases_debt p amount

theorem borrow_preserves_safety_of_bound (p : Position) (amount : Nat) :
    safe p /\ p.debt + amount <= p.collateral -> safe (borrow p amount) :=
  _root_.borrow_is_safe p amount

theorem borrowIfSafe_preserves_safety (p : Position) (amount : Nat) :
    safe p -> safe (borrowIfSafe p amount) :=
  _root_.borrowIfSafe_is_safe p amount

end Leaning.Unit0
