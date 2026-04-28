import Mathlib.Tactic
import Leaning.Units.Unit4_ArithmeticAndBounds.Core

/-!
Unit 5 scratch surface: Finsupp Ledgers.

Unit 4 gave us the numeric layer: `NNReal` and `PReal`.
Unit 5 moves from numbers to sparse keyed state: token balances, wallet updates,
and untouched-key reasoning.
-/

namespace Unit5.KeyedLedgers

open NNReal

/-!
## Session 16: token wallets as sparse keyed ledgers

### Unit progress

Unit 5 is just starting: roughly 0-10% complete. This session builds the
smallest useful wallet layer: a finite-support token balance map plus the local
readback facts for deposit, withdraw, and drain.

### Why this session is next

AMMs are state machines over balances. Unit 6 will need reserves and user
wallets that behave like sparse maps: every token has a balance, almost all
tokens are implicitly zero, and updates at one token must not affect another.

### Prerequisite roundup

New tools and patterns:

- `α →₀ β` is `Finsupp α β`.
  Read it as a finitely-supported function from keys `α` to values `β`.
  Here, keys are tokens and values are `NNReal` balances.

- Finsupp application looks like function application.
  If `w : Token →₀ NNReal` and `t : Token`, then `w t` is the balance of token
  `t`. If `t` is not explicitly stored, this returns `0`.

- `Finsupp.update w t x` changes one key.
  The important simplification rule is:
  `(w.update t x) t' = if t' = t then x else w t'`.
  Same-key goals usually close with `simp [definition]`; different-key goals
  usually need the inequality proof in the right orientation.

- `Finsupp.erase t w` sets key `t` to zero.
  This is the drain pattern: it removes a token balance while preserving all
  other token balances.

- `[DecidableEq Token]` is required for keyed updates.
  Lean needs to decide whether `t' = t` when evaluating an updated map.

- Use theorem names to state the contract.
  `get_deposit_self` says what happens at the updated key.
  `get_deposit_diff` says all other keys are untouched.

### Hint policy

Start with `simp [Wallet.deposit]` or `simp [Wallet.withdraw]`.
If a different-key theorem does not close, inspect whether Lean has `t ≠ t'`
but the simplifier wants `t' ≠ t`.
-/

variable (Token : Type) [DecidableEq Token]

abbrev Wallet : Type :=
  Token →₀ NNReal

namespace Wallet

variable {Token : Type} [DecidableEq Token]

-- Exercise 1.
-- Add `amount` to token `t`.
-- Think: update the current balance at `t` to `w t + amount`.
noncomputable def deposit (w : Wallet Token) (t : Token) (amount : NNReal) : Wallet Token :=
  w.update t (w t + amount)

-- Exercise 2.
-- Reading the same key after deposit gives old balance plus amount.
theorem get_deposit_self (w : Wallet Token) (t : Token) (amount : NNReal) :
    (deposit w t amount) t = w t + amount := by
  simp[deposit]

-- Exercise 3.
-- Reading a different key after deposit gives the old balance.
theorem get_deposit_diff (w : Wallet Token) (t t' : Token) (amount : NNReal) (h : t' ≠ t) :
    (deposit w t amount) t' = w t' := by
  simp[deposit, Function.update, h]

-- Exercise 4.
-- Withdraw `amount` from token `t`.
-- The proof argument records the economic precondition, even though NNReal
-- subtraction is total. You may not need to use the proof yet.
noncomputable def withdraw (w : Wallet Token) (t : Token) (amount : NNReal) (_h : amount ≤ w t) : Wallet Token :=
  w.update t (w t - amount)

-- Exercise 5.
-- Reading the same key after withdrawal gives old balance minus amount.
theorem get_withdraw_self (w : Wallet Token) (t : Token) (amount : NNReal) (h : amount ≤ w t) :
    (withdraw w t amount h) t = w t - amount := by
  simp[withdraw]

-- Exercise 6.
-- Reading a different key after withdrawal gives the old balance.
theorem get_withdraw_diff (w : Wallet Token) (t t' : Token) (amount : NNReal) (h : amount ≤ w t) (hdiff : t' ≠ t) :
    (withdraw w t amount h) t' = w t' := by
  simp[withdraw, Function.update, hdiff]

-- Exercise 7.
-- Drain token `t`, setting its balance to zero.
noncomputable def drain (w : Wallet Token) (t : Token) : Wallet Token :=
  w.update t 0

-- Exercise 8.
-- Reading the drained key gives zero.
theorem get_drain_self (w : Wallet Token) (t : Token) :
    (drain w t) t = 0 := by
  simp[drain]

-- Exercise 9.
-- Reading any other key after drain gives the old balance.
theorem get_drain_diff (w : Wallet Token) (t t' : Token) (h : t' ≠ t) :
    (drain w t) t' = w t' := by
  simp[drain, Function.update, h]

-- Exercise 10.
-- Stretch: updates at distinct tokens commute for deposits.
-- This is the first local "independent keys commute" state-machine theorem.
theorem deposit_comm_diff (w : Wallet Token) (t0 t1 : Token) (x0 x1 : NNReal) (h : t0 ≠ t1) :
    deposit (deposit w t0 x0) t1 x1 =
      deposit (deposit w t1 x1) t0 x0 := by
  ext t
  by_cases ht0 : t = t0
  ·  simp[deposit, ht0, h]
  · by_cases ht1 : t = t1
    · simp_all[deposit]
    · simp[deposit, ht0, ht1]

/-!
## Session 17: wallet worth and sum decomposition

### Unit progress

Unit 5 is roughly 25% complete. You have the local keyed-update API now:
deposit, withdraw, drain, and independent-key commutation. This session adds
the aggregate layer: valuing a sparse wallet by summing each balance times a
price.

### Why this session is next

Unit 6 and later AMM proofs care about both local balances and aggregate value.
The new proof shape is "one key plus the rest of the finite support", which is
how conservation and no-unintended-value-change proofs are usually structured.

### Prerequisite roundup

New tools and patterns:

- `w.sum fun t x => ...` folds over the nonzero entries of a Finsupp.
  The first argument is the key, the second is the stored value at that key.
  For a wallet, `w.sum fun t bal => bal * price t` is total marked-to-market
  value.

- The function passed to `sum` must map zero balances to zero for key-splitting
  lemmas to behave well. For worth, this is just `0 * price t = 0`.

- `Finsupp.add_sum_erase'` is the main decomposition lemma.
  It says a sum over `w` can be split into the contribution at token `t` plus
  the sum over `w.erase t`.

- `Finsupp.update_zero_eq_erase` is not available as a built-in here in the
  exact form we want, so first prove a local bridge:
  updating a key to zero equals erasing that key.

- Conservation proofs usually reduce to two local update facts:
  the sender loses `amount`, the receiver gains `amount`, and every other key
  is unchanged. In this session we stay at the one-wallet worth layer.

### Hint policy

For decomposition, do not unfold into support finsets manually unless you are
stuck. First try the named Finsupp lemma. If the direction is opposite, use
`rw [← ...]` or commute the final addition.
-/

-- Exercise 11.
-- Define wallet worth under an external price function.
-- `price t` is the value of one unit of token `t`.
noncomputable def worth (w : Wallet Token) (price : Token → NNReal) : NNReal := by
  sorry

-- Exercise 12.
-- Local bridge: updating a token to zero is the same as erasing it.
theorem update_zero_eq_erase (w : Wallet Token) (t : Token) :
    w.update t 0 = w.erase t := by
  sorry

-- Exercise 13.
-- Drain is just erase, by the bridge above.
theorem drain_eq_erase (w : Wallet Token) (t : Token) :
    drain w t = w.erase t := by
  sorry

-- Exercise 14.
-- A drained wallet has zero balance at the drained token as an erase fact.
-- This should be another view of `get_drain_self`.
theorem erase_get_self (w : Wallet Token) (t : Token) :
    (w.erase t) t = 0 := by
  sorry

-- Exercise 15.
-- Worth decomposition: total worth is worth after draining token `t`, plus the
-- contribution of token `t`.
theorem worth_destruct (w : Wallet Token) (price : Token → NNReal) (t : Token) :
    worth w price = worth (drain w t) price + w t * price t := by
  sorry

-- Exercise 16.
-- Deposit increases worth by exactly `amount * price t`.
-- This is the first aggregate effect theorem.
theorem worth_deposit
    (w : Wallet Token) (price : Token → NNReal) (t : Token) (amount : NNReal) :
    worth (deposit w t amount) price = worth w price + amount * price t := by
  sorry

-- Exercise 17.
-- If a withdrawal is allowed, worth decreases by exactly `amount * price t`.
-- NNReal subtraction is truncated, so the affordability hypothesis is part of
-- the economic contract.
theorem worth_withdraw
    (w : Wallet Token) (price : Token → NNReal) (t : Token) (amount : NNReal)
    (h : amount ≤ w t) :
    worth (withdraw w t amount h) price + amount * price t = worth w price := by
  sorry

end Wallet

end Unit5.KeyedLedgers
