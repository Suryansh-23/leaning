# Tool Index

This appendix is for durable indexing, not for spoon-feeding solutions.

## Current Baseline

Already encountered in `Leaning/Basic.lean`:

- `def`, `structure`, `inductive`
- pattern matching and recursive definitions
- `theorem`, `Prop`, implication, conjunction
- `rfl`, `intro`, `exact`
- `cases`, `by_cases`, `induction`
- `simp`, `simp_all`, `dsimp`
- `Nat.le_trans`, `Nat.add_le_add`, `Nat.add_assoc`
- recursive list proofs and append-style lemmas

## Near-Term Expansion

Likely to matter in the next several units:

- `rw` for explicit rewriting
- `have` for intermediate facts
- `calc` for chained equalities and inequalities
- `rcases` for structured hypothesis unpacking
- `apply` and `specialize` for theorem/IH use
- selected mathlib arithmetic tactics:
  `norm_num`, `linarith`, `ring`, `field_simp`, `zify`, `qify`

## Modeling Patterns

- state -> transition -> invariant
- reducer -> append/compositionality law
- summary -> execution correspondence
- selector -> feasibility/membership/bestness
- controller -> boundedness/monotonicity
- mechanism -> payoff/best-response style property

## Failure Modes To Track

- overusing automation without understanding the proof shape
- induction hypotheses that are too specific
- `Bool` and `Prop` getting mixed without a deliberate bridge
- definitions that are elegant point-free code but awkward for simplification
