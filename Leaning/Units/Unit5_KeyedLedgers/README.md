# Unit 5: Finsupp Ledgers

Purpose:
- model token balances as Finsupp T NNReal (finitely-supported maps from token
  to non-negative real), directly matching lean4-amm's AtomicWall design
- prove conservation, transfer correctness, and untouched-key lemmas
- build the multi-token wallet and account-indexed wallet set used in Unit 6

Why it matters:
- this is the direct preparation for the AMM state container in Unit 6
- Finsupp is the right abstraction for sparse token balances: zero is the default,
  only non-zero entries need storage
- the proof patterns here (key independence, sum conservation) reappear in every
  subsequent unit that touches state

Typical theorem families:
- get/set/add/sub on Finsupp and their commutativity
- conservation: total supply unchanged under transfer
- untouched-key: an operation on token A does not affect token B
- wallet sets: Finsupp A (Finsupp T NNReal) for per-account balances

Key Lean/Mathlib surfaces:
- Finsupp.Basic (add, sub, update, support)
- NNReal arithmetic for balance values
- Finsupp.sum for total supply proofs
