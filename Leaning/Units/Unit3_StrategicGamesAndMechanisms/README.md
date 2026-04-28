# Unit 3: Mechanism Design for On-Chain Markets

Purpose:
- formalize dominance, best response, and incentive compatibility
- prove key mechanism properties for direct-revelation mechanisms
- build proof shapes that reappear in AMM fee design and auction settlement

Why it matters:
- on-chain fee markets, auctions, and solver competitions are mechanisms
- second-price auction truthfulness is a prototype for DSIC fee design
- the proof shapes here (universal quantification over strategies, case splits
  on win/lose conditions) appear throughout Units 7 and 9

Typical theorem families:
- weak dominance, transitivity, dominant → best response
- second-price utility decomposition (both win, both lose, split cases)
- truthful reporting weakly dominates any alternative report
- mechanism feasibility and participation constraints

Connects to:
- Unit 7: rational actor / arbitrage framing uses the same gain-comparison shape
- Unit 9: custom fee mechanisms are mechanism design problems
