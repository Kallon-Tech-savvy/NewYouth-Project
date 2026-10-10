# Supabase cost and security assessment — TNY-002

- **Status:** Preliminary assessment; not a final provider selection
- **Assessment date:** 2026-10-10 (Supabase, Cloudflare Pages, Resend, and domain-renewal evidence re-checked during follow-up)
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
- Frontend hosting has a possible USD 0 static-site option; email has a possible USD 0 starter option but is still a required service to validate; domain renewal, payment fees, independent backups, and usage overages remain unpriced.

### Recurring cost lines

| Item | Planning cost (USD/month) | Planning cost (NLe/month) | Evidence/status |
|---|---:|---:|---|
| Supabase Pro base plan | 25.00 | 572.99 | Published base price; re-verify before purchase |
| Default Micro compute | 10.00 gross | 229.19 gross | Assumed covered by included USD 10 compute credit |
| Net additional default Micro compute | 0.00 | 0.00 | Conditional on credit applying to selected instance |
| Daily database backups, seven-day retention | Included | Included | Pro plan feature; restore test still required |
| TOTP MFA APIs | No separate base charge identified | 0.00 assumed incremental | App flows and enforcement remain engineering work |
| Frontend hosting | 0.00 candidate | 0.00 candidate | Cloudflare Pages Free supports static assets and custom domains; not a quote for Functions or other services |
| Domain renewal (.com example) | 0.87 | TBD | Cloudflare Registrar lists USD 10.46/year renewal; USD/month equivalent, local conversion/fees excluded; actual domain not selected |
| Transactional email | 0.00 candidate | 0.00 candidate | Resend Free advertises 3,000 emails/month and 100/day; must confirm suitability, sender-domain setup, and actual authentication volume |
| Independent database export/backup storage | USD 0 at very small volumes, candidate only | TBD | Backblaze B2 lists first 10 GB free and USD 6/TB/month; operational export automation, retention, restore testing, and object-storage backup are separate; not selected |
| Payment processing/currency conversion | TBD | TBD | Payment route and actual exchange rate unknown |
| Additional database compute/disk, storage, or egress | TBD | TBD | Usage forecast and plan limits must be verified |
| Monitoring or other paid operational services | TBD | TBD | Select only when required and costed |

**Known baseline subscription charge:** USD 25/month, estimated at NLe 572.99/month using the provisional planning rate. This already exceeds the NLe 500 ceiling by approximately NLe 72.99. The budget cannot be marked as passing. Even if static hosting and starter email remain free, domain renewal, payment conversion, independent backup/export, and potential overages are still unresolved.

The USD 10 compute credit must not be counted twice: under the stated assumption, the default Micro compute charge is offset by that credit. Confirm the exact current billing mechanics before relying on this estimate.

### Hosting, email, domain, and currency evidence

- **Static frontend:** Cloudflare Pages documents a Free plan with up to 500 builds/month, custom-domain support, and free/unlimited static asset requests. This is a candidate for a static React/Vite frontend, not a commitment to use Cloudflare and not a price for server-side Functions. Source: [Cloudflare Pages limits](https://developers.cloudflare.com/pages/platform/limits/), checked 2026-10-10.
- **Authentication email:** Supabase states its built-in SMTP is not for production: it is limited to pre-authorized team addresses and currently 2 messages/hour, with no delivery SLA. Production email/password confirmation and password-reset flows require custom SMTP. Resend lists a Free tier of 3,000 emails/month and 100/day, so USD 0 is a candidate for a small pilot only if sender-domain verification, delivery needs, and limits are acceptable. Sources: [Supabase custom SMTP](https://supabase.com/docs/guides/auth/auth-smtp), [Supabase production checklist](https://supabase.com/docs/guides/deployment/going-into-prod), [Resend pricing](https://resend.com/pricing?product=transactional), checked 2026-10-10.
- **Domain and DNS:** Cloudflare Registrar's live price table lists `.com` registration/renewal at USD 10.46/year (about USD 0.87/month when annualized), and Cloudflare DNS is a no-cost candidate. This is only a representative `.com` price, not a selected or availability-checked domain; payment conversion and provider fees remain unverified. ICANN advises checking renewal terms separately from promotional registration prices. Sources: [Cloudflare Registrar domain prices](https://pricing.registrar.cloudflare.com/), [Cloudflare Registrar renewal policy](https://developers.cloudflare.com/registrar/account-options/renew-domains/), [ICANN renewal guidance](https://www.icann.org/resources/pages/domain-name-renewal-expiration-faqs-2018-12-07-en/), checked 2026-10-10.
- **Independent backup storage:** Backblaze B2 lists the first 10 GB free and USD 6/TB/month for pay-as-you-go storage, with monthly egress free up to 3× average stored data. These prices do not include implementation/operation of exports, restore drills, or protection of uploaded objects; B2 is a candidate only, not selected. Source: [Backblaze B2 pricing](https://www.backblaze.com/cloud-storage/solutions/backup-and-archive), checked 2026-10-10.
- **Exchange rate/payment route:** Searches did not yield an unambiguous authoritative same-day USD/NLe rate suitable for a binding calculation, nor the fee schedule for the card/payment route that would actually be used. Retain NLe 22.9194/USD only as a provisional planning assumption; obtain a dated bank/payment-provider quote before approval.

### Optional recovery cost

Current Supabase documentation lists seven-day PITR at approximately USD 100/month and requires at least Small compute, listed at approximately USD 15/month. One Pro organization receives USD 10/month in compute credits. Assuming the credit offsets the Small compute charge, a rough one-project Pro + Small + seven-day PITR estimate is USD 25 + USD 15 + USD 100 − USD 10 = approximately USD 130/month, before other services and usage charges. At the provisional NLe 22.9194/USD planning rate, this is approximately NLe 2,980/month. Confirm current billing treatment before relying on this calculation. Sources: [PITR pricing and retention](https://supabase.com/docs/guides/platform/backups), [compute and disk](https://supabase.com/docs/guides/platform/compute-and-disk), and [billing FAQ](https://supabase.com/docs/guides/platform/billing-faq), checked 2026-10-10. PITR is excluded from the baseline because no approved RPO/RTO currently requires it.

### Scenarios

| Scenario | Indicative Supabase cost | Use and decision |
|---|---:|---|
| Free plan | USD 0 plan fee | Development/controlled experiments only; do not describe as production-ready without explicit acceptance of limitations |
| Pro baseline | USD 25/month before additional services and overages | Preferred production candidate for further assessment, but over the current ceiling |
| Pro plus 7-day PITR | Approximately USD 130/month before other services, assuming USD 10 compute credit offsets Small compute | Not approved; roughly NLe 2,980/month at the provisional planning rate; only evaluate if recovery objectives justify the added cost |

### Recovery objectives — approved on 2026-10-10; verification remains pending

The user explicitly approved these minimum targets on 2026-10-10. Approval establishes policy targets; it does not prove implementation or successful recovery:

- **RPO (maximum tolerable data loss): 24 hours** for the PostgreSQL database, conditional on daily backup completion. This is a target, not a guarantee; backup schedules and actual restore points must be verified.
- **RTO (target to restore core service): 1 business day** after a declared recoverable outage, subject to staff availability, provider access, restore duration, and validation. This is not an SLA.
- **Backup retention:** at least the Supabase Pro baseline of seven days for database backups, plus an independent export on a regular schedule stored separately. Proposed independent-export retention: 30 days, pending storage/privacy review.
- **Restore test:** before launch, restore into a separate non-production project/environment; verify schema/migrations, row counts and representative calculations, RLS/authorization behavior, authentication flows, and object-storage recovery. Record duration, errors, and operator steps. Repeat at least quarterly and after material schema/backup changes.
- **Object storage:** database backups do not establish that uploaded files can be restored. Define a separate inventory/checksum/export and restore test for Storage objects, including object-to-record consistency.
- **Recovery ownership:** assign a named responsible role, a documented runbook, secure access to backup credentials, and an escalation/contact path before launch.
- **Incident handling:** document how to declare recovery, preserve evidence, notify the project lead, validate recovered data, and communicate service restoration.

If the project requires an RPO materially below 24 hours or an RTO below one business day, daily backups alone may not meet the requirement; evaluate PITR or another recovery design and its full cost. Do not enable paid PITR without a separate decision. These targets are approved, but remain unverified until demonstrated by a restore drill.

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
- Approved pilot RPO: 24 hours; approved pilot RTO: one business day. Neither has been verified by a restore drill yet.
- Baseline: daily backups with seven-day retention, subject to current plan verification.
- Approved independent export retention target: 30 days. Privacy/storage implementation, cost and automation still require validation.
- Complete and record a restore drill before production, including data, calculations, authorization, and uploaded-object recovery. Repeat quarterly and after material changes.
- Treat database backups and Storage object recovery separately; do not assume restoring the database restores deleted uploaded objects.
- If required objectives cannot be met, document alternatives and costs and obtain a decision rather than silently lowering requirements.

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
- [Supabase manage PITR usage](https://supabase.com/docs/guides/platform/manage-your-usage/point-in-time-recovery) — official billing example totals approximately USD 130/month for Pro + Small compute + seven-day PITR after the compute credit.
- [Supabase Auth MFA](https://supabase.com/docs/guides/auth/auth-mfa) — MFA implementation and enforcement.
- [Supabase production checklist](https://supabase.com/docs/guides/deployment/going-into-prod) — production hardening.
- [Bank of Sierra Leone](https://bsl.gov.sl/) — official starting point for exchange-rate verification; no unambiguous same-day USD/NLe rate or actual payment-route fee has been recorded.
- [Cloudflare Pages limits](https://developers.cloudflare.com/pages/platform/limits/) — static-site hosting limits and custom-domain support, checked 2026-10-10.
- [Supabase custom SMTP](https://supabase.com/docs/guides/auth/auth-smtp) — default SMTP is not production-ready; custom SMTP required for normal external authentication email, checked 2026-10-10.
- [Resend transactional email pricing](https://resend.com/pricing?product=transactional) — free-tier limits, checked 2026-10-10.
- [Cloudflare Registrar domain prices](https://pricing.registrar.cloudflare.com/) — current listed extension registration and renewal prices, including `.com` at USD 10.46/year, checked 2026-10-10.
- [Cloudflare Registrar renewal policy](https://developers.cloudflare.com/registrar/account-options/renew-domains/) — renewal at registry list price, checked 2026-10-10.
- [Backblaze B2 pricing](https://www.backblaze.com/cloud-storage/solutions/backup-and-archive) — first 10 GB free, USD 6/TB/month, and egress allowance, checked 2026-10-10.
- [ICANN domain-renewal guidance](https://www.icann.org/resources/pages/domain-name-renewal-expiration-faqs-2018-12-07-en/) — registrar-specific renewal prices, checked 2026-10-10.

## 7. Decision brief

**Recommendation:** Do not select or provision Supabase for production yet. Keep Supabase Pro as the preferred candidate for evaluation, preserve the NLe 500/month ceiling, and seek explicit approval for any budget change only after the recovery targets and payment costs are validated.

### Budget arithmetic (planning only)

- Supabase Pro: USD 25/month.
- Representative `.com` renewal annualized: USD 10.46/year ÷ 12 ≈ USD 0.87/month.
- Known recurring subtotal before payment fees, independent backup operations, and usage overages: approximately USD 25.87/month.
- At the provisional—not authoritative—rate of NLe 22.9194/USD, this is approximately NLe 592.90/month, already about NLe 92.90 over the ceiling.
- Pro plus seven-day PITR is officially illustrated by Supabase at about USD 130/month including Small compute and compute credit; adding the annualized representative domain gives about USD 130.87/month, or approximately NLe 2,999/month at the same provisional rate, before other costs.
- Independent storage may have a zero storage charge at very small volumes, but export automation, staff operations, restore drills, object backups, and payment fees are not costed. A free storage allowance is not a complete backup solution.

### Decision paths
1. **Stay within ceiling:** assess alternative hosting/database architecture or a controlled non-production pilot, but do not claim production readiness until email, backup/restore, security, and service reliability are met. Supabase Free is not the production recommendation.
2. **Retain the proposed managed production baseline:** submit a separate budget request for a verified all-in monthly amount, with a contingency and recovery choice. PITR is a materially higher-cost option.
3. **Recovery target decision:** approve or revise the proposed RPO 24 hours / RTO one business day / seven-day managed backup / 30-day independent export, then validate through a restore drill before production.

### Explicit outstanding decisions/evidence
- Approve or revise the proposed RPO/RTO and independent-export retention.
- Obtain a dated exchange rate tied to the actual payment route and its fees. The Bank of Sierra Leone page exposes exchange-rate information, but the captured page did not unambiguously label a usable same-day USD/NLe quote; no rate is asserted as authoritative.
- Confirm a domain choice and renewal quote; `.com` is representative only.
- Confirm expected user, data, file-storage, egress, and email volumes.
- Select and test database and object-storage backup/export/restore procedures.
- Recalculate the all-in budget using verified quotes and a reasonable contingency before any provider/budget decision.

## 8. Current conclusion

Supabase remains the priority candidate, but the Pro + representative domain baseline is approximately USD 25.87/month (about NLe 592.90 using the provisional rate), above the NLe 500/month ceiling before payment fees, independent-backup operations, and usage overages. The budget gap and need for a separate budget decision are documented. The recovery targets are approved, but recovery has not been tested. TNY-002 architecture documentation may close as complete for its planning/evaluation scope; this does not approve a production provider, budget increase, provisioning, deployment, or application implementation. Production remains blocked pending verified all-in costs, local payment conversion, workload assumptions, and a successful recovery drill.
