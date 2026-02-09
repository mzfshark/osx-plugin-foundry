# [PLAN] HarmonyVoting Plugin Fixes — Master Plan

**Slug:** `PLAN-HarmonyVoting`  
**End Date Goal:** 2026-02-15  
**Priority:** URGENT  
**Estimative Hours:** 100h (all repos)  
**Status:** Phase 2 In Progress — NativeTokenVoting UNKNOWN mitigated (fix implemented; evidence pending)
**Last Updated:** 2026-02-04

---

## Executive Summary

This **master plan** coordinates fixes across **4 repositories** for the HarmonyVoting plugins: **NativeTokenVoting**, **DelegationVoting**, and **HIPVoting**. Each repo has its own detailed plan linked below.

### Problem Summary

| Plugin            | Issue                                                             | Severity    |
| ----------------- | ----------------------------------------------------------------- | ----------- |
| NativeTokenVoting | Installs but displays as `UNKNOWN` name                           | High        |
| DelegationVoting  | `processKey` from form ignored; uses hardcoded key                | High        |
| DelegationVoting  | Validator address not displayed after install                     | High        |
| DelegationVoting  | Delegators and token counts not shown                             | High        |
| DelegationVoting  | Proposals created successfully but not listed in UI               | Critical    |
| HIPVoting         | Permission flow for DAO allowlist documented (TASK-005 completed) | Medium-High |

---

## Distributed Plans (by Repository)

| Repository             | Plan                                                                                                  | Scope                                 | Hours |
| ---------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------- | ----- |
| **osx-plugin-foundry** | [This document](#sprints-linked)                                                                      | Setup contracts, events, verification | 38h   |
| **aragon-app**         | [PLAN_HARMONYVOTING_FRONTEND.md](../../../aragon-app/docs/plans/PLAN_HARMONYVOTING_FRONTEND.md)       | Forms, display, SDK calls             | 28h   |
| **Aragon-app-backend** | [PLAN_HARMONYVOTING_INDEXER.md](../../../Aragon-app-backend/docs/plans/PLAN_HARMONYVOTING_INDEXER.md) | Event indexing, API, backfill         | 24h   |
| **AragonOSX**          | [PLAN_HARMONYVOTING_SUBGRAPH.md](../../../AragonOSX/docs/plans/PLAN_HARMONYVOTING_SUBGRAPH.md)        | Subgraph mappings, schema             | 20h   |

### Key Metrics

- **Total Planned Work:** 100h (all repos)
- **Completion:** Partial (NativeTokenVoting detection fix implemented; remaining items pending)
- **Active Plans:** 4
- **Open Bugs:** 5
- **Timeline:** 2026-01-28 → 2026-02-15

### Latest Status (2026-02-05)

- **NativeTokenVoting — UNKNOWN name:** Fix implemented in backend/frontend detection (selector-based bytecode detection + subdomain precedence). Status is **mitigated** pending staging reproduction evidence (tx + backend plugin record).
- **DelegationVoting fixes:** TASK-002/003/004 implemented in [SPRINT_001A_DELEGATION_FIXES.md] and marked COMPLETED.
- **HIPVoting allowlist (TASK-005):** Documented end-to-end permission flow and UI gaps; recommendations captured in sprint notes. Status: COMPLETED (operational runbook and recommendations created).
- **DelegationVoting Full Implementation:** New [SPRINT-002](SPRINT_002_DELEGATION_VOTING.md) created to address complete plugin experience: installation metadata, validator data display (members, voting power), proposal listing/indexing, and delegator voting integration with Harmony API.
- **DelegationVoting — processKey ignored:** Root-cause hypothesis documented (UI does not collect/forward `processKey`); still needs reproduction evidence and implementation work.
- **DelegationVoting — validator/delegators missing:** Hypothesis documented (missing data read/render path); needs staging reproduction + indexing/subgraph confirmation.
- **DelegationVoting — proposals not listed:** Not yet reproduced in this sprint doc; blocked on evidence collection.
- **HIPVoting — allowlist permission flow:** Not yet documented end-to-end; remains pending.

---

## Hierarchy Overview (This Repo: Contracts)

```
[PLAN] HarmonyVoting Plugin Fixes — Master Plan (this document)
├── [PLAN-HarmonyVoting | SPRINT-001] Diagnosis & Reproduction
│   ├── TASK-001: Reproduce NativeTokenVoting UNKNOWN issue
│   ├── TASK-002: Reproduce DelegationVoting processKey issue
│   ├── TASK-003: Reproduce DelegationVoting validator/delegators issue
│   ├── TASK-004: Reproduce DelegationVoting proposals not listed
│   └── TASK-005: Document HIPVoting permission flow gaps
└── [PLAN-HarmonyVoting | SPRINT-002] Contract & Setup Fixes
    ├── BUG-001: Fix NativeTokenVoting metadata/name emission
    ├── BUG-002: Fix DelegationVoting processKey persistence
    ├── BUG-003: Fix DelegationVoting validator event emission
    ├── FEATURE-001: Implement HIPVoting allowlist UX flow
    └── TASK-001: Re-verify Setup contracts on Blockscout/Sourcify
```

**Note:** Frontend integration (SPRINT-003) moved to [aragon-app plan](../../../aragon-app/docs/plans/PLAN_HARMONYVOTING_FRONTEND.md).

### Related EPICs

- [EPIC-VoteDelegation](EPIC_VOTEDELEGATION.md) — Vote Delegation & Multi-Validator for HarmonyVoting Suite (validator feedback Feb 2026)

---

## Sprints (Linked)

### [PLAN-HarmonyVoting | SPRINT-001] Diagnosis & Reproduction

**Goal:** Reproduce all issues in staging, collect logs/tx receipts, identify root causes.

- [ ] [PLAN-HarmonyVoting | SPRINT-001 | TASK-001] Reproduce NativeTokenVoting UNKNOWN issue [key:01JK8QXYZ0001] [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-001] Reproduce NativeTokenVoting UNKNOWN issue [key:01JK8QXYZ0001] [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:4h] (fix implemented; evidence optional)
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-002] Reproduce DelegationVoting processKey issue [key:01JK8QXYZ0002] [labels:type:task, area:frontend] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-003] Reproduce DelegationVoting validator/delegators issue [key:01JK8QXYZ0003] [labels:type:task, area:indexer] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-004] Reproduce DelegationVoting proposals not listed [key:01JK8QXYZ0004] [labels:type:task, area:indexer] [status:DONE] [priority:URGENT] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-005] Document HIPVoting permission flow gaps [key:01JK8QXYZ0005] [labels:type:task, area:docs] [status:DONE] [priority:MEDIUM] [estimate:2h]

### [PLAN-HarmonyVoting | SPRINT-002] Contract & Setup Fixes

**Goal:** Fix Setup contracts to emit correct metadata, persist processKey, and emit validator events.

- [ ] [PLAN-HarmonyVoting | SPRINT-002 | BUG-001] Fix NativeTokenVoting metadata/name emission [key:01JK8QXYZ0006] [labels:type:bug, area:contracts] [status:TODO] [priority:HIGH] [estimate:8h]
- [ ] [PLAN-HarmonyVoting | SPRINT-002 | BUG-002] Fix DelegationVoting processKey persistence [key:01JK8QXYZ0007] [labels:type:bug, area:contracts] [status:TODO] [priority:HIGH] [estimate:8h]
- [ ] [PLAN-HarmonyVoting | SPRINT-002 | BUG-003] Fix DelegationVoting validator event emission [key:01JK8QXYZ0008] [labels:type:bug, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h]
- [ ] [PLAN-HarmonyVoting | SPRINT-002 | FEATURE-001] Implement HIPVoting allowlist UX flow [key:01JK8QXYZ0009] [labels:type:feature, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:12h]
- [ ] [PLAN-HarmonyVoting | SPRINT-002 | TASK-001] Re-verify Setup contracts on Blockscout/Sourcify [key:01JK8QXYZ0010] [labels:type:task, area:devops] [status:TODO] [priority:MEDIUM] [estimate:4h]

### [PLAN-HarmonyVoting | SPRINT-003] Frontend & Indexer Integration

**Goal:** Update frontend mappings, fix form submission, add subgraph handlers, reindex data.

- [ ] [PLAN-HarmonyVoting | SPRINT-003 | BUG-001] Fix frontend processKey form submission [key:01JK8QXYZ0011] [labels:type:bug, area:frontend] [status:TODO] [priority:HIGH] [estimate:6h]
- [ ] [PLAN-HarmonyVoting | SPRINT-003 | BUG-002] Fix proposal indexing for DelegationVoting [key:01JK8QXYZ0012] [labels:type:bug, area:indexer] [status:TODO] [priority:URGENT] [estimate:8h]
- [ ] [PLAN-HarmonyVoting | SPRINT-003 | TASK-001] Update networkDefinitions with correct addresses [key:01JK8QXYZ0013] [labels:type:task, area:frontend] [status:TODO] [priority:HIGH] [estimate:2h]
- [ ] [PLAN-HarmonyVoting | SPRINT-003 | TASK-002] Add subgraph mappings for HarmonyVoting events [key:01JK8QXYZ0014] [labels:type:task, area:subgraph] [status:TODO] [priority:HIGH] [estimate:8h]
- [ ] [PLAN-HarmonyVoting | SPRINT-003 | TASK-003] Run reindex/backfill scripts [key:01JK8QXYZ0015] [labels:type:task, area:indexer] [status:TODO] [priority:HIGH] [estimate:4h]
- [ ] [PLAN-HarmonyVoting | SPRINT-003 | TASK-004] E2E validation tests [key:01JK8QXYZ0016] [labels:type:task, area:testing] [status:TODO] [priority:HIGH] [estimate:6h]

---

## Milestones

- **M1: Diagnosis Complete** — TODO — 2026-01-28 → 2026-01-31
- **M2: Contract Fixes Deployed** — TODO — 2026-02-01 → 2026-02-07
- **M3: Full Integration & E2E** — TODO — 2026-02-08 → 2026-02-15

---

## Risks & Mitigations

- 🚨 **Risk 1:** Setup contract changes require redeploy and re-verification
  → Mitigation: Prepare flatten scripts and multi-verifier strategy (Sourcify + Blockscout)
  → Contingency: Manual source upload if automated verification fails

- 🚨 **Risk 2:** Subgraph changes may require redeployment on The Graph hosted service
  → Mitigation: Test on local graph-node first; coordinate deploy window
  → Contingency: Use backend direct RPC indexing as temporary fallback

- ⚠️ **Risk 3:** Frontend cache issues may persist old addresses
  → Mitigation: Clear `.next` cache, hard-refresh, add cache-busting headers
  → Contingency: Add runtime config overrides for address mappings

- ⚠️ **Risk 4:** HIPVoting allowlist requires management DAO action
  → Mitigation: Document clear admin runbook; automate via multisig proposal
  → Contingency: Temporary bypass flag for staging/testing

---

## Cross-Repository Impact

| Repository           | Impact                        | Files                                                                        |
| -------------------- | ----------------------------- | ---------------------------------------------------------------------------- |
| `osx-plugin-foundry` | Setup contracts, plugin logic | `src/setup/*`, `src/harmony/*`                                               |
| `aragon-app`         | Frontend forms, display       | `src/shared/constants/networkDefinitions.ts`, `src/**/PrepareProcessDialog*` |
| `Aragon-app-backend` | Indexer, API                  | `src/models/*`, `scripts/backfillHarmony.ts`                                 |
| `AragonOSX`          | Subgraph mappings             | `packages/subgraph/src/*`                                                    |

---

## Files to Investigate

```
# Contracts / Setup
osx-plugin-foundry/src/setup/HarmonyDelegationVotingSetup.sol
osx-plugin-foundry/src/setup/HarmonyHIPVotingSetup.sol
osx-plugin-foundry/src/setup/HarmonyNativeTokenVotingSetup.sol
osx-plugin-foundry/src/harmony/HIPPluginAllowlist.sol
osx-plugin-foundry/deployed_contracts_harmony.json

# Frontend
aragon-app/src/shared/constants/networkDefinitions.ts
aragon-app/src/**/PrepareProcessDialog*
aragon-app/src/**/harmonyVoting*

# Backend / Indexer
Aragon-app-backend/src/models/schema/proposal.ts
Aragon-app-backend/scripts/backfillHarmony.ts
Aragon-app-backend/scripts/reindexDaoRegistry.ts

# Subgraph
AragonOSX/packages/subgraph/src/**
```

---

## Definition of Done

- [ ] All three plugins install without errors
- [ ] NativeTokenVoting displays correct name (not UNKNOWN)
- [ ] DelegationVoting respects user-provided `processKey`
- [ ] DelegationVoting shows validator address, delegators, token counts
- [ ] DelegationVoting proposals are listed and accessible in UI
- [ ] HIPVoting has documented permission request flow
- [ ] All Setup contracts verified on block explorers
- [ ] E2E tests pass for install → proposal → execution flow
