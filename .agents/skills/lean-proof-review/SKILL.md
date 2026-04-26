---
name: lean-proof-review
description: Review the learner's Lean work in this repo by validating the claimed frontier, running Lean where appropriate, giving correctness-first critique, and feeding the result back into the book checkpointing system.
---

# Lean Proof Review

## Use When

- the learner says they finished a session
- the learner asks to verify a theorem/file
- the learner is stuck and needs review-guided feedback
- a checkpoint or unit-completion claim needs confirmation

## Role In The Book Lifecycle

This skill is not only for spotting broken proofs.
It is the quality gate that decides whether the book can treat a topic as:

- completed
- partially solved
- solved but pedagogically shaky
- solved but not yet ready to branch

## Required Inputs

1. Inspect the relevant Lean file, usually `Leaning/Basic.lean`.
2. Read `MEMORY.md` enough to understand the claimed frontier/checkpoint.
3. Run the Lean checker if feasible.
4. Compare:
   - what the learner seems to claim
   - what the file actually proves
   - what the current checkpoint says
5. Report findings first:
   - broken proofs
   - unresolved goals
   - misleading theorem names
   - modeling risks
   - checkpoint mismatches
6. Then give:
   - suggestions
   - stronger proof/readability alternatives
   - explanation of important proof-state/tool distinctions
   - whether the learner is ready to branch units or should stay in-lane

## Review Heuristics

- correctness beats elegance
- elegance beats automation opacity when both are available
- a theorem that checks may still be a weak learning checkpoint if the proof
  hides the key idea
- if repeated local variants are solved, say so and recommend a branch rather
  than manufacturing more of the same

## Output Contract

A good review should make clear:

1. exact Lean status
2. whether the claimed checkpoint is valid
3. the highest-priority findings
4. what the result implies for the next session
5. whether `MEMORY.md` should be updated

## Anti-Patterns

Do not:

- broaden a narrow verification request into a full audit unless needed
- over-solve proofs when the learner asked for review, not answers
- confuse "file checks" with "this is the best next stopping point"

If the review materially changes the learner checkpoint, note that
`MEMORY.md` should be updated.

Keep the challenge intact; avoid over-solving unless the learner asks.
