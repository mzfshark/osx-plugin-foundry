# #SPRINT-004 - HarmonyVoting Plugin Contracts & Deployment Roadmap

**Repository:** osx-plugin-foundry (Axodus/osx-plugin-foundry)  
**Sprint Duration:** 6 weeks (2026-01-21 → 2026-02-28)  
**Priority Focus:** Plugin Contracts (HIGH) → Deployment (HIGH) → Integration Testing (HIGH)  
**Total Capacity:** 120h

---

## Executive Summary

6-week implementation roadmap for HarmonyVoting plugin development and deployment. Organized by execution priority: contract development → deployment setup → integration testing → E2E validation.

**Key Outcomes:**

- HIP voting plugin deployed to Harmony testnet/mainnet
- Delegation + Validator Opt-In plugins operational
- Full integration with backend indexing validated
- Security audit completed

---

## WEEK 1 (2026-01-21 → 2026-01-27) — Specification & Design

[labels:type:sprint] [status:IN_PROGRESS] [priority:HIGH] [estimate:16h]

**Monday–Tuesday (2026-01-21 → 2026-01-22):**

- [x] **HIGH (8h):** Plugin specification documentation (DONE)
  - Define HIP plugin interface (3h)
  - Define Delegation plugin interface (2h)
  - Define Validator Opt-In registry (3h)
    [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h]

**Wednesday–Friday (2026-01-23 → 2026-01-27):**

- [x] **HIGH (8h):** Setup contract architecture (DONE)
  - Design permission model (3h)
  - Plan storage layout (3h)
  - Create contract templates (2h)
    [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h]

---

## WEEK 2 (2026-01-28 → 2026-02-03) — Core Plugin Development

[labels:type:sprint] [status:TODO] [priority:HIGH] [estimate:40h]

**Monday–Tuesday (2026-01-28 → 2026-01-29):**

- [ ] **HIGH (12h):** Implement HIP plugin contract
  - UUPS proxy pattern setup (4h)
  - Voting logic implementation (5h)
  - Band Oracle integration (3h)
    [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:12h]

- [ ] **HIGH (12h):** Implement HIPPluginSetup contract
  - Permission setup logic (4h)
  - Parameter encoding (4h)
  - Upgrade patterns (4h)
    [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:12h]

**Wednesday–Friday (2026-02-01 → 2026-02-03):**

- [ ] **HIGH (10h):** Delegation plugin contract
  - Delegation logic (4h)
  - Setup contract (3h)
  - Validator tracking (3h)
    [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:10h]

- [ ] **HIGH (6h):** Validator Opt-In registry
  - Registry contract implementation (3h)
  - Operator control logic (3h)
    [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h]

---

## WEEK 3 (2026-02-04 → 2026-02-10) — Testnet Deployment

[labels:type:sprint] [status:TODO] [priority:HIGH] [estimate:24h]

**Monday–Tuesday (2026-02-04 → 2026-02-05):**

- [ ] **HIGH (8h):** Deploy to Harmony testnet
  - Prepare deployment environment (2h)
  - Deploy HIP plugin (3h)
  - Deploy setup contracts (3h)
    [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:8h]

- [ ] **MEDIUM (4h):** Configure allowlist + Band Oracle
  - Allowlist setup (2h)
  - Oracle configuration (2h)
    [labels:type:task, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:4h]

**Wednesday–Friday (2026-02-08 → 2026-02-10):**

- [ ] **HIGH (8h):** Integration tests (testnet)
  - Setup contract behavior tests (4h)
  - Permission enforcement tests (4h)
    [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:8h]

- [ ] **HIGH (4h):** Update deployment registry
  - Record testnet addresses (2h)
  - Generate ABI/Typechain (2h)
    [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]

---

## WEEK 4 (2026-02-11 → 2026-02-17) — Mainnet Deployment & Testing

[labels:type:sprint] [status:TODO] [priority:HIGH] [estimate:24h]

**Monday–Tuesday (2026-02-11 → 2026-02-12):**

- [ ] **HIGH (4h):** Deploy to Harmony mainnet
  - Mainnet deployment execution (2h)
  - Verification (2h)
    [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]

- [ ] **HIGH (12h):** Unit tests (Solidity)
  - Test HIP voting logic (4h)
  - Test Delegation logic (4h)
  - Test permission model (4h)
    [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:12h]

**Wednesday–Friday (2026-02-15 → 2026-02-17):**

- [ ] **HIGH (8h):** Fork tests (Harmony mainnet)
  - Set up fork environment (2h)
  - Run mainnet fork tests (6h)
    [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:8h]

---

## WEEK 5 (2026-02-18 → 2026-02-24) — Integration & Security Audit

[labels:type:sprint] [status:TODO] [priority:HIGH] [estimate:20h]

**Monday–Tuesday (2026-02-18 → 2026-02-19):**

- [ ] **HIGH (6h):** Integration tests with backend
  - Event emission verification (3h)
  - Backend handler integration (3h)
    [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h]

- [ ] **HIGH (4h):** Security audit preparation
  - Audit checklist (2h)
  - Code review (2h)
    [labels:type:qa, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]

**Wednesday–Friday (2026-02-22 → 2026-02-24):**

- [ ] **HIGH (10h):** Security vulnerabilities remediation
  - Address audit findings (8h)
  - Re-audit critical issues (2h)
    [labels:type:qa, area:contracts] [status:TODO] [priority:HIGH] [estimate:10h]

---

## WEEK 6 (2026-02-25 → 2026-02-28) — Documentation & E2E Validation

[labels:type:sprint] [status:TODO] [priority:MEDIUM] [estimate:16h]

**Monday–Tuesday (2026-02-25 → 2026-02-26):**

- [ ] **MEDIUM (4h):** Contract documentation
  - NatSpec comments (2h)
  - Architecture diagrams (2h)
    [labels:type:docs, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:4h]

- [ ] **MEDIUM (2h):** Deployment runbook
  - Step-by-step guide (2h)
    [labels:type:docs, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:2h]

**Wednesday–Friday (2026-02-27 → 2026-02-28):**

- [ ] **HIGH (6h):** E2E flow tests
  - Plugin install → vote → execute (6h)
    [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h]

- [ ] **HIGH (2h):** Mainnet integration validation
  - Live contract verification (2h)
    [labels:type:qa, area:contracts] [status:TODO] [priority:HIGH] [estimate:2h]

- [ ] **MEDIUM (2h):** Operational readiness
  - Team handoff (1h)
  - Monitoring setup (1h)
    [labels:type:docs, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:2h]

---

## Capacity Planning

| Week      | Planned (h) | Buffer (h) | Total (h) |
| --------- | ----------- | ---------- | --------- |
| W1        | 16          | 1          | 17        |
| W2        | 40          | 2          | 42        |
| W3        | 24          | 2          | 26        |
| W4        | 24          | 2          | 26        |
| W5        | 20          | 2          | 22        |
| W6        | 16          | 1          | 17        |
| **Total** | **140h**    | **10h**    | **150h**  |

---

## Critical Path Dependencies

1. **Plugin specifications** → Contract development (W1 blocks W2)
2. **HIP plugin contract** → HIPPluginSetup (W2 parallel tasks)
3. **Contract tests** → Testnet deployment (W2 → W3)
4. **Testnet validation** → Mainnet deployment (W3 → W4)
5. **All contracts** → Integration tests (W4 → W5)
6. **Security audit** → E2E tests (W5 → W6)

---

**Version:** 1.0  
**Last Updated:** 2026-01-22  
**Template:** [SPRINT.md](https://gist.github.com/mzfshark/2ab8856d6c0efc0dfa9d1f98d2a23fdf)
