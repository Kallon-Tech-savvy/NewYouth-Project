# Domain Model

Use these terms consistently in code, tests, issue titles, UI copy, and architecture notes.

## Core concepts

| Term | Meaning | Important distinction |
|---|---|---|
| Price observation | A submitted report of a price at a particular place and time, with a defined item, unit, and context | A submission is not automatically approved or public |
| Contributor | A person who submits price observations | Public identity is private by default |
| Reviewer | An authorized person who checks submissions and disputes | Reviewers must not handle cases where they have a relevant conflict |
| Core-team administrator | An authorized operator with broader responsibilities and access | Broader access must be justified and auditable |
| Approved observation | A price observation that passed the applicable review and validation rules | Approval does not by itself prove nationwide representativeness |
| Published observation | An approved observation made available to users | Public display should include context and limitations |
| Price estimate | A summary derived from eligible observations | It is not the same as a raw observation |
| Standard basket | A fixed set of items, standardized units, and quantities used to compare price changes over time | Keep basket quantities fixed for index comparisons |
| Basket cost | The estimated cost of purchasing the standard basket at a defined place and time | Do not confuse with actual household spending |
| Affordability scenario | A calculation using household resources and expenses | Must reflect explicit inputs and disclosed assumptions |
| Reference income | An evidence-based income benchmark used for standard comparisons | Not a claim that every household earns this amount |
| Savings projection | A modeled future balance based on contributions and return assumptions | Not a guarantee of actual future balance |
| Purchasing power in today's terms | The estimated present-price equivalent of a projected future balance | Depends on the inflation assumption used |
| User-defined assumption | A value entered or changed by the user for a scenario | Must not be represented as observed evidence or an official forecast |
| Emergency reserve | The portion of total savings earmarked for emergencies | It is part of total savings, not additional savings |
| Methodology version | A versioned set of rules used to produce an estimate | Changes require a public change log and careful historical comparison |
| Correction record | An auditable record of a correction to an observation or published result | Preserve the original value and reason for correction |
| Appeal | A formal request to reconsider a moderation, restriction, suspension, or report decision | Must be reviewed impartially |
| Security incident | An event affecting, or plausibly threatening, confidentiality, integrity, or availability | Response and disclosure depend on risk and applicable requirements |

## Important distinctions

### Observation versus estimate

A report is evidence submitted by a contributor. Validation and review determine whether it can be approved. An estimate is a calculation over eligible observations and must disclose the coverage and limitations of its evidence.

### Basket cost versus affordability

A fixed-basket index measures price movement while holding basket quantities constant. Household affordability compares resources available with the household's actual or modeled expenses. A household buying fewer items because prices rose must not be interpreted as experiencing improved affordability merely because spending fell.

### Historical data versus future scenario

Historical observations describe recorded conditions. Future scenarios apply assumptions to explore possible outcomes. Label both the period and the type of value.

### Total savings versus available savings

Emergency reserves remain part of total savings, but they are not freely available for unrelated goals. Never count a reserve twice.

### Remittance received versus expected

Money already received is different from a future transfer that may be delayed, reduced, or stopped. Model those states separately.

## Suggested conceptual relationships

These are domain relationships, not a claim about the existing database schema:

- Contributor submits Price observations.
- Reviewer validates and decides the status of a submission.
- Approved observations may contribute to a published price estimate.
- A standard basket defines items, standardized units, and fixed quantities for basket-cost calculations.
- A methodology version defines calculation and validation rules for estimates.
- An affordability scenario combines income/resources, expenses, debts, and optional reserves.
- A savings projection combines initial savings, contributions, duration, and an explicitly labeled return assumption.
- Purchasing power in today's terms adjusts a projected balance using a stated inflation assumption.
- Correction and appeal records preserve decision history.

## Naming rule

Prefer the defined terms above. If implementation reveals a genuinely missing concept, note the gap and resolve it through domain modeling before introducing a competing synonym.
