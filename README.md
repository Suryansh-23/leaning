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

### Unit 3: Mechanism Design for On-Chain Markets

- 2-player normal-form games, dominance, best response
- direct mechanisms: second-price auctions, truthful reporting
- incentive compatibility as a formal property
- groundwork for fee design and auction settlement in later units

### Unit 4: NNReal and Continuous Arithmetic

- `ℝ≥0` (NNReal) and `ℝ>0` (PReal) as the number system for protocol math
- `noncomputable` definitions and why they are right for mathematical specs
- ordered field reasoning, positivity, division, and sqrt
- Finsupp preview: finitely-supported functions as the ledger primitive

### Unit 5: Finsupp Ledgers

- `Finsupp T NNReal` as the wallet model (token → balance)
- transfer, conservation, and untouched-key lemmas
- multi-token state and account-indexed wallet sets
- direct preparation for the AMM state container in Unit 6

### Unit 6: AMM Kernels and the SX Framework

- `SX = ℝ>0 → ℝ>0 → ℝ>0 → ℝ>0` as the parametric swap function type
- constant-product as the first `SX` instance
- output bound, no-drain, homogeneity, scale invariance
- calibrated against dpusceddu/lean4-amm (Pusceddu & Bartoletti, FMBC 2024)

### Unit 7: AMM Economic Properties

- net worth, gain, and oracle-relative valuation
- arbitrage direction: profit implies no reverse profit
- optimal trade size: closed-form arbitrage for constant-product
- rational actor framing for adversarial reasoning

### Unit 8: LP Mechanics

- deposit and redeem as state transitions
- LP token minting, burning, and supply conservation
- LP token pricing: (r0·p0 + r1·p1) / supply
- invariants across the full create/deposit/swap/redeem lifecycle

### Unit 9: Stableswap — Novel AMM Design Capstone

- Curve Finance stableswap as a second `SX` instance, proved against the full
  property suite (outputbound, homogeneous, strictmono)
- D existence and uniqueness via the intermediate value theorem
- Newton-Raphson convergence for the `get_y` cubic solve (stretch goal)
- first proof-assistant formalization of stableswap — fills a gap in the literature
- comparison with constprod: formally proving stableswap gives lower slippage near peg

### Unit 10: Verification Bridges (capstone)

- Layer B: computable integer arithmetic over `Nat`/`Int`
- approximation theorems: discrete output vs continuous spec within ε
- rounding direction proofs (always round against user, never against protocol)
- connection path to real Solidity/Rust implementations

### Appendix: Integer Bridge

- overflow safety for `uint256`-scale arithmetic
- fixed-point representations and their Lean models
- extended approximation results from Unit 10

## What This Book Is Optimizing For

- AMM design and DeFi protocol reasoning as the primary thread
- Layer A (noncomputable, mathematical) for economic and structural proofs
- Layer B (computable, integer) as a capstone verification bridge
- parametric framework first, concrete instances second
- novel AMM designs as the culmination, not an afterthought

## What Is Intentionally Deferred

- concentrated liquidity (Uniswap v3 tick math) — a named future target after
  Unit 9, not in the primary sequence
- full EVM semantics and Solidity extraction — appendix territory
- deep continuous-economics proofs beyond what the SX framework needs
- subtype-heavy arithmetic before the learner is ready for it

## Current State

- `Leaning/Basic.lean` contains the live progression to date.
- A snapshot was preserved at
  [`Leaning/Appendix/BasicHistory.lean`](Leaning/Appendix/BasicHistory.lean).
- The units are now scaffolded so the book can evolve without flattening all
  work into one file.
