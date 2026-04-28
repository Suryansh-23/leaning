# Unit 9: Stableswap — A Novel AMM Design Capstone

## What this unit is

This is the primary research-oriented capstone of the book. By Unit 9 you have:
- the SX parametric swap framework and constprod instance (Unit 6)
- economic properties: outputbound, gain_direction, arbitrage_solve (Unit 7)
- LP mechanics and pool state transitions (Unit 8)

The goal here is to use all of that as a foundation to formally verify a second,
genuinely different AMM design: **Curve Finance's stableswap (v1)**.

Stableswap is the most important AMM design after constant-product. It is
deployed at billions of dollars of TVL and its invariant is fundamentally
different from x·y=k. **No proof assistant (Lean, Coq, Isabelle, Dafny) has
ever formally verified stableswap.** This unit closes that gap.

---

## Why stableswap

Constant-product (x·y=k) trades off price efficiency for generality. Near a
1:1 peg, it wastes most of the liquidity on price ranges that never get touched.
Stableswap interpolates between the constant-sum invariant (Σxᵢ = D, perfectly
efficient at peg, zero slippage) and constant-product (Πxᵢ = (D/n)^n, safe away
from peg). The amplification coefficient A controls how aggressively the pool
hugs the constant-sum line:

```
A · n^n · Σxᵢ + D = A · n^n · D + D^(n+1) / (n^n · Πxᵢ)
```

- When A → 0: reduces to constant-product x·y = (D/2)²
- When A → ∞: reduces to constant-sum x + y = D
- At A = 1 (the deployed choice for like-pegged assets): a tight band around
  the 1:1 price with graceful degradation at the extremes

The invariant is **not closed-form solvable**. Given input reserve changes, the
new output reserve must be found by Newton-Raphson iteration on a cubic equation.
This is what makes stableswap hard to formally reason about and what makes it an
ideal capstone.

---

## The 2-coin stableswap invariant

For n = 2 coins with reserves x and y, and amplification coefficient A ≥ 1:

```
4A(x + y) + D = 4AD + D³ / (4xy)
```

where D is the total liquidity invariant (the "size" of the pool). D is uniquely
determined by x and y for any fixed A > 0.

The output y' for a trade that moves reserve x to x' is the unique positive
solution to:

```
4A(x' + y') + D = 4AD + D³ / (4x'y')
```

This is a cubic in y'. The reference Vyper implementation solves it via Newton:

```python
# get_y: Newton iteration for new reserve y given new reserve x' and D
y = D  # initial guess
for _ in range(255):
    y_prev = y
    k = D³ / (4 * A * x')          # constant term
    y = (y² + k) / (2y + D/A - D)  # Newton step
    if |y - y_prev| <= 1: break    # integer convergence
```

See the reference Vyper implementation:
`.context/curve-contract/contracts/pool-templates/base/SwapTemplateBase.vy`
(`_get_D`, `_get_y` functions, lines 206–420).

---

## What this unit proves

### Phase 1: D existence and uniqueness

- `stableswap_D_exists`: for any x, y > 0 and A ≥ 1, there exists a unique
  D > 0 satisfying the stableswap invariant
- `stableswap_D_pos`: D > 0 whenever x, y > 0
- This requires the intermediate value theorem over ℝ — the first real use of
  Mathlib's continuous analysis surface

### Phase 2: stableswap as an SX instance

Define `stableswap_sx A x r0 r1 : ℝ>0` as the unique y' solving the invariant
given input reserve change x, reserves r0, r1, and amplification A. Prove:

- `stableswap_outputbound`: x · stableswap_sx(x, r0, r1) < r1
  (can't drain the pool — same safety guarantee as constprod)
- `stableswap_homogeneous`: stableswap_sx(ax, ar0, ar1) = stableswap_sx(x, r0, r1)
  (scale invariance — holds because D scales linearly with reserves)
- `stableswap_strictmono`: larger trades get worse rates
  (price impact increases with trade size)

### Phase 3: Newton convergence (stretch goal)

- `newton_decreasing`: each Newton iterate is a decreasing sequence bounded
  below by zero
- `newton_converges`: the iteration converges to the unique root of the cubic
- This is the hardest part and is explicitly a stretch goal — partial progress
  (monotonicity of iterates, or a fixed-point formulation) counts

### Phase 4: comparison with constprod

- `stableswap_lower_slippage`: near peg (r0 ≈ r1), stableswap output > constprod
  output for the same trade size (the core economic claim of Curve)
- `stableswap_A_monotone`: higher A → output closer to constant-sum

---

## What is novel about this

Across all major proof assistants — Lean, Coq, Isabelle, Dafny — **no
formalization of the stableswap invariant exists**. The research landscape:

| Formal work | System | Covers stableswap? |
|---|---|---|
| Pusceddu & Bartoletti 2024 (lean4-amm) | Lean 4 | No — constprod only |
| Bartoletti et al. 2025 (fees follow-on) | Lean 4 | No — constprod + fees |
| Nielsen, Annenkov, Spitters 2023 | Coq (ConCert) | No — Dexter2/constprod |
| Certora PoolManager verification | CVL/SMT | No — hook accounting only |
| Tranquilli & Gupta 2024 | TLA+ / PTA | No — tick math only |

Completing Phase 2 (stableswap as a verified SX instance) produces the first
proof-assistant formalization of stableswap. Phase 3 (Newton convergence) would
be the first mechanized proof of the iteration's correctness in any system.

This unit is explicitly research-adjacent. Partial results are valuable.

---

## Research resources

All papers are in `.context/papers/`. The reference Vyper implementation is in
`.context/curve-contract/`.

### Primary papers

- **Pusceddu & Bartoletti, "Formalizing Automated Market Makers in Lean 4"**
  FMBC 2024. The SX framework this unit builds on.
  - `.context/papers/lean4-amm-pusceddu-bartoletti-2024.pdf`
  - arXiv: https://arxiv.org/abs/2402.06064
  - Repo: `.context/lean4-amm/`

- **Bartoletti et al., "A Formal Approach to AMM Fee Mechanisms"**
  2025 follow-on extending lean4-amm to fees for constprod.
  - `.context/papers/lean4-amm-fees-bartoletti-2025.pdf`
  - arXiv: https://arxiv.org/abs/2602.00101

- **Egorov, "StableSwap — efficient mechanism for Stablecoin liquidity"**
  Curve Finance whitepaper, 2019. The original stableswap design document.
  - `.context/papers/stableswap-egorov-2019.pdf`
  - https://curve.fi/files/stableswap-paper.pdf

### Secondary papers (context and comparison)

- **Nielsen, Annenkov, Spitters, "Formalising Decentralised Exchanges in Coq"**
  CPP 2023. The closest comparable work in a different proof assistant (Coq,
  ConCert framework), covering constprod-style DEX on Tezos.
  - `.context/papers/coq-dex-nielsen-2023.pdf`
  - arXiv: https://arxiv.org/abs/2203.08016

- **Tranquilli & Gupta, "Formal State Machine Models for Uniswap v3"**
  2024. TLA+ / UPPAAL PTA treatment of concentrated liquidity tick math.
  Relevant for understanding the limits of formal methods on Uniswap v3/v4.
  - `.context/papers/tickmath-tranquilli-2024.pdf`
  - arXiv: https://arxiv.org/abs/2512.06203

### Reference implementations

- **Curve Finance stableswap reference (Vyper)**
  `.context/curve-contract/` — production Vyper implementation.
  Key files:
  - `contracts/pool-templates/base/SwapTemplateBase.vy` — `_get_D`, `_get_y`
  - `contracts/pools/3pool/` — the canonical 3-coin USDC/USDT/DAI pool

- **lean4-amm**
  `.context/lean4-amm/` — SX framework and constprod proofs to extend.
  Key files:
  - `AMMLib/Transaction/Swap/Rate.lean` — SX definition and property specs
  - `AMMLib/Transaction/Swap/Constprod.lean` — constprod instance and proofs

---

## Design notes

- All stableswap definitions are noncomputable (Layer A). The integer Newton
  iteration is Layer B territory — Unit 10 / Appendix.
- The 2-coin case (n=2) is the target. n-coin generalization is a named
  extension beyond this unit's scope.
- D existence uses Mathlib's `IntermediateValue` or `IsConnected`; this is the
  first unit that needs real analysis beyond ordered field lemmas.
- The Newton convergence proof requires showing the iteration function is a
  contraction on the relevant interval — this may require `Metric.contraction`
  or a direct monotonicity + boundedness argument.
- Concentrated liquidity (Uniswap v3/v4 tick math) is explicitly deferred as a
  named long-term target. It requires Q64.96 fixed-point arithmetic, int24 ticks,
  and a full Layer B treatment — a multi-year research program on its own.

---

## Connection to the rest of the book

- Unit 6 defines SX and proves it for constprod — stableswap is a second SX
  instance proved against the same property suite
- Unit 7's gain_direction proof shape applies directly to stableswap once the
  SX properties are established
- Unit 3's DSIC framework connects if the capstone is extended to prove
  fee adequacy for a fee-bearing stableswap variant
- Unit 10 is where the Newton iteration becomes a verified integer algorithm
