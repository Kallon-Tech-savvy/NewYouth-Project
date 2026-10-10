# Governance, Contributor Protection, and Security

## 1. Roles and access

Use role-based access control and least privilege.

- Reviewers can access records needed for assigned work.
- Core-team administrators may have broader access where justified.
- Contributor identities, enforcement records, and appeal records receive additional access restrictions and audit logging.
- Access must be denied when a person is not authorized to access a record.
- Do not allow reviewers to decide cases involving their own submissions or relevant personal/financial conflicts.

The exact role matrix and permission checks must be defined and tested in implementation.

## 2. Contributor privacy and retention

Contributor identities are private by default. Public users can see approved observations and source type, but not contributor identity.

Maintain a documented retention schedule with separate periods for:

- Raw submissions
- Published observations
- Audit logs
- Contributor identity records

Exact retention periods remain undecided. Do not invent them. Account deletion requests should remove or anonymize personal identifiers while retaining valid published observations and necessary audit history where the retention policy requires it. Revoke account access and explain retention exceptions.

## 3. Inactive accounts

Disable access after 180 days of inactivity. Preserve records according to the retention policy. Reactivation requires identity verification and restoration of only the user's current role permissions.

Meaningful activity means a successful login followed by an intentional action, such as checking submission status, updating account details, or submitting a price report. A login alone does not reset the inactivity clock.

Send two in-platform warnings: one at day 150 and another shortly before suspension.

If a user loses access to their registered contact method, or a reactivation request appears suspicious, require manual administrator review. Log the outcome.

## 4. Contributor enforcement

Use progressive enforcement:

1. Feedback or retraining for initial or minor problems.
2. Temporary restrictions for repeated problems where justified.
3. Suspension for serious or deliberate misconduct.
4. Permanent suspension only with clear, documented evidence of serious or repeated deliberate misconduct and review by an authorized decision-maker.

A suspicious price report or unusual value alone does not prove contributor misconduct.

Before permanent suspension, normally provide the allegations and an opportunity to respond. Temporary protective action without advance notice is permitted when justified by risk, followed by prompt review.

Publish a standard appeal window, with extensions for reasonable circumstances such as connectivity problems or difficulty obtaining evidence. The exact deadline remains open.

During an appeal, restrictions normally remain active. Limited interim access may be granted after a documented risk assessment. Disputed observations remain protected from publication until the applicable review resolves them.

## 5. Appeals and impartiality

- Ordinary report disputes and enforcement appeals should be handled by a different authorized reviewer where practical.
- High-impact or unresolved cases go to an uninvolved core-team member.
- A conflicted appeal reviewer must withdraw.
- Reassign internally first. If no eligible reviewer is available, pause the decision and seek an independent external reviewer or another documented impartial arrangement.
- If an appeal identifies a specific error in a price report, correct that error and then apply all remaining validation requirements before publication.
- Preserve the history of decisions and appeals.

## 6. Suspected coordinated manipulation

Use a risk-based response:

- Protect estimates that could be affected.
- Investigate evidence before making misconduct findings.
- Apply proportionate temporary restrictions when justified.
- Provide the applicable review and appeal process.

Similar prices or anomalies alone are not proof of coordination or manipulation.

## 7. Privileged authentication and sessions

Reviewers and core-team administrators must use two-factor authentication (2FA).

Initial second factor: authenticator-app TOTP codes. SMS must not be the sole second factor.

Recovery should support one-time recovery codes and encourage a backup device. If self-service recovery is unavailable, use a documented administrator-assisted identity-verification process.

Privileged sessions must:

- Auto-logout after 30 minutes of inactivity.
- Enforce a separate maximum session lifetime.
- Require reauthentication for sensitive actions.
- Be invalidated on logout and account suspension.
- Log relevant security events without logging passwords, TOTP codes, or recovery codes.

The maximum session lifetime, sensitive-action list, and recovery verification details remain open for security design.

## 8. Failed login and account protection

Use progressive throttling and temporary lockout, with stronger protections for privileged accounts. Avoid controls that make it easy for an attacker to lock out a legitimate user. Provide secure recovery and log relevant events.

Exact thresholds and lockout durations must be established in the security design and tested. Do not log credentials or authentication codes.

## 9. Security contact and incident response

Establish a public security contact before launch, once a responsible team member and response process exist. Define a monitoring owner, triage/escalation process, and restricted access to incoming reports.

Use risk-based incident disclosure. Notify affected users when an incident creates meaningful risk and comply with applicable legal requirements. Explain impact and protective steps without exposing exploitable details. Document the response.

## 10. Transparency reporting

Publish transparency reports after the pilot and at significant platform milestones, not on a fixed annual schedule.

Where meaningful and safe, report aggregated statistics about:

- Security incidents
- Privacy requests
- Data corrections
- Moderation and enforcement

Protect personal information and security-sensitive details. Explain definitions, scope, and limitations; do not publish statistics that imply precision the underlying records cannot support.

## 11. Methodology transparency

Publish calculation methods and validation standards. Keep sensitive manipulation-detection signals and security controls restricted.

Maintain a versioned public change log for methodology changes. Recalculate historical estimates where methodologically valid, clearly identifying revised figures and preserving the original published results.
