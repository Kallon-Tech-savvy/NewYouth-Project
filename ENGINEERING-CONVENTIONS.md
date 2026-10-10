# Engineering Conventions for Agents and Contributors

## 1. Before exploring the codebase

Before working on a domain area, read the relevant documentation if present:

- `GLOSSARY.md` at the repository root, or `GLOSSARY-MAP.md` if the repository is multi-context.
- Relevant `docs/adr/` records.
- For a multi-context repository, the glossary and ADRs within the affected context.

If these files are absent, proceed with the task without blocking. Do not treat their absence alone as a defect or create them speculatively.

This documentation set is an initial domain baseline. A root `GLOSSARY.md` can be created or extracted from `DOMAIN-MODEL.md` when the team adopts a formal glossary workflow.

## 2. Vocabulary

Use terms from `DOMAIN-MODEL.md` in issue titles, code, tests, refactor proposals, and hypotheses. If a needed concept is absent, flag the domain gap instead of casually inventing competing synonyms.

## 3. Policy versus implementation

- These docs record intended policy.
- The code, schema, migrations, and tests show what currently exists.
- When they conflict, report the exact conflict and impact.
- Do not silently override policy or existing ADRs.
- Do not describe unimplemented behavior as complete.

## 4. Changes and tests

For changes affecting price observations, estimates, authorization, appeals, corrections, savings, or inflation calculations:

1. Identify the relevant domain rules and any ADRs.
2. Inspect the existing implementation and tests before editing.
3. Define expected behavior and edge cases.
4. Add or update tests at the appropriate unit, integration, API, and database layers.
5. Verify failure cases, permissions, stale/insufficient data, and audit history where applicable.
6. Run the available checks and report what was and was not run.
7. Update documentation when policy or domain meaning changes.

Never use fabricated production-looking values to conceal missing data. Fixtures must be clearly test-only.

## 5. Domain and architecture decisions

Record consequential architectural choices as ADRs under `docs/adr/`. An ADR should include context, decision, alternatives considered, consequences, and status.

If a proposed change contradicts an existing ADR, identify the conflict explicitly and explain why reopening the decision may be justified.

## 6. Issue tracking

The repository's issue tracker is not specified by this document. Confirm the actual repository workflow before creating issues or tickets. Do not assume GitHub Issues, GitLab, or local Markdown until verified.

## 7. Prototype policy

Prototypes are exploratory and must be clearly marked as prototypes.

### UI question

When the question is about appearance, build several structurally distinct variants on the same existing route whenever practical. Preserve real page context, data fetching, route parameters, and authentication; switch only the rendered subtree. Use a shareable `?variant=` parameter and a clearly separate switcher. Keep the switcher out of production builds.

Variants should differ in structure and information hierarchy, not just color or copy. Avoid wiring prototypes to real mutations. After a winner is selected, implement it properly and remove prototype-only code from the production path. Keep the prototype on a throwaway branch as the primary record of exploration where the repository workflow supports this.

### Logic/state question

When the question is about state, domain logic, or a workflow, use a small runnable logic prototype rather than UI variations. Surface the full relevant state after actions. Keep it easy to run, in-memory by default, and clearly marked as throwaway. Do not add production-grade abstractions prematurely.

### General prototype rules

- Identify the question the prototype is meant to answer.
- Place it near the related code while clearly labeling it as exploratory.
- Make it runnable with a simple documented command or as a standalone file.
- Do not depend on persistent production data by default.
- Capture the decision and why it was selected.
- Keep unselected variants out of the production branch.

## 8. Documentation maintenance

When an approved policy changes, update the relevant document and any affected tests. Prefer small, focused changes. Preserve a clear record of what changed and why.
