# Unit 5: Finsupp Ledgers

## Purpose

- Model token balances as `Finsupp T NNReal` (finitely-supported maps from
  token type to non-negative real), directly matching lean4-amm's `W₀` design
- Prove add/sub correctness, key-independence, and conservation
- Build the account-indexed wallet set `A →₀ (T →₀ NNReal)` used in Unit 6

## Why it matters

Finsupp is the right abstraction for sparse token balances: zero is the default,
only non-zero entries need storage, and `Finsupp.sum` gives the total supply
directly. Every proof pattern here — key independence, sum conservation,
drain/restore — reappears in every subsequent unit that touches state.

## Typical theorem families

- `get_add_self`, `get_add_diff` — reading back after update at same/different key
- `get_sub_self`, `get_sub_diff` — symmetric for subtraction
- `drain_comm` — draining two tokens commutes (order independence)
- `worth_destruct` — total value = value at token t + value at all others
- conservation: `w.worth o` unchanged under transfer between accounts
- untouched-key: adding to token A leaves token B's balance unchanged

## Key Lean/Mathlib surfaces

- `Finsupp` (`T →₀ ℝ≥0`) — `Mathlib.Data.Finsupp.Defs`
- `Finsupp.update` — sets a key's value
- `Finsupp.erase` — sets a key to zero (drain pattern)
- `Finsupp.sum` — aggregates over non-zero entries (total supply / worth)
- `Finsupp.add_sum_erase'` — decompose sum around a single key
- `Sym2` (`Mathlib.Data.Sym.Sym2`) — unordered pairs for token-pair AMM keys
- `Decidable.byCases` — case splitting on decidable propositions

## Reference material

**lean4-amm** implements this layer as `W₀` (atomic token wallet) and `W₁`
(minted LP token wallet). The file structure maps directly to Unit 5's scope:

Key files in `.context/lean4-amm/`:
- `AMMLib/State/AtomicWall.lean` — `W₀ = T →₀ ℝ≥0`; `add`, `sub`, `drain`,
  `worth` definitions and their simp lemmas; `drain_comm`; `worth_destruct`
- `AMMLib/State/AtomicWallSet.lean` — `W₀` indexed by account (`A →₀ W₀`);
  `get`, `sub`, `add` on the account-indexed set
- `HelpersLib/Finsupp2.lean` — helper lemmas for `Finsupp` operations not in
  Mathlib (e.g., `update_zero_eq_erase`)
- `AMMLib/State/Tokens.lean` — `T` (token type) and `A` (account type)
  as opaque types with `DecidableEq`

Papers in `.context/papers/`:
- `lean4-amm-pusceddu-bartoletti-2024.pdf` — Section 3.1 describes the `W₀`
  design and why Finsupp is preferred over a list or map (arXiv 2402.06064)
- `coq-dex-nielsen-2023.pdf` — the ConCert framework uses a similar balance
  map design for the Dexter2 formalization; comparison is instructive
  (arXiv 2203.08016)
