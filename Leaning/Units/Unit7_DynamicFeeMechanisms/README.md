# Unit 7: Dynamic Fee Mechanisms

Purpose:
- model a dynamic trading fee controller over observable venue state
- prove boundedness, monotonicity, and mechanism sanity properties
- include a small game-theoretic layer for strategic response when useful

Why it matters:
- this is where Lean becomes useful for mechanism-design-style DeFi reasoning,
  not just protocol invariants

Typical theorem families:
- fee stays in range
- fee is monotone in selected signals
- neutral state maps to baseline fee
- higher fee weakly worsens trader payoff in the toy model
- abstain/trade threshold properties
