# Supabase cost and security assessment — TNY-002

- **Status:** Preliminary assessment; not a final provider selection
- **Assessment date:** 2026-10-10 (official Supabase pricing pages re-checked during follow-up)
- **Related ticket:** [TNY-002 — Architecture and technical baseline](../tickets/TNY-002.md)
- **Related ADR:** [ADR-0001 — Modular monolith and provider evaluation](../adr/0001-modular-monolith-and-provider-evaluation.md)
- **Budget rule:** NLe 500/month remains the current ceiling. No increase is approved by this assessment.
- **Decision:** Prioritize Supabase for detailed evaluation. Do not provision services or implement application code from this document alone.

## 1. Executive finding

Supabase is the preferred candidate for the next evaluation step because it can combine PostgreSQL, authentication, storage, database policies, and server-side functions with relatively low integration overhead. It is **not yet the final provider selection**.

The official Supabase pricing page currently lists Pro at USD 25/month and states that paid plans include USD 10/month in compute credits, enough to cover one Micro instance. The published plan limits include 8 GB database disk per project, 250 GB egress, 100 GB file storage, and daily backups retained for seven days. Sources: [Supabase pricing](https://supabase.com/pricing) and [compute and disk](https://supabase.com/docs/guides/platform/compute-and-disk), checked 2026-10-10.

Using the existing provisional planning rate of NLe 22.9194/USD gives USD 25 ≈ NLe 572.99/month, approximately NLe 72.99 above the NLe 500 ceiling before payment conversion costs or any additional operating services. The exchange rate remains a planning assumption; an authoritative same-day rate and the actual payment provider's conversion fees have not been verified. Do not treat the local-currency conversion as a binding quote.

## 2. Cost model

### Baseline assumptions

- One production Supabase project.
- Pro subscription.
- One default Micro compute instance, assuming the included USD 10 compute credit offsets its listed USD 10 monthly compute price.
- Initial pilot workload; no reliable traffic, database growth, storage, or egress forecast is available yet.
- No paid point-in-time recovery (PITR) in the baseline.
- No second paid environment assumed.
- Domain, email delivery, frontend hosting, payment fees, independent backups, and usage overages are not yet priced.

### Recurring cost lines

| Item | Planning cost (USD/month) | Planning cost (NLe/month) | Evidence/status |
|---|---:|---:|---|
| Supabase Pro base plan | 25.00 | 572.99 | Published base price; re-verify before purchase |
| Default Micro compute | 10.00 gross | 229.19 gross | Assumed covered by included USD 10 compute credit |
| Net additional default Micro compute | 0.00 | 0.00 | Conditional on credit applying to selected instance |
| Daily database backups, seven-day retention | Included | Included | Pro plan feature; restore test still required |
| TOTP MFA APIs | No separate base charge identified | 0.00 assumed incremental | App flows and enforcement remain engineering work |
| Frontend hosting | TBD | TBD | Hosting provider not selected |
| Domain and DNS | TBD | TBD | Registrar and renewal terms not selected |
| Transactional email | TBD | TBD | Provider, volume, and deliverability requirements unknown |
| Independent database export/backup storage | TBD | TBD | Strategy and retention not selected |
| Payment processing/currency conversion | TBD | TBD | Payment route and actual exchange rate unknown |
| Additional database compute/disk, storage, or egress | TBD | TBD | Usage forecast and plan limits must be verified |
| Monitoring or other paid operational services | TBD | TBD | Select only when required and costed |

**Known baseline subscription charge:** USD 25/month, estimated at NLe 572.99/month using the provisional planning rate. This already exceeds the NLe 500 ceiling by approximately NLe 72.99. The budget cannot be marked as passing.

The USD 10 compute credit must not be counted twice: under the stated assumption, the default Micro compute charge is offset by that credit. Confirm the exact current billing mechanics before relying on this estimate.

### Optional recovery cost

Current Supabase documentation lists seven-day PITR at approximately USD 100/month and requires at least Small compute, listed at approximately USD 15/month. One Pro organization receives USD 10/month in compute credits. Assuming the credit offsets the Small compute charge, a rough one-project Pro + Small + seven-day PITR estimate is USD 25 + USD 15 + USD 100 − USD 10 = approximately USD 130/month, before other services and usage charges. At the provisional NLe 22.9194/USD planning rate, this is approximately NLe 2,980/month. Confirm current billing treatment before relying on this calculation. Sources: [PITR pricing and retention](https://supabase.com/docs/guides/platform/backups), [compute and disk](https://supabase.com/docs/guides/platform/compute-and-disk), and [billing FAQ](https://supabase.com/docs/guides/platform/billing-faq), checked 2026-10-10. PITR is excluded from the baseline because no approved RPO/RTO currently requires it.

### Scenarios

| Scenario | Indicative Supabase cost | Use and decision |
|---|---:|---|
| Free plan | USD 0 plan fee | Development/controlled experiments only; do not describe as production-ready without explicit acceptance of limitations |
| Pro baseline | USD 25/month before additional services and overages | Preferred production candidate for further assessment, but over the current ceiling |
| Pro plus 7-day PITR | Approximately USD 130/month before other services, assuming USD 10 compute credit offsets Small compute | Not approved; roughly NLe 2,980/month at the provisional planning rate; only evaluate if recovery objectives justify the added cost |

## 3. Security baseline

### Identity and privileged access
- Use Supabase Auth for identity.
- Require TOTP MFA for privileged reviewers and administrators.
- Enforce the appropriate MFA assurance level in database policies and server-side operations, not only in the frontend.
- Design secure recovery codes or an approved backup-factor and identity-verification process.
- Apply progressive login throttling and protect account recovery from abuse.

### Authorization and database
- Enable and test RLS on exposed tables containing private or role-restricted data.
- Public users may read only approved and published price information.
- Contributors may access their own submissions and permitted status information.
- Reviewers must be prevented from reviewing their own reports and relevant conflicts of interest.
- Restrict identity, appeal, enforcement, and audit information to authorized roles.
- Use server-side validation and authorization for sensitive state changes.
- Never place service-role credentials or other server secrets in browser code.

### Sessions and auditability
- Enforce the approved 30-minute inactivity timeout for privileged sessions.
- Define a separate maximum session lifetime; this value remains open.
- Require reauthentication for sensitive operations.
- Invalidate sessions on logout, suspension, and relevant security revocation events.
- Audit privileged actions and important review/correction transitions.
- Never log passwords, tokens, MFA codes, or recovery codes.

### Backup and recovery
- Baseline: daily backups with seven-day retention, subject to current plan verification.
- Define approved recovery-point and recovery-time objectives before production.
- Test restoration and record results.
- Evaluate independent database exports/backups within the cost model.
- Treat database backups and Storage object recovery separately; do not assume restoring the database restores deleted uploaded objects.
- If the required recovery objectives cannot be met with the baseline, document the cost and obtain a decision rather than silently lowering the requirements.

## 4. Failure conditions

TNY-002 must not be marked complete if any of the following remains unresolved:

1. The complete recurring cost is unknown or exceeds the ceiling without a separate budget decision.
2. RLS, ownership checks, reviewer conflict restrictions, or privileged MFA can be bypassed.
3. Backup restoration has not been tested or cannot meet the approved recovery objectives.
4. Essential hosting, email, payment, or overage costs are missing from the budget.
5. Provider billing assumptions have not been re-verified against current official pricing.
6. The repository baseline remains insufficient to ground architecture in the actual application and deployment state.
7. An unresolved product policy is silently assigned a value by implementation.

## 5. Required evidence before final provider decision

- Current official Supabase pricing and plan-limit evidence, dated at verification.
- A workload model for expected users, submissions, database growth, file storage, and egress.
- Actual payment route, exchange rate, and conversion fees.
- Line-item prices for hosting, domain, email, backup/export, and other required services.
- Approved RPO/RTO and a tested restore procedure.
- Security test results for RLS, object ownership, privileged MFA, session controls, and secret handling.
- Completed/reconciled TNY-001 repository audit.
- A separate explicit decision if the recommended configuration exceeds NLe 500/month.

## 6. Official references checked 2026-10-10

- [Supabase pricing](https://supabase.com/pricing) — Pro base, plan limits, included compute credits.
- [Supabase billing FAQ](https://supabase.com/docs/guides/platform/billing-faq) — compute credit and multi-project billing examples.
- [Supabase compute and disk](https://supabase.com/docs/guides/platform/compute-and-disk) — Micro and Small compute prices.
- [Supabase database backups](https://supabase.com/docs/guides/platform/backups) — daily backup retention, PITR prices and Small compute requirement.
- [Supabase Auth MFA](https://supabase.com/docs/guides/auth/auth-mfa) — MFA implementation and enforcement.
- [Supabase production checklist](https://supabase.com/docs/guides/deployment/going-into-prod) — production hardening.
- [Bank of Sierra Leone](https://bsl.gov.sl/) — official exchange-rate portal; an unambiguous same-day USD/NLe rate and payment-route fee remain to be recorded before a binding local-currency budget.

## 7. Current conclusion

Supabase remains the priority candidate, but the Pro baseline fails the current budget ceiling on the available estimate. No budget increase, provider selection, provisioning, deployment, or application implementation is authorized by this assessment. Continue only with evidence gathering and documentation until the user makes the required separate decisions.
