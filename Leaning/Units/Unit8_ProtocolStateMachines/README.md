# Unit 8: LP Mechanics

## Purpose

- Model `Create`, `Deposit`, and `Redeem` as typed state transitions on `Γ`
- Prove LP token minting and burning preserve supply and reserve invariants
- Derive LP token pricing: `(r0·p0 + r1·p1) / supply`
- Establish lifecycle invariants across the full create/deposit/swap/redeem arc

## Why it matters

LP mechanics are the other half of AMM correctness beyond the swap kernel.
Supply conservation and pro-rata pricing are the formal basis for the "fair
value" guarantee that LPs receive when they exit. These invariants are directly
comparable to those proved in lean4-amm and are the preconditions needed for the
stableswap capstone in Unit 9 (deposit/redeem rules change under stableswap
because D must be recomputed after each liquidity event).

## Transaction structure (from lean4-amm)

Each transaction is a **proof-carrying data structure**: the `structure` fields
are both parameters and precondition proofs. `apply` produces the new `Γ`.

```lean
structure Create (s : Γ) (t0 t1 : T) (a : A) (v0 v1 : ℝ>0) where
  hdif  : t0 ≠ t1              -- valid pair
  hnin  : ¬s.amms.init t0 t1  -- AMM doesn't exist yet
  hen0  : v0 ≤ s.atoms.get a t0
  hen1  : v1 ≤ s.atoms.get a t1

structure Deposit (s : Γ) (a : A) (t0 t1 : T) (v0 : ℝ>0) where
  exi     : s.amms.init t0 t1
  possupp : 0 < s.mints.supply t0 t1   -- LP tokens in circulation
  hen0    : v0 ≤ s.atoms.get a t0
  hen1    : v0 * r0 / supply ≤ s.atoms.get a t1  -- proportional t1 required

structure Redeem (s : Γ) (a : A) (t0 t1 : T) (v : ℝ>0) where
  exi     : s.amms.init t0 t1
  hen0    : v ≤ (s.mints.get a).get t0 t1        -- enough LP tokens
  nodrain : v < s.mints.supply t0 t1             -- can't redeem 100%
```

## Typical theorem families

- `Deposit.v` — minted LP amount = `v0 * supply / r0` (proportional to deposit)
- `Deposit.v1` — required t1 deposit = `v0 * r0 / supply` (reserves ratio)
- `Redeem.gain0_lt_r0`, `gain1_lt_r1` — each redeem receives strictly less than
  the full reserve (follows from `nodrain < supply`)
- `supply_conservation` — total LP supply increases by exactly `Deposit.v`
  and decreases by exactly `v` on redeem
- `mintedprice_stable` — LP token price is preserved across balanced deposit
- `lifecycle_init` — after `Create.apply`, `s.amms.init t0 t1` holds
- `lifecycle_uninit_diff` — Create/Deposit/Redeem on {t0,t1} don't affect
  {t0',t1'} when the pairs are different

## Connects to

- Unit 5: the `Finsupp` add/sub/drain patterns from Unit 5 are exactly what
  `Create.apply`, `Deposit.apply`, and `Redeem.apply` use internally
- Unit 6: pool reserves (`AMMs.r0`, `AMMs.r1`) are the objects being updated;
  `AMMs.add_r0`, `AMMs.sub_r1` etc. are the internal operations
- Unit 7: `mintedprice` is defined in Unit 7 and used here for LP fair-value
- Unit 9: stableswap deposit/redeem requires recomputing D; the transaction
  structure pattern from this unit is reused directly

## Reference material

Key files in `.context/lean4-amm/`:
- `AMMLib/Transaction/Create.lean` — `Create` structure and `Create.apply`;
  `init_same`, `init_diff_iff` simp lemmas
- `AMMLib/Transaction/Deposit.lean` — `Deposit` structure; `Deposit.v`,
  `Deposit.v1` (LP mint amount and t1 deposit); `Deposit.apply`
- `AMMLib/Transaction/Redeem.lean` — `Redeem` structure; `Redeem.gain0`,
  `Redeem.gain1` (pro-rata reserve shares); `gain0_lt_r0`, `gain1_lt_r1`;
  `Redeem.apply`
- `AMMLib/State/Supply.lean` — `S₁.supply`, `S₁.get_pos_imp_supp_pos`;
  supply accounting for LP tokens
- `AMMLib/Transaction/Trace.lean` — reachable state definition over a sequence
  of transactions; lifecycle invariants over full traces

Papers in `.context/papers/`:
- `lean4-amm-pusceddu-bartoletti-2024.pdf` — Section 3.2 defines the state
  structure; Section 4 covers Create/Deposit/Redeem transactions
  (arXiv 2402.06064)
- `coq-dex-nielsen-2023.pdf` — the ConCert formalization covers analogous
  `add_liquidity` and `remove_liquidity` entrypoints for Dexter2; comparison
  highlights the Lean 4 vs Coq/ConCert tradeoffs (arXiv 2203.08016)
