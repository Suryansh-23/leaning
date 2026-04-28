# Unit 7: AMM Economic Properties

Purpose:
- define net worth, gain, and oracle-relative valuation for AMM positions
- prove gain_direction: a profitable swap implies the reverse is not profitable
- derive the optimal trade size for constant-product (closed-form arbitrage)
- frame rational actor analysis for adversarial reasoning

Why it matters:
- arbitrage safety and price-impact bounds are the core economic guarantees of AMMs
- the gain_direction proof is the foundation for "no free lunch" theorems
- optimal trade size connects abstract SX properties to concrete protocol parameters
- the rational actor framing reappears in Unit 9 when proving fee adequacy

Typical theorem families:
- gain_direction: profit(swap) > 0 → profit(reverse_swap) ≤ 0
- price_impact: larger trades get worse rates (follows from SX.strictmono)
- arbitrage_solve: closed-form optimal x for constant-product vs oracle price p
- no_reverse_profit: corollary of gain_direction, no round-trip gain

Connects to:
- Unit 6: all results follow directly from SX properties proved there
- Unit 3: same gain-comparison proof shape as second-price utility decomposition
- Unit 9: fee adequacy = gain_direction under fee-adjusted SX

Design note:
- all definitions noncomputable (Layer A); prices are PReal-valued oracles
- oracle is an external parameter, not a state variable
