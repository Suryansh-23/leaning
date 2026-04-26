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

theorem betterQuote_keeps_left_when_right_invalid
  (a b : Quote) :
  b.valid = false -> betterQuote a b = a := by
  intro hBNotValid
  simp[hBNotValid, betterQuote]


theorem betterQuote_takes_right_when_valid_and_not_worse
  (a b : Quote) :
  b.valid = true ->
  a.output <= b.output ->
  betterQuote a b = b := by
  intro hBValid hBBetterOutput
  simp[hBValid, hBBetterOutput, betterQuote]

theorem betterQuote_valid_if_left_valid
  (a b : Quote) :
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

theorem betterQuote_output_ge_left
  (a b : Quote) :
  a.output <= (betterQuote a b).output := by
  sorry

theorem selectBestQuote_output_ge_fallback
  (quotes : List Quote) (fallback : Quote) :
  fallback.output <= (selectBestQuote quotes fallback).output := by
  sorry

theorem selectBestQuote_valid_and_output_ge_fallback
  (quotes : List Quote) (fallback : Quote) :
  isValidQuote fallback ->
    isValidQuote (selectBestQuote quotes fallback) /\
      fallback.output <= (selectBestQuote quotes fallback).output := by
  sorry

end Unit2.SelectorKernels
