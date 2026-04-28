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

/-!
## Session 12: finite examples and executable checks

Session 11 gave us Prop-shaped game specs. This session bridges those specs to
small concrete games.

First, prove a couple of Prisoner's Dilemma facts directly by finite-list case
splitting. Then write executable Bool checkers for payoff comparison over a
finite action list and inspect them with `#eval`.

Generic Bool-to-Prop soundness is intentionally deferred to Session 13; this
session is about building the executable surface and sanity-checking it on a
small concrete game.
-/

-- Exercise 1.
-- Defect weakly dominates cooperate for player 1 in the concrete game.
theorem prisonersDilemma_defect_weaklyDominates_cooperate :
  weaklyDominates prisonersDilemma 1 0 := by
  simp[prisonersDilemma, weaklyDominates]

-- Exercise 2.
-- Defect is a best response to cooperate.
theorem prisonersDilemma_defect_bestResponse_to_cooperate :
  isBestResponse1 prisonersDilemma 1 0 := by
  simp[prisonersDilemma, isBestResponse1]

-- Exercise 3.
-- Defect is a best response to defect.
theorem prisonersDilemma_defect_bestResponse_to_defect :
  isBestResponse1 prisonersDilemma 1 1 := by
  simp[prisonersDilemma, isBestResponse1]

-- Exercise 4.
-- Executable checker: all actions in `opponentActions` satisfy the payoff
-- comparison for player 1.
def weaklyDominatesBool
    (g : TwoPlayerGame) (opponentActions : List Nat) (a b : Nat) : Bool :=
  opponentActions.all fun a2 => g.u1 a a2 >= g.u1 b a2

-- Exercise 5.
-- Executable checker: `a1` is an available action, `a2` is an available
-- opponent action, and no available player-1 action beats `a1` against `a2`.
def isBestResponse1Bool (g : TwoPlayerGame) (a1 a2 : Nat) : Bool :=
  a1 ∈ g.actions1 ∧ a2 ∈ g.actions2 ∧ ∀ a1' ∈ g.actions1, g.u1 a1' a2 <= g.u1 a1 a2

-- Exercise 6.
-- The executable dominance checker succeeds on the Prisoner's Dilemma example.
theorem prisonersDilemma_defect_weaklyDominates_cooperate_bool :
  weaklyDominatesBool prisonersDilemma prisonersDilemma.actions2 1 0 = true := by
  simp[prisonersDilemma, weaklyDominatesBool]

-- Exercise 7.
-- The executable dominance checker rejects the reverse dominance claim.
theorem prisonersDilemma_cooperate_not_weaklyDominates_defect_bool :
  weaklyDominatesBool prisonersDilemma prisonersDilemma.actions2 0 1 = false := by
  simp[prisonersDilemma, weaklyDominatesBool]

-- Exercise 8.
-- The executable best-response checker succeeds on both opponent actions.
theorem prisonersDilemma_defect_bestResponse_to_cooperate_bool :
  isBestResponse1Bool prisonersDilemma 1 0 = true := by
  simp[prisonersDilemma, isBestResponse1Bool]

theorem prisonersDilemma_defect_bestResponse_to_defect_bool :
  isBestResponse1Bool prisonersDilemma 1 1 = true := by
  simp[prisonersDilemma, isBestResponse1Bool]

-- Use these while developing the Bool definitions.
#eval weaklyDominatesBool prisonersDilemma prisonersDilemma.actions2 1 0
#eval weaklyDominatesBool prisonersDilemma prisonersDilemma.actions2 0 1
#eval isBestResponse1Bool prisonersDilemma 1 0
#eval isBestResponse1Bool prisonersDilemma 1 1

/-!
## Session 13: direct mechanisms and truthful bidding

Session 12 stayed close to normal-form examples. This session moves toward the
mechanism-design part of the roadmap: reports, allocation, payment, utility,
and incentive compatibility.

The toy mechanism is a two-bidder second-price auction from bidder 1's
perspective. Bidder 2's bid is treated as the environment. Bidder 1 wins
exactly when `bid2 ≤ bid1`; if bidder 1 wins, they pay `bid2`.

This is deliberately a small direct-revelation mechanism: the proof target is
that reporting the true value weakly dominates any alternative report, for any
fixed opponent bid.
-/

def winsSecondPrice (bid1 bid2 : Nat) : Prop :=
  bid2 <= bid1

instance winsSecondPriceDecidable (bid1 bid2 : Nat) :
    Decidable (winsSecondPrice bid1 bid2) :=
  inferInstanceAs (Decidable (bid2 <= bid1))

def secondPriceUtility (value bid1 bid2 : Nat) : Int :=
  if winsSecondPrice bid1 bid2 then
    (value : Int) - (bid2 : Int)
  else
    0

def reportWeaklyDominates
    (value truthful alternative : Nat) : Prop :=
  ∀ bid2 : Nat,
    secondPriceUtility value truthful bid2 >=
      secondPriceUtility value alternative bid2

-- Exercise 1.
-- If both the truthful report and the alternative report win against `bid2`,
-- the utility is the same: both pay the second price.
theorem secondPriceUtility_same_when_both_win
    (value truthful alternative bid2 : Nat)
    (hTruthWins : winsSecondPrice truthful bid2)
    (hAltWins : winsSecondPrice alternative bid2) :
    secondPriceUtility value truthful bid2 =
      secondPriceUtility value alternative bid2 := by
  simp[secondPriceUtility, hTruthWins, hAltWins]

-- Exercise 2.
-- If neither report wins, both utilities are zero.
theorem secondPriceUtility_same_when_both_lose
    (value truthful alternative bid2 : Nat)
    (hTruthLoses : ¬ winsSecondPrice truthful bid2)
    (hAltLoses : ¬ winsSecondPrice alternative bid2) :
    secondPriceUtility value truthful bid2 =
      secondPriceUtility value alternative bid2 := by
  simp[secondPriceUtility, hTruthLoses, hAltLoses]

-- Exercise 3.
-- If truthful bidding wins but an alternative loses, truthful utility is
-- nonnegative. This is where `truthful = value` matters.
theorem truthful_win_alt_lose_nonnegative
    (value alternative bid2 : Nat)
    (hTruthWins : winsSecondPrice value bid2)
    (hAltLoses : ¬ winsSecondPrice alternative bid2) :
    secondPriceUtility value value bid2 >=
      secondPriceUtility value alternative bid2 := by
  simp[secondPriceUtility, hAltLoses]
  simp[hTruthWins]
  simp[winsSecondPrice] at hTruthWins
  exact hTruthWins

-- Exercise 4.
-- The dangerous-looking case is overbidding: the alternative wins while the
-- truthful bid loses. Show truthful bidding is still at least as good because
-- the winning alternative would pay more than the value.
theorem truthful_lose_alt_win_nonpositive
    (value alternative bid2 : Nat)
    (hTruthLoses : ¬ winsSecondPrice value bid2)
    (hAltWins : winsSecondPrice alternative bid2) :
    secondPriceUtility value value bid2 >=
      secondPriceUtility value alternative bid2 := by
  simp[winsSecondPrice] at hTruthLoses hAltWins
  simp[secondPriceUtility, winsSecondPrice, hAltWins]
  omega

-- Exercise 5.
-- Main theorem: truthful reporting weakly dominates any alternative report in
-- the toy second-price auction.
theorem truthful_secondPrice_weaklyDominates
    (value alternative : Nat) :
    reportWeaklyDominates value value alternative := by
  simp[reportWeaklyDominates, secondPriceUtility, winsSecondPrice]
  intro someBid2
  by_cases h: someBid2 <= alternative && someBid2 <= value
  · omega
  · omega

end Unit3.StrategicGames
