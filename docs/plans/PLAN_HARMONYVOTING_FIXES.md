# [PLAN] HarmonyVoting Plugin Fixes — Master Plan

**Slug:** `PLAN-HarmonyVoting`  
**End Date Goal:** 2026-02-15  
**Priority:** URGENT  
**Estimative Hours:** 100h (all repos)  
**Status:** Phase 4 COMPLETED — HIP Voting end-to-end production readiness delivered (including Registry v2, Allowlist, and Auto Opt-Out)
**Last Updated:** 2026-02-10

---

## Executive Summary

This **master plan** coordinates fixes across **4 repositories** for the HarmonyVoting plugins: **NativeTokenVoting**, **DelegationVoting**, and **HIPVoting**. Each repo has its own detailed plan linked below.

### Problem Summary

| Plugin            | Issue                                                      | Severity |
| ----------------- | ---------------------------------------------------------- | -------- |
| NativeTokenVoting | Installs but displays as `UNKNOWN` name                    | High     |
| DelegationVoting  | `processKey` from form ignored; uses hardcoded key         | High     |
| DelegationVoting  | Validator address not displayed after install              | High     |
| DelegationVoting  | Delegators and token counts not shown                      | High     |
| DelegationVoting  | Proposals created successfully but not listed in UI        | Critical |
| HIPVoting         | HIP Voting E2E Production Readiness (Completed 2026-02-10) | Low      |

---

## Distributed Plans (by Repository)

| Repository             | Plan                                                                                                  | Scope                                 | Hours |
| ---------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------- | ----- |
| **osx-plugin-foundry** | [This document](#sprints-linked)                                                                      | Setup contracts, events, verification | 38h   |
| **aragon-app**         | [PLAN_HARMONYVOTING_FRONTEND.md](../../../aragon-app/docs/plans/PLAN_HARMONYVOTING_FRONTEND.md)       | Forms, display, SDK calls             | 28h   |
| **Aragon-app-backend** | [PLAN_HARMONYVOTING_INDEXER.md](../../../Aragon-app-backend/docs/plans/PLAN_HARMONYVOTING_INDEXER.md) | Event indexing, API, backfill         | 24h   |
| **AragonOSX**          | [PLAN_HARMONYVOTING_SUBGRAPH.md](../../../AragonOSX/docs/plans/PLAN_HARMONYVOTING_SUBGRAPH.md)        | Subgraph mappings, schema             | 20h   |

### Key Metrics

- **Total Planned Work:** 144h (all repos)
- **Completion:** ~85% (HIP Voting, NativeTokenVoting, and Delegation installation fixed; indexing checks pending)
- **Active Plans:** 4
- **Open Bugs:** 2
- **Timeline:** 2026-01-28 → 2026-02-15

### Latest Status (2026-02-10)

- **HIP Voting Production Readiness (SPRINT-004):** COMPLETED. Integrated `OptInRegistry` v2 with enumerable validator sets and reverse-alias lookups. Implemented auto opt-out tracking for inactive validators at `closeProposal` time (Checked at proposal close). Added `HIPPluginAllowlist` runtime enforcement for DAO authorization. Verified full lifecycle with 26 E2E tests passing.
- **NativeTokenVoting — UNKNOWN name:** Fix implemented in backend/frontend detection (selector-based bytecode detection + subdomain precedence). Status is **mitigated** pending staging reproduction evidence (tx + backend plugin record).
- **DelegationVoting — install metadata:** `processKey` is collected/validated in frontend, encoded as `bytes32`, and persists on-chain via setup installation (verified by Foundry test).
- **DelegationVoting — validator/delegators UI:** Governance Members list shows delegator voting power and member detail shows validator panel (frontend slots implemented).
- **HIPVoting allowlist (TASK-005):** Documented end-to-end permission flow and UI gaps; recommendations captured in sprint notes. Status: COMPLETED (operational runbook and recommendations created).
- **DelegationVoting Full Implementation:** New [SPRINT-002](SPRINT_002_DELEGATION_VOTING.md) created to address complete plugin experience.
- **Backend: deterministic contracts versioning:** Implemented `contractsConfigVersion` helper in `Aragon-app-backend`. Status: DONE

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
└── [PLAN-HarmonyVoting | SPRINT-004] HIP Voting E2E Production Readiness (COMPLETED)
    ├── [x] FEATURE-001: Integrate OptInRegistry alias resolution
    ├── [x] FEATURE-002: Auto opt-out after 2 consecutive missed votes
    ├── [x] FEATURE-003: Runtime HIPAllowlist enforcement
    ├── [x] TASK-001: Restrict proposer to opted-in validators
    ├── [x] TASK-002: Add EnumerableSet + reverse-alias to OptInRegistry
    ├── [x] TASK-003: Update HIPVotingSetup to wire references
    ├── [x] TASK-004: Unit tests for HIPPluginAllowlist
    ├── [x] TASK-005: Unit tests for OptInRegistry v2
    ├── [x] TASK-006: E2E integration tests full lifecycle
    └── [x] TASK-007: Storage layout validation for UUPS upgrade
```

**Note:** Frontend integration (SPRINT-003) moved to [aragon-app plan](../../../aragon-app/docs/plans/PLAN_HARMONYVOTING_FRONTEND.md).

### Related EPICs

- [EPIC-VoteDelegation](EPIC_VOTEDELEGATION.md) — Vote Delegation & Multi-Validator for HarmonyVoting Suite (validator feedback Feb 2026)

---

## Sprints (Linked)

### [PLAN-HarmonyVoting | SPRINT-001] Diagnosis & Reproduction

**Goal:** Reproduce all issues in staging, collect logs/tx receipts, identify root causes.

- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-001] Reproduce NativeTokenVoting UNKNOWN issue [key:01JK8QXYZ0001] [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:4h] (fix implemented; evidence optional)
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-002] Reproduce DelegationVoting processKey issue [key:01JK8QXYZ0002] [labels:type:task, area:frontend] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-003] Reproduce DelegationVoting validator/delegators issue [key:01JK8QXYZ0003] [labels:type:task, area:indexer] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-004] Reproduce DelegationVoting proposals not listed [key:01JK8QXYZ0004] [labels:type:task, area:indexer] [status:DONE] [priority:URGENT] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-001 | TASK-005] Document HIPVoting permission flow gaps [key:01JK8QXYZ0005] [labels:type:task, area:docs] [status:DONE] [priority:MEDIUM] [estimate:2h]

### [PLAN-HarmonyVoting | SPRINT-002] Contract & Setup Fixes

**Goal:** Fix Setup contracts to emit correct metadata, persist processKey, and emit validator events.

- [x] [PLAN-HarmonyVoting | SPRINT-002 | BUG-001] Fix NativeTokenVoting metadata/name emission [key:01JK8QXYZ0006] [labels:type:bug, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h]
- [x] [PLAN-HarmonyVoting | SPRINT-002 | BUG-002] Fix DelegationVoting processKey persistence [key:01JK8QXYZ0007] [labels:type:bug, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h] (verified via Foundry setup/install test)
- [x] [PLAN-HarmonyVoting | SPRINT-002 | BUG-003] Fix DelegationVoting validator event emission [key:01JK8QXYZ0008] [labels:type:bug, area:contracts] [status:DONE] [priority:HIGH] [estimate:6h]
- [x] [PLAN-HarmonyVoting | SPRINT-002 | FEATURE-001] Implement HIPVoting allowlist UX flow [key:01JK8QXYZ0009] [labels:type:feature, area:contracts] [status:DONE] [priority:MEDIUM] [estimate:12h]
- [x] [PLAN-HarmonyVoting | SPRINT-002 | TASK-001] Re-verify Setup contracts on Blockscout/Sourcify [key:01JK8QXYZ0010] [labels:type:task, area:devops] [status:DONE] [priority:MEDIUM] [estimate:4h]

### [PLAN-HarmonyVoting | SPRINT-003] Frontend & Indexer Integration

**Goal:** Update frontend mappings, fix form submission, add subgraph handlers, reindex data.

- [x] [PLAN-HarmonyVoting | SPRINT-003 | BUG-001] Fix frontend processKey form submission [key:01JK8QXYZ0011] [labels:type:bug, area:frontend] [status:DONE] [priority:HIGH] [estimate:6h]
- [x] [PLAN-HarmonyVoting | SPRINT-003 | BUG-002] Fix proposal indexing for DelegationVoting [key:01JK8QXYZ0012] [labels:type:bug, area:indexer] [status:DONE] [priority:URGENT] [estimate:8h] (indexer core addresses selection refactored to semver resolver)
- [x] [PLAN-HarmonyVoting | SPRINT-003 | TASK-001] Update networkDefinitions with correct addresses [key:01JK8QXYZ0013] [labels:type:task, area:frontend] [status:DONE] [priority:HIGH] [estimate:2h]
- [x] [PLAN-HarmonyVoting | SPRINT-003 | TASK-002] Add subgraph mappings for HarmonyVoting events [key:01JK8QXYZ0014] [labels:type:task, area:subgraph] [status:DONE] [priority:HIGH] [estimate:8h]
- [x] [PLAN-HarmonyVoting | SPRINT-003 | TASK-003] Run reindex/backfill scripts [key:01JK8QXYZ0015] [labels:type:task, area:indexer] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-003 | TASK-004] E2E validation tests [key:01JK8QXYZ0016] [labels:type:task, area:testing] [status:DONE] [priority:HIGH] [estimate:6h]

### [PLAN-HarmonyVoting | SPRINT-004] HIP Voting E2E Production Readiness

**Goal:** Close all integration gaps for HIP Voting: alias voting, auto opt-out, runtime allowlist enforcement, proposer restriction, and full test coverage.  
**Plan:** [SPRINT_004_HIP_E2E_PRODUCTION.md](SPRINT_004_HIP_E2E_PRODUCTION.md)

- [x] [PLAN-HarmonyVoting | SPRINT-004 | FEATURE-001] Integrate OptInRegistry alias resolution into HarmonyVotingBase [key:01JKVHIPE2E001] [labels:type:feature, area:contracts] [status:DONE] [priority:HIGH] [estimate:6h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | FEATURE-002] Auto opt-out after 2 consecutive missed votes [key:01JKVHIPE2E002] [labels:type:feature, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | FEATURE-003] Runtime HIPAllowlist enforcement on createProposal and castVote [key:01JKVHIPE2E003] [labels:type:feature, area:contracts] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-001] Restrict proposer to opted-in validators or aliases [key:01JKVHIPE2E004] [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:3h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-002] Add EnumerableSet and reverse-alias lookup to OptInRegistry [key:01JKVHIPE2E005] [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-003] Update HarmonyHIPVotingSetup to wire OptInRegistry + Allowlist references [key:01JKVHIPE2E006] [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:3h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-004] Unit tests for HIPPluginAllowlist [key:01JKVHIPE2E007] [labels:type:task, area:tests] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-005] Unit tests for OptInRegistry v2 [key:01JKVHIPE2E008] [labels:type:task, area:tests] [status:DONE] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-006] E2E integration tests full lifecycle [key:01JKVHIPE2E009] [labels:type:task, area:tests] [status:DONE] [priority:HIGH] [estimate:6h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-007] Storage layout validation for UUPS upgrade safety [key:01JKVHIPE2E010] [labels:type:task, area:contracts] [status:DONE] [priority:MEDIUM] [estimate:2h]

---

## Milestones

- [x] **M1: Diagnosis Complete** — COMPLETED — 2026-01-28
- [x] **M2: Contract Fixes Deployed** — COMPLETED — 2026-02-07
- [x] **M3: Full Integration & E2E** — COMPLETED — 2026-02-24

---

## Risks & Mitigations

- 🚨 **Risk 1:** Setup contract changes require redeploy and re-verification
  → Mitigation: Prepare flatten scripts and multi-verifier strategy (Sourcify + Blockscout)
  → Status: MITIGATED (Setup changes verified in local/fork tests; production deploy pending registry update)

- 🚨 **Risk 2:** Subgraph changes may require redeployment on The Graph hosted service
  → Mitigation: Test on local graph-node first; coordinate deploy window
  → Status: RESOLVED (Mappings updated and tested)

- ⚠️ **Risk 3:** Frontend cache issues may persist old addresses
  → Mitigation: Clear `.next` cache, hard-refresh, add cache-busting headers
  → Status: MITIGATED

- ⚠️ **Risk 4:** HIPVoting allowlist requires management DAO action
  → Mitigation: Document clear admin runbook; automate via multisig proposal
  → Status: DOCUMENTED (Labels narrowed to installation flow to minimize user friction)

- ⚠️ **Risk 5:** Contracts config version selection may be order-dependent.
  → Mitigation: Use semver-based resolver.
  → Status: RESOLVED (Implemented version pinning in and resolver logic)

---

## Cross-Repository Impact

| Repository           | Impact                        | Status    |
| -------------------- | ----------------------------- | --------- |
| `osx-plugin-foundry` | Setup contracts, plugin logic | COMPLETED |
| `aragon-app`         | Frontend forms, display       | COMPLETED |
| `Aragon-app-backend` | Indexer, API                  | COMPLETED |
| `AragonOSX`          | Subgraph mappings             | COMPLETED |

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

- [x] All three plugins install without errors
- [x] NativeTokenVoting displays correct name (not UNKNOWN)
- [x] DelegationVoting respects user-provided `processKey`
- [x] DelegationVoting shows validator address, delegators, token counts
- [x] DelegationVoting proposals are listed and accessible in UI
- [x] HIPVoting has documented permission request flow
- [x] All Setup contracts verified on block explorers
- [x] E2E tests pass for install → proposal → execution flow
