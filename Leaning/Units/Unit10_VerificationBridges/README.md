# Unit 10: Verification Bridges (capstone)

## Purpose

- Introduce Layer B: computable integer arithmetic over `Nat`/`Int` as a
  discrete approximation to the Layer A continuous specs from Units 4-9
- Prove approximation theorems: integer output vs continuous spec within ε
- Prove rounding direction: integer AMM implementations always round against
  the user, never against the protocol (no free tokens from rounding)
- Sketch the connection path toward Solidity/Rust implementations

## Why it matters

Layer A specs are mathematically clean but not directly executable — real
contracts operate on `uint256` integers. This unit is what makes the formal
verification practically useful: a Lean proof that your integer implementation
of `constprod` is within ε of the continuous spec, and that the rounding always
goes in the protocol's favor. This eliminates a class of real exploits where
rounding errors accumulate into drained reserves.

The lean4-amm reference deliberately stops at Layer A — it explicitly defers
EVM-faithful integer arithmetic. Unit 10 is where this book goes further.

## Layer A → Layer B bridge

```
Layer A (Units 4-9)           Layer B (Unit 10)
─────────────────────         ─────────────────────────────────
NNReal / PReal                Nat, Int (or ℕ, ℤ in Lean)
noncomputable def             computable def
constprod x r0 r1 = r1/(r0+x)  constprod_int x r0 r1 = r1*x/(r0+x)  (integer division)
x * sx x r0 r1 < r1           x * sx_int x r0 r1 ≤ r1    (≤ because floor rounding)
```

## Typical theorem families

- `discrete_outputbound` — integer implementation never exceeds the continuous
  output bound: `sx_int x r0 r1 ≤ ⌊sx x r0 r1⌋`
- `rounding_direction` — protocol-safe rounding: the integer implementation
  rounds down (against the user), never up
- `approximation_gap` — `|sx_int x r0 r1 - sx x r0 r1| < 1` (unit error bound
  from floor division)
- `overflow_safety` — `x * r1 ≤ Nat.max_val` for realistic reserve sizes
  (uint256 range safety)
- `constprod_int_correct` — the integer constprod agrees with the real spec up
  to a rounding bound that is tight

## Design notes

- This unit uses `Nat.div` (floor division) as the integer model; the appendix
  extends to `Int` and fixed-point (`Q64.96`) representations
- Rounding direction is proved by showing `⌊a/b⌋ * b ≤ a` (which Lean's
  `Nat.div_mul_le_self` gives for free) and that the AMM charges this floor
- Overflow safety requires `omega` or `decide` for bounded sizes; for
  uint256-scale (`2^256`) it requires careful algebraic bounds
- The stableswap Newton iteration (Unit 9) has a natural Layer B counterpart:
  the Vyper `_get_D` loop — bridging this is a named future extension

## Connection to Rust/Aeneas (named future target)

Aeneas (Ho et al., ICFP 2022) is a Lean 4 backend for Charon, which extracts
Lean 4 models from Rust source via LLBC (low-level borrow calculus). The path:

```
Rust AMM implementation
  → Charon (LLBC extraction)
  → Lean 4 model (via Aeneas)
  → refinement proof against Layer A spec
```

This is currently a research-level target — the Aeneas toolchain handles safe
Rust well but AMM integer arithmetic often hits edge cases. It is the most
ambitious form of the verification bridge and is named here so future work can
connect to it directly.

- Aeneas repo: https://github.com/AeneasVerifier/aeneas
- Paper: "Aeneas: Rust Verification by Functional Translation" (ICFP 2022)

## Reference material

**lean4-amm** deliberately stops at Layer A; there is no integer bridge in the
reference. This unit is original work.

For context on what a faithful integer model looks like in practice:

- `.context/papers/tickmath-tranquilli-2024.pdf` — Tranquilli & Gupta model the
  Uniswap v3 tick math integer arithmetic in TLA+ and prove the rounding error
  is tight. The error bound structure there is the closest published analog to
  what this unit does for constprod/stableswap (arXiv 2512.06203).

- `.context/curve-contract/contracts/pool-templates/base/SwapTemplateBase.vy`
  — the stableswap `_get_D` and `_get_y` Vyper implementations use
  `A_PRECISION = 100` fixed-point scaling and iterate with integer Newton steps;
  this is the Layer B stableswap target for the Integer Bridge Appendix.

Papers in `.context/papers/`:
- `lean4-amm-pusceddu-bartoletti-2024.pdf` — Section 7 ("Future Work") names
  the integer bridge as the primary open problem (arXiv 2402.06064)
- `tickmath-tranquilli-2024.pdf` — closest existing work on AMM integer
  arithmetic error bounds, in TLA+ (arXiv 2512.06203)
