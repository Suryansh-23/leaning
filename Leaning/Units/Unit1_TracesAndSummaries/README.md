# Unit 1: Traces and Summaries

Purpose:
- move from local transitions to reducers and execution semantics
- prove append/compositionality and summary-vs-execution laws

Current migration target:
- `Event`, `applyEvent`, `applyEvents`, borrow-free/repay-free traces, and
  trace summary material from `Basic.lean`

Current curated status:
- `Core.lean` now provides a namespaced curated mirror of the trace and summary
  material
- `Basic.lean` remains the live scratch/reference source

What this unit should teach:
- why reducers compose
- how restricted traces let stronger theorems hold
- how a simple summary function can match a more operational interpreter

Typical theorem families:
- append laws
- restricted-trace safety or monotonicity
- summary-vs-execution equalities
