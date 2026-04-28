# Unit 4: NNReal and Continuous Arithmetic

Purpose:
- introduce ℝ≥0 (NNReal) and ℝ>0 (PReal) as the number system for all
  subsequent AMM units
- establish comfort with noncomputable definitions and why they are correct for
  mathematical specifications
- preview Finsupp as the ledger primitive used in Unit 5

Why it matters:
- Units 5-9 all use NNReal/PReal for balances, reserves, and prices
- the distinction between computable (Layer B) and noncomputable (Layer A) specs
  is fundamental to the book's design
- ordered field reasoning (positivity, division, monotonicity) underpins every
  AMM economic property in Units 6 and 7

Typical theorem families:
- positivity preservation under addition, multiplication, and division
- NNReal / Real coercions and their proof obligations
- Finsupp.support, Finsupp.add, Finsupp.sub basics
- monotonicity and boundedness in ordered fields
- noncomputable sqrt and its algebraic properties (needed for Unit 7 arbitrage)

Key Lean/Mathlib surfaces:
- NNReal, PReal (ℝ≥0, ℝ>0)
- Finsupp.Basic (preview)
- noncomputable keyword and its implications for executability
- field_simp, ring, positivity (omega is insufficient for ℝ)
