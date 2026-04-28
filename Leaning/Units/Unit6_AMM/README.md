# Unit 6: AMM Kernels and the SX Framework

Purpose:
- introduce SX = ℝ>0 → ℝ>0 → ℝ>0 → ℝ>0 as the parametric swap function type
- prove SX.outputbound, SX.homogeneous, SX.reversible, SX.additive, SX.strictmono
  for the constant-product instance SX.constprod x r0 r1 = r1 / (r0 + x)
- build the AMM state: pool reserves as a constrained Finsupp over token pairs

Why it matters:
- this is the primary formal DeFi artifact in the book
- the SX abstraction means any AMM design is just a new SX function; properties
  proved about SX in general carry over to every instance
- calibrated against dpusceddu/lean4-amm (Pusceddu & Bartoletti, FMBC 2024)

Typical theorem families:
- outputbound: x * sx(x, r0, r1) < r1 (can't drain the pool)
- homogeneous: sx(a*x, a*r0, a*r1) = sx(x, r0, r1) (scale invariant)
- reversible: there exists a reverse swap that undoes a forward swap
- additive: splitting a trade gives the same output as one trade
- strictmono: exchange rate degrades with trade size

Design note:
- all definitions are noncomputable (Layer A); the integer bridge is Unit 10
- novel AMM designs in Unit 9 are new SX functions proved against these properties
