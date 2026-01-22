# #EPIC-004 - HarmonyVoting Plugin Contracts & Deployment Production Release

**Repository:** osx-plugin-foundry (Axodus/osx-plugin-foundry)  
**End Date Goal:** 2026-02-28  
**Priority:** HIGH  
**Estimative Hours:** 120h  
**Status:** in progress

---

## Executive Summary

Deliver production-ready HarmonyVoting plugin contracts with full Harmony deployment, comprehensive testing, security audit, and E2E integration validation.

**Vision:** Deploy secure, upgradeable HarmonyVoting voting plugins (HIP, Delegation, Validator Opt-In) to Harmony testnet/mainnet with complete setup contracts, permissioning, and operator tooling.

**Timeline:** 6-week sprint (2026-01-21 → 2026-02-28)

---

## Subtasks (Linked)

### EPIC-004: HarmonyVoting Plugin Contracts & Deployment

[labels:type:epic, area:contracts] [status:IN_PROGRESS] [priority:HIGH] [estimate:120h] [start:2026-01-13] [end:2026-02-28]

**Phase 1 (2026-01-13 → 2026-01-21) — Specifications & Design:**

- [x] Plugin specs (HIP, Delegation, Validator Opt-In) (8h, DONE) [labels:type:feature, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h]
- [x] Setup contract architecture (8h, DONE) [labels:type:feature, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h]

**Phase 2 (2026-01-20 → 2026-02-04) — Core Contracts:**

- [x] HIP plugin UUPS contract (12h, DONE) [labels:type:feature, area:contracts] [status:DONE] [priority:HIGH] [estimate:12h]
- [x] HIPPluginSetup contract (12h, DONE) [labels:type:feature, area:contracts] [status:DONE] [priority:HIGH] [estimate:12h]
- [ ] Delegation plugin contract (6h, IN_PROGRESS) [labels:type:feature, area:contracts] [status:IN_PROGRESS] [priority:HIGH] [estimate:6h]
- [ ] Validator Opt-In registry (4h) [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]

**Phase 3 (2026-01-22 → 2026-02-11) — Deployment & Setup:**

- [ ] Deploy to Harmony testnet (8h) [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:8h]
- [ ] Configure allowlist + Band Oracle (4h) [labels:type:feature, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:4h]
- [ ] Deploy to Harmony mainnet (4h) [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]
- [ ] Update deployment registry (2h) [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:2h]

**Phase 4 (2026-02-05 → 2026-02-18) — Integration & Testing:**

- [ ] Unit tests (Solidity) (12h) [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:12h]
- [ ] Fork tests (Harmony mainnet) (8h) [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:8h]
- [ ] Integration tests with backend (6h) [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h]
- [ ] Security audit (4h) [labels:type:qa, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]

**Phase 5 (2026-02-19 → 2026-02-28) — Documentation & E2E:**

- [ ] Contract documentation (NatSpec) (4h) [labels:type:docs, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:4h]
- [ ] Deployment runbook (2h) [labels:type:docs, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:2h]
- [ ] E2E flow tests (plugin install → vote → execute) (6h) [labels:type:test, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h]
- [ ] Mainnet integration validation (2h) [labels:type:qa, area:contracts] [status:TODO] [priority:HIGH] [estimate:2h]

---

## Acceptance Criteria

- [x] Plugin specs documented (DONE)
- [x] HIP plugin contract deployed (DONE)
- [ ] Delegation plugin contract complete
- [ ] Validator Opt-In registry deployed
- [ ] Testnet deployment successful (all contracts)
- [ ] Band Oracle allowlist configured
- [ ] Mainnet deployment successful
- [ ] All unit + fork tests passing
- [ ] Security audit passed
- [ ] E2E tests passing (full lifecycle)
- [ ] Backend integration tested
- [ ] Documentation complete (NatSpec + runbooks)

---

**Version:** 2.0  
**Last Updated:** 2026-01-22  
**Template:** [EPIC.md](https://gist.github.com/mzfshark/2ab8856d6c0efc0dfa9d1f98d2a23fdf)

---

## Deliverables

**Component 1:** HIP Plugin (HarmonyVoting with Band Oracle)

- UUPS upgradeable contract
- Setup contract with permissioning
- Allowlist contract

**Component 2:** Delegation Plugin

- Delegation logic contract
- Setup contract

**Component 3:** Validator Opt-In Registry

- Validator registration/opt-out
- Storage contract

**Component 4:** Deployment Artifacts

- Harmony testnet addresses
- Harmony mainnet addresses
- ABIs + Typechain types

---

## Risks & Mitigations

| Risk                                      | Mitigation                         |
| ----------------------------------------- | ---------------------------------- |
| Smart contract vulnerabilities            | Security audit + fork testing      |
| Harmony chain reorgs affecting deployment | Confirmations + deployment retries |
| Band Oracle unavailability                | Fallback validation logic          |
| Plugin install permission conflicts       | Comprehensive permissioning tests  |

---

## Milestones

- **M1 (2026-01-21):** HIP plugin deployed to testnet
- **M2 (2026-02-04):** Delegation + Validator Opt-In plugins designed
- **M3 (2026-02-11):** All plugins deployed to mainnet
- **M4 (2026-02-18):** Security audit passed
- **M5 (2026-02-28):** E2E tests + documentation complete
