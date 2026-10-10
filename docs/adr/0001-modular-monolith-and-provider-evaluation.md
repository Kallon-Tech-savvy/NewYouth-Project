# ADR-0001 — Modular monolith and provider evaluation

- **Status:** Accepted architectural direction; provider selection deferred
- **Date:** 2026-10-10
- **Decision owner:** The New Youth project owner
- **Related ticket:** [TNY-002 — Architecture and technical baseline](../tickets/TNY-002.md)
- **Approval record:** TNY-002 Architecture Proposal Revision 2 explicitly approved on 2026-10-10.

## Context

The New Youth MVP must support public essential-price estimates for Freetown and Kenema, contributor submissions, validation and freshness controls, manual review and appeals, historical corrections, household affordability, savings and purchasing-power simulations, and privacy-preserving administration.

The repository has been treated as documentation-only during planning. The available repository audit did not establish a complete existing application stack or verify runtime behavior. Architecture must therefore avoid assuming an existing framework or prescribing implementation changes before evidence is available.

The provisional budget ceiling is **NLe 500 per month for recurring platform costs**. Provider prices, plan limits, workload assumptions, and required security/recovery capabilities still need verification.

## Decision

### Architecture shape

Adopt a **modular monolith** for the MVP: one web application, one primary relational database, and a small server-side API/function layer. Do not introduce microservices or separate databases without demonstrated need.

### Candidate technology direction

- Frontend candidate: React + TypeScript + Vite.
- Delivery model: client-rendered single-page application for the pilot.
- Persistence: PostgreSQL.
- Backend/provider: compare Supabase with at least one alternative before choosing.
- Testing candidates: Vitest and suitable React tests, PostgreSQL-backed integration tests, and Playwright or an equivalent end-to-end framework.

These are the approved direction and candidates, not a claim that dependencies are installed or implementation exists.

### Provider and budget rule

Keep hosting and specific plans undecided until the comparison records actual recurring cost, limits, security controls, backup/restore capabilities, portability, and operational burden. The comparison must test feasibility against the NLe 500/month platform-cost ceiling. If no option meets the requirements, revisit scope or providers rather than silently reducing security.

### Module boundaries

Keep distinct responsibilities for price evidence; quality and governance; price estimation; basket and historical comparisons; affordability; savings and purchasing power; publication and audit; and identity/access. Reuse tested domain calculations instead of duplicating business rules across pages.

### Security baseline

Enforce authorization server-side and reinforce it with database controls where available. Public access is limited to approved/publishable information. Ownership, reviewer conflict restrictions, privileged 2FA, session protections, secret handling, correction history, and retention requirements apply independently of provider choice.

## Consequences

### Benefits
- Limits operational complexity and recurring service count for the pilot.
- Preserves clear business boundaries and testable calculations.
- Keeps provider selection evidence-based rather than relying on assumptions about free plans.
- Supports a later provider change without making the product domain depend directly on vendor APIs.

### Costs and trade-offs
- A modular monolith requires discipline to keep module boundaries clear.
- The SPA approach may need reconsideration if strong server-rendering or public SEO requirements emerge.
- Separately managed services may increase integration and operational work.
- Provider-specific authorization, backup, and recovery capabilities must be verified before implementation can safely rely on them.

## Explicitly unresolved

- Final provider, plan, and hosting arrangement.
- Verified recurring cost and expected usage assumptions.
- Predefined annual investment-return rate.
- Decision 101 on negative returns/downside scenarios.
- Exact retention periods, appeal deadlines, high-impact and coverage thresholds, privileged maximum session lifetime, and recovery objectives.
- Whether public pages require SEO/server-side rendering.

This ADR does not resolve those product-policy questions or authorize application implementation, provider provisioning, or deployment.

## Follow-up work

1. Complete or reconcile the TNY-001 repository audit.
2. Compare Supabase with at least one alternative against the TNY-002 criteria.
3. Record verified costs, limits, and operational/security findings.
4. Make a separate provider decision after the comparison is reviewed.
5. Update this ADR or add a superseding ADR if the evidence changes the architecture direction.
