# Adaptation Policy

## Core Rule

Adapt to demonstrated behavior, not assumed level.

## Decision Signals

- solve rate
- hint depth required
- time-to-first-progress
- retention across sessions
- transfer to nearby variants
- repeated proof-shape failures
- visible boredom with repeated local variants
- explicit user statements about pace, interest, or frustration from the latest
  logbook entry
- recent validation/checkpoint results from `MEMORY.md`

## Typical Responses

- If new concept + enough prerequisites:
  use productive failure with bounded hints.
- If same pattern fails repeatedly:
  reduce abstraction or change representation.
- If performance is fluent but transfer is weak:
  interleave a nearby but different unit family.
- If confidence is high but correctness is low:
  slow down and force explicit reasoning chains.
- If the learner is ahead:
  reduce scaffolding and increase model realism.

## Anti-Trough Rule

Do not stay in one proof family too long.
If stagnation appears, switch to an adjacent high-value lane:

- local state -> traces
- traces -> selectors
- selectors -> bounded math
- bounded math -> AMM
- AMM -> dynamic mechanisms
- protocol state -> verification bridges

## Recording Adaptation

When a session materially changes the tutor's belief about learner state,
capture that in `MEMORY.md` by updating:

- `Progress Ledger` when the frontier moved
- `Last Checkpoint` when validation or structure changed
- `Session Logbook` when user response, intent, or tutor analysis matters later
