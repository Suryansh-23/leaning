# Tutor Memory

This file is readable markdown but optimized for the tutor agent.
Use it as retrieval-first learner and repo state, not as another instruction
file.

## Progress Ledger

This is the canonical checkpoint section for the tutoring system.
When the tutor needs to know "where are we?", start here before inferring from
the rest of the repo.

Current unit:
- Unit 2: Selector Kernels

Current sub-unit / frontier:
- global optimality over valid candidates for `selectBestQuote` in
  `Leaning/Units/Unit2_SelectorKernels/Scratch.lean`

Last solid checkpoint:
- completed through the current Session 5 material in `Leaning/Basic.lean`

Current live artifact:
- `Leaning/Units/Unit2_SelectorKernels/Scratch.lean`

Current curated migration status:
- repo structure, tutor docs, unit skeletons, and skills are in place
- solved Unit 0 / Unit 1 material now has curated namespaced mirrors in the
  unit `Core.lean` modules
- Unit 2 active work has moved into the unit-specific `Scratch.lean` file

Ready to branch into:
- Unit 3: Strategic Games and Mechanisms
- Unit 4: Arithmetic and Bounds, after selector basics need scoring/bounds

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
- `Leaning/Units/Unit2_SelectorKernels/Scratch.lean` checks with intended
  `sorry` placeholders for the active Unit 2 session batch

What was established:
- the repo now has a stable book/tutor structure
- the curriculum has been broadened beyond the early local proof loop
- the next true content branch should leave the local trough rather than
  repeating more of the same theorem family
- Unit 0 / Unit 1 now have curated module surfaces in addition to the live
  scratch artifact

Next intended move:
- solve Session 9's global optimality batch, focusing on validity-conditioned
  dominance over allowed candidates

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

- Active live file: `Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
- Covered so far:
  - tiny state models
  - guarded transitions
  - aggregates and traces
  - trace summaries
  - local quote-selector facts for `betterQuote`
  - list-wide validity preservation for `selectBestQuote`
  - score monotonicity and combined validity/output contract
  - provenance and candidate membership for `selectBestQuote`
- Current repo transition:
  - active learner work is moving from global `Basic.lean` into unit-specific
    scratch files

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
- The learner wants a bounded subagent/tool audit whenever the tutor models a
  new session scaffold, so prerequisite tools are identified and explained
  before handoff.

Why it matters:
- Missing prerequisite explanations slow the session down and force the learner
  to ask for setup that should have been part of the scaffold.

How the tutor should adapt:
- Before presenting a new session, run a focused prerequisite audit over the
  exercise batch, preferably via subagent when available, then explain new
  tools with meaning, trigger shape, and minimal non-solution examples.

Status:
- active

### 2026-04-26

Observation:
- The learner had to ask for the prerequisite tool roundup for Session 8, even
  though list membership and disjunction handling were new proof surfaces.

Why it matters:
- New-session setup is incomplete if it omits the tools needed to start the
  exercise batch.

How the tutor should adapt:
- Always include a prerequisite roundup before handoff whenever a session
  introduces new syntax, APIs, proof constructs, or modeling patterns. Keep it
  calibrated and non-solution-leaking.

Status:
- active

### 2026-04-26

Observation:
- The learner wants completion reviews to include a score out of 10 with
  analysis, and wants new session roundups to start with a unit progress
  indicator.

Why it matters:
- Scored reviews make checkpoints easier to calibrate, and progress indicators
  keep each session oriented inside the larger unit.

How the tutor should adapt:
- Use `lean-proof-review` with a score and short rationale after each completed
  session. Use `lean-session-coach` with a short description plus approximate
  percentage before each new session roundup.

Status:
- active

### 2026-04-26

Observation:
- The learner asked whether the focus should be only theorem proving or also
  function/spec definition work.

Why it matters:
- The book should train formal modeling, not just filling proofs after the
  tutor supplies every definition.

How the tutor should adapt:
- Include definition-design exercises once a unit's basic vocabulary is in
  place: ask the learner to write small executable functions, spec predicates,
  and theorem statements before proving them.

Status:
- active

### 2026-04-26

Observation:
- The learner wants the tutor to move fast after enough practice has been
  demonstrated and avoid circling around the same concept.

Why it matters:
- Repetition should stop once the tutor has evidence that the proof pattern is
  usable; the book should advance to a new proof shape or stronger contract.

How the tutor should adapt:
- Treat repeated success as a signal to increase scope, introduce the next
  concept family, or branch forward, rather than adding near-duplicate drills.

Status:
- active

### 2026-04-26

Observation:
- The learner wants each prepared session to contain multiple exercises, enough
  to move faster while keeping the learning curve feasible.

Why it matters:
- Single-theorem handoffs are too slow once the learner is comfortable with the
  local proof tools.

How the tutor should adapt:
- Prepare a small batch of related exercises per session, ordered from
  straightforward to stretch, with a useful roundup before the handoff.

Status:
- active

### 2026-04-26

Observation:
- The learner prefers guided hints over direct answers. The tutor gave too much
  of the proof for `selectBestQuote_valid_if_fallback_valid`.

Why it matters:
- Full proof shapes should be delayed until the learner says they cannot bridge
  the gap from hints.

How the tutor should adapt:
- Use the hint ladder strictly: semantic hint, goal-shape hint, tactic/tool
  hint, partial skeleton, then full proof only on explicit request or clear
  necessity.

Status:
- active

### 2026-04-26

Observation:
- The learner pointed to `Leaning/Appendix/BasicHistory.lean` as evidence that
  basic `simp`, `by_cases`, induction, generalized IHs, and local selector
  case proofs are already mostly familiar.

Why it matters:
- Session setup should not over-teach elementary tactics; early Unit 2 local
  lemmas may be treated as quick calibration before moving to stronger
  selector contracts.

How the tutor should adapt:
- Keep roundups focused on genuinely new Lean/modeling concepts, such as
  derived instances, executable-vs-spec boundaries, membership, optimality, and
  list-wide correctness.

Status:
- active

### 2026-04-26

Observation:
- The learner wants the tutor to set up the session workspace before handing
  over, including the next Lean scaffold and task instructions.

Why it matters:
- Session starts should minimize administrative friction; the learner expects
  to open the prepared file and perform the proof work directly.

How the tutor should adapt:
- Before each session, inspect the checkpoint, add or prepare the relevant
  exercise scaffold in the live Lean surface when appropriate, and then give
  concise instructions for what the learner should prove.

Status:
- active

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

### 2026-04-26 - Unit 2 Provenance Complete And Optimality Setup

Session intent:
- review Session 8 provenance work and move to global optimality over valid
  candidates

Tutor actions:
- validated the completed provenance/membership batch
- ran a focused prerequisite audit via subagent before finalizing the next
  session roundup
- scaffolded Session 9 global optimality exercises in Unit 2 Scratch

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
  checked before scaffolding
- the same command checked after scaffolding, with six intended `sorry`
  warnings

Learner response / behavior:
- completed the provenance batch after needing extra explanation for `rcases`,
  nested disjunctions, and `simpa`
- is ready to move forward but needs new tools surfaced before handoff

Tutor analysis:
- Session 8 completion score: 8/10. Correctness is solid and the final bundled
  theorem uses the right composition shape after guidance; the main growth area
  is recognizing when a theorem should be composed from prior lemmas instead of
  reproved by induction.

Checkpoint result:
- Unit 2 now covers validity, output monotonicity, provenance, and a basic
  bundled selector contract
- current frontier is global optimality over valid candidates

Next move:
- solve Session 9 by defining validity-conditioned dominance and lifting it
  from `betterQuote` to `selectBestQuote`

### 2026-04-26 - Unit 2 Score Contracts And Provenance Setup

Session intent:
- review the score-monotonicity batch and prepare the next faster-moving Unit 2
  session

Tutor actions:
- validated Session 7 score-monotonicity proofs
- rewrote the combined contract proof into an explicit conjunction structure
  for readability
- recorded the learner preference to avoid repeated concept circling after
  demonstrated competence
- scaffolded Session 8 provenance and membership exercises

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
  checked before scaffolding
- the same command checked after scaffolding, with five intended `sorry`
  warnings

Learner response / behavior:
- completed the local and recursive score contracts
- asked for more exercises and faster advancement through already-practiced
  concepts

Tutor analysis:
- selector validity and fallback-score monotonicity are now sufficiently
  practiced
- next session should change proof shape to membership/provenance, not add more
  preservation variants

Checkpoint result:
- Unit 2 now has validity, output monotonicity, and a combined basic selector
  contract over the fallback
- current frontier is proving selector provenance over list membership

Next move:
- solve Session 8's five provenance exercises, then proceed toward global
  optimality over valid candidates

### 2026-04-26 - Unit 2 Validity Lift And Pacing Calibration

Session intent:
- review the list-wide validity theorem and prepare a faster but feasible next
  Unit 2 batch

Tutor actions:
- validated `selectBestQuote_valid_if_fallback_valid`
- recorded the learner preference for multi-exercise sessions
- recorded the learner preference for hint-first guidance instead of direct
  proof answers
- scaffolded Session 7 score-monotonicity exercises in Unit 2 Scratch

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
  checked after the learner proof
- the same command checked after adding Session 7, with three intended `sorry`
  warnings

Learner response / behavior:
- completed the recursive validity lift
- explicitly asked for more exercises per session and less direct answer-giving

Tutor analysis:
- the learner can handle batched selector-contract work
- future hints should stop short of full proof skeletons unless requested

Checkpoint result:
- list-wide validity preservation is complete
- current frontier is score monotonicity and combining selector contracts

Next move:
- solve the three Session 7 exercises in order, using local-to-global lifting
  again

### 2026-04-26 - Unit 2 Warm-Up Review And List-Wide Validity

Session intent:
- review the first Unit 2 selector proofs and continue to the next prepared
  exercise if they were sound

Tutor actions:
- inspected `Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
- validated the learner's three local `betterQuote` lemmas
- scaffolded `selectBestQuote_valid_if_fallback_valid` as the next exercise

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
  checked after the learner proofs
- the same command checked again after adding the next exercise, with one
  intended `sorry` warning

Learner response / behavior:
- completed the warm-up proofs cleanly
- should be moved to stronger recursive selector contracts rather than more
  local Boolean simplification drills

Tutor analysis:
- proofs are correct; only minor readability improvement is to reduce
  unnecessary case splitting when a direct selector-condition split would expose
  the proof shape more compactly

Checkpoint result:
- local `betterQuote` validity preservation is established
- current frontier is list-wide validity for `selectBestQuote`

Next move:
- solve `selectBestQuote_valid_if_fallback_valid` by induction on `quotes`,
  generalizing `fallback`

### 2026-04-26 - Unit 2 Scratch Scaffold

Session intent:
- correct the session workflow so the learner can work in the unit-specific
  Lean file instead of continuing everything in global `Basic.lean`

Tutor actions:
- scaffolded Session 6 in
  `Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
- introduced `Quote`, `isValidQuote`, `betterQuote`, `selectBestQuote`, and
  three local selector lemmas with `sorry` placeholders
- updated the checkpoint to mark Unit 2 Scratch as the active live artifact

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
  checks with intended `sorry` warnings

Learner response / behavior:
- clarified that the agentic book should set up each session before handoff
- correctly recalled that per-unit Lean files are part of the intended book
  design

Tutor analysis:
- future sessions should prepare the working file first, then give concise
  instructions
- `Basic.lean` should remain the historical/live reference for earlier work
  unless a deliberate migration is requested

Checkpoint result:
- Unit 2 has started as an active Lean artifact
- the current unsolved frontier is the local `betterQuote` theorem trio

Next move:
- learner replaces the `sorry`s in Unit 2 Scratch, then tutor reviews and
  validates before introducing list-wide selector correctness

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
