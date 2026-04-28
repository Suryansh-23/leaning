# Curriculum Map

## Primary Sequence

1. Unit 0: Proof Workflow
2. Unit 1: Traces and Summaries
3. Unit 2: Selector Kernels
4. Unit 3: Mechanism Design for On-Chain Markets
5. Unit 4: NNReal and Continuous Arithmetic
6. Unit 5: Finsupp Ledgers
7. Unit 6: AMM Kernels and the SX Framework
8. Unit 7: AMM Economic Properties
9. Unit 8: LP Mechanics
10. Unit 9: Novel AMM Designs
11. Unit 10: Verification Bridges (capstone)

Appendix: Integer Bridge — computable approximation theorems connecting the
continuous Layer A specs (Units 6-8) to integer implementations

## Layer Model

- Units 4-9: Layer A — noncomputable, mathematical specification over ℝ≥0 and
  ℝ>0; proves economic and structural properties
- Unit 10 / Appendix: Layer B — computable, integer arithmetic, approximation
  and rounding theorems bridging spec to implementation

## Adjacent Escape Routes

- Unit 0 → Unit 1 or Unit 2
- Unit 1 → Unit 2 or Unit 5
- Unit 2 → Unit 3 or Unit 4
- Unit 3 → Unit 4 (mechanism design reappears in Unit 9 novel fee design)
- Unit 4 → Unit 5 (NNReal/Finsupp are the shared number system)
- Unit 5 → Unit 6 (ledger state is the AMM state container)
- Unit 6 → Unit 7 or Unit 8
- Unit 7 → Unit 8 or Unit 9
- Unit 9 → Unit 10 (capstone connects designs to computable implementations)

## Reference Implementation

dpusceddu/lean4-amm (Pusceddu & Bartoletti, FMBC 2024) — cloned to
`.context/lean4-amm`. Engage with it directly starting at Unit 6 to calibrate
against established results and identify extension points.

## Purpose

This map is for tutor routing. Do not dump solutions into docs.
