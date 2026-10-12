# GateKeeper# GaterKeeper — Goals & Milestones

**Type:** Personal platform engineering project (portfolio piece)
**Owner:** Mariama Lukata
**Status:** Kickoff / Phase 0
**Last updated:** 2026-09-14

## What GaterKeeper Is

GaterKeeper is a cloud access governance and enforcement platform. It combines two things that are usually built separately:

1. **Governance/audit** — continuously scans IAM roles and policies in a cloud account, flags over-permissioned or drifted access against a defined rule set, and reports on it.
2. **Enforcement gateway** — sits in front of a set of resources/services as a policy decision & enforcement point, so access isn't just *audited after the fact* but actively *checked at request time* (zero-trust style).

The goal is a single coherent system: the same policy definitions drive both the passive audits and the active enforcement, rather than two disconnected tools.


## Goals

- **G1 — Working policy engine.** A single, reusable policy model (roles/permissions/conditions) that both the audit scanner and the enforcement gateway evaluate against.
- **G2 — Real governance value.** The audit component finds and reports genuinely over-permissioned or non-compliant IAM configurations in a real (sandboxed) AWS account — not a toy example.
- **G3 — Real enforcement value.** The gateway component actually blocks/allows a request based on policy, in real time, for at least one realistic access path.
- **G4 — Infrastructure as code.** The whole thing is deployable from Terraform, with CI/CD via GitHub Actions and OIDC (no long-lived AWS keys) — consistent with existing DevOps practice.
- **G5 — Observable.** Access decisions and audit findings are logged and visible (dashboard or structured logs + alerting), not just printed to a console.
- **G6 — Tellable story.** By the end, there's a clear architecture diagram, a README that reads like a case study, and 2-3 resume-ready bullets with concrete outcomes (e.g., "flagged X% of over-permissioned roles," "reduced policy evaluation latency to Xms").


## Milestones

### Phase 0 — Foundations (scoping & setup)
- Define the policy model: what a "role," "permission," and "condition" look like in GaterKeeper (decide: roll your own, or build on an existing engine like OPA/Cedar).
- Decide the target AWS surface for v1 (e.g., a small set of S3 buckets + Lambda functions + one API).
- Repo set up, Terraform backend/state configured, GitHub Actions skeleton with OIDC auth to AWS.
- **Done when:** repo exists, policy model is written down, and a "hello world" Terraform apply runs via CI/CD.

### Phase 1 — Governance/Audit Engine
- Build the scanner: pulls IAM roles/policies from the target AWS account and evaluates them against the rule set.
- Define the initial rule set (start with 5-10 rules, echoing the Deployment Gate Lambda approach: e.g., no wildcard actions/resources, no unused permissions, mandatory MFA condition on sensitive roles).
- Produce a report (structured output — JSON/CSV, plus a human-readable summary).
- **Done when:** running the scanner against a sandbox account produces a real, non-trivial findings report.

### Phase 2 — Enforcement Gateway
- Stand up the enforcement point (e.g., API Gateway custom authorizer, or a small Lambda-fronted proxy) that evaluates a request against the same policy model in real time.
- Wire it to at least one real access path (e.g., gating calls to a specific API or resource).
- **Done when:** a request that violates policy is actually denied, and one that complies is allowed — demonstrated live.

### Phase 3 — Observability & Reporting
- Structured logging for every audit run and every enforcement decision.
- Basic dashboard or scheduled report (CloudWatch dashboard, or a lightweight page) showing findings/decisions over time.
- Alerting for high-severity findings (e.g., SNS/Slack notification on a critical policy violation).
- **Done when:** you can answer "what happened and why" for any decision without reading raw logs.

### Phase 4 — Polish, Docs & Demo
- Architecture diagram covering both the audit and enforcement paths.
- README written as a case study (problem, approach, tradeoffs, results — not just setup instructions).
- Short recorded demo or script for walking through it in an interview.
- Extract 2-3 quantified resume bullets from real results produced by the project.
- **Done when:** the project is presentable cold, without you narrating context first.

### Stretch (only if time allows)
- Multi-account or multi-cloud support.
- Policy-as-code authoring workflow (PR-based policy changes with automated testing).
- Self-service access request/approval flow.

## Open Questions
- Final choice of policy engine (custom vs. OPA/Cedar vs. AWS-native tools like Access Analyzer/Verified Permissions) — to be decided in Phase 0.
- Exact AWS resource scope for the enforcement gateway demo.