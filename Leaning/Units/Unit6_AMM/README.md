# Unit 6: AMM Kernels and the SX Framework

## Purpose

- Define `SX := ℝ>0 → ℝ>0 → ℝ>0 → ℝ>0` — the parametric swap function type
- Prove the full SX property suite for the constant-product instance
  `SX.constprod x r0 r1 = r1 / (r0 + x)`
- Build the AMM pool state: reserves as a constrained `Finsupp` over unordered
  token pairs with symmetry and positivity invariants

## Why it matters

This is the primary formal DeFi artifact of the book. The SX abstraction means
any AMM design is just a new function `ℝ>0 → ℝ>0 → ℝ>0 → ℝ>0` — every theorem
proved about SX in general (Unit 7) and every novel instance (Unit 9) inherits
the same property vocabulary. Calibrated directly against lean4-amm.

## SX property suite

| Property | Statement | Economic meaning |
|---|---|---|
| `outputbound` | `x * sx x r0 r1 < r1` | can't drain the pool |
| `homogeneous` | `sx (a*x) (a*r0) (a*r1) = sx x r0 r1` | scale invariant |
| `reversible` | `∃ y, sx y (r1 - x·sx x r0 r1) (x + r0) = 1/(sx x r0 r1)` | undo-able |
| `additive` | splitting a trade is equivalent to one trade | no arbitrage from splitting |
| `strictmono` | larger trade or smaller r0/r1 → worse rate | price impact |

## AMM pool state structure (`Γ`)

```
Γ = {
  atoms : A →₀ (T →₀ ℝ≥0)   -- per-account token balances (Unit 5)
  mints : A →₀ W₁            -- per-account LP token balances
  amms  : AMMs               -- pool reserves, constrained Finsupp
}
```

`AMMs` enforces: `res t t = 0` (no self-pair), `res t0 t1 ≠ 0 ↔ res t1 t0 ≠ 0`
(symmetry), and `res t0 t1 ≠ 0` implies both entries are `PReal` (positivity).

## Typical theorem families

- `constprod_outputbound` — `x * (r1/(r0+x)) < r1`
- `constprod_homogeneous` — scale invariance via `← mul_add` + `field_simp`
- `constprod_reversible` — inverse swap restores state
- `constprod_additive` — trade splitting lemma (algebraically involved)
- `constprod_strictmono` — rate degrades with trade size and reserve changes
- `AMMs.init`, `AMMs.initialize`, `AMMs.r0`, `AMMs.r1` — pool accessor API
- `Swap` structure — bundles the AMM existence proof, balance proof, nodrain proof

## Reference material

**lean4-amm** is the canonical calibration target. Use property names and proof
shapes from these files directly:

Key files in `.context/lean4-amm/`:
- `AMMLib/Transaction/Swap/Rate.lean` — `SX` definition; `SX.outputbound`,
  `SX.homogeneous`, `SX.mono`, `SX.strictmono` spec predicates
- `AMMLib/Transaction/Swap/Constprod.lean` — all five constprod proofs;
  `constprod.gain_direction`; `constprod.arbitrage_solve`; `constprod.exchrate_vs_oracle`
- `AMMLib/Transaction/Swap/Additive.lean` — `SX.additive` definition;
  `Swap.additive`, `Swap.additive_gain` (Lemma 5.7 in the paper)
- `AMMLib/Transaction/Swap/Reversible.lean` — `SX.reversible`; `Swap.inv`;
  `Swap.inv_apply` (round-trip = identity)
- `AMMLib/State/AMMs.lean` — `AMMs` structure, `AMMs.initialize`,
  `AMMs.r0`, `AMMs.r1`, `AMMs.init` predicate

Papers in `.context/papers/`:
- `lean4-amm-pusceddu-bartoletti-2024.pdf` — Sections 3-4 define the full
  framework; Section 5 proves constprod properties (arXiv 2402.06064)
- `lean4-amm-fees-bartoletti-2025.pdf` — Section 3 generalizes SX to fee-bearing
  swap functions; relevant for Unit 9 warmup (arXiv 2602.00101)
