# Unit 10: Verification Bridges (capstone)

## Purpose

- Introduce Layer B: computable integer arithmetic over `Nat`/`Int` as a
  discrete approximation to the Layer A continuous specs from Units 4-9
- Prove approximation theorems: integer swap output vs continuous spec within ε
- Prove rounding direction: integer AMM implementations always round against
  the user, never against the protocol (no free tokens from rounding)
- Identify the connection path toward Solidity/Rust implementations via Aeneas

## Why it matters

Layer A specs are mathematically clean but not directly executable — real
contracts operate on `uint256` integers with floor division. This unit is what
makes formal verification practically useful: a Lean proof that your integer
implementation of `constprod` is within 1 unit of the continuous spec, and that
the rounding always favors the protocol. This eliminates a real exploit class
where rounding accumulates into drained reserves.

The lean4-amm reference explicitly defers this: "we leave as future work the
formalization of integer arithmetic and its connection to the continuous model"
(paper Section 7). Unit 10 is where this book takes that step.

**No existing proof assistant work formalizes an integer AMM approximation
bound.** The only comparable work is Tranquilli & Gupta's TLA+ model checking
(arXiv 2512.06203), which proves the rounding slack for Uniswap v3 tick math
but uses model checking, not a proof assistant. Q64.96 and UQ112x112 fixed-point
representations are unformalized in Lean, Coq, or Isabelle as of 2026.

---

## Layer A → Layer B bridge

```
Layer A (Units 4-9)                     Layer B (Unit 10)
────────────────────────────────        ──────────────────────────────────────
NNReal / PReal                          Nat, Int
noncomputable def                       computable def
r1 / (r0 + x)  ∈ ℝ>0                   r1 * x / (r0 + x)  : Nat  (floor div)
x * sx x r0 r1 < r1   (strict)         x * sx_int x r0 r1 ≤ r1   (≤, not <)
```

The gap: `x * sx_int x r0 r1 = ⌊x * r1 / (r0 + x)⌋ ≤ x * r1 / (r0 + x) < r1`

The rounding direction proof chains three inequalities:
floor div rounds down → output ≤ continuous output → continuous output < reserve

---

## Key Mathlib surfaces (Unit 10's main new tools)

All in stable Mathlib4 — no external dependencies needed:

| Lemma | Location | Use |
|---|---|---|
| `Int.floor_le` | `Mathlib.Algebra.Order.Floor.Defs` | `⌊a⌋ ≤ a` |
| `Int.sub_one_lt_floor` | same | `a - 1 < ⌊a⌋` (tight bound) |
| `Int.le_ceil` | same | `a ≤ ⌈a⌉` |
| `le_floorDiv_iff_smul_le` | `Mathlib.Algebra.Order.Floor.Div` | Galois connection for floor div |
| `ceilDiv_le_iff_le_smul` | same | Galois connection for ceil div |
| `Nat.div_add_mod` | `Init.Data.Nat.Div.Basic` | `n / k * k + n % k = n` |
| `Nat.div_mul_le_self` | same | `n / k * k ≤ n` (floor rounds down) |
| `omega` | core tactic | closes all linear `Nat`/`Int` goals after casting |
| `norm_cast` / `push_cast` | Mathlib | bridges `Nat`/`Int`/`Real` coercions |

---

## Typical theorem families

- `discrete_outputbound` — `sx_int x r0 r1 ≤ ⌊sx x r0 r1⌋`
  integer output never exceeds the floor of the continuous output

- `rounding_direction` — `sx_int x r0 r1 * (r0 + x) ≤ r1 * x`
  the integer implementation rounds in the protocol's favor (user gets ≤ exact)

- `approximation_gap` — `sx x r0 r1 - sx_int x r0 r1 < 1`
  error is strictly less than 1 (one unit of the base denomination)

- `overflow_safety` — `r1 * x ≤ 2^256 - 1` for `x, r1 ≤ 2^128`
  intermediate product stays within `uint256`; proved by `omega` after bounding

- `constprod_int_correct` — combining all of the above into a single statement:
  "the integer constprod is a correct approximation of the continuous spec"

---

## Design notes

- Use `Nat` as the integer model for this unit; the appendix extends to `Int`
  and discusses Q64.96 fixed-point (which is unformalized in any proof assistant)
- The stableswap Newton iteration (Unit 9) has a natural Layer B counterpart:
  the Vyper `_get_D` and `_get_y` loops in
  `.context/curve-contract/contracts/pool-templates/base/SwapTemplateBase.vy`
  — bridging these is a named future extension (Integer Bridge Appendix)
- For `uint256` overflow: Lean's `Nat` is unbounded, so overflow is modeled as
  a precondition (`h : x * r1 ≤ 2^256 - 1`) not a runtime behavior

---

## Rust/Aeneas connection (named future target)

**Aeneas** (Ho, Protzenko, Fromherz — ICFP 2022) is a Lean 4 backend for
Charon, which extracts Lean 4 models from Rust source via LLBC (low-level
borrow calculus). The pipeline:

```
Rust AMM implementation
  → Charon (LLBC extraction, CAV 2025)
  → Lean 4 model (via Aeneas)
  → refinement proof connecting Lean model to Layer A spec
```

Aeneas has been applied to cryptographic libraries (Kyber/ML-KEM for Mozilla
NSS, Microsoft SymCrypt). No DeFi or AMM application exists yet — that gap is
exactly what this target represents. The refinement proof would connect a real
Rust `constprod` implementation to the Layer A `SX.constprod` spec from Unit 6.

This is a research-level target, not a Unit 10 exercise. It is named here so
future work can connect to it directly.

---

## Research resources

### Primary

- **Tranquilli & Gupta, "Formal State-Machine Models for Uniswap v3"** (2024)
  The only published work formally bounding the rounding error of an integer AMM.
  Proves that the tick math approximation error is tight (Theorem 1 / Def 4).
  Uses TLA+ / PTA model checking, not a proof assistant — this unit's proof
  assistant version is original work.
  - `.context/papers/tickmath-tranquilli-2024.pdf`
  - arXiv: https://arxiv.org/abs/2512.06203

- **Ho, Protzenko, Fromherz — "Aeneas: Rust Verification by Functional Translation"**
  ICFP 2022. The Rust → Lean 4 extraction pipeline that defines the long-term
  connection path for verified integer AMM implementations.
  - `.context/papers/aeneas-ho-2022.pdf`
  - arXiv: https://arxiv.org/abs/2206.07185
  - Repo: `.context/aeneas/`

### Supporting

- **Pusceddu & Bartoletti 2024** — Section 7 names the integer bridge as the
  primary open problem; Unit 10 is the answer
  - `.context/papers/lean4-amm-pusceddu-bartoletti-2024.pdf`

- **Curve stableswap reference (Vyper)** — `_get_D` and `_get_y` are the
  Layer B stableswap targets; `A_PRECISION = 100` fixed-point scaling is the
  concrete representation to eventually formalize
  - `.context/curve-contract/contracts/pool-templates/base/SwapTemplateBase.vy`

### Mathlib docs (direct working references)

- https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Order/Floor/Defs.html
- https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Order/Floor/Div.html
- https://leanprover-community.github.io/mathlib4_docs/Init/Data/Nat/Div/Basic.html
- https://leanprover-community.github.io/mathlib4_docs/Init/Data/Int/DivMod.html
