# Unit 8: LP Mechanics

Purpose:
- model deposit and redeem as state transitions on the AMM pool state
- prove LP token minting and burning preserve the LP token supply invariant
- derive LP token pricing: (r0·p0 + r1·p1) / supply
- establish invariants across the full create/deposit/swap/redeem lifecycle

Why it matters:
- LP mechanics are the other half of AMM correctness beyond the swap kernel
- supply conservation and pricing are the formal basis for "fair value" guarantees
- lifecycle invariants are directly verifiable against production AMM contracts

Typical theorem families:
- deposit_mints: mint amount proportional to deposited reserves
- redeem_burns: burned LP tokens ↔ returned reserves, supply decreases correctly
- supply_conservation: total LP supply = sum of all mint events - sum of all burns
- lp_price_correct: token price equals pro-rata share of pool reserves at oracle prices
- lifecycle_invariant: total value locked preserved across create/deposit/swap/redeem

Connects to:
- Unit 6: pool state (Finsupp-based reserves) is the object being updated
- Unit 5: Finsupp ledger mechanics underpin the reserve accounting
- Unit 9: fee tiers and range constraints modify deposit/redeem rules

Design note:
- LP token supply modeled as an additional Finsupp or a Nat counter
- all definitions noncomputable (Layer A); the integer bridge is Unit 10
