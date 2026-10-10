# Product Overview

## Mission

The New Youth helps people in Sierra Leone understand why money may buy less over time, compare the affordability of essential household needs, and explore how saving and inflation can affect future purchasing power.

The platform should make uncertainty visible and help people reason about their own circumstances. It must not present uncertain estimates or financial projections as guarantees.

## Pilot geography

- Freetown
- Kenema

Do not imply that pilot observations represent all of Sierra Leone unless the evidence supports that conclusion.

## Primary capabilities

1. Collect and validate observations of essential-goods and household-service prices.
2. Show current approved prices with observation counts, dates, ranges, freshness, and coverage limitations.
3. Estimate the cost movement of a fixed standard basket.
4. Compare evidence across pilot locations and over time.
5. Help users explore affordability using household income and expense assumptions.
6. Simulate savings contributions and future balances.
7. Show projected future savings both as a nominal balance and as estimated purchasing power in today's terms.
8. Let users explore deficits, emergency reserves, remittances, debt repayments, and alternative scenarios.
9. Publish methodology, corrections, and periodic milestone-based transparency reporting.

## Audience and access

The intended audience includes Sierra Leoneans across income levels. A user should be able to explore standard scenarios without needing specialist economic or financial knowledge. Advanced controls may be available where they add value, but must be clearly labeled.

The platform may involve community contributors, trained reviewers, and core-team administrators. Access must be restricted by role and task.

## Initial basket categories

- Food
- Transport
- Housing
- Utilities
- Cooking fuel

Categories have different collection cadences and freshness limits; see `DATA-QUALITY-AND-PRICING.md`.

## Product principles

### Evidence before precision

Do not publish a number merely because the interface needs one. If data are missing, stale, insufficient, or too geographically narrow, say so and suppress estimates that fail critical quality requirements.

### Explain uncertainty

Display relevant observation counts, dates, freshness, geographic coverage, price variation, and evidence tier. Avoid implying representativeness beyond the evidence.

### Separate observed facts from scenarios

An observed price, a calculated estimate, an official statistic, a user-entered assumption, and a hypothetical scenario are different kinds of information. Label them accordingly.

### Preserve history

Corrections, methodology changes, enforcement actions, and material changes to published results need appropriate audit history. Never silently rewrite historical public results.

### User agency

The simulator quantifies possible choices and consequences. It must not silently change a user's income or expenses, or decide which expenses they should cut.

### Privacy and proportionality

Collect and expose only information needed for the task. Contributor identities are private by default; access to identity and enforcement records is restricted and auditable.

## Explicitly deferred

- AI-powered “magic” curation or automatic personalized recommendations unless separately approved.
- A full debt-management product; the initial simulator models debt repayments as an expense.
- Dependence on SMS or email for MVP contributor notifications; the initial channel is the in-platform dashboard.
- Broad claims about nationwide conditions without adequate nationwide evidence.
