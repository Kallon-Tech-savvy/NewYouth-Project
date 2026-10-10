# Domain schema v1 — provider-neutral PostgreSQL

## Scope

This is the first persistence baseline for TNY-003. It targets PostgreSQL 13+ and uses built-in UUID generation and JSONB. It deliberately does not choose an authentication provider, hosting provider, object-storage provider, or deployment arrangement. No provider credentials, extensions, RLS policies, or provider-specific identity functions are included.

Apply `db/migrations/0001_domain_schema.sql` to a new disposable PostgreSQL database. The paired `0001_domain_schema.down.sql` is destructive and is intended only for controlled rollback where deleting all data created by this migration is acceptable.

## Table groups

- **Identity and authorization references:** `profiles`, `roles`, `profile_roles`. `auth_subject` is an opaque unique identity-provider subject, not a credential. Authentication-provider mapping and permission enforcement are still implementation work.
- **Reference data:** `locations`, `price_categories`, `units`, `price_items`. The migration seeds the five approved pilot categories, freshness limits and initial standard units. It does not seed unverified prices, actual markets, or invented household benchmarks.
- **Submitted evidence and review:** `price_reports`, `report_review_events`, `report_assignments`, `report_corrections`, `appeals`. The report stores observation time separately from submission/record timestamps. Review, correction and appeal history are separate records.
- **Publication and estimates:** `published_observations`, `methodology_versions`, `estimate_runs`, `estimate_run_observations`, `estimate_values`. Approval and publication are separate. A database trigger rejects publication unless a report is approved, and a published report must be explicitly unpublished before its status can leave approved. Estimate runs retain their publication-source lineage.
- **Fixed-basket analysis:** `standard_baskets`, `standard_basket_items`.
- **Personal scenarios and audit:** `simulator_scenarios`, `audit_events`. Scenario inputs and assumptions are separated; anonymous/local scenarios can have no profile owner, while access control for saved scenarios remains an application responsibility.

## Database invariants in this increment

- Foreign keys protect references; restrictive deletes preserve linked evidence/history.
- Positive price and quantity, currency-code shape, supported lifecycle values, valid time ranges, and JSON object/array shapes are checked in PostgreSQL.
- Only one active reviewer assignment per report and one current publication per report are allowed.
- A report cannot be published unless its current status is approved.
- A report with an active publication cannot be moved away from approved until it is unpublished.
- Published estimate inputs reference publication records, not arbitrary submitted reports.
- Estimate runs record methodology version, period, evidence tier, observation count, coverage and limitations.
- Correction records store both prior and corrected value snapshots plus a reason and actor.
- Indexes cover review queues, contributor history, item/location/time lookups, publication lineage, estimate lookups, and audit access patterns.

## Deliberate boundaries and remaining work

1. **Provider-neutral does not mean launch-secure by itself.** This migration has no row-level security, grants, auth-provider adapter, API authorization, or browser-facing access rules. Do not expose database access to an untrusted client until those controls are implemented and tested.
2. **Self-review and conflict-of-interest checks:** a report assignment table records the reviewer and conflict declaration, but the full role/conflict matrix must be enforced in the service/database authorization layer. The assignment workflow must reject self-review and reassign declared/relevant conflicts.
3. **Append-only history:** review events, corrections, and audit events are intended as append-only records. Production database roles must deny ordinary application users UPDATE/DELETE on those tables. The privileged migration/owner role necessarily retains stronger powers.
4. **Corrections:** correction must be a transaction that records before/after values and reason before changing an active report or withdrawing publication; never silently overwrite evidence. Published results affected by correction require a new estimate run or a documented corrected/withdrawn state.
5. **Category-specific comparability:** `price_reports.context` holds category-specific details (transport route/direction/one-way vs return, housing type/rent period, utility billing period, fuel type and standardized unit). The API must validate category-specific required keys and prevent incomparable reports from entering the same estimate. A future schema revision may normalize these fields after pilot workflows clarify the stable context model.
6. **Freshness and estimate eligibility:** category freshness is seeded at 14 days for food, transport and cooking fuel, and 45 days for housing and utilities. Estimate-generation code must apply these rules to `observed_at`, calculate comparable groups only, and suppress results below evidence thresholds. Exact coverage/count thresholds remain intentionally unset pending pilot evidence.
7. **Currency and units:** `SLE` is the default currency code, not an FX conversion rule. Normalize/convert only under an explicit documented method. Item units and report quantity/unit must be checked for dimensional comparability by the service.
8. **Policy gates:** no investment-return percentage, negative-return/downside policy, retention period, appeal deadline, high-impact threshold, or minimum-coverage threshold is hard-coded here.
9. **Retention and deletion:** exact retention periods remain open. Account deletion should anonymize identifiers where policy requires, revoke access, and preserve valid public observations/audit history only to the approved retention rules.
10. **RLS and grants:** add and test provider-specific policies only after the final auth/database provider is selected. Database constraints do not replace record-level authorization.
11. **Timestamps and updates:** `updated_at` columns are initialized, but automatic update triggers and meaningful-activity/session handling are application work for a later security/auth ticket.
12. **No runtime claim:** the migration and SQL invariant script are committed artifacts, not proof that the migration has executed successfully. Run them against a real PostgreSQL 13+ disposable database before closing the ticket.

## Verification

Run the migration on an empty disposable PostgreSQL database, then run:

```sh
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f db/tests/0001_domain_schema_invariants.sql
```

The test script uses a transaction and rolls back its fixtures. It checks seeded categories, positive-price constraints, foreign-key enforcement, approval-before-publication, publication status protection, and estimate source lineage. A successful execution is not yet recorded; no database server/runtime was available in this repository inspection.
