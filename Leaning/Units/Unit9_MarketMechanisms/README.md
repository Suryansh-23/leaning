# Unit 9: Novel AMM Designs

Purpose:
- build fee-aware SX instances: prove that fee-adjusted swap functions satisfy
  the full SX property suite (outputbound, homogeneous, reversible, additive, strictmono)
- design new invariant curves (stableswap-style, weighted pools) as SX functions
- introduce range constraints for concentrated-liquidity-flavored designs
- run the design-verify cycle: propose an SX instance, prove it, compare economically

Why it matters:
- this is the primary creative/research destination of the book
- any new AMM design reduces to: define SX, prove its properties, reason economically
- fee adequacy (gain_direction still holds under fees) is a theorem, not an assumption
- the unit demonstrates that the SX framework is an extensible formal design tool

Typical theorem families:
- fee_sx_outputbound: fee-adjusted output still bounded by r1
- fee_sx_strictmono: fees make rate degradation strictly worse with size
- stableswap_outputbound, stableswap_homogeneous (if stableswap is covered)
- weighted_sx_price_ratio: price ratio = reserve ratio weighted by pool weights
- fee_adequacy: gain_direction holds under fee-adjusted SX

Design note:
- concentrated liquidity (tick math) is explicitly deferred — named future target
- novel designs are compared against constant-product as the baseline
- if time allows, one design from the literature (e.g., Curve v1) as a case study
