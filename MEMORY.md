# Tutor Memory

This file is readable markdown but optimized for the tutor agent.
Use it as retrieval-first learner and repo state, not as another instruction
file.

## Progress Ledger

This is the canonical checkpoint section for the tutoring system.
When the tutor needs to know "where are we?", start here before inferring from
the rest of the repo.

Current unit:
- Unit 5: Finsupp Ledgers

Current sub-unit / frontier:
- Unit 5 next: keyed ledger / Finsupp wallet surface in
  `Leaning/Units/Unit5_KeyedLedgers/Scratch.lean`

Last solid checkpoint:
- Unit 4 closed out: NNReal constprod arithmetic and PReal/SX wrapper surface
  proved in Scratch.lean, migrated into Core.lean, and full package build checks

Current live artifact:
- `Leaning/Units/Unit5_KeyedLedgers/Scratch.lean`

Current curated migration status:
- Unit 2 Core.lean fully populated
- Unit 3 Core.lean fully populated
- Unit 4 Core.lean fully populated

Ready to branch into:
- Unit 5: Finsupp ledgers over sparse token-balance maps

Explicitly not started as Lean artifacts yet:
- Unit 6: AMM Kernels and the SX Framework (constprod, outputbound, homogeneous, etc.)
- Unit 7: AMM Economic Properties (gain_direction, arbitrage_solve)
- Unit 8: LP Mechanics (deposit, redeem, supply conservation)
- Unit 9: Novel AMM Designs (fee-aware SX, new invariant curves)
- Unit 10: Verification Bridges / Integer Bridge (capstone)

Reference material (all in `.context/`, gitignored):
- `.context/lean4-amm/` — dpusceddu/lean4-amm (Pusceddu & Bartoletti, FMBC 2024)
  calibration target for Unit 6 SX definitions and property names
- `.context/papers/lean4-amm-pusceddu-bartoletti-2024.pdf` — FMBC 2024 paper
- `.context/papers/lean4-amm-fees-bartoletti-2025.pdf` — 2025 fees follow-on
- `.context/papers/stableswap-egorov-2019.pdf` — Curve stableswap whitepaper
- `.context/curve-contract/` — Curve Finance reference Vyper implementation
- `.context/papers/coq-dex-nielsen-2023.pdf` — Coq/ConCert DEX (CPP 2023)
- `.context/papers/tickmath-tranquilli-2024.pdf` — TLA+ tick math (2024)

Unit 9 capstone: stableswap (Curve v1) as a novel SX instance — first
proof-assistant formalization of stableswap anywhere

Unit 10 research findings:
- No existing proof assistant formalizes an integer AMM approximation bound
- Tranquilli & Gupta (arXiv 2512.06203) is the only published rounding-bound
  work for integer AMMs — uses TLA+, not a proof assistant
- Q64.96 / UQ112x112 fixed-point representations unformalized in any system
- Aeneas (arXiv 2206.07185) is the Rust → Lean 4 extraction pipeline; no DeFi
  application exists yet
- Key Mathlib surfaces: Int.floor_le, Nat.div_add_mod, le_floorDiv_iff_smul_le,
  omega, norm_cast — all in stable Mathlib4

## Last Checkpoint

Date:
- 2026-04-28

What was verified:
- `Leaning/Units/Unit4_ArithmeticAndBounds/Scratch.lean` checks clean
- `Leaning/Units/Unit4_ArithmeticAndBounds/Core.lean` checks clean
- `~/.elan/bin/lake build Leaning` completes successfully

What was established:
- Unit 4 now has a stable continuous Layer A arithmetic surface
- `constprod` output bound, denominator monotonicity, and homogeneity are
  available in Core.lean
- `PReal` positivity-by-type wrappers are available for the SX framework
- the next content branch should move into sparse keyed ledger state

Next intended move:
- scaffold Unit 5 Session 16 in `Leaning/Units/Unit5_KeyedLedgers/Scratch.lean`

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

- Active live file: `Leaning/Units/Unit4_ArithmeticAndBounds/Scratch.lean`
- Covered so far:
  - tiny state models
  - guarded transitions
  - aggregates and traces
  - trace summaries
  - local quote-selector facts for `betterQuote`
  - list-wide validity preservation for `selectBestQuote`
  - score monotonicity and combined validity/output contract
  - provenance and candidate membership for `selectBestQuote`
  - global optimality over valid allowed candidates
- Current Unit 3 surface:
  - finite two-player normal-form game model
  - weak dominance and best-response specs
  - dominance reflexivity/transitivity and dominant strategy implies best
    response
  - concrete Prisoner's Dilemma Prop proofs and executable Bool sanity checks
  - direct second-price auction mechanism scaffold
- Current repo transition:
- active learner work should now start Unit 5 after Unit 4 migration

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

### 2026-04-27

Observation:
- The learner has undergrad-level game theory background and does not need
  basic game-theory concepts overexplained in Unit 3.

Why it matters:
- Unit 3 roundups should focus on Lean modeling/proof tools, theorem-shape
  decisions, and mechanism/formalization tradeoffs, not textbook explanations
  of dominance or best response.

How the tutor should adapt:
- Assume game-theory concepts like dominance, best response, and normal-form
  games are familiar. Spend teaching budget on bounded quantifiers, spec
  design, `omega`, decidable examples, and proof structure.

Status:
- active

### 2026-04-27

Observation:
- The learner wants hints broken into smaller staged steps; a direct full proof
  shape for `selectBestQuote_optimal_for_allowed_candidates` was too large.

Why it matters:
- Even when avoiding full solutions, giving the whole branch plan can remove
  too much of the problem-solving work.

How the tutor should adapt:
- For stuck-proof help, give only the next one or two moves first. Wait for the
  learner to ask before escalating to branch structure, theorem selection, or
  skeletons.

Status:
- active

### 2026-04-26

Observation:
- The learner clarified that "more problems per session" means compressing each
  unit into fewer, faster sessions, not adding more micro-drills around the same
  concept.

Why it matters:
- Session batches should cover coherent concept arcs and move the unit forward,
  rather than increasing volume without increasing progression rate.

How the tutor should adapt:
- Design larger sessions that combine setup, one or two core proof shapes,
  definition/spec work, and a stretch/bundling theorem when feasible.

Status:
- active

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

### 2026-04-28 - Unit 4 Curated Into Core

Session intent:
- migrate completed Unit 4 arithmetic/PReal work into the curated unit artifact

Tutor actions:
- replaced the placeholder `Leaning/Units/Unit4_ArithmeticAndBounds/Core.lean`
  with the stable NNReal constprod and PReal wrapper API
- kept the scratch file as the worked session history
- fixed namespace shadowing in PReal theorem statements by qualifying the
  underlying NNReal `constprod` family
- updated the checkpoint ledger to make Unit 5 the next live branch

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit4_ArithmeticAndBounds/Core.lean`
  checks cleanly
- `~/.elan/bin/lake build Leaning` completes successfully

Learner response / behavior:
- approved moving ahead after completing Session 15

Tutor analysis:
- Unit 4 is now a useful dependency for future units, not just a scratch result
- the core surface still uses some broad `simp` proof style inherited from the
  learning session; acceptable for now, but later library-grade cleanup can
  tighten these proofs if needed

Checkpoint result:
- Unit 4 closed out and curated
- current frontier is Unit 5 keyed/Finsupp ledgers

Next move:
- scaffold Unit 5 Session 16 with a prerequisite roundup for `Finsupp`,
  sparse maps, keyed updates, and untouched-key reasoning

### 2026-04-28 - Unit 4 Session 15 Complete

Session intent:
- review completed PReal/SX wrapper exercises

Tutor actions:
- inspected `Leaning/Units/Unit4_ArithmeticAndBounds/Scratch.lean`
- validated the solved Session 15 definitions and lifted theorem proofs
- updated the checkpoint ledger to mark Session 15 complete

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit4_ArithmeticAndBounds/Scratch.lean`
  checks cleanly with no warnings

Learner response / behavior:
- completed the PReal wrapper batch quickly and cleanly

Tutor analysis:
- Session 15 score: 9/10. The definitions show the right type-level positivity
  model and the theorem proofs correctly reuse the NNReal facts rather than
  redoing the arithmetic. Minor growth point: prefer recognizing when a direct
  wrapper theorem call plus projection lemma is clearer than a broad `simp`
  call, especially as the PReal/SX API grows.

Checkpoint result:
- Unit 4 Scratch now has both the NNReal arithmetic facts and a PReal/SX-shaped
  wrapper surface for constprod

Next move:
- migrate stable Unit 4 material into Core.lean, then branch to Unit 5 Finsupp
  ledgers unless a short SX-type alias bridge is desired first

### 2026-04-28 - Unit 4 Session 15 Scaffolded

Session intent:
- prepare the next Unit 4 session after completed NNReal constprod arithmetic

Tutor actions:
- inspected the current Unit 4 scratch file, Unit 4 README, curriculum map, and
  checkpoint ledger
- scaffolded Session 15 in
  `Leaning/Units/Unit4_ArithmeticAndBounds/Scratch.lean`
- added a prerequisite roundup for PReal subtype wrappers, `.val`/`.property`,
  namespaced helper definitions, wrapper theorem transport, and avoiding subtype
  equality pitfalls
- used a bounded prerequisite audit to confirm the session should focus on
  wrapper/transport mechanics rather than redoing raw division arithmetic

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit4_ArithmeticAndBounds/Scratch.lean`
  checks with seven intended `sorry` warnings

Learner response / behavior:
- asked the tutor to choose the next sensible session after completing Session 14

Tutor analysis:
- Unit 4 should now cross the boundary from `NNReal` arithmetic into the
  positivity-by-type surface needed for Unit 6 SX kernels
- the session is intentionally larger than a micro-drill but avoids repeating
  the completed division algebra

Checkpoint result:
- Session 15 is ready in Unit 4 Scratch; current unsolved frontier is PReal
  multiplication/division, `PReal.constprod`, and three lifted constprod facts

Next move:
- learner completes Session 15, then tutor reviews, validates, scores, and
  likely migrates stable Unit 4 material into Core.lean

### 2026-04-28 - Unit 4 Session 14 Complete

Session intent:
- review completed NNReal constprod arithmetic proofs

Tutor actions:
- inspected `Leaning/Units/Unit4_ArithmeticAndBounds/Scratch.lean`
- validated Session 14 with Lean
- made a small proof-local cleanup in `constprod_outputbound` so the positive
  trade-size hypothesis is used explicitly and the file checks without warnings

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit4_ArithmeticAndBounds/Scratch.lean`
  checks cleanly

Learner response / behavior:
- completed the NNReal arithmetic session after small hints on division
  rewriting and denominator monotonicity

Tutor analysis:
- Session 14 score: 8.5/10. The core AMM arithmetic facts are proved and the
  learner handled new Mathlib arithmetic tools well. Remaining growth is
  recognizing which rewrite lemmas need explicit positivity hypotheses and when
  a theorem hypothesis is economically meaningful but mathematically redundant.

Checkpoint result:
- Unit 4 now has `constprod` positivity, output bound, denominator monotonicity,
  and homogeneity over `NNReal`

Next move:
- either migrate the stable Unit 4 arithmetic to Core or add a short PReal/SX
  wrapper session so positivity assumptions are carried by types before Unit 6

### 2026-04-27 - Roadmap Refit: AMM Design Specialization

Session intent:
- vet and refit the entire curriculum around the learner's primary goal: AMM
  design verification as a formal DeFi modeling foundation

Tutor actions:
- strategic discussion to clarify learner intent (AMM design + DeFi depth,
  not just theorem-proving drills or a single v4-hook use case)
- researched dpusceddu/lean4-amm (Pusceddu & Bartoletti, FMBC 2024) and
  established it as the calibration reference for Units 6-9
- cloned lean4-amm to `.context/lean4-amm/` (gitignored)
- decided on Layer A (noncomputable, continuous math) for Units 4-9 and
  Layer B (computable integer bridge) as a Unit 10 capstone
- decided on Tier 1 (protocol-level, not EVM-heavy) as the primary focus
- refit all unit names and READMEs (Units 3-10) to the AMM specialization path:
  Unit 3 = Mechanism Design, Unit 4 = NNReal/PReal Arithmetic,
  Unit 5 = Finsupp Ledgers, Unit 6 = AMM Kernels & SX Framework,
  Unit 7 = AMM Economic Properties, Unit 8 = LP Mechanics,
  Unit 9 = Novel AMM Designs, Unit 10 = Verification Bridges
- rewrote docs/curriculum-map.md and README.md units section to match

Validation / tests:
- no Lean files changed; documentation refit only

Learner response / behavior:
- confirmed continuous-first is the right abstraction level
- confirmed AMM design as the core specialization
- confirmed Layer B integer bridge as capstone, not a blocker
- confirmed library-based design from Unit 6 onwards is the right shape
- confirmed lean4-amm as a useful reference rather than a direct copy

Checkpoint result:
- curriculum and all unit READMEs aligned to AMM design verification path
- MEMORY.md updated with new unit names and lean4-amm reference

Next move:
- complete Unit 3 Session 13 (second-price auction dominance, 5 sorries)
- then close out Unit 3 and move to Unit 4 NNReal/PReal arithmetic

### 2026-04-27 - Unit 3 Session 12 Complete And Mechanism Fast-Track

Session intent:
- review completed finite examples / executable checks and fast-track Unit 3 to
  more relevant mechanism-design content

Tutor actions:
- inspected completed Session 12 in Unit 3 Scratch
- validated Unit 3 Scratch
- scaffolded Session 13 around a toy direct-revelation second-price auction,
  utility, and truthful-reporting dominance
- added a `Decidable` instance for the `winsSecondPrice` Prop wrapper so it can
  be used in executable utility definitions

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit3_StrategicGamesAndMechanisms/Scratch.lean`
  checks with five intended Session 13 `sorry` placeholders

Learner response / behavior:
- completed Session 12 easily and asked to move into tougher, more interesting
  problems that fit the roadmap

Tutor analysis:
- Session 12 score: 9/10. The work is correct and quick; difficulty was too
  low for the learner's current pace. Future Unit 3 sessions should connect
  normal-form reasoning to mechanisms, auctions, dynamic fees, and later market
  mechanisms rather than spending more time on textbook examples.

Checkpoint result:
- Unit 3 now has concrete finite-game examples and executable Bool checks

Next move:
- solve Session 13's second-price auction dominance theorem family, with focus
  on case splits over allocation/payment and Nat-to-Int arithmetic

### 2026-04-27 - Unit 3 Session 12 Scaffold

Session intent:
- scaffold the next Unit 3 session after dominance/best-response basics

Tutor actions:
- read current Unit 3 Scratch and memory checkpoint
- ran a focused prerequisite/scaffold audit via subagent
- scaffolded Session 12 around concrete Prisoner's Dilemma Prop examples,
  executable Bool dominance/best-response checkers, and `#eval` sanity checks
- deferred generic Bool-to-Prop soundness to a later session to avoid API
  overload

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit3_StrategicGamesAndMechanisms/Scratch.lean`
  checks with intended `sorry` warnings for Session 12
- current `#eval` outputs are `false` because the Bool checker definitions are
  placeholders

Learner response / behavior:
- asked to continue immediately after Session 11

Tutor analysis:
- the scaffold fits the clarified faster-session policy: it covers a coherent
  computation bridge rather than adding abstract dominance variants
- prerequisite audit flagged generic reflection/soundness as too much for this
  session

Checkpoint result:
- Unit 3 Session 12 is ready for learner work

Next move:
- complete concrete finite examples and implement executable Bool checkers

### 2026-04-27 - Unit 3 Session 11 Complete

Session intent:
- review completed Unit 3 dominance and best-response scaffold

Tutor actions:
- inspected the completed Session 11 proofs
- validated Unit 3 Scratch
- tested the scaffold's commented `native_decide` examples separately and found
  they do not work with the current Prop-shaped bounded universal definitions
- corrected the scaffold comment to describe finite-list proof or later
  executable Bool checkers instead of misleading `native_decide` examples

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit3_StrategicGamesAndMechanisms/Scratch.lean`
  checks clean
- ad hoc stdin check confirmed the commented `native_decide` examples fail to
  synthesize `Decidable`, so the comment was corrected

Learner response / behavior:
- completed Session 11 after needing one direct walkthrough for the bundled
  best-response theorem

Tutor analysis:
- Session 11 score: 8/10. Definitions and theorem statements are solid, and
  the main proof family checks. The key improvement is proof readability:
  `dominantStrategy_isBestResponse` currently closes the optimality branch with
  `simp_all!`; an explicit `intro a1' hMemAlt` plus applying `hDom` would show
  the intended quantifier-instantiation pattern better.

Checkpoint result:
- Unit 3 now has the basic normal-form game model plus weak dominance,
  best-response, dominance reflexivity/transitivity, and dominant-strategy
  implies best-response

Next move:
- choose between concrete finite game proofs for Prisoner's Dilemma or adding
  executable Bool checkers before moving deeper into mechanisms

### 2026-04-27 - Unit 3 Session 11 Scaffold Audit

Session intent:
- inspect repo state after another agent completed Unit 2 closeout and
  scaffolded Unit 3 Session 11

Tutor actions:
- inspected changed worktree state, AGENTS, MEMORY, README, Unit 2 Core/Scratch,
  and Unit 3 Scratch/Core/README
- validated Unit 2 Core and Scratch
- validated Unit 3 Scratch with intended Session 11 `sorry` placeholders
- ran a focused prerequisite/scaffold audit via subagent
- updated memory to match the live Unit 3 scaffold and learner game-theory
  background

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Core.lean`
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
- `~/.elan/bin/lake env lean Leaning/Units/Unit3_StrategicGamesAndMechanisms/Scratch.lean`

Learner response / behavior:
- reported Session 10 complete and Session 11 scaffolded by another agent
- clarified that standard undergrad game theory should be assumed

Tutor analysis:
- Session 11 scaffold fits Unit 3 and the learner profile; no scaffold patch is
  required before starting
- the main risk is Lean notation density, not game-theory domain overload

Checkpoint result:
- Unit 3 is active and scaffolded for dominance/best-response work

Next move:
- hand off Session 11 with a prerequisite roundup centered on bounded
  quantifiers, conjunction specs, quantified-hypothesis application, `omega`,
  and `native_decide`

### 2026-04-27 - Unit 2 Closeout And Migration Complete

Session intent:
- prove tie-breaking behavior and all-invalid edge case; migrate to Core.lean

Tutor actions:
- scaffolded Session 10 in Scratch.lean (tie theorem, no-valid theorem, order-sensitivity demo)
- migrated all Unit 2 material verbatim from Scratch.lean into Core.lean
- updated Progress Ledger to Unit 3

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Scratch.lean` — clean
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Core.lean` — clean

Learner response / behavior:
- corrected tutor for rewriting proofs instead of copying them; correct feedback

Tutor analysis:
- Session 10 score: 9.5/10. Exercise 1 is idiomatic; Exercise 2 found a more
  compact proof than the hint suggested using `simp_all` instead of manual
  `List.forall_mem_cons` destructuring

Checkpoint result:
- Unit 2 fully closed out; Core.lean populated; Unit 3 is the next frontier

Next move:
- scaffold Unit 3: Strategic Games and Mechanisms

### 2026-04-27 - Unit 2 Global Optimality Complete

Session intent:
- review Session 9 global optimality work and decide whether Unit 2 is ready
  for closeout

Tutor actions:
- inspected the completed global optimality proofs
- validated `Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
- adjusted `dominatesValidCandidate` to use `isValidQuote` rather than raw
  `candidate.valid`, preserving the established executable/spec boundary

Validation / tests:
- `~/.elan/bin/lake env lean Leaning/Units/Unit2_SelectorKernels/Scratch.lean`
  checks cleanly

Learner response / behavior:
- completed the global optimality batch after staged hints around membership,
  implication use, and theorem composition

Tutor analysis:
- Session 9 completion score: 8.5/10. The core theorem family is correct and
  meaningfully advances Unit 2. The remaining growth point is proof
  readability: several proofs lean on `simp[...]` with large theorem arguments,
  which checks but can hide the intended branch structure.

Checkpoint result:
- Unit 2 now has validity, score monotonicity, provenance, and global
  validity-conditioned optimality for allowed candidates

Next move:
- complete a short Unit 2 closeout on tie behavior/determinism, then migrate
  stable material from Scratch to Core

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
