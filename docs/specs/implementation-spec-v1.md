# The New Youth — MVP Implementation Specification v1

- **Status:** Approved planning baseline; implementation not yet verified
- **Pilot:** Freetown and Kenema, Sierra Leone
- **Tickets:** [Dependency graph and index](../tickets/README.md)
- **Policy sources:** `PRODUCT-OVERVIEW.md`, `DOMAIN-MODEL.md`, `DATA-QUALITY-AND-PRICING.md`, `GOVERNANCE-AND-SECURITY.md`, `SIMULATOR-POLICIES.md`, `OPEN-DECISIONS.md`, and `ENGINEERING-CONVENTIONS.md`

## 1. Purpose and source of truth

Implement a reliable, accessible, evidence-led product that helps people in Sierra Leone understand essential-price changes, household affordability, savings, inflation, and future purchasing power. This specification records approved product scope and acceptance criteria; it does not certify current implementation. Code, migrations, configuration, tests, and executed verification determine implementation status.

## 2. MVP scope

### Price evidence
- Pilot locations: Freetown and Kenema; categories: food, transport, housing, utilities, cooking fuel.
- Hybrid collection by trained core team and community volunteers.
- Freshness limits for current estimates: food, transport, cooking fuel 14 days; housing and utilities 45 days.
- Standardized item/variant, unit, quantity, price, location, observation date, and category-specific context. Transport includes route, direction, and one-way/return; housing includes accommodation type and rent period; utilities include type and billing period; fuel includes type and standardized unit.
- Automated validation for every submission; manual review for suspicious, incomplete, or unusually large changes.
- Comparable approved observations summarized with median, range, count, period, freshness, coverage, evidence tier, and limitations.
- Stale observations excluded from current estimates but retained for valid historical comparisons.
- Contextual price-shock alerts use validated evidence; one report does not prove a market-wide shock.

### Governance and privacy
- Explicit submission statuses, appropriate reasons, clarification, impartial review, escalation, appeal, and controlled reconsideration.
- Reviewers cannot adjudicate their own reports or relevant conflicts of interest.
- Corrections preserve original/corrected values, reason, actor, and timestamp.
- Contributor identities private by default; identity and enforcement access restricted and auditable.
- Least-privilege authorization, privileged-account 2FA, session protections, and incident readiness.
- MVP notifications are in-platform; no SMS/email dependency.
- Deletion/anonymization follows an approved retention schedule; exact periods remain unresolved.

### Affordability and savings
- Model income/resources, actual expenses, remittances, debt repayments, deficits, emergency reserves, savings contributions, and user-selected alternatives.
- Emergency reserves are part of total savings, not additional savings.
- Show nominal projected savings and estimated purchasing power in today's terms using explicit, consistent assumptions.
- Use a standard return assumption only after its percentage is approved; support an advanced user-defined override.
- Negative-return/downside behavior remains gated by the unanswered policy decision.
- Disclose fallback inflation assumptions where category evidence is insufficient.
- Never silently modify user inputs or present projections as guarantees.

### Transparency
- Publish methodology and versioned changes, material corrections, and milestone-based transparency reports when meaningful and safe.
- Distinguish New Youth basket-based estimates from official inflation statistics.
- Suppress estimates failing critical quality requirements rather than inventing values.

## 3. Out of scope or gated
- AI-powered automatic curation/personalized recommendations unless separately approved.
- Full debt-management functionality.
- Mandatory SMS/email notifications for MVP.
- Nationwide representativeness claims without adequate evidence.
- Fabricated observations, pilot findings, reference-income values, return rates, validation thresholds, or retention periods.
- Legal-compliance certification by this specification.

## 4. Functional requirements
1. Authorized contributors submit price observations with standardized context.
2. Every submission is validated and has an auditable status/review history.
3. Only eligible, approved, sufficiently fresh, comparable observations contribute to current estimates.
4. Estimates expose period, count, range, freshness, geographic coverage, uncertainty, and limitations.
5. Fixed-basket comparisons use stable quantities and remain distinct from actual household spending.
6. Users explore affordability and savings scenarios without silent input changes.
7. Nominal balance and purchasing power in today's terms are calculated consistently and labeled separately.
8. Review, correction, appeal, and methodology history is preserved and access-controlled.
9. Authorization is enforced at API/service and data boundaries, not just by hiding UI controls.
10. Deployment and release claims are supported by actual tests and operational evidence.

## 5. Cross-cutting acceptance criteria
- **Truthfulness:** No fabricated values; missing or insufficient evidence is explicit.
- **Integrity:** Validate inputs, standardize comparable observations, preserve audit history, and test boundary cases.
- **Security:** Test unauthenticated, unauthorized, cross-user, conflict-of-interest, and privilege-escalation cases.
- **Privacy:** Minimize exposed personal data and restrict contributor identity/enforcement records.
- **Accessibility:** Forms, errors, status, charts, and scenario controls are understandable and keyboard-accessible where applicable.
- **Reproducibility:** Calculation rules and methodology versions are documented; assumptions are explicit.
- **Testing:** Add unit/integration tests and end-to-end checks for critical flows where supported.
- **Honest verification:** Record exact commands and outcomes; distinguish static inspection, local tests, and production verification.
- **Documentation:** Update relevant product/domain/engineering documentation when approved behavior or implementation changes.

## 6. Data-quality baseline

| Category | Intended cadence | Maximum age for current estimates |
|---|---|---:|
| Food | Weekly | 14 days |
| Transport | Weekly | 14 days |
| Cooking fuel | Weekly | 14 days |
| Housing | Monthly | 45 days |
| Utilities | Monthly | 45 days |

Minimum counts, coverage thresholds, and material price-shock thresholds remain open and must be justified by pilot evidence.

## 7. Open decisions and release gates

Consult `OPEN-DECISIONS.md`. Do not silently resolve:
- Predefined annual investment-return percentage and rationale.
- Negative returns/downside scenarios (Decision 101).
- Minimum observation counts and geographic coverage.
- Price-shock alert thresholds and evidence requirements.
- Evidence-based reference-income benchmark.
- Review/appeal deadlines, retention periods, login throttling values, privileged maximum session lifetime, sensitive-action reauthentication list, and exact inactivity warning timing.
- Applicable legal/privacy obligations and accountable operational owners.

Independent work may proceed with explicit unconfigured states and tests that prevent invented defaults. Features requiring a missing decision remain gated from release.

## 8. Implementation workflow
1. Audit repository code, migrations, dependencies, CI, tests, and deployment configuration (TNY-001).
2. Confirm the architecture based on evidence (TNY-002).
3. Implement tickets in dependency order; keep work on the approved integration branch.
4. Review each merge and its tests before expanding the task frontier.
5. Run focused checks and final integration/end-to-end checks.
6. Complete code review, resolve material findings, reconcile ticket evidence, and report open risks.
7. Do not merge to `main` or claim production readiness merely because documentation or a prototype is complete.

## 9. Definition of done

A ticket is done only when acceptance criteria are met, relevant tests are added/updated and run where possible, results are recorded, the diff is reviewed, documentation is updated, and remaining limitations are explicit. Release is acceptable only when critical data, security, operational, and policy gates are resolved or affected features are excluded.

