---
name: book-state-sync
description: Sync the adaptive Lean book state after substantive tutoring, roadmap changes, or validation-heavy review by updating the checkpoint ledger, logbook, and any affected tutor-facing docs coherently.
---

# Book State Sync

## Use When

- a tutoring session materially changed the learner frontier
- a review session changed what is considered complete, shaky, or next
- the curriculum or unit structure changed
- the tutor docs and `MEMORY.md` risk drifting apart

## Role In The Book Lifecycle

This skill is the state-maintenance layer for the book.
It keeps the following aligned:

- actual learner frontier
- intended roadmap
- tutor operating policy
- recent evidence from tutoring/review/validation

Without this sync step, the repo becomes structurally neat but operationally
stale.

## Required Inputs

Read:

1. `MEMORY.md`
2. `AGENTS.md`
3. `README.md`
4. relevant `docs/*.md`
5. the relevant live or reviewed Lean file, usually `Leaning/Basic.lean`

## Sync Checklist

Check whether these need updating:

- `Progress Ledger`
- `Last Checkpoint`
- `Session Logbook`
- `Recent Observations`
- any unit README whose stated purpose/frontier is now stale
- tutor docs if the adaptation or checkpointing model changed

## Preferred Update Order

1. update `MEMORY.md` first
2. then adjust tutor docs if policy changed
3. then adjust roadmap/unit docs if curriculum shape changed

## What A Good Sync Captures

- what changed
- what was verified
- what the learner response implied
- whether the next branch changed
- whether the tutor learned something about pace, scaffolding, or motivation

## Anti-Patterns

Do not:

- rewrite history noisily
- turn the logbook into a transcript dump
- update roadmap docs for a local one-off unless it changed durable direction
- mark progress beyond what the Lean file or review actually supports

## Output Contract

After syncing, the repo should make it easy for a future tutor to answer:

- where are we?
- what was the last solid checkpoint?
- what changed recently?
- what should happen next?
