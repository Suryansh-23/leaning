/-!
Unit 2 curated artifact: Selector Kernels.

Stable material migrated from Scratch.lean after Sessions 6–10.
All proofs are verbatim from Scratch.lean — no rewrites.
-/

namespace Unit2.SelectorKernels

structure Quote where
  venue : Nat
  output : Nat
  valid : Bool
deriving Repr, DecidableEq

def isValidQuote (q : Quote) : Prop :=
  q.valid = true

def betterQuote (a b : Quote) : Quote :=
  if b.valid && a.output <= b.output then b else a

def selectBestQuote : List Quote -> Quote -> Quote
  | [], fallback => fallback
  | q :: qs, fallback => selectBestQuote qs (betterQuote fallback q)

def isFromCandidates (q fallback : Quote) (quotes : List Quote) : Prop :=
  q = fallback \/ q ∈ quotes

def dominatesValidCandidate (selected candidate : Quote) : Prop :=
  isValidQuote candidate -> candidate.output <= selected.output

theorem betterQuote_keeps_left_when_right_invalid (a b : Quote) :
  b.valid = false -> betterQuote a b = a := by
  intro hBNotValid
  simp[hBNotValid, betterQuote]

theorem betterQuote_takes_right_when_valid_and_not_worse (a b : Quote) :
  b.valid = true -> a.output <= b.output -> betterQuote a b = b := by
  intro hBValid hBBetterOutput
  simp[hBValid, hBBetterOutput, betterQuote]

theorem betterQuote_valid_if_left_valid (a b : Quote) :
  isValidQuote a -> isValidQuote (betterQuote a b) := by
  intro hAValid
  by_cases hBValid: b.valid = true
  . simp[betterQuote, isValidQuote] at |-
    by_cases hBBetterQuote: a.output <= b.output
    . simp[hBValid, hBBetterQuote]
    . simp[hBBetterQuote]
      exact hAValid
  . simp[hBValid, betterQuote, isValidQuote] at |-
    exact hAValid

theorem betterQuote_output_ge_left (a b : Quote) :
  a.output <= (betterQuote a b).output := by
  simp[betterQuote]
  by_cases h1: a.output <= b.output
  . simp[h1]
    by_cases h2: b.valid = true
    . simp[h1, h2]
    . simp[h2]
  . simp[h1]

theorem betterQuote_eq_left_or_right (a b : Quote) :
  betterQuote a b = a \/ betterQuote a b = b := by
  by_cases h: b.valid && a.output <= b.output
  . simp[h, betterQuote]
  . simp[h, betterQuote]

theorem betterQuote_tie_takes_right (a b : Quote) :
  b.valid = true -> a.output = b.output -> betterQuote a b = b := by
  intro hValidB
  intro hEqualOutput
  simp[hValidB, hEqualOutput, betterQuote]

theorem betterQuote_dominates_right (a b : Quote) :
  dominatesValidCandidate (betterQuote a b) b := by
  simp[dominatesValidCandidate, isValidQuote]
  intro hBValid
  simp[betterQuote]
  simp[hBValid] at |-
  by_cases h: a.output <= b.output
  . simp[h]
  . simp[h]
    exact Nat.le_of_not_le h

theorem selectBestQuote_valid_if_fallback_valid (quotes : List Quote) (fallback : Quote) :
  isValidQuote fallback -> isValidQuote (selectBestQuote quotes fallback) := by
  induction quotes generalizing fallback with
  | nil => simp[selectBestQuote]
  | cons q qs ih =>
    intro hFallbackValid
    simp[selectBestQuote]
    apply ih
    exact betterQuote_valid_if_left_valid fallback q hFallbackValid

theorem selectBestQuote_output_ge_fallback (quotes : List Quote) (fallback : Quote) :
  fallback.output <= (selectBestQuote quotes fallback).output := by
  induction quotes generalizing fallback with
  | nil => simp[selectBestQuote]
  | cons q qs ih =>
    simp[selectBestQuote] at |-
    have hStep := betterQuote_output_ge_left fallback q
    have hTail := ih (betterQuote fallback q)
    exact Nat.le_trans hStep hTail

theorem selectBestQuote_eq_fallback_or_mem (quotes : List Quote) (fallback : Quote) :
  selectBestQuote quotes fallback = fallback \/
    selectBestQuote quotes fallback ∈ quotes := by
  induction quotes generalizing fallback with
  | nil => simp[selectBestQuote]
  | cons q qs ih =>
    simp [selectBestQuote]
    have hTail := ih (betterQuote fallback q)
    rcases hTail with hEqStep | hInQs
    · have hStep := betterQuote_eq_left_or_right fallback q
      rcases hStep with hStepFallback | hStepQ
      · left
        exact Eq.trans hEqStep hStepFallback
      · right
        left
        exact Eq.trans hEqStep hStepQ
    · right
      right
      exact hInQs

theorem selectBestQuote_preserves_dominance (quotes : List Quote) (selected candidate : Quote) :
  dominatesValidCandidate selected candidate ->
    dominatesValidCandidate (selectBestQuote quotes selected) candidate := by
  simp[dominatesValidCandidate]
  intro ih
  intro hValid
  have hSOGF := selectBestQuote_output_ge_fallback quotes selected
  have hOut := ih hValid
  exact Nat.le_trans hOut hSOGF

theorem selectBestQuote_dominates_member (quotes : List Quote) (fallback candidate : Quote) :
  candidate ∈ quotes ->
    dominatesValidCandidate (selectBestQuote quotes fallback) candidate := by
  induction quotes generalizing fallback with
  | nil => simp[selectBestQuote]
  | cons q qs ih =>
    intro hMem
    simp at hMem
    rcases hMem with hHead | hTail
    . simp[selectBestQuote]
      simp[hHead, betterQuote_dominates_right fallback q, selectBestQuote_preserves_dominance qs (betterQuote fallback q) q]
    . simp[selectBestQuote]
      have h := ih (betterQuote fallback q)
      simp[hTail, h]

theorem selectBestQuote_dominates_fallback (quotes : List Quote) (fallback : Quote) :
  dominatesValidCandidate (selectBestQuote quotes fallback) fallback := by
  simp[dominatesValidCandidate]
  intro hFValid
  exact selectBestQuote_output_ge_fallback quotes fallback

theorem selectBestQuote_fallback_when_no_valid (quotes : List Quote) (fallback : Quote) :
  (∀ q ∈ quotes, q.valid = false) ->
    selectBestQuote quotes fallback = fallback := by
  induction quotes generalizing fallback with
  | nil => simp[selectBestQuote]
  | cons q qs ih =>
    intro hInvalidQ
    simp_all[selectBestQuote, betterQuote_keeps_left_when_right_invalid]

theorem selectBestQuote_optimal_for_allowed_candidates (quotes : List Quote) (fallback candidate : Quote) :
  candidate ∈ fallback :: quotes ->
    dominatesValidCandidate (selectBestQuote quotes fallback) candidate := by
  intro hMem
  simp at hMem
  rcases hMem with hIsFallback | hInQuotes
  . simp[hIsFallback] at |-
    exact selectBestQuote_dominates_fallback quotes fallback
  . simp[hInQuotes, selectBestQuote_dominates_member quotes fallback candidate]

/-- Full selector contract: validity, provenance, and global optimality. -/
theorem selectBestQuote_full_contract (quotes : List Quote) (fallback : Quote) :
  isValidQuote fallback ->
    isValidQuote (selectBestQuote quotes fallback) /\
      isFromCandidates (selectBestQuote quotes fallback) fallback quotes /\
        ∀ candidate,
          candidate ∈ fallback :: quotes ->
            dominatesValidCandidate (selectBestQuote quotes fallback) candidate := by
  intro hFallbackValid
  constructor
  . simp[hFallbackValid, selectBestQuote_valid_if_fallback_valid quotes fallback]
  . constructor
    . simpa [isFromCandidates] using
        selectBestQuote_eq_fallback_or_mem quotes fallback
    . exact selectBestQuote_optimal_for_allowed_candidates quotes fallback

end Unit2.SelectorKernels
