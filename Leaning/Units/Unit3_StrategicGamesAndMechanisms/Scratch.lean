import Mathlib.Tactic

/-!
Unit 3 scratch surface: Strategic Games and Mechanisms.

The model is a finite 2-player normal-form game. Actions are `Nat` indices
drawn from explicit lists; payoffs are `Int`-valued functions over action pairs.

New proof shapes in this unit:

- universally quantified strategy comparisons (`∀ a2 ∈ actions2, u a2 ≤ v a2`)
- dominance transitivity via `omega` on `Int`
- dominant → best response by instantiation
- concrete finite game examples by splitting list membership cases
-/

namespace Unit3.StrategicGames

structure TwoPlayerGame where
  actions1 : List Nat
  actions2 : List Nat
  u1 : Nat → Nat → Int   -- player 1's payoff given (a1, a2)
  u2 : Nat → Nat → Int   -- player 2's payoff given (a1, a2)

/-!
## Session 11: Dominance and Best Response

### Exercises 1–2: Write the spec predicates yourself

You know what these mean from game theory. Write the Lean definitions.
-/

-- Exercise 1.
-- `a` weakly dominates `b` for player 1:
-- for every opponent action in `g.actions2`, playing `a` yields at least as
-- much utility as playing `b`.
def weaklyDominates (g : TwoPlayerGame) (a b : Nat) : Prop :=
  ∀ a2 ∈ g.actions2, g.u1 a a2 >= g.u1 b a2

-- Exercise 2.
-- `a1` is a best response to `a2` for player 1:
-- `a1` is in the action set and no available alternative does strictly better
-- against `a2`.
def isBestResponse1 (g : TwoPlayerGame) (a1 a2 : Nat) : Prop :=
  a1 ∈ g.actions1 /\ a2 ∈ g.actions2 /\ ∀ a1' ∈ g.actions1, g.u1 a1 a2 >= g.u1 a1' a2

-- Exercise 3.
-- Weak dominance is reflexive.
theorem weaklyDominates_refl (g : TwoPlayerGame) (a : Nat) :
  weaklyDominates g a a := by
  simp[weaklyDominates]

-- Exercise 4.
-- Weak dominance is transitive.
-- If `a` weakly dominates `b` and `b` weakly dominates `c`, then `a`
-- weakly dominates `c`.
-- New tool: `omega` closes linear arithmetic goals on `Int` (and `Nat`)
-- directly from hypotheses, no lemma names needed.
theorem weaklyDominates_trans (g : TwoPlayerGame) (a b c : Nat) :
  weaklyDominates g a b → weaklyDominates g b c → weaklyDominates g a c := by
  intro h1 h2 someA2 hMem
  have h1 := h1 someA2
  have h2 := h2 someA2
  simp[hMem] at h1
  simp[hMem] at h2
  omega

-- Exercise 5.
-- A weakly dominant strategy is a best response against any opponent action.
-- Given: `a1` is in `g.actions1`, `a1` weakly dominates every other action in
-- `g.actions1`, and `a2` is any opponent action in `g.actions2`.
-- Prove: `a1` is a best response to `a2`.
--
-- This combines the two definitions you wrote — unfolding them and instantiating
-- the universal quantifier in `weaklyDominates` at `a2`.
theorem dominantStrategy_isBestResponse (g : TwoPlayerGame)
    (a1 a2 : Nat)
    (hMem1 : a1 ∈ g.actions1)
    (hMem2 : a2 ∈ g.actions2)
    (hDom : ∀ a1' ∈ g.actions1, weaklyDominates g a1 a1') :
    isBestResponse1 g a1 a2 := by
  simp[weaklyDominates] at hDom
  simp[isBestResponse1]
  constructor
  · exact hMem1
  · constructor
    · exact hMem2
    · simp_all![isBestResponse1, hMem1, hMem2]

/-!
### Concrete example: Prisoner's Dilemma

Actions: 0 = Cooperate, 1 = Defect.

Payoff matrix for player 1 (row = a1, col = a2):

        C (0)   D (1)
  C (0)   2       0
  D (1)   3       1

Defect (1) weakly dominates Cooperate (0): 3 > 2 and 1 > 0.
-/

def prisonersDilemma : TwoPlayerGame := {
  actions1 := [0, 1],
  actions2 := [0, 1],
  u1 := fun a1 a2 =>
    if a1 == 0 && a2 == 0 then 2
    else if a1 == 0 && a2 == 1 then 0
    else if a1 == 1 && a2 == 0 then 3
    else 1,
  u2 := fun a1 a2 =>  -- symmetric game
    if a1 == 0 && a2 == 0 then 2
    else if a1 == 1 && a2 == 0 then 0
    else if a1 == 0 && a2 == 1 then 3
    else 1
}

-- Concrete finite examples are next. With the current Prop-shaped definitions,
-- `native_decide` does not synthesize a decision procedure for the bounded
-- universal quantifier directly; prove these by unfolding the definitions and
-- splitting membership in `[0, 1]`, or introduce a separate executable Bool
-- checker later if we want computation-first examples.

end Unit3.StrategicGames
