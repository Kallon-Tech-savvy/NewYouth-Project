# Domain Documentation Guide — The New Youth

## Purpose

Use this guide to locate the authoritative documentation for a task. It summarizes document responsibilities; it does not replace or override the referenced documents.

For general source-of-truth rules and project status, begin with `README-DOCUMENTATION.md`.

## Choose the Relevant Documents

| Task area | Read first | Also consult when relevant |
|---|---|---|
| Product scope, user needs, or experience | `PRODUCT-OVERVIEW.md` | `OPEN-DECISIONS.md` |
| Domain terms, entities, and relationships | `DOMAIN-MODEL.md` | The document governing the affected behavior |
| Price submissions, validation, freshness, publication, or corrections | `DATA-QUALITY-AND-PRICING.md` | `GOVERNANCE-AND-SECURITY.md`, `OPEN-DECISIONS.md` |
| Contributor roles, reviewer conflicts, appeals, restrictions, or security | `GOVERNANCE-AND-SECURITY.md` | `DOMAIN-MODEL.md`, `OPEN-DECISIONS.md` |
| Basket cost, affordability, income, remittances, debt, or reserves | `SIMULATOR-POLICIES.md` | `PRODUCT-OVERVIEW.md`, `DOMAIN-MODEL.md` |
| Savings projections, investment returns, inflation, or purchasing power | `SIMULATOR-POLICIES.md` | `OPEN-DECISIONS.md`, `DOMAIN-MODEL.md` |
| Unresolved thresholds, assumptions, or release requirements | `OPEN-DECISIONS.md` | The policy document for the affected area |
| Testing, ADRs, prototypes, and documentation changes | `ENGINEERING-CONVENTIONS.md` | The affected product or domain documents |
| Repository documentation orientation | `README-DOCUMENTATION.md` | The documents linked from it |

## How to Resolve Conflicts

1. Identify the exact behavior, term, assumption, or requirement in conflict.
2. Compare the relevant policy documents with the source code, schema, migrations, and tests.
3. Check for applicable ADRs and any explicitly approved later decision.
4. Explain the discrepancy, its impact, and the decision needed.
5. Do not silently invent a resolution or present an implementation proposal as approved policy.

Follow `ENGINEERING-CONVENTIONS.md` for the required engineering workflow and ADR practices.

## Handling Missing or Incomplete Guidance

- A missing glossary or ADR does not automatically block work.
- Do not create documents merely to fill an apparent structural gap.
- If a task requires an unresolved product decision or numerical assumption, consult `OPEN-DECISIONS.md` and identify the decision needed.
- If a domain concept is genuinely missing, flag the gap and propose a consistent definition for review.
- Never fabricate observations, thresholds, financial assumptions, pilot results, or implementation status to fill a gap.

## Maintenance

Update this guide only when document ownership, names, or the documentation structure materially changes. Keep detailed policy and domain definitions in their existing authoritative documents.
