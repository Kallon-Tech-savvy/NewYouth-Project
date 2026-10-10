# Agent Instructions — The New Youth

## Mission

The New Youth helps people in Sierra Leone understand essential-price changes, household affordability, savings, inflation, and future purchasing power. The initial pilot focuses on Freetown and Kenema.

Build and maintain the product in accordance with its documented policies. Prefer clear, reliable, accessible, and testable solutions over unnecessary complexity.

## Start Here

Before making changes:

1. Read `README-DOCUMENTATION.md` for the documentation map and source-of-truth rules.
2. Read `ENGINEERING-CONVENTIONS.md` for engineering workflow, testing, architecture decisions, and prototype rules.
3. Read the relevant product, domain, data-quality, governance, simulator, and open-decision documents for the task.
4. Inspect the existing implementation, tests, migrations, and repository configuration before proposing or changing code.

Use `docs/agents/domain.md` as a navigation aid when identifying relevant domain documentation.

If a recommended document does not exist, continue using the available sources. Do not create missing documentation speculatively.

## Non-Negotiable Rules

- Treat documented product decisions as the current policy baseline, not proof that a feature is implemented.
- Treat source code, database schema, migrations, and tests as evidence of current implementation.
- Report conflicts between policy and implementation explicitly. Do not silently resolve them by assumption.
- Never invent production observations, official statistics, pilot findings, financial-return assumptions, validation thresholds, retention periods, or other unresolved values.
- Keep observed data, derived estimates, official statistics, historical values, and user-defined scenario assumptions distinguishable.
- Preserve appropriate correction, methodology, security, moderation, and appeal history.
- Enforce authorization at the appropriate data and operation boundaries. Do not expose private contributor or enforcement information without authorization.
- Do not silently change a user's income, expenses, savings plan, or other scenario inputs.
- Do not describe unimplemented, untested, or unverified behavior as complete.
- Keep changes focused and consistent with the existing architecture unless a justified, reviewed decision supports a broader change.

## Implementation and Verification

Before editing, identify the expected behavior, relevant policy, affected components, data boundaries, and failure cases.

For meaningful changes:

- Add or update appropriate tests.
- Check validation, authorization, error handling, and relevant historical or audit behavior.
- Run available, relevant checks using commands supported by the repository.
- Review the final diff for unintended changes.
- Report what changed, what was verified, which commands ran, and any remaining risks or checks that could not be completed.

Do not claim a test passed unless it was actually run and its result supports that claim. Distinguish static inspection from execution and local verification from production verification.

## Unresolved Decisions

Consult `OPEN-DECISIONS.md` before implementing behavior that depends on an unresolved policy or numerical value.

Do not convert a proposed implementation into confirmed product policy without approval. When a decision blocks safe or correct implementation, explain the missing decision and propose explicit options.

## Architecture and Documentation

Follow `ENGINEERING-CONVENTIONS.md` for Architecture Decision Records (ADRs), prototype work, testing, and documentation maintenance.

Use established terms from `DOMAIN-MODEL.md`. If the domain model is insufficient, identify the gap rather than introducing competing terminology without review.

Update affected documentation when an approved policy, domain concept, or consequential implementation behavior changes.

## Repository Workflow

Inspect the repository's actual contribution and issue-tracking workflow before creating tickets, branches, pull requests, or other project artifacts. Do not assume a workflow that the repository has not established.

Respect existing changes and avoid overwriting unrelated work. Keep proposed changes reviewable and report the exact scope of each change.
