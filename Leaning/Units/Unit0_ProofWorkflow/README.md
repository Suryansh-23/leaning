# Unit 0: Proof Workflow

Purpose:
- build Lean proof-state fluency
- use tiny models and guarded transitions
- establish the active tutoring style before larger protocol artifacts

Current migration target:
- early `Position` / `safe` / `deposit` / `repay` / `borrowIfSafe` material from `Basic.lean`

Current curated status:
- `Core.lean` now provides a namespaced curated mirror of the early local
  state-transition material
- `Basic.lean` remains the live scratch/reference source

What this unit should teach:
- how to read goals and hypotheses in Infoview
- the difference between a definition, a proposition, and a proof term
- when simple `simp` is enough and when the proof shape matters

Typical theorem families:
- field-level postconditions
- operation preserves invariant
- guarded operation is safe under a check
