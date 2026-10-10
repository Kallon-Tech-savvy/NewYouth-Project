# The New Youth — Documentation Index

## Purpose

The New Youth helps people in Sierra Leone understand changes in prices, household affordability, savings, inflation, and future purchasing power. The pilot focuses on Freetown and Kenema.

This documentation records agreed product policies and engineering conventions. It is not a substitute for validating implementation against the source code, pilot evidence, applicable law, or specialist advice.

## Read in this order

1. [`PRODUCT-OVERVIEW.md`](PRODUCT-OVERVIEW.md) — purpose, users, scope, and core principles.
2. [`DOMAIN-MODEL.md`](DOMAIN-MODEL.md) — domain concepts and relationships.
3. [`DATA-QUALITY-AND-PRICING.md`](DATA-QUALITY-AND-PRICING.md) — collection, validation, publication, and corrections.
4. [`GOVERNANCE-AND-SECURITY.md`](GOVERNANCE-AND-SECURITY.md) — roles, contributor protections, appeals, access, and incidents.
5. [`SIMULATOR-POLICIES.md`](SIMULATOR-POLICIES.md) — affordability, savings, inflation, and return assumptions.
6. [`OPEN-DECISIONS.md`](OPEN-DECISIONS.md) — unresolved choices and values that must not be invented.
7. [`ENGINEERING-CONVENTIONS.md`](ENGINEERING-CONVENTIONS.md) — how engineering agents should explore and change the repository.

## Source-of-truth rules

- Treat explicit decisions in these documents as the current product-policy baseline.
- Source code and migrations establish what is implemented today; documentation establishes the intended policy. If they disagree, report the conflict instead of silently assuming either is correct.
- Do not fabricate observations, rates, thresholds, retention periods, pilot findings, or official statistics.
- Keep assumptions, observed data, derived estimates, and user-entered values distinguishable in code and UI.
- Update the relevant documentation when an approved policy or domain term changes.
- Record consequential architectural choices as Architecture Decision Records (ADRs) under `docs/adr/`.
- Do not claim a feature is implemented merely because its policy is documented.

## Status vocabulary

- **Confirmed policy** — explicitly selected in product-policy decisions.
- **Proposed implementation** — a practical way to implement a confirmed policy, still subject to codebase review.
- **Open decision** — needs evidence, a product decision, or technical design before release.
- **Not in initial scope** — intentionally deferred unless later approved.

## Project status

These files capture prior research and decisions. They do not certify the current repository's implementation, deployment readiness, legal compliance, or data quality. Verify all of those independently.
