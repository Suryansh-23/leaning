# Unit 7: AMM Economic Properties

## Purpose

- Define net worth, gain, and oracle-relative valuation for AMM positions
- Prove `gain_direction`: a profitable swap implies the reverse is not profitable
- Derive `arbitrage_solve`: the closed-form optimal trade size for constant-product
  vs an external oracle price
- Frame rational actor analysis — the lens for adversarial reasoning in Unit 9

## Why it matters

Arbitrage safety and price-impact bounds are the core economic guarantees of any
AMM. `gain_direction` is the formal statement that AMMs don't hand out free money
to round-tripping arbitrageurs. `arbitrage_solve` connects the abstract SX math
to a concrete number a bot would compute. Both proof shapes reappear in Unit 9
when proving fee adequacy for stableswap.

## Key definitions (from lean4-amm)

```lean
-- Oracle: external price per token (PReal-valued, exogenous)
def O := T → ℝ>0

-- LP token price: pro-rata share of reserves at oracle prices
noncomputable def Γ.mintedprice (s : Γ) (o : O) (t0 t1 : T) : ℝ≥0 :=
  if h : s.amms.init t0 t1 then
    (r0 * o t0 + r1 * o t1) / s.mints.supply t0 t1
  else 0

-- Net worth of account a at prices o in state s
noncomputable def Γ.networth (s : Γ) (a : A) (o : O) : ℝ≥0 :=
  W₀.worth (s.atoms.get a) o + W₁.worth (s.mints.get a) (s.mintedprice o)

-- Gain from state s to s' (signed real)
noncomputable def A.gain (a : A) (o : O) (s s' : Γ) : ℝ :=
  (s'.networth a o : ℝ) - (s.networth a o : ℝ)
```

## Typical theorem families

- `gain_direction` — `gain(swap) > 0 → gain(reverse_swap) < 0`
  (Theorem 6.2 in lean4-amm paper; the key "no free lunch" result)
- `exchrate_vs_oracle` — if AMM rate ≥ oracle rate before swap, then after
  the swap the reverse rate is below the oracle (Lemma 6.1)
- `swaprate_vs_exchrate_gt` / `_lt` — connecting gain sign to rate comparison
- `arbitrage_solve` — closed-form `x* = sqrt(p1/p0 · r0 · r1) - r0`
  using `PReal.sqrt`; verified via `optimality_suff`
- `rev_gain` — `gain(inverse swap) = -gain(forward swap)`
- `mintedprice_reorder` — LP price is symmetric in t0, t1

## Connects to

- Unit 3: gain comparison has the same logical shape as second-price utility
  case splits — win/lose branches, signed arithmetic, omega closes
- Unit 6: all results follow from `SX.outputbound` and `SX.reversible`;
  no new SX axioms are introduced here
- Unit 9: `gain_direction` applies to stableswap once its SX properties are
  proved; fee adequacy is `gain_direction` under fee-adjusted SX

## Reference material

Key files in `.context/lean4-amm/`:
- `AMMLib/State/Networth.lean` — `Γ.mintedprice`, `Γ.networth`, `A.gain`
- `AMMLib/Transaction/Swap/Constprod.lean` — `gain_direction` (lines 160-182),
  `optimality_suff`, `arbitrage_solve`, `exchrate_vs_oracle`
- `HelpersLib/PReal/Sqrt.lean` — `PReal.sqrt` and its algebraic properties
  (used in `arbitrage_solve`)

Papers in `.context/papers/`:
- `lean4-amm-pusceddu-bartoletti-2024.pdf` — Section 6 covers gain_direction
  and arbitrage_solve with full proof sketches (arXiv 2402.06064)
- `lean4-amm-fees-bartoletti-2025.pdf` — Section 4 extends gain_direction to
  fee-bearing constprod; the proof structure is essentially identical
  (arXiv 2602.00101)
