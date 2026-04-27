/-!
Unit 2 scratch surface.

Session 6 starts the selector-kernel lane.

Work here first. Once this material is solved and reviewed, the stable pieces
can move into `Core.lean`.
-/

namespace Unit2.SelectorKernels

/-!
Think of a `Quote` as one candidate route/venue/result from a search process.

- `venue` is just an identifier for now.
- `output` is the score we want to maximize.
- `valid` says whether the candidate is feasible.

This unit's new proof shape is:

1. define a small executable selector,
2. state the contract that a selected candidate should satisfy,
3. prove local and then list-wide correctness facts about that selector.
-/
structure Quote where
  venue : Nat
  output : Nat
  valid : Bool
deriving Repr

def isValidQuote (q : Quote) : Prop :=
  q.valid = true

/-!
`betterQuote a b` keeps the current candidate `a` unless the challenger `b`
is valid and has output at least as large as `a`.

This intentionally uses `Bool` in the executable selector, while
`isValidQuote` gives us a `Prop`-shaped contract for proofs.
-/
def betterQuote (a b : Quote) : Quote :=
  if b.valid && a.output <= b.output then b else a

def selectBestQuote : List Quote -> Quote -> Quote
  | [], fallback => fallback
  | q :: qs, fallback => selectBestQuote qs (betterQuote fallback q)

#eval betterQuote
  { venue := 0, output := 100, valid := true }
  { venue := 1, output := 120, valid := true }

#eval selectBestQuote
  [ { venue := 1, output := 120, valid := true }
  , { venue := 2, output := 150, valid := false }
  , { venue := 3, output := 130, valid := true }
  ]
  { venue := 0, output := 100, valid := true }

/-!
## Your Work

Start with these local selector facts. Do not prove global optimality yet.
The point of this session is to get comfortable proving contracts about one
selector step.
-/

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

/-!
## Next: lift the local selector fact to the whole list

You proved that one `betterQuote` step preserves validity when the current
candidate is valid. Now prove the same contract for the recursive selector.

This is the first real Unit 2 pattern:

- local step lemma: `betterQuote_valid_if_left_valid`
- recursive selector: `selectBestQuote`
- global contract: valid fallback means valid final selection

The intended shape is induction on `quotes`, with the fallback generalized
because the recursive call changes it.
-/

theorem selectBestQuote_valid_if_fallback_valid (quotes : List Quote) (fallback : Quote) :
  isValidQuote fallback -> isValidQuote (selectBestQuote quotes fallback) := by
  induction quotes generalizing fallback with
  | nil => simp[selectBestQuote]
  | cons q qs ih =>
    intro hFallbackValid
    simp[selectBestQuote]
    apply ih
    exact betterQuote_valid_if_left_valid fallback q hFallbackValid

/-!
## Session 7: score monotonicity for selectors

The last theorem proved that selection preserves validity if the initial
fallback is valid. This batch adds the second half of the selector contract:
the selected quote should not be worse than the fallback.

Work in order. The first theorem is local, the second lifts it over the list,
and the third asks you to combine the validity and score contracts.
-/

theorem betterQuote_output_ge_left (a b : Quote) :
  a.output <= (betterQuote a b).output := by
  simp[betterQuote]
  by_cases h1: a.output <= b.output
  . simp[h1]
    by_cases h2: b.valid = true
    . simp[h1, h2]
    . simp[h2]
  . simp[h1]


theorem selectBestQuote_output_ge_fallback (quotes : List Quote) (fallback : Quote) :
  fallback.output <= (selectBestQuote quotes fallback).output := by
  induction quotes generalizing fallback with
  | nil => simp[selectBestQuote]
  | cons q qs ih =>
    simp[selectBestQuote] at |-
    have hStep := betterQuote_output_ge_left fallback q
    have hTail := ih (betterQuote fallback q)
    exact Nat.le_trans hStep hTail


theorem selectBestQuote_valid_and_output_ge_fallback (quotes : List Quote) (fallback : Quote) :
  isValidQuote fallback ->
    isValidQuote (selectBestQuote quotes fallback) /\
      fallback.output <= (selectBestQuote quotes fallback).output := by
  intro hFallbackValid
  constructor
  · exact selectBestQuote_valid_if_fallback_valid quotes fallback hFallbackValid
  · exact selectBestQuote_output_ge_fallback quotes fallback

/-!
## Session 8: provenance and candidate membership

You now have two selector guarantees:

- validity is preserved from a valid fallback
- output is not worse than the fallback

The next contract family is provenance: the selector should not invent a quote.
Its result should be either the original fallback or one of the input
candidates. This is a different proof shape from score monotonicity because it
uses list membership.

This batch is larger on purpose. First, write one small spec predicate yourself.
Then prove membership facts for the local selector, lift them through the
recursive selector, and combine validity, score, and provenance into one
high-level contract.
-/

-- Definition exercise: replace `False` with the intended membership spec.
-- The result should say that `q` is either the fallback or one of the candidates.
def isFromCandidates (q fallback : Quote) (quotes : List Quote) : Prop :=
  q = fallback \/ q ∈ quotes

theorem fallback_isFromCandidates (fallback : Quote) (quotes : List Quote) :
  isFromCandidates fallback fallback quotes := by
  simp[isFromCandidates]

theorem betterQuote_eq_left_or_right (a b : Quote) :
  betterQuote a b = a \/ betterQuote a b = b := by
  by_cases h: b.valid && a.output <= b.output
  . simp[h, betterQuote]
  . simp[h, betterQuote]


theorem betterQuote_mem_pair (a b : Quote) :
  betterQuote a b ∈ [a, b] := by
  simp[betterQuote_eq_left_or_right a b]

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


theorem selectBestQuote_mem_fallback_cons (quotes : List Quote) (fallback : Quote) :
  selectBestQuote quotes fallback ∈ fallback :: quotes := by
  simp[selectBestQuote_eq_fallback_or_mem quotes fallback]

theorem selectBestQuote_basic_contract (quotes : List Quote) (fallback : Quote) :
  isValidQuote fallback ->
    isValidQuote (selectBestQuote quotes fallback) /\
      fallback.output <= (selectBestQuote quotes fallback).output /\
        isFromCandidates (selectBestQuote quotes fallback) fallback quotes := by
  -- -- intro igh
  -- induction quotes generalizing fallback with
  -- -- | nil => simp![selectBestQuote, isValidQuote, isFromCandidates, igh]
  -- | nil => simp[selectBestQuote, isValidQuote, isFromCandidates]
  -- | cons q qs ih =>
  --   simp[selectBestQuote]
  --   have h := ih (betterQuote fallback q)
  --   have hBQV := betterQuote_valid_if_left_valid fallback q
  intro hFallbackValid
  constructor
  · exact selectBestQuote_valid_if_fallback_valid quotes fallback hFallbackValid
  · constructor
    · exact selectBestQuote_output_ge_fallback quotes fallback
    · simpa [isFromCandidates] using
        selectBestQuote_eq_fallback_or_mem quotes fallback

/-!
## Session 9: global optimality over valid candidates

The previous session proved provenance: `selectBestQuote` does not invent a
quote. This session adds the core selector guarantee: valid candidates should
not beat the selected quote on output.

First, write the local spec predicate. Then prove local dominance for one
`betterQuote` step, show that dominance survives later selector steps, and lift
the result over list membership.
-/

-- Definition exercise: replace `False` with the intended dominance spec.
-- It should mean: every valid `candidate` has output no greater than `selected`.
def dominatesValidCandidate (selected candidate : Quote) : Prop :=
  isValidQuote candidate -> candidate.output <= selected.output

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

theorem selectBestQuote_optimal_for_allowed_candidates (quotes : List Quote) (fallback candidate : Quote) :
  candidate ∈ fallback :: quotes ->
    dominatesValidCandidate (selectBestQuote quotes fallback) candidate := by
  intro hMem
  simp at hMem
  rcases hMem with hIsFallback | hInQuotes
  . simp[hIsFallback] at |-
    exact selectBestQuote_dominates_fallback quotes fallback
  . simp[hInQuotes, selectBestQuote_dominates_member quotes fallback candidate]


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
