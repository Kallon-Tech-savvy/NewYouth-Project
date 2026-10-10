# ADR-0001 — Modular monolith and provider evaluation

- **Status:** Accepted architectural direction; Supabase prioritized for evaluation; final provider selection deferred
- **Date:** 2026-10-10
- **Decision owner:** The New Youth project owner
- **Related ticket:** [TNY-002 — Architecture and technical baseline](../tickets/TNY-002.md)
- **Approval record:** TNY-002 Architecture Proposal Revision 2 explicitly approved on 2026-10-10. Revision 3 was subsequently approved for documentation-only follow-through.
- **Cost assessment:** [Supabase cost and security assessment v1](../architecture/supabase-cost-and-security-assessment-v1.md)

## Context

The New Youth MVP must support public essential-price estimates for Freetown and Kenema, contributor submissions, validation and freshness controls, manual review and appeals, historical corrections, household affordability, savings and purchasing-power simulations, and privacy-preserving administration.

The repository has been treated as documentation-only during planning. The available repository audit did not establish a complete existing application stack or verify runtime behavior. Architecture must therefore avoid assuming an existing framework or prescribing implementation changes before evidence is available.

The provisional budget ceiling is **NLe 500 per month for recurring platform costs**. This ceiling remains in force; a proposal or assessment does not increase it.

## Decision

### Architecture shape

Adopt a **modular monolith** for the MVP: one web application, one primary relational database, and a small server-side API/function layer. Do not introduce microservices or separate databases without demonstrated need.

### Candidate technology direction

- Frontend candidate: React + TypeScript + Vite.
- Delivery model: client-rendered single-page application for the pilot.
- Persistence: PostgreSQL.
- Backend/provider: prioritize Supabase for detailed cost and security evaluation; do not consider it finally selected until required evidence and an explicit decision are recorded.
- Testing candidates: Vitest and suitable React tests, PostgreSQL-backed integration tests, and Playwright or an equivalent end-to-end framework.

These are the approved direction and candidates, not a claim that dependencies are installed or implementation exists.

### Provider and budget rule

Supabase is the priority candidate because an integrated PostgreSQL, authentication, database-policy, storage, and server-side-function offering may reduce integration overhead. Provider selection remains open.

The preliminary assessment estimates the Supabase Pro base plan at USD 25/month, or approximately NLe 573/month using the provisional conversion assumption. This exceeds the current NLe 500/month ceiling before other required operating costs. The estimate must be re-verified against current official prices, actual payment conversion, compute-credit application, workload, and required ancillary services.

Prepare a complete line-item budget, including hosting, domain, email, backup/export, usage-dependent charges, and payment fees where applicable. If the minimum viable secure configuration exceeds the ceiling, record the gap and request a separate budget decision. Do not silently increase the budget or weaken security to make the estimate appear to fit.

### Module boundaries

Keep distinct responsibilities for price evidence; quality and governance; price estimation; basket and historical comparisons; affordability; savings and purchasing power; publication and audit; and identity/access. Reuse tested domain calculations instead of duplicating business rules across pages.

### Security baseline

Enforce authorization server-side and reinforce it with database controls where available. Public access is limited to approved/publishable information. Ownership, reviewer conflict restrictions, privileged TOTP MFA, session protections, secret handling, correction history, and retention requirements apply independently of provider choice.

The Supabase assessment must address RLS, server-side authorization, privileged MFA enforcement, recovery flows, session invalidation, auditability, backups, restoration testing, and storage-object recovery. A provider feature label alone does not establish that the application meets these requirements.

## Consequences

### Benefits

- Limits operational complexity and recurring service count for the pilot.
- Preserves clear business boundaries and testable calculations.
- Prioritizes an integrated provider for detailed evidence gathering.
- Keeps final selection dependent on cost, security, recovery, and repository evidence.
- Supports a later provider change without making the product domain depend directly on vendor APIs.

### Costs and trade-offs

- A modular monolith requires discipline to keep module boundaries clear.
- The SPA approach may need reconsideration if strong server-rendering or public SEO requirements emerge.
- Supabase Pro's current preliminary base estimate exceeds the budget ceiling.
- Free-tier limitations make a zero-cost plan unsuitable as an assumed production solution without explicit risk acceptance.
- Provider-specific authorization, backup, and recovery capabilities must be verified before implementation can safely rely on them.

## Explicitly unresolved

- Final provider, plan, and hosting arrangement.
- Complete verified monthly cost and workload assumptions.
- Whether a budget revision should be approved if the minimum viable production configuration exceeds NLe 500/month.
- Predefined annual investment-return rate.
- Decision 101 on negative returns/downside scenarios.
- Exact retention periods, appeal deadlines, high-impact and coverage thresholds, privileged maximum session lifetime, and recovery objectives.
- Whether public pages require SEO/server-side rendering.

This ADR does not resolve those product-policy questions or authorize application implementation, provider provisioning, or deployment.

## Follow-up work

1. Complete or reconcile the TNY-001 repository audit.
2. Re-verify current Supabase pricing, plan limits, and billing assumptions.
3. Complete the line-item cost model, including all required operating services.
4. Define recovery objectives and verify a backup/restore approach.
5. Test the required authorization and privileged-authentication controls during implementation, after implementation is separately authorized.
6. Present the cost gap and any proposed budget revision for a separate explicit decision.
7. Update this ADR or add a superseding ADR after the provider decision is approved.
