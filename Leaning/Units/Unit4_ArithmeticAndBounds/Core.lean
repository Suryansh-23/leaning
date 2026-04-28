import Mathlib.Tactic

/-!
Unit 4 curated artifact: NNReal and Continuous Arithmetic.

This module contains the continuous Layer A arithmetic surface used by the
AMM-oriented units:

- `NNReal` constant-product output function
- output bound, denominator monotonicity, and homogeneity facts
- `PReal` as a strictly-positive subtype API
- PReal wrappers for the same constant-product facts
-/

namespace Unit4.Arithmetic

open NNReal

noncomputable def constprod (x r0 r1 : NNReal) : NNReal :=
  r1 / (r0 + x)

lemma denom_pos (x r0 : NNReal) (hr0 : 0 < r0) : 0 < r0 + x := by
  simp [hr0]

lemma constprod_pos (x r0 r1 : NNReal) (hr0 : 0 < r0) (hr1 : 0 < r1) :
    0 < constprod x r0 r1 := by
  simp [constprod, hr0, hr1]

theorem constprod_outputbound
    (x r0 r1 : NNReal) (hx : 0 < x) (hr0 : 0 < r0) (hr1 : 0 < r1) :
    x * constprod x r0 r1 < r1 := by
  simp [constprod]
  have hden : 0 < r0 + x := denom_pos x r0 hr0
  have hx_nonneg : 0 <= x := le_of_lt hx
  rw [← mul_div_assoc]
  rw [div_lt_iff₀ hden]
  nlinarith [hx_nonneg, hr0, hr1]

theorem constprod_strictmono
    (x y r0 r1 : NNReal) (hxy : x ≤ y) (hr0 : 0 < r0) :
    constprod y r0 r1 ≤ constprod x r0 r1 := by
  simp [constprod]
  have hr1 : 0 <= r1 := by positivity
  have hc : 0 < r0 + x := denom_pos x r0 hr0
  have hden : r0 + x <= r0 + y := by linarith
  simp [div_le_div_of_nonneg_left hr1 hc hden]

theorem constprod_homogeneous (x r0 r1 a : NNReal) (ha : 0 < a) :
    constprod (a * x) (a * r0) (a * r1) = constprod x r0 r1 := by
  simp [constprod]
  rw [← mul_add]
  field_simp

abbrev PReal := { r : NNReal // 0 < r }

notation "ℝ>0" => PReal

def PReal.add (x y : ℝ>0) : ℝ>0 :=
  ⟨x.val + y.val, add_pos x.property y.property⟩

def PReal.mul (x y : ℝ>0) : ℝ>0 :=
  ⟨x.val * y.val, mul_pos x.property y.property⟩

noncomputable def PReal.div (x y : ℝ>0) : ℝ>0 :=
  ⟨x.val / y.val, div_pos x.property y.property⟩

noncomputable def PReal.constprod (x r0 r1 : ℝ>0) : ℝ>0 :=
  r1.div (r0.add x)

theorem PReal.constprod_val (x r0 r1 : ℝ>0) :
    (PReal.constprod x r0 r1).val =
      Unit4.Arithmetic.constprod x.val r0.val r1.val := by
  simp [PReal.constprod, PReal.div, PReal.add, Unit4.Arithmetic.constprod]

theorem PReal.constprod_outputbound (x r0 r1 : ℝ>0) :
    x.val * (PReal.constprod x r0 r1).val < r1.val := by
  simp [PReal.constprod, PReal.div, PReal.add]
  exact Unit4.Arithmetic.constprod_outputbound x.val r0.val r1.val
    x.property r0.property r1.property

theorem PReal.constprod_strictmono
    (x y r0 r1 : ℝ>0) (hxy : x.val ≤ y.val) :
    (PReal.constprod y r0 r1).val ≤ (PReal.constprod x r0 r1).val := by
  simp [PReal.constprod_val,
    Unit4.Arithmetic.constprod_strictmono x.val y.val r0.val r1.val hxy r0.property]

theorem PReal.constprod_homogeneous (x r0 r1 a : ℝ>0) :
    (PReal.constprod (PReal.mul a x) (PReal.mul a r0) (PReal.mul a r1)).val =
      (PReal.constprod x r0 r1).val := by
  simp [PReal.constprod, PReal.mul, PReal.add, PReal.div]
  exact Unit4.Arithmetic.constprod_homogeneous x.val r0.val r1.val a.val a.property

end Unit4.Arithmetic
