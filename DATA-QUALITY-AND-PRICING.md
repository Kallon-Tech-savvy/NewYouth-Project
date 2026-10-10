# Data Quality and Pricing Policy

## 1. Pilot and collection model

Pilot locations are Freetown and Kenema. Use a hybrid collection model: a trained core team establishes and maintains baseline coverage, supported by community volunteers.

Initial essential categories:

- Food
- Transport
- Housing
- Utilities
- Cooking fuel

Extra targeted observations may be collected when prices change sharply.

## 2. Collection cadence and freshness

| Category | Intended collection cadence | Maximum age for current estimates |
|---|---|---:|
| Food | Weekly | 14 days |
| Transport | Weekly | 14 days |
| Cooking fuel | Weekly | 14 days |
| Housing | Monthly | 45 days |
| Utilities | Monthly | 45 days |

Stale observations are excluded from current estimates but retained for valid historical comparisons. Show observation dates. Do not make a stale observation appear current by updating its display timestamp.

## 3. Standardization

Submissions must use standardized units and context so observations can be compared meaningfully.

- **Goods:** identify the item/variant, unit, and quantity (for example, per kilogram or litre where appropriate).
- **Transport:** capture route, fare, direction, and whether the fare is one-way or return.
- **Housing:** capture accommodation type, rent period, and location.
- **Utilities:** capture utility type and billing period.
- **Cooking fuel:** capture fuel type and standardized unit.

Do not compare observations as equivalent when their unit, quality, route, period, or other material context differs.

## 4. Validation and review

Every submission receives automatic validation. Suspicious, incomplete, or unusually large changes are sent for manual review before publication.

A flagged report is not automatically false. A real price spike can be published when sufficient evidence supports it. Requests for evidence should be proportionate to risk and impact.

Submissions may be accepted without attachments. For suspicious or high-impact reports, reviewers may request supporting evidence or clarification.

Use documented review rules. Authorized reviewers follow the rules and escalate unresolved or high-impact cases to the core team as appropriate.

## 5. Summarizing conflicting observations

For comparable approved observations, summarize prices using:

- Median price
- Observed range
- Number of observations
- Observation period and freshness
- Relevant geographic coverage
- Evidence/confidence tier and limitations

Avoid overstating representativeness when the sample is small or geographically narrow. The median does not eliminate the need to display variation or coverage gaps.

## 6. Insufficient, stale, or unverified data

- Do not fabricate missing values.
- Keep unverified reports pending while they are within the defined review process.
- Exclude pending reports from public estimates.
- Request clarification where useful.
- Retain stale observations for historical use, but exclude them from current estimates.
- Use historical fallbacks only when explicitly labeled.
- Suppress overall estimates when minimum critical coverage requirements are not met.
- Show missing categories, freshness, observation counts, and limitations.

Minimum coverage rules must combine category-specific counts, geographic coverage, freshness, and uncertainty. Exact thresholds are an open decision and must be justified using pilot evidence.

## 7. Sudden price shocks

**Confirmed policy:** Update estimates using validated observations and publish a contextual alert when a price movement is materially important.

Alerts should explain, where available:

- Affected item or category
- Affected location
- Observation period
- Number of observations and their freshness
- Magnitude and range of observed change
- Evidence tier and uncertainty
- Whether the change is localized or supported more broadly

One unusual report does not establish a market-wide shock. Use existing validation and review rules. A verified genuine spike should not be suppressed solely because it is large.

## 8. Fixed basket and inflation interpretation

Use fixed basket quantities when measuring basket-cost changes over time. Keep this measure separate from a household's actual expenses.

Do not interpret reduced consumption caused by rising prices as improved affordability. Where users model reduced quantities or substitutions, label those changes as household choices rather than as a price-index improvement.

Clearly distinguish:

- Item-level price change
- Fixed-basket cost change
- Freetown versus Kenema comparison
- Historical observations
- Future scenarios
- New Youth basket-based estimates versus official inflation statistics

The tracked essential-goods basket may be used as an inflation baseline when data quality is adequate. It is not automatically equivalent to an official national inflation measure.

## 9. Submission lifecycle and status

The contributor dashboard should show submission status, using states such as:

- Received
- Under review
- Awaiting clarification
- Approved
- Rejected

Provide a reason when appropriate. Notifications for the MVP are in-platform; do not require SMS or email.

If a contributor supplies new evidence after closure, use controlled reconsideration or a linked resubmission according to the case status and audit requirements. Preserve history.

## 10. Disputes and reviewer disagreement

Ordinary disputes should be reviewed by a different authorized reviewer where practical. High-impact or unresolved cases escalate to an uninvolved core-team decision-maker.

If reviewers disagree, unresolved observations remain excluded from public estimates until further evidence or review resolves the disagreement. High-impact criteria combine numerical impact, essential-goods importance, influence on public conclusions, suspected manipulation, and conflicts of interest. Exact thresholds remain open.

Reviewers may not review their own submissions or cases involving a relevant personal or financial conflict. Reassign the case; escalate if no eligible reviewer is available.

## 11. Corrections and audit history

For corrections to published prices, preserve:

- Original value
- Corrected value
- Reason
- Reviewer/actor
- Timestamp

Exclude invalid observations from current estimates when appropriate without erasing historical records. Recalculate affected estimates consistently.

For a materially incorrect published result, correct it promptly, identify affected results as corrected, give a brief explanation, and link to detailed correction history. Preserve the originally published value and audit history.

When methodology changes, publish a versioned change log. Recalculate historical estimates only where methodologically valid and clearly identify revised figures.

## 12. Data-quality failures and release controls

Use a risk-based response to major data-quality failures:

- Suspend estimates that could materially mislead users.
- Warn on other affected outputs where a warning adequately communicates the limitation.
- Withdraw an entire report only when its overall conclusions are no longer defensible.

An estimate should carry a documented evidence tier—strong, limited, or insufficient—alongside counts, freshness, geographic coverage, and price variation. Suppress estimates that fail critical requirements.
