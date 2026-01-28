# HarmonyVoting Plugin Fixes — Plan Index

**Status:** Ready for Development  
**Created:** 2026-01-28  
**Owner:** mzfshark

---

## Quick Navigation (Distributed across Repos)

### Master Plan (osx-plugin-foundry)

| Document                                                     | Type          | Status | Priority |
| ------------------------------------------------------------ | ------------- | ------ | -------- |
| [PLAN_HARMONYVOTING_FIXES.md](PLAN_HARMONYVOTING_FIXES.md)   | PLAN (Master) | TODO   | URGENT   |
| [SPRINT_001_DIAGNOSIS.md](SPRINT_001_DIAGNOSIS.md)           | SPRINT        | TODO   | HIGH     |
| [SPRINT_002_CONTRACT_FIXES.md](SPRINT_002_CONTRACT_FIXES.md) | SPRINT        | TODO   | HIGH     |

### Reference Documentation

| Document                                             | Description                                                                      |
| ---------------------------------------------------- | -------------------------------------------------------------------------------- |
| [HARMONY_API_REFERENCE.md](HARMONY_API_REFERENCE.md) | Harmony Node API (api.hmny.io) — RPC methods for validators, delegators, staking |

### Frontend Plan (aragon-app)

| Document                                                                                        | Type | Status | Priority |
| ----------------------------------------------------------------------------------------------- | ---- | ------ | -------- |
| [PLAN_HARMONYVOTING_FRONTEND.md](../../../aragon-app/docs/plans/PLAN_HARMONYVOTING_FRONTEND.md) | PLAN | TODO   | HIGH     |

### Backend/Indexer Plan (Aragon-app-backend)

| Document                                                                                              | Type | Status | Priority |
| ----------------------------------------------------------------------------------------------------- | ---- | ------ | -------- |
| [PLAN_HARMONYVOTING_INDEXER.md](../../../Aragon-app-backend/docs/plans/PLAN_HARMONYVOTING_INDEXER.md) | PLAN | TODO   | HIGH     |

### Subgraph Plan (AragonOSX)

| Document                                                                                       | Type | Status | Priority |
| ---------------------------------------------------------------------------------------------- | ---- | ------ | -------- |
| [PLAN_HARMONYVOTING_SUBGRAPH.md](../../../AragonOSX/docs/plans/PLAN_HARMONYVOTING_SUBGRAPH.md) | PLAN | TODO   | HIGH     |

---

## Problem Summary

| #   | Plugin            | Issue                             | Severity | Repo                |
| --- | ----------------- | --------------------------------- | -------- | ------------------- |
| 1   | NativeTokenVoting | Displays as UNKNOWN after install | High     | Contracts + FE      |
| 2   | DelegationVoting  | processKey from form ignored      | High     | Contracts + FE      |
| 3   | DelegationVoting  | Validator address not shown       | High     | Contracts + BE + SG |
| 4   | DelegationVoting  | Delegators/tokens not displayed   | High     | BE + FE             |
| 5   | DelegationVoting  | Proposals not listed in UI        | Critical | BE + SG + FE        |
| 6   | HIPVoting         | Permission flow unclear           | Medium   | Contracts + FE      |

---

## Timeline

```
Week 1 (Jan 28-31): Diagnosis across all repos
Week 2 (Feb 01-07): Contract fixes + Subgraph mappings
Week 3 (Feb 08-15): Backend indexer + Frontend integration + E2E
```

---

## Cross-Repository Coordination

| Repository         | Role                          | Branch      | Plan                                                                                 |
| ------------------ | ----------------------------- | ----------- | ------------------------------------------------------------------------------------ |
| osx-plugin-foundry | Setup contracts, plugin logic | main        | This index                                                                           |
| aragon-app         | Frontend, forms, display      | develop     | [Frontend Plan](../../../aragon-app/docs/plans/PLAN_HARMONYVOTING_FRONTEND.md)       |
| Aragon-app-backend | Indexer, API, persistence     | development | [Indexer Plan](../../../Aragon-app-backend/docs/plans/PLAN_HARMONYVOTING_INDEXER.md) |
| AragonOSX          | Subgraph mappings             | develop     | [Subgraph Plan](../../../AragonOSX/docs/plans/PLAN_HARMONYVOTING_SUBGRAPH.md)        |

---

## Key Files

```
# Contracts
osx-plugin-foundry/src/setup/HarmonyNativeTokenVotingSetup.sol
osx-plugin-foundry/src/setup/HarmonyDelegationVotingSetup.sol
osx-plugin-foundry/src/setup/HarmonyHIPVotingSetup.sol
osx-plugin-foundry/src/harmony/HIPPluginAllowlist.sol

# Frontend
aragon-app/src/shared/constants/networkDefinitions.ts

# Backend
Aragon-app-backend/scripts/backfillHarmony.ts

# Subgraph
AragonOSX/packages/subgraph/src/**
```

---

## How to Start

1. **Read** [PLAN_HARMONYVOTING_FIXES.md](PLAN_HARMONYVOTING_FIXES.md) for full context
2. **Begin** with [SPRINT_001_DIAGNOSIS.md](SPRINT_001_DIAGNOSIS.md) tasks
3. **Track** progress by checking off tasks in each sprint document
4. **Sync** to GitHub Issues using GitIssue-Manager (optional)

---

## Commands Reference

```bash
# Frontend
cd aragon-app && pnpm dev

# Backend
cd Aragon-app-backend && pnpm run service:aragon-api

# Contracts
cd osx-plugin-foundry && make test

# Subgraph
cd AragonOSX/packages/subgraph && yarn codegen && yarn build
```
