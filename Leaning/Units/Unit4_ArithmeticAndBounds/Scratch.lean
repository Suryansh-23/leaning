import Mathlib.Tactic

/-!
Unit 4 scratch surface: NNReal and Continuous Arithmetic.

This unit introduces the number system used throughout Units 5-9.

`NNReal` (ℝ≥0) is Mathlib's non-negative reals — a subtype of ℝ with zero as the
default, which makes it the right type for token balances and pool reserves.
Division over NNReal is *noncomputable* (it uses classical existence arguments).
That is fine for Layer A mathematical specs; the integer bridge is Unit 10.

By the end of this unit you will have proved the three core arithmetic properties
of `constprod x r0 r1 = r1 / (r0 + x)` that reappear as SX axioms in Unit 6:
outputbound, strictmono, and homogeneous.
-/

namespace Unit4.Arithmetic

open NNReal

/-!
## Session 14: NNReal arithmetic and the noncomputable boundary

### Prerequisite roundup

New tools this session:

- `NNReal` — type `ℝ≥0`, non-negative reals as a Mathlib subtype of ℝ.
  Every element carries a proof that it is ≥ 0; you never need `0 ≤ x` as a
  hypothesis for an `NNReal` value.

- `positivity` — closes goals of the form `0 < e`, `0 ≤ e`, `e ≠ 0`
  by structural analysis of the expression. Knows about sums, products,
  and literals. Pair it with explicit hypotheses when needed.

- `nlinarith [h1, h2, ...]` — like `linarith` but handles nonlinear goals.
  Useful when the residual goal is a product inequality; pass the relevant
  products as hints.

- `field_simp [hne]` — simplifies field expressions and cancels denominators.
  Requires `hne : d ≠ 0` for any denominator `d` that needs cancellation.

- `div_lt_iff₀ hd` — rewrites `a / b < c` to `a < c * b` (needs `hd : 0 < b`).

- `div_le_div_of_nonneg_left ha hc h` — `a / b ≤ a / c` when `ha : 0 ≤ a`,
  `hc : 0 < c`, `h : c ≤ b`.

- `noncomputable` — required for definitions that use real-number division,
  sqrt, or any other classically-defined operation. Not a limitation: all
  Layer A proofs are noncomputable by design.

---

The swap function we are heading toward:

  `constprod x r0 r1 = r1 / (r0 + x)`

`x` is the trade size, `r0` is the input-token reserve, `r1` is the output-token
reserve. Division forces the definition to be `noncomputable`.
-/

noncomputable def constprod (x r0 r1 : NNReal) : NNReal :=
  r1 / (r0 + x)

-- Exercise 1.
-- The denominator r0 + x is positive whenever r0 is positive.
-- This is a helper you will reuse in the next three proofs.
-- Hint: `linarith` closes linear arithmetic over NNReal directly.
lemma denom_pos (x r0 : NNReal) (hr0 : 0 < r0) : 0 < r0 + x := by
  sorry

-- Exercise 2.
-- constprod output is positive whenever r1 is positive and r0 is positive.
-- Hint: `div_pos` takes two positivity proofs.
lemma constprod_pos (x r0 r1 : NNReal) (hr0 : 0 < r0) (hr1 : 0 < r1) :
    0 < constprod x r0 r1 := by
  sorry

-- Exercise 3.
-- **Output bound**: the amount received never exceeds the reserve.
-- Formally: x * constprod(x, r0, r1) < r1.
-- This is the core economic safety property — you can't drain the pool.
--
-- Proof sketch:
--   x * (r1 / (r0 + x))
--   = x * r1 / (r0 + x)       [← mul_div_assoc]
--   < r1                       [div_lt_iff₀, then nlinarith with mul_pos hr1 hr0]
theorem constprod_outputbound
    (x r0 r1 : NNReal) (hx : 0 < x) (hr0 : 0 < r0) (hr1 : 0 < r1) :
    x * constprod x r0 r1 < r1 := by
  sorry

-- Exercise 4.
-- **Strict monotonicity**: a larger trade gets a worse exchange rate.
-- Formally: x ≤ y → constprod(y, r0, r1) ≤ constprod(x, r0, r1).
-- (Output per unit decreases as trade size grows.)
--
-- Hint: `div_le_div_of_nonneg_left` with `positivity` for the numerator,
-- `denom_pos` for positivity of the smaller denominator, and `linarith`
-- for the denominator ordering.
theorem constprod_strictmono
    (x y r0 r1 : NNReal) (hxy : x ≤ y) (hr0 : 0 < r0) :
    constprod y r0 r1 ≤ constprod x r0 r1 := by
  sorry

-- Exercise 5.
-- **Homogeneity**: scaling all inputs by the same positive factor leaves the
-- output rate unchanged.
-- Formally: constprod(a*x, a*r0, a*r1) = constprod(x, r0, r1).
--
-- This is why AMM price impact is invariant to pool size — only the ratio
-- of reserves and trade-to-reserve ratio matters.
--
-- Hint: unfold constprod, `rw [← mul_add]`, then `field_simp [ha.ne']`.
theorem constprod_homogeneous
    (x r0 r1 a : NNReal) (ha : 0 < a) :
    constprod (a * x) (a * r0) (a * r1) = constprod x r0 r1 := by
  sorry

/-!
### Session 14 stretch: why PReal

NNReal lets the value be zero. For SX functions the reserves r0, r1 and trade
size x must all be *strictly* positive — otherwise division by zero is
degenerate and outputbound is trivially vacuous.

The lean4-amm reference handles this by defining:

  `PReal := { r : ℝ // 0 < r }` with notation `ℝ>0`
  `SX    := ℝ>0 → ℝ>0 → ℝ>0 → ℝ>0`

This bakes positivity into the type so proofs don't need hr0, hr1, hx
hypotheses everywhere. Unit 6 will use this design; the exercises above
are the same proofs you will write there, minus the boilerplate.

As a preview: here is PReal as a Lean 4 subtype.
-/

abbrev PReal := { r : NNReal // 0 < r }
notation "ℝ>0" => PReal

-- Every PReal is positive — extracted from its type.
example (x : ℝ>0) : 0 < x.val := x.property

-- PReal addition is closed (sum of two positives is positive).
def PReal.add (x y : ℝ>0) : ℝ>0 :=
  ⟨x.val + y.val, add_pos x.property y.property⟩

-- No exercise here — just read and understand the pattern.
-- Unit 6 will give you a full PReal arithmetic surface to work with.

end Unit4.Arithmetic
