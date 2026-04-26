# Unit 5: Keyed Ledgers and Failure Semantics

Purpose:
- move from single-record state to keyed/accounted protocol state
- introduce partial transitions with `Option` / `Except`
- prove conservation and untouched-key lemmas

Why it matters:
- this is the first unit that starts to feel like real protocol state, not just
  single-record toy models

Typical theorem families:
- unaffected-key lemmas
- conservation under transfer/update
- failed operation leaves state unchanged
- disjoint updates commute
