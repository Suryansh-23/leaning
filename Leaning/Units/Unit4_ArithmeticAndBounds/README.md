# Unit 4: NNReal and Continuous Arithmetic

## Purpose

- Introduce ℝ≥0 (`NNReal`) and the custom `PReal = { r : ℝ // 0 < r }` (ℝ>0)
  as the number system for all subsequent AMM units
- Establish comfort with `noncomputable` definitions and why they are correct
  for mathematical (Layer A) specifications
- Prove the three core arithmetic properties of `constprod x r0 r1 = r1/(r0+x)`
  that reappear as SX axioms in Unit 6: outputbound, strictmono, homogeneous

## Why it matters

Units 5-9 use NNReal/PReal for every balance, reserve, price, and LP token
value. The distinction between computable (Layer B) and noncomputable (Layer A)
is fundamental to the book's design — all AMM economic proofs live in Layer A.
Ordered field reasoning (positivity, division, monotonicity) underpins every SX
property in Units 6 and 7.

## Typical theorem families

- positivity preservation under `+`, `*`, `/`
- `div_lt_iff₀`, `div_le_div_of_nonneg_left` — the two workhorses for AMM bounds
- `nlinarith` with product hints for nonlinear inequality goals
- `field_simp [h.ne']` for cancellation in field expressions
- outputbound: `x * (r1/(r0+x)) < r1` — the template proof for Unit 6
- strictmono: `x ≤ y → r1/(r0+y) ≤ r1/(r0+x)`
- homogeneous: `(a*r1)/(a*r0 + a*x) = r1/(r0+x)` via `← mul_add` + `field_simp`
- PReal as a subtype: `{ r : NNReal // 0 < r }` — preview of the Unit 6 design

## Key Lean/Mathlib surfaces

- `NNReal` (`ℝ≥0`) — Mathlib type at `Mathlib.Data.Real.NNReal`
- `positivity` tactic — closes `0 < e`, `0 ≤ e`, `e ≠ 0` structurally
- `linarith`, `nlinarith` — linear and nonlinear arithmetic over ordered types
- `field_simp` — field simplification and denominator cancellation
- `div_lt_iff₀` — rewrites `a/b < c` to `a < c*b` (needs `0 < b`)
- `div_le_div_of_nonneg_left` — monotonicity of division in the denominator
- `noncomputable` keyword — required for real division and sqrt

## Reference material

**lean4-amm** defines `PReal` as a custom subtype (not from Mathlib) and
provides the coercion infrastructure used throughout Units 6-9.

Key files in `.context/lean4-amm/`:
- `HelpersLib/PReal/Basic.lean` — `PReal` definition, coercions to NNReal and ℝ,
  simp lemmas for `add_toReal`, `mul_toReal`, `div_toReal`
- `HelpersLib/PReal/Order.lean` — ordering lemmas on PReal
- `HelpersLib/NNReal.lean` — `NNReal.toPReal`, `neq_zero_imp_gt`

Papers in `.context/papers/`:
- `lean4-amm-pusceddu-bartoletti-2024.pdf` — the HelpersLib design decisions
  are explained in Section 2 of the paper (arXiv 2402.06064)
