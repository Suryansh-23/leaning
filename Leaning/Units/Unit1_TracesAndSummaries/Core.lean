import Leaning.Basic

/-!
# Unit 1 Curated Surface

This module mirrors the reducer, trace, and summary material from
`Leaning/Basic.lean` into a stable, namespaced surface for the book.

It intentionally points back to the live scratch file rather than duplicating
all development history.
-/

namespace Leaning.Unit1

abbrev Position := _root_.Position
abbrev safe := _root_.safe
abbrev deposit := _root_.deposit
abbrev repay := _root_.repay
abbrev borrow := _root_.borrow

abbrev totalCollateral := _root_.total_collateral
abbrev totalDebt := _root_.total_debt
abbrev portfolioSafe := _root_.portfolioSafe
abbrev depositAll := _root_.depositAll

abbrev Event := _root_.Event
abbrev applyEvent := _root_.applyEvent
abbrev applyEvents := _root_.applyEvents
abbrev isBorrowFree := _root_.isBorrowFree
abbrev areBorrowFree := _root_.areBorrowFree
abbrev isRepayFree := _root_.isRepayFree
abbrev areRepayFree := _root_.areRepayFree
abbrev depositAmount := _root_.depositAmount
abbrev totalDeposits := _root_.totalDeposits
abbrev borrowAmount := _root_.borrowAmount
abbrev totalBorrows := _root_.totalBorrows
abbrev isBorrow := _root_.isBorrow

theorem totalCollateral_append (xs ys : List Position) :
    totalCollateral (xs ++ ys) = totalCollateral xs + totalCollateral ys :=
  _root_.total_collateral_append xs ys

theorem totalDebt_empty_eq_zero :
    totalDebt [] = 0 :=
  _root_.total_debt_empty_list_zero

theorem totalDebt_cons_eq (p : Position) (ps : List Position) :
    totalDebt (p :: ps) = p.debt + totalDebt ps :=
  _root_.total_debt_recursive p ps

theorem totalDebt_append (xs ys : List Position) :
    totalDebt (xs ++ ys) = totalDebt xs + totalDebt ys :=
  _root_.total_debt_append xs ys

theorem portfolioSafe_nil :
    portfolioSafe [] :=
  _root_.portfolioSafe_nil

theorem portfolioSafe_of_two_safe (p1 p2 : Position) :
    safe p1 -> safe p2 -> portfolioSafe [p1, p2] :=
  _root_.portfolioSafe_of_two_safe p1 p2

theorem totalDebt_depositAll_eq (ps : List Position) (amount : Nat) :
    totalDebt (depositAll ps amount) = totalDebt ps :=
  _root_.total_debt_depositAll ps amount

theorem applyEvents_nil (p : Position) :
    applyEvents p [] = p :=
  _root_.applying_no_event_changes_nothing p

theorem applyEvents_singleton (p : Position) (e : Event) :
    applyEvents p [e] = applyEvent p e :=
  _root_.applying_singleton_event p e

theorem applyEvents_append (p : Position) (xs ys : List Event) :
    applyEvents p (xs ++ ys) = applyEvents (applyEvents p xs) ys :=
  _root_.applyEvents_append p xs ys

theorem deposit_preserves_safety (p : Position) (amount : Nat) :
    safe p -> safe (deposit p amount) :=
  _root_.deposit_safe p amount

theorem borrowFree_trace_preserves_safety (p : Position) (trace : List Event) :
    safe p -> areBorrowFree trace -> safe (applyEvents p trace) :=
  _root_.safe_and_no_borrows_remains_safe p trace

theorem borrowFree_trace_debt_le_start (p : Position) (trace : List Event) :
    areBorrowFree trace -> p.debt >= (applyEvents p trace).debt :=
  _root_.borrow_free_trace_debt_le_start p trace

theorem totalDeposits_append (xs ys : List Event) :
    totalDeposits (xs ++ ys) = totalDeposits xs + totalDeposits ys :=
  _root_.totalDeposits_append xs ys

theorem repayFree_trace_collateral_eq_start_plus_totalDeposits
    (p : Position) (trace : List Event) :
    areRepayFree trace ->
      (applyEvents p trace).collateral = p.collateral + totalDeposits trace :=
  _root_.repay_free_trace_collateral_eq_start_plus_totalDeposits p trace

theorem borrowOnly_trace_debt_eq_start_plus_totalBorrows
    (p : Position) (trace : List Event) :
    trace.all isBorrow -> (applyEvents p trace).debt = p.debt + totalBorrows trace :=
  _root_.trace_with_only_borrows p trace

end Leaning.Unit1
