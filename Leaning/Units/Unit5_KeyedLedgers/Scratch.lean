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
def deposit (w : Wallet Token) (t : Token) (amount : NNReal) : Wallet Token := by
  sorry

-- Exercise 2.
-- Reading the same key after deposit gives old balance plus amount.
theorem get_deposit_self (w : Wallet Token) (t : Token) (amount : NNReal) :
    (deposit w t amount) t = w t + amount := by
  sorry

-- Exercise 3.
-- Reading a different key after deposit gives the old balance.
theorem get_deposit_diff
    (w : Wallet Token) (t t' : Token) (amount : NNReal) (h : t' ≠ t) :
    (deposit w t amount) t' = w t' := by
  sorry

-- Exercise 4.
-- Withdraw `amount` from token `t`.
-- The proof argument records the economic precondition, even though NNReal
-- subtraction is total. You may not need to use the proof yet.
def withdraw
    (w : Wallet Token) (t : Token) (amount : NNReal) (_h : amount ≤ w t) :
    Wallet Token := by
  sorry

-- Exercise 5.
-- Reading the same key after withdrawal gives old balance minus amount.
theorem get_withdraw_self
    (w : Wallet Token) (t : Token) (amount : NNReal) (h : amount ≤ w t) :
    (withdraw w t amount h) t = w t - amount := by
  sorry

-- Exercise 6.
-- Reading a different key after withdrawal gives the old balance.
theorem get_withdraw_diff
    (w : Wallet Token) (t t' : Token) (amount : NNReal)
    (h : amount ≤ w t) (hdiff : t' ≠ t) :
    (withdraw w t amount h) t' = w t' := by
  sorry

-- Exercise 7.
-- Drain token `t`, setting its balance to zero.
def drain (w : Wallet Token) (t : Token) : Wallet Token := by
  sorry

-- Exercise 8.
-- Reading the drained key gives zero.
theorem get_drain_self (w : Wallet Token) (t : Token) :
    (drain w t) t = 0 := by
  sorry

-- Exercise 9.
-- Reading any other key after drain gives the old balance.
theorem get_drain_diff
    (w : Wallet Token) (t t' : Token) (h : t' ≠ t) :
    (drain w t) t' = w t' := by
  sorry

-- Exercise 10.
-- Stretch: updates at distinct tokens commute for deposits.
-- This is the first local "independent keys commute" state-machine theorem.
theorem deposit_comm_diff
    (w : Wallet Token) (t0 t1 : Token) (x0 x1 : NNReal) (h : t0 ≠ t1) :
    deposit (deposit w t0 x0) t1 x1 =
      deposit (deposit w t1 x1) t0 x0 := by
  sorry

end Wallet

end Unit5.KeyedLedgers
