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
  simp[hr0]

-- Exercise 2.
-- constprod output is positive whenever r1 is positive and r0 is positive.
-- Hint: `div_pos` takes two positivity proofs.
lemma constprod_pos (x r0 r1 : NNReal) (hr0 : 0 < r0) (hr1 : 0 < r1) :
    0 < constprod x r0 r1 := by
  simp[constprod, hr0, hr1]

-- Exercise 3.
-- **Output bound**: the amount received never exceeds the reserve.
-- Formally: x * constprod(x, r0, r1) < r1.
-- This is the core economic safety property — you can't drain the pool.
--
-- Proof sketch:
--   x * (r1 / (r0 + x))
--   = x * r1 / (r0 + x)       [← mul_div_assoc]
--   < r1                       [div_lt_iff₀, then nlinarith with mul_pos hr1 hr0]
theorem constprod_outputbound (x r0 r1 : NNReal) (hx : 0 < x) (hr0 : 0 < r0) (hr1 : 0 < r1) :
    x * constprod x r0 r1 < r1 := by
    simp[constprod]
    have hden : 0 < r0 + x := denom_pos x r0 hr0
    have hx_nonneg : 0 <= x := le_of_lt hx
    rw [← mul_div_assoc]
    rw [div_lt_iff₀ hden]
    nlinarith[hx_nonneg, hr0, hr1]

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
  simp[constprod]
  have hr1 : 0 <= r1 := by positivity
  have hc : 0 < r0 + x := denom_pos x r0 hr0
  have hden : r0 + x <= r0 + y := by linarith
  -- r1 / (r0 + y) ≤ r1 / (r0 + x)
  simp[div_le_div_of_nonneg_left hr1 hc hden]

-- Exercise 5.
-- **Homogeneity**: scaling all inputs by the same positive factor leaves the
-- output rate unchanged.
-- Formally: constprod(a*x, a*r0, a*r1) = constprod(x, r0, r1).
--
-- This is why AMM price impact is invariant to pool size — only the ratio
-- of reserves and trade-to-reserve ratio matters.
--
-- Hint: unfold constprod, `rw [← mul_add]`, then `field_simp [ha.ne']`.
theorem constprod_homogeneous (x r0 r1 a : NNReal) (ha : 0 < a) :
    constprod (a * x) (a * r0) (a * r1) = constprod x r0 r1 := by
  simp[constprod]
  rw [← mul_add]
  field_simp

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

/-!
## Session 15: PReal wrappers and the SX-shaped boundary

### Unit progress

Unit 4 is roughly 60% complete. The NNReal arithmetic facts are done; this
session moves those facts onto a strictly-positive API so Unit 6 can define
swap functions without carrying `hx`, `hr0`, and `hr1` everywhere.

### Prerequisite roundup

New or newly important tools this session:

- Subtype values are pairs: `⟨value, proof⟩`.
  To build an `ℝ>0`, you must provide an `NNReal` value and a proof that the
  value is strictly positive.

- `.val` and `.property`.
  If `x : ℝ>0`, then `x.val : NNReal` and `x.property : 0 < x.val`.
  This is the main pattern: unwrap PReal inputs, apply an NNReal theorem, then
  rewrap the result if the output type is again `ℝ>0`.

- Dot-namespaced definitions such as `PReal.mul`.
  This is just naming, not a special class mechanism. It keeps the positive-real
  helper API grouped under `PReal`.

- Wrapper theorem pattern.
  A PReal theorem often has fewer explicit hypotheses because the hypotheses
  live inside the inputs. For example, an NNReal theorem needing `hx : 0 < x`
  will usually receive `x.property` in the PReal wrapper theorem.

- Subtype equality is not the main goal here.
  Most wrapper theorems below state equality/inequality of `.val` fields. That
  avoids needing to prove two subtype values equal as pairs.

- `rfl` can prove projection lemmas after a wrapper definition.
  If a definition is literally `⟨someValue, someProof⟩`, then its `.val` is
  definitionally `someValue`.

### Session target

Build the smallest positive-real arithmetic surface needed for the SX framework:
closed multiplication/division, a positive `constprod`, and lifted versions of
the three NNReal constprod facts.
-/

-- Exercise 1.
-- Define positive multiplication.
-- Goal: the product of two positive values is positive.
def PReal.mul (x y : ℝ>0) : ℝ>0 := by
  sorry

-- Exercise 2.
-- Define positive division.
-- Goal: a positive numerator divided by a positive denominator is positive.
noncomputable def PReal.div (x y : ℝ>0) : ℝ>0 := by
  sorry

-- Exercise 3.
-- Wrap the NNReal constprod function as a strictly-positive function.
-- Notice: this definition should not need a separate positivity hypothesis;
-- positivity comes from the PReal arguments.
noncomputable def PReal.constprod (x r0 r1 : ℝ>0) : ℝ>0 := by
  sorry

-- Exercise 4.
-- Projection sanity check: the `.val` of the wrapper is the old NNReal function.
theorem PReal.constprod_val (x r0 r1 : ℝ>0) :
    (PReal.constprod x r0 r1).val =
      Unit4.Arithmetic.constprod x.val r0.val r1.val := by
  sorry

-- Exercise 5.
-- Lift outputbound to the PReal API.
-- The statement has no explicit `hx`, `hr0`, or `hr1`; find them on the inputs.
theorem PReal.constprod_outputbound (x r0 r1 : ℝ>0) :
    x.val * (PReal.constprod x r0 r1).val < r1.val := by
  sorry

-- Exercise 6.
-- Lift strictmono to the PReal API.
-- This still needs the real comparison assumption between trade sizes.
theorem PReal.constprod_strictmono
    (x y r0 r1 : ℝ>0) (hxy : x.val ≤ y.val) :
    (PReal.constprod y r0 r1).val ≤ (PReal.constprod x r0 r1).val := by
  sorry

-- Exercise 7.
-- Lift homogeneity to the PReal API using `PReal.mul`.
-- This is the first SX-shaped theorem: scale every positive input by the same
-- positive value and the output rate is unchanged.
theorem PReal.constprod_homogeneous (x r0 r1 a : ℝ>0) :
    (PReal.constprod (PReal.mul a x) (PReal.mul a r0) (PReal.mul a r1)).val =
      (PReal.constprod x r0 r1).val := by
  sorry

end Unit4.Arithmetic
