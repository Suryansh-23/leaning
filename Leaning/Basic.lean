-- set_option diagnostics true

structure Position where
  collateral : Nat
  debt : Nat

def health(p: Position): Int := p.collateral - p.debt

def safe(p: Position): Prop :=
  p.debt <= p.collateral

def deposit(p: Position) (amount: Nat): Position :=
  { p with collateral := p.collateral + amount }

#check Position
#check health
#check safe
#check deposit

#eval deposit { collateral := 120, debt := 60 } 30

theorem deposit_increases_collateral (p: Position) (amount: Nat) :
  (deposit p amount).collateral = p.collateral + amount := by
  rfl

theorem deposit_debt (p : Position) (amount : Nat) :
  (deposit p amount).debt = p.debt := by
  rfl

def repayAll (p : Position) : Position :=
  { p with debt := 0 }

theorem repayAll_safe (p : Position) : safe (repayAll p) := by
  simp [safe, repayAll]

theorem safe_means_debt_le_collateral (p: Position) :
  safe p -> p.debt <= p.collateral := by
  intro h
  exact h


inductive Side where
  | buy
  | sell

def feeBps (s : Side) : Nat :=
  match s with
  | .buy => 30
  | .sell => 20

#eval feeBps .buy
#eval feeBps .sell

theorem fee_positive (s: Side): feeBps s > 0 := by
  cases s <;> decide

def total_collateral: List Position -> Nat
  | [] => 0
  | p :: ps => p.collateral + total_collateral ps

#eval total_collateral
  [{ collateral := 10, debt := 3 }, { collateral := 7, debt := 2 }]

theorem total_collateral_append (xs ys : List Position) :
  total_collateral (xs ++ ys) = total_collateral xs + total_collateral ys := by induction xs with
  | nil =>  simp[total_collateral]
  | cons x xs ih => simp[total_collateral, ih, Nat.add_assoc]


-- session #1
-- 1
def repay (p: Position) (amount: Nat): Position :=
  { p with debt := p.debt - amount }

--2
theorem repay_does_not_change_collateral (p: Position) (amount: Nat):
  (repay p amount).collateral = p.collateral := by
  rfl

theorem repay_debt (p: Position) (amount: Nat):
  (repay p amount).debt = p.debt - amount := by
  rfl

-- 3
theorem repay_monotonicity (p: Position) (amount: Nat):
  (repay p amount).debt <= p.debt := by
  simp[repay]

--4
theorem repay_safe (p: Position) (amount: Nat):
  safe p -> safe (repay p amount) := by
  simp_all[safe, repay, Nat.le_add_right_of_le]

-- theorem repay_safe (p : Position) (amount : Nat) :
--   safe p -> safe (repay p amount) := by
--   intro hSafe
--   dsimp [safe, repay] at hSafe ⊢
--   exact Nat.le_trans (Nat.sub_le _ _) hSafe

--5
theorem repayAll_debt (p : Position) :
  (repayAll p).debt = 0 := by
  simp[repayAll]

theorem repayAll_collateral (p : Position) :
  (repayAll p).collateral = p.collateral := by
  simp[repayAll]

theorem repayAll_idempotent (p : Position) :
  repayAll (repayAll p) = repayAll p := by
  simp![repayAll]


-- session #2
def borrow (p : Position) (amount : Nat) : Position :=
  { p with debt := p.debt + amount }

--1
theorem borrow_does_not_change_collateral (p: Position) (amount: Nat):
  (borrow p amount).collateral = p.collateral := by
  rfl

theorem borrow_increases_debt (p: Position) (amount: Nat):
  p.debt <= (borrow p amount).debt := by
  simp[borrow]

--3
theorem borrow_is_safe (p: Position) (amount: Nat):
  safe p /\ p.debt + amount <= p.collateral -> safe (borrow p amount) := by
  simp[safe, borrow]

--4
-- def p := { collateral := 100, debt := 60 : Position}
-- #eval safe p /\ borrow p 50 -> !(safe (borrow p 50))

--5
def borrowIfSafe (p: Position) (amount: Nat) : Position :=
  if p.debt + amount <= p.collateral then borrow p amount else p

theorem borrowIfSafe_is_safe (p: Position) (amount: Nat):
  safe p -> safe (borrowIfSafe p amount) := by
  intro hSafe
  by_cases h : p.debt + amount <= p.collateral
  . simp[borrowIfSafe, h, borrow, safe]
  . simp[borrowIfSafe, h]
    exact hSafe


-- session #3
-- 1
def total_debt : List Position -> Nat
  | [] => 0
  | p :: ps => p.debt + total_debt (ps)

theorem total_debt_empty_list_zero:
  total_debt [] = 0 := by
  simp[total_debt]

theorem total_debt_recursive (p: Position) (ps: List Position):
  total_debt (p :: ps) = p.debt + total_debt ps := by
  simp[total_debt]

--2
theorem total_debt_append (xs ys : List Position) :
  total_debt (xs ++ ys) = total_debt xs + total_debt ys := by induction xs with
  | nil => simp[total_debt]
  | cons _ _ ih => simp[total_debt, ih, Nat.add_assoc]

--3
def portfolioSafe (ps : List Position) : Prop :=
  total_debt ps <= total_collateral ps

theorem portfolioSafe_nil : portfolioSafe [] := by
  simp[portfolioSafe, total_debt, total_collateral]

--4
theorem portfolioSafe_of_two_safe
  (p1 p2 : Position) :
  safe p1 -> safe p2 -> portfolioSafe [p1, p2] := by
  intro h1 h2
  dsimp[safe, portfolioSafe, total_debt, total_collateral] at h1 h2 |-
  exact Nat.add_le_add h1 h2

--5
def depositAll (ps : List Position) (amount : Nat) : List Position :=
  ps.map (deposit . amount)

theorem total_debt_depositAll (ps : List Position) (amount : Nat) :
  total_debt (depositAll ps amount) = total_debt ps := by induction ps with
    | nil => simp[depositAll]
    | cons p ps ih => simp_all[total_debt, depositAll, deposit]

-- sesh#4
--1
inductive Event where
  | deposit : Nat -> Event
  | repay : Nat -> Event
  | borrow : Nat -> Event

#check Event.deposit

--2
def applyEvent (p : Position): Event -> Position :=
  fun e: Event =>
    match e with
    | .deposit x => deposit p x
    | .repay x => repay p x
    | .borrow x => borrow p x

--3
def applyEvents (p : Position) : List Event -> Position
  | [] => p
  | e :: es => applyEvents (applyEvent p e) es

--4
theorem applying_no_event_changes_nothing (p: Position):
  applyEvents p [] = p := by
  simp[applyEvents]

theorem applying_singleton_event (p: Position) (e: Event):
  applyEvents p [e] = applyEvent p e := by
  simp[applyEvent, applyEvents]

theorem applyEvents_append (p : Position) (xs ys : List Event) :
  applyEvents p (xs ++ ys) = applyEvents (applyEvents p xs) ys := by induction xs generalizing p with
  | nil => simp[applyEvents]
  | cons x xs ih => simp[applyEvents, ih]

--5
def isBorrowFree : Event -> Prop :=
  fun e: Event => match e with
    | .borrow _ => False
    | _ => True

def areBorrowFree : List Event -> Prop :=
  fun es: List Event => match es with
    | .nil => True
    | e :: es => isBorrowFree e /\ areBorrowFree es

--6
theorem deposit_safe (p : Position) (amount : Nat) :
  safe p -> safe (deposit p amount) := by
  intro h1
  dsimp[safe, deposit] at h1 |-
  exact Nat.le_add_right_of_le h1


theorem safe_and_no_borrows_remains_safe (p: Position) (trace: List Event):
  safe p -> areBorrowFree trace -> safe (applyEvents p trace) := by
  -- `p` changes after the head event, so keep it generalized in the IH.
  induction trace generalizing p with
  | nil =>
    -- Empty trace does nothing.
    simp [safe, areBorrowFree, applyEvents]
  | cons t ts ih =>
    intro hSafe hBorrowFree
    -- Split by the head event because both the reducer and the
    -- borrow-free predicate are defined by matching on the event.
    cases t with
    | deposit n =>
        -- Borrow-free on a cons list gives a fact about the head and tail.
        rcases hBorrowFree with ⟨_, hTailBorrowFree⟩
        -- Reuse the IH on the tail starting from the updated state.
        exact ih (deposit p n) (deposit_safe p n hSafe) hTailBorrowFree
    | repay n =>
        rcases hBorrowFree with ⟨_, hTailBorrowFree⟩
        -- Same shape as deposit, but now use the earlier theorem that
        -- repay preserves safety.
        exact ih (repay p n) (repay_safe p n hSafe) hTailBorrowFree
    | borrow n =>
        -- Impossible: a borrow head contradicts `areBorrowFree`.
        simp [areBorrowFree, isBorrowFree] at hBorrowFree


theorem borrow_free_trace_debt_le_start (p: Position) (trace: List Event):
  areBorrowFree trace -> p.debt >= ((applyEvents p) trace).debt := by
  induction trace generalizing p with
  | nil => simp[areBorrowFree, applyEvents]
  | cons t ts ih =>
    intro hBorrowFree
    cases t with
    | deposit n =>
      rcases hBorrowFree with ⟨_, hTailBorrowFree⟩
      -- Deposit does not change debt, so the induction hypothesis on the tail
      -- is already exactly the right result.
      exact ih (deposit p n) hTailBorrowFree
    | borrow n =>
      -- Impossible branch: a head borrow contradicts the borrow-free predicate.
      simp[areBorrowFree, isBorrowFree] at hBorrowFree
    | repay n =>
      rcases hBorrowFree with ⟨_, hTailBorrowFree⟩
      -- The IH gives a bound from the repaid state through the tail:
      --   (repay p n).debt >= (applyEvents (repay p n) ts).debt
      have hTail : (repay p n).debt >= (applyEvents (repay p n) ts).debt :=
        ih (repay p n) hTailBorrowFree
      -- Session 1 already proved that repaying cannot increase debt:
      --   p.debt >= (repay p n).debt
      have hRepay : p.debt >= (repay p n).debt :=
        repay_monotonicity p n
      -- Chain those two inequalities to reach the final target.
      exact Nat.le_trans hTail hRepay

-- sesh#5
--1
def depositAmount : Event -> Nat :=
  fun e: Event =>
    match e with
    | .deposit n => n
    | .borrow _ => 0
    | .repay _ => 0

def totalDeposits : List Event -> Nat :=
  fun es: List Event =>
    match es with
    | .nil => 0
    | e :: es => depositAmount e + totalDeposits es

--2
theorem totalDeposits_append (xs ys : List Event) :
  totalDeposits (xs ++ ys) = totalDeposits xs + totalDeposits ys := by
  induction xs with
  | nil => simp[totalDeposits]
  | cons x xs ih =>
    simp[totalDeposits, ih, Nat.add_assoc]
    -- simp[totalDeposits] at |-
    -- match x with
    -- | .deposit n =>
    --   simp[depositAmount]
    --   rw [ih]
    --   simp [Nat.add_assoc]
    -- | .repay n
    -- | .borrow n =>
    --   simp[depositAmount]
    --   exact ih

--3
def isRepayFree : Event -> Prop :=
  fun e: Event =>
  match e with
    | .repay _ => False
    | _ => True

def areRepayFree : List Event -> Prop :=
  fun es: List Event =>
  match es with
  | .nil => True
  | e :: es => isRepayFree e /\ areRepayFree es

--4
theorem repay_free_trace_collateral_eq_start_plus_totalDeposits
  (p : Position) (trace : List Event) :
  areRepayFree trace ->
  (applyEvents p trace).collateral = p.collateral + totalDeposits trace := by
  induction trace generalizing p with
  | nil => simp[applyEvents, totalDeposits]
  | cons e es ih =>
    intro hRepayFree
    match e with
    | .repay _ =>
      simp[areRepayFree, isRepayFree] at hRepayFree
    | .deposit n =>
      simp_all![applyEvents, applyEvent, totalDeposits, depositAmount, deposit]
      exact Nat.add_assoc p.collateral n (totalDeposits es)
    | .borrow n =>
      simp_all![applyEvents, applyEvent, borrow]

--5: Too Repetitive but i'm doing totalBorrows for ex. 6
def borrowAmount : Event -> Nat :=
  fun e: Event =>
    match e with
    | .borrow n => n
    |  _ => 0

def totalBorrows : List Event -> Nat :=
  fun es: List Event =>
    match es with
    | .nil => 0
    | e :: es => borrowAmount e + totalBorrows es


--6
def isBorrow (e: Event): Bool :=
  match e with
  | .borrow _ => True
  | _ => False

theorem trace_with_only_borrows (p: Position) (trace: List Event):
  trace.all isBorrow -> (applyEvents p trace).debt = p.debt + totalBorrows trace := by
  induction trace generalizing p with
  | nil => simp[applyEvents, totalBorrows]
  | cons e es ih =>
    intro hOnlyBorrows
    match e with
    | .deposit _
    | .repay _ =>
      simp![applyEvents] at hOnlyBorrows
    | .borrow n =>
      simp_all![isBorrow, borrow]
      exact Nat.add_assoc p.debt n (totalBorrows es)
