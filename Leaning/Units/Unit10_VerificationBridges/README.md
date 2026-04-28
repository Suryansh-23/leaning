# Unit 10: Verification Bridges (capstone)

Purpose:
- introduce Layer B: computable integer arithmetic over Nat/Int as a discrete
  approximation to the Layer A continuous specs from Units 4-9
- prove approximation theorems: discrete output vs continuous spec within ε
- prove rounding direction: integer implementations always round against the user,
  never against the protocol (no free tokens from rounding)
- sketch the connection path toward real Solidity/Rust implementations

Why it matters:
- Layer A specs are mathematically clean but not executable; real contracts run integers
- the bridge is what makes formal verification practically useful: a Lean proof that
  your integer AMM is within ε of the continuous-math spec
- rounding direction proofs are high-value: they eliminate a class of real exploits

Typical theorem families:
- discrete_outputbound: integer implementation never exceeds the continuous output bound
- rounding_direction: ⌊continuous_output⌋ ≤ integer_output ≤ ⌈continuous_output⌉,
  with the protocol-safe direction guaranteed
- approximation_gap: |integer_output - continuous_output| < ε for given precision
- overflow_safety: arithmetic stays within uint256 range for realistic reserve sizes

Design note:
- this unit is a capstone, not a prerequisite for any earlier unit
- the Integer Bridge Appendix extends these results with fixed-point representations
  and extended approximation proofs for overflow-safe uint256-scale arithmetic
- Aeneas/Rust extraction is named as a future target beyond this book's scope
