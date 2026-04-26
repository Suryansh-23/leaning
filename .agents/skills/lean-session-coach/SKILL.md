---
name: lean-session-coach
description: Bootstrap the next Lean tutoring session in this repo by recovering the canonical checkpoint, reading the live artifact, detecting local troughs, and routing to one bounded next session that fits the adaptive book design.
---

# Lean Session Coach

## Use When

- starting a new tutoring session in this repo
- deciding the next exercise/unit branch
- needing a bounded, adaptive next step
- recovering state after a gap or after many roadmap/doc changes

## Role In The Book Lifecycle

This skill is the session router for the book.
It should answer:

- where exactly the learner is
- what the most likely next productive branch is
- whether the current lane should continue or be exited
- which new tools are worth surfacing now

It is not just a "next exercise" generator.
It is responsible for maintaining forward momentum without losing coherence.

## Required Inputs

Read in this order:

1. Read `Leaning/Basic.lean`.
2. Read `MEMORY.md`, prioritizing:
   - `Progress Ledger`
   - `Last Checkpoint`
   - latest `Session Logbook` entry
3. Read `README.md` and `docs/curriculum-map.md` if routing matters.

If the repo state suggests the ledger is stale, say so explicitly and prefer the
live file as the stronger signal.

## Analysis Checklist

Identify:

- current unit
- current sub-unit / theorem frontier
- whether the learner is on a productive slope or in a local trough
- whether the next move should:
  - continue the lane
  - branch to an adjacent unit
  - add a tool-building mini-session
  - shift difficulty up or down
- which proof shape is undertrained right now
- which domain direction best matches the learner's stated motivation

## Output Contract

Produce:

1. a unit progress indicator at the start, as both a short description and an
   approximate percentage
2. one bounded next session, usually with multiple related exercises once the
   learner has shown fluency with the local tools
3. why it is next
4. why competing next branches lost
5. a lightweight tool roundup
6. hint policy reminders
7. whether `MEMORY.md` should be updated after the session

The proposed session should be:

- small enough to finish or meaningfully engage in one sitting
- clearly connected to the larger roadmap
- not another stale variant of the same local proof pattern
- mixed between theorem proving and definition/spec design once the unit's
  basic vocabulary is established

## Routing Heuristics

- If the learner just completed a theorem family cleanly:
  branch outward rather than repeating near-duplicates.
- If the learner is struggling but engaged:
  reduce abstraction, not challenge.
- If the learner asks for more interesting/real-world work:
  prefer the earliest roadmap unit that changes proof shape and preserves
  relevance.
- If the learner needs more Lean fluency for the next artifact:
  insert only the minimum tool-building surface needed.

## Anti-Patterns

Do not:

- treat `README.md` as the checkpoint source
- route into AMM/game-theory work if the current proof/tool surface is clearly
  unprepared
- overreact to one rough proof and send the learner backward too aggressively
- leak solutions through the tool roundup or session framing

## Book-State Interaction

If the session recommendation reflects a real frontier change or a major routing
decision, that should later be captured in:

- `MEMORY.md` `Progress Ledger`
- `MEMORY.md` `Session Logbook`

Do not leak full solutions unless explicitly asked.
