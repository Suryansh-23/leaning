import Mathlib.Tactic

/-!
Unit 3 curated artifact: Mechanism Design for On-Chain Markets.

Covers:
- two-player normal-form games, weak dominance, best response
- dominance reflexivity, transitivity, dominant strategy → best response
- concrete Prisoner's Dilemma examples and executable Bool checkers
- toy second-price auction: utility, allocation cases, truthful dominance (DSIC)
-/

namespace Unit3.StrategicGames

structure TwoPlayerGame where
  actions1 : List Nat
  actions2 : List Nat
  u1 : Nat → Nat → Int
  u2 : Nat → Nat → Int

-- `a` weakly dominates `b` for player 1.
def weaklyDominates (g : TwoPlayerGame) (a b : Nat) : Prop :=
  ∀ a2 ∈ g.actions2, g.u1 a a2 >= g.u1 b a2

-- `a1` is a best response to `a2` for player 1.
def isBestResponse1 (g : TwoPlayerGame) (a1 a2 : Nat) : Prop :=
  a1 ∈ g.actions1 /\ a2 ∈ g.actions2 /\ ∀ a1' ∈ g.actions1, g.u1 a1 a2 >= g.u1 a1' a2

theorem weaklyDominates_refl (g : TwoPlayerGame) (a : Nat) :
    weaklyDominates g a a := by
  simp [weaklyDominates]

theorem weaklyDominates_trans (g : TwoPlayerGame) (a b c : Nat) :
    weaklyDominates g a b → weaklyDominates g b c → weaklyDominates g a c := by
  intro h1 h2 someA2 hMem
  have h1 := h1 someA2
  have h2 := h2 someA2
  simp [hMem] at h1
  simp [hMem] at h2
  omega

theorem dominantStrategy_isBestResponse (g : TwoPlayerGame)
    (a1 a2 : Nat)
    (hMem1 : a1 ∈ g.actions1)
    (hMem2 : a2 ∈ g.actions2)
    (hDom : ∀ a1' ∈ g.actions1, weaklyDominates g a1 a1') :
    isBestResponse1 g a1 a2 := by
  simp [weaklyDominates] at hDom
  simp [isBestResponse1]
  constructor
  · exact hMem1
  · constructor
    · exact hMem2
    · simp_all! [isBestResponse1, hMem1, hMem2]

-- Prisoner's Dilemma: actions 0 = Cooperate, 1 = Defect.
-- Payoff matrix for player 1: (C,C)=2, (C,D)=0, (D,C)=3, (D,D)=1.
-- Defect strictly dominates Cooperate.
def prisonersDilemma : TwoPlayerGame := {
  actions1 := [0, 1],
  actions2 := [0, 1],
  u1 := fun a1 a2 =>
    if a1 == 0 && a2 == 0 then 2
    else if a1 == 0 && a2 == 1 then 0
    else if a1 == 1 && a2 == 0 then 3
    else 1,
  u2 := fun a1 a2 =>
    if a1 == 0 && a2 == 0 then 2
    else if a1 == 1 && a2 == 0 then 0
    else if a1 == 0 && a2 == 1 then 3
    else 1
}

theorem prisonersDilemma_defect_weaklyDominates_cooperate :
    weaklyDominates prisonersDilemma 1 0 := by
  simp [prisonersDilemma, weaklyDominates]

theorem prisonersDilemma_defect_bestResponse_to_cooperate :
    isBestResponse1 prisonersDilemma 1 0 := by
  simp [prisonersDilemma, isBestResponse1]

theorem prisonersDilemma_defect_bestResponse_to_defect :
    isBestResponse1 prisonersDilemma 1 1 := by
  simp [prisonersDilemma, isBestResponse1]

def weaklyDominatesBool
    (g : TwoPlayerGame) (opponentActions : List Nat) (a b : Nat) : Bool :=
  opponentActions.all fun a2 => g.u1 a a2 >= g.u1 b a2

def isBestResponse1Bool (g : TwoPlayerGame) (a1 a2 : Nat) : Bool :=
  a1 ∈ g.actions1 ∧ a2 ∈ g.actions2 ∧ ∀ a1' ∈ g.actions1, g.u1 a1' a2 <= g.u1 a1 a2

theorem prisonersDilemma_defect_weaklyDominates_cooperate_bool :
    weaklyDominatesBool prisonersDilemma prisonersDilemma.actions2 1 0 = true := by
  simp [prisonersDilemma, weaklyDominatesBool]

theorem prisonersDilemma_cooperate_not_weaklyDominates_defect_bool :
    weaklyDominatesBool prisonersDilemma prisonersDilemma.actions2 0 1 = false := by
  simp [prisonersDilemma, weaklyDominatesBool]

theorem prisonersDilemma_defect_bestResponse_to_cooperate_bool :
    isBestResponse1Bool prisonersDilemma 1 0 = true := by
  simp [prisonersDilemma, isBestResponse1Bool]

theorem prisonersDilemma_defect_bestResponse_to_defect_bool :
    isBestResponse1Bool prisonersDilemma 1 1 = true := by
  simp [prisonersDilemma, isBestResponse1Bool]

-- Second-price auction: bidder 1 wins iff bid2 ≤ bid1; pays bid2 if they win.
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

def reportWeaklyDominates (value truthful alternative : Nat) : Prop :=
  ∀ bid2 : Nat,
    secondPriceUtility value truthful bid2 >=
      secondPriceUtility value alternative bid2

theorem secondPriceUtility_same_when_both_win
    (value truthful alternative bid2 : Nat)
    (hTruthWins : winsSecondPrice truthful bid2)
    (hAltWins : winsSecondPrice alternative bid2) :
    secondPriceUtility value truthful bid2 =
      secondPriceUtility value alternative bid2 := by
  simp [secondPriceUtility, hTruthWins, hAltWins]

theorem secondPriceUtility_same_when_both_lose
    (value truthful alternative bid2 : Nat)
    (hTruthLoses : ¬ winsSecondPrice truthful bid2)
    (hAltLoses : ¬ winsSecondPrice alternative bid2) :
    secondPriceUtility value truthful bid2 =
      secondPriceUtility value alternative bid2 := by
  simp [secondPriceUtility, hTruthLoses, hAltLoses]

theorem truthful_win_alt_lose_nonnegative
    (value alternative bid2 : Nat)
    (hTruthWins : winsSecondPrice value bid2)
    (hAltLoses : ¬ winsSecondPrice alternative bid2) :
    secondPriceUtility value value bid2 >=
      secondPriceUtility value alternative bid2 := by
  simp [secondPriceUtility, hAltLoses]
  simp [hTruthWins]
  simp [winsSecondPrice] at hTruthWins
  exact hTruthWins

theorem truthful_lose_alt_win_nonpositive
    (value alternative bid2 : Nat)
    (hTruthLoses : ¬ winsSecondPrice value bid2)
    (hAltWins : winsSecondPrice alternative bid2) :
    secondPriceUtility value value bid2 >=
      secondPriceUtility value alternative bid2 := by
  simp [winsSecondPrice] at hTruthLoses hAltWins
  simp [secondPriceUtility, winsSecondPrice, hAltWins]
  omega

theorem truthful_secondPrice_weaklyDominates
    (value alternative : Nat) :
    reportWeaklyDominates value value alternative := by
  intro bid2
  simp only [secondPriceUtility, winsSecondPrice]
  split_ifs <;> omega

end Unit3.StrategicGames
