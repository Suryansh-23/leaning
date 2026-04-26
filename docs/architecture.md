# Tutor Architecture

## Purpose

This repo is a hands-on Lean learning book with an adaptive tutor agent.

The architecture is intentionally split:

- `README.md`: human-facing roadmap
- `AGENTS.md`: stable tutor operating contract
- `MEMORY.md`: learner/repo state, canonical checkpoint ledger, and logbook
- `docs/*.md`: deeper tutor-system docs

## Working Surfaces

- `Leaning/Basic.lean`: live global scratch/reference surface
- `Leaning/Units/*/Core.lean`: curated unit artifact
- `Leaning/Units/*/Scratch.lean`: unit-local experimentation
- `Leaning/Appendix/BasicHistory.lean`: preserved historical snapshot

## Checkpointing Model

The tutor should not guess current progress purely from the roadmap.

Use this order:

1. `MEMORY.md` `Progress Ledger`
2. `MEMORY.md` `Last Checkpoint`
3. latest `MEMORY.md` `Session Logbook` entry
4. `Leaning/Basic.lean` as the live reality check
5. `README.md` only for intended curriculum shape

This keeps:
- roadmap intent
- actual solved frontier
- and recent learner/tutor signals

separate and recoverable.

## Design Principles

- keep the learner active
- preserve challenge
- diversify proof shapes
- keep protocol/mechanism relevance visible
- separate stable instructions from evolving learner state
- move repeated workflows into skills, not bloated instructions
