# Tutor Memory

This file is readable markdown but optimized for the tutor agent.
Use it as retrieval-first learner and repo state, not as another instruction
file.

## Progress Ledger

This is the canonical checkpoint section for the tutoring system.
When the tutor needs to know "where are we?", start here before inferring from
the rest of the repo.

Current unit:
- Unit 1: Traces and Summaries

Current sub-unit / frontier:
- trace summaries and restricted-trace theorems in `Leaning/Basic.lean`

Last solid checkpoint:
- completed through the current Session 5 material in `Leaning/Basic.lean`

Current live artifact:
- `Leaning/Basic.lean`

Current curated migration status:
- repo structure, tutor docs, unit skeletons, and skills are in place
- solved Unit 0 / Unit 1 material now has curated namespaced mirrors in the
  unit `Core.lean` modules
- the live scratch flow remains in `Leaning/Basic.lean`

Ready to branch into:
- Unit 2: Selector Kernels
- Unit 3: Strategic Games and Mechanisms

Explicitly not started as Lean artifacts yet:
- AMM core
- dynamic fee mechanisms
- keyed ledgers
- protocol state machines
- verification bridges

## Last Checkpoint

Date:
- 2026-04-26

What was verified:
- `Leaning/Basic.lean` checks
- the package root `Leaning` builds with the new unit module tree

What was established:
- the repo now has a stable book/tutor structure
- the curriculum has been broadened beyond the early local proof loop
- the next true content branch should leave the local trough rather than
  repeating more of the same theorem family
- Unit 0 / Unit 1 now have curated module surfaces in addition to the live
  scratch artifact

Next intended move:
- start Unit 2 or Unit 3 rather than extending more trace-summary variants

## Stable Profile

- Strong engineering background with DeFi, protocol logic, backend/systems, and
  interest in formal methods.
- Wants Lean to become useful for protocol/mechanism/verification reasoning,
  not just theorem-proving drills.
- Prefers active tutoring with open problems, bounded hints, and adaptive
  pacing.
- Values first-principles reasoning, explicit proof-state understanding, and
  real transfer to DeFi / crypto / verification work.

## Current Frontier

- Active live file: `Leaning/Basic.lean`
- Covered so far:
  - tiny state models
  - guarded transitions
  - aggregates and traces
  - trace summaries
  - first selector/market-shaped ideas are next
- Current repo transition:
  - moving from session log to unit-based book structure

## Concept State

### Mastered Or Usable

- `def`, `structure`, `inductive`
- `rfl`, `intro`, `exact`
- `simp`, `simp_all`, `dsimp`
- `cases`, `by_cases`, `induction`
- recursive list functions and append-style proofs
- state -> transition -> invariant proofs

### Usable But Shaky

- when to use automation vs explicit proof structure
- `Bool` vs `Prop`
- proof ergonomics around generalized induction hypotheses
- broader theorem-family recognition beyond local invariant preservation

### Explicit Growth Goals

- richer Lean/mathlib tool fluency when it unlocks real modeling work
- more proof-shape diversity
- protocol/mechanism/state-machine reasoning
- verification-bridge patterns toward Rust/Aeneas-style work

## Active Adaptation Policy

- Prefer open-ended problems over worked examples.
- Do not keep the learner trapped in one local problem class too long.
- Introduce new tools when they unlock the next unit, not just for coverage.
- Keep the book dynamic and tutor-like rather than rigid and worksheet-like.

## Active Experiment

- Hypothesis: a mixed spiral progression with explicit protocol relevance and
  lightweight tool roundups will outperform a narrower “one proof pattern at a
  time” progression.
- Status: active

## Logbook Policy

Use the logbook section below for compact, append-only session notes.

Each entry should try to capture:
- session intent
- what the tutor actually did
- what was validated or tested
- what the learner response/behavior signaled
- how the tutor should adapt
- the resulting checkpoint / next move

This is the durable conversation-to-progress bridge.

## Recent Observations

### 2026-04-26

Observation:
- The learner pushed back on repetitive local variants and wanted a broader,
  more forward-looking roadmap.

Why it matters:
- Static theorem families are not enough; the curriculum must diversify proof
  shapes and protocol artifacts.

How the tutor should adapt:
- Use the new unit roadmap and switch lanes when stagnation appears.

Status:
- active

### 2026-04-26

Observation:
- The learner wants the tutor to track teaching-style fit, including dynamic
  adaptation and lightweight A/B-style experimentation.

Why it matters:
- Tutor behavior must be explicit and portable across sessions.

How the tutor should adapt:
- Keep changes and experiments recorded here; route durable policy into
  `AGENTS.md` and `docs/*`.

Status:
- active

## Session Logbook

### 2026-04-26 - Roadmap Pivot And Tutor-System Formalization

Session intent:
- move from a narrow session-by-session flow into a durable, adaptive,
  unit-based Lean tutoring book

Tutor actions:
- expanded the roadmap
- added tutor-facing repo docs
- created unit skeletons, tutor docs, and repo-local skills
- preserved historical Lean work in the appendix
- added curated Unit 0 / Unit 1 module surfaces that mirror the solved
  foundations without destabilizing `Basic.lean`

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Basic.lean`
- `~/.elan/bin/lake build Leaning`

Learner response / behavior:
- explicitly pushed back on repetitive local variants
- wanted more forward-looking, DeFi-relevant, and game-theoretic directions
- wanted the tutor to act more like a real adaptive mentor with portable state

Tutor analysis:
- the early work was useful, but the curriculum was at risk of staying trapped
  in one proof family
- explicit checkpointing and session-memory structure were needed, not just a
  general learner profile

Checkpoint result:
- repo architecture and curriculum structure are now in place
- learner frontier remains in `Leaning/Basic.lean` through Session 5
- early solved material now also exists in curated unit surfaces

Next move:
- start the next substantive unit branch from the current frontier
- use the progress ledger first when routing the next session
