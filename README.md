# Leaning

Hands-on Lean 4 learning workspace for a strong protocol/DeFi engineer.

This repo is being structured as a small book:

- active, tutor-driven
- proof-oriented but not math-homework-first
- protocol/mechanism shaped
- adaptive to the learner, not a static worksheet dump

The main live scratch/reference artifact remains
[`Leaning/Basic.lean`](Leaning/Basic.lean).

## How To Use This Repo

- Use [`Leaning/Basic.lean`](Leaning/Basic.lean) as the fast scratchpad,
  restart surface, and current live interaction file.
- Use `Leaning/Units/*/Core.lean` as the curated artifact for a unit.
- Use `Leaning/Units/*/Scratch.lean` for unit-local experiments and dead ends.
- Use [`MEMORY.md`](MEMORY.md) as the learner/tutor state ledger.
- Use [`AGENTS.md`](AGENTS.md) for the tutor operating contract.

## Book Structure

This book follows a mixed spiral progression:

- Lean/proof workflow
- mathlib/tool growth
- protocol and market modeling
- verification-bridge units toward Rust/Aeneas-style work

## Units

### Unit 0: Proof Workflow

- Lean interaction and proof-state reading
- tiny state machines
- guarded transitions
- first invariants and postconditions

### Unit 1: Traces and Summaries

- event interpreters
- append/compositionality laws
- summary-vs-execution theorems
- restricted traces
- `Bool` vs `Prop`

### Unit 2: Selector Kernels

- candidate/quote models
- feasibility predicates
- best-valid-choice correctness
- tie-breaking and filtering

### Unit 3: Strategic Games and Mechanisms

- finite game/mechanism kernels
- players, actions, outcomes, payoffs
- best responses and dominance-style reasoning
- bridge to DeFi mechanism design

### Unit 4: Arithmetic and Bounds

- bounded controller math
- monotonicity and threshold reasoning
- arithmetic/cast management for protocol math
- targeted mathlib/tactic exposure for later units

### Unit 5: Keyed Ledgers and Failure Semantics

- finite/keyed state
- credit/debit/transfer
- `Option` / `Except`
- state equality, untouched-key lemmas, conservation

### Unit 6: AMM Core

- idealized constant-product AMM
- fee-aware swaps
- invariant-style reasoning
- later discrete/integer wrinkles
- optional LP accounting add-on

### Unit 7: Dynamic Fee Mechanisms

- dynamic fee controller `fee(state)` or `fee(state, action)`
- boundedness / monotonicity / normalization
- execution under dynamic fees
- toy game-theoretic / mechanism-design layer

### Unit 8: Protocol State Machines

- lending/accounting kernels
- risk and liquidation
- authorization/capabilities
- time, epochs, oracle freshness
- optional authenticated-state sub-unit (for example Merkle-style proofs)

### Unit 9: Market Mechanisms

- routing / aggregator kernels
- intent / auction settlement
- orderbook state-machine kernels

### Unit 10: Verification Bridges

- reachable-state invariants
- spec-vs-implementation refinement
- accumulator loops and invariants
- indexed updates and localized mutation
- Rust/Aeneas-adjacent capstone

## What This Book Is Optimizing For

- real protocol reasoning, not only theorem drills
- multiple proof shapes, not only invariant preservation
- forward-looking formal methods intuition
- explicit transfer into DeFi / crypto / verification work

## What Is Intentionally Deferred

The roadmap deliberately does **not** start with:

- concentrated liquidity
- full Hyperliquid-style exchange kernels
- deep continuous-economics proofs
- full direct Rust verification
- subtype-heavy arithmetic as the default beginner surface

Those can come later, once the core unit sequence is stable.

## Current State

- `Leaning/Basic.lean` contains the live progression to date.
- A snapshot was preserved at
  [`Leaning/Appendix/BasicHistory.lean`](Leaning/Appendix/BasicHistory.lean).
- The units are now scaffolded so the book can evolve without flattening all
  work into one file.
