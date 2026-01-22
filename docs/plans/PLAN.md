# #PLAN-004 - HarmonyDelegation Plugin Execution Plan

**Repository:** osx-plugin-foundry (Axodus/osx-plugin-foundry)  
**End Date Goal:** 2026-02-28  
**Priority:** HIGH  
**Estimative Hours:** 120h  
**Status:** in progress

---

## Executive Summary

Implement and ship HarmonyDelegation voting strategy with validator-based delegation weights. The plugin uses off-chain Harmony API for delegator stake resolution, with final on-chain write occurring only after vote end using snapshot epoch `endEpoch - 2`.

### Key Metrics

- **Total Planned Work:** 120h
- **Completion:** 70% (specifications, contracts, deployment done; integration and testing pending)
- **Active Features:** 4 (Specs, Contracts, Deployment, Testing)
- **Open Bugs:** 1 (Blockscout verification)
- **Timeline:** 2026-01-10 → 2026-02-28

### Requirements Summary

- **Installation:** DAO admin installs governance using `HarmonyDelegation` strategy with `validatorAddress` during setup.
- **Weight source:** Off-chain fetch of delegators + stake via Harmony API at https://api.harmony.one
- **Token:** Native token stake (address `0x0000000000000000000000000000000000000000`)
- **Voting:** Intermediate snapshots read-only; on-chain write only after `endDate`

### Deployment Output (2026-01-16)

| Contract         | Address                                      |
| ---------------- | -------------------------------------------- |
| Allowlist Proxy  | `0x3653c14Ca7bef3E7B02ca04E65f6fc174D48c5C0` |
| HIP Setup        | `0x8D151e5021F495e23FbBC3180b4EeA1a6B251Fd0` |
| HIP Repo         | `0x377Fa6d56066b81a7233043302B7e1569591253E` |
| Delegation Setup | `0xD872C4333CF09e3794DD8e8e8d4E09C0124E830D` |
| Delegation Repo  | `0x908a794F6e59872cB9b5Da0465a667833eEBdcFD` |
| Opt-In Registry  | `0x1E1F6128f1e611c6bD9696a758aF9310017C993B` |

---

## Subtasks (Linked)

### FEATURE-001: Specifications & Design

[labels:type:feature, area:contracts, area:docs] [status:DONE] [priority:HIGH] [estimate:16h] [start:2026-01-10] [end:2026-01-14]

- [x] Confirm `validatorAddress` parameter in `HarmonyDelegationSetup` [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:4h] [start:2026-01-10] [end:2026-01-11]
- [x] Define off-chain weight resolution schema (delegator → stake) [labels:type:task, area:docs, area:backend] [status:DONE] [priority:HIGH] [estimate:4h] [start:2026-01-11] [end:2026-01-12]
- [x] Confirm intermediate snapshots exposed to UI (read-only) [labels:type:task, area:docs, area:frontend] [status:DONE] [priority:HIGH] [estimate:4h] [start:2026-01-12] [end:2026-01-13]
- [x] Lock final snapshot rule to match backend logic (`endEpoch - 2`) [labels:type:task, area:contracts, area:backend] [status:DONE] [priority:HIGH] [estimate:4h] [start:2026-01-13] [end:2026-01-14]

### FEATURE-002: Contract Implementation

[labels:type:feature, area:contracts] [status:DONE] [priority:HIGH] [estimate:24h] [start:2026-01-14] [end:2026-01-16]

- [x] Verify/implement `HarmonyDelegation` plugin contract in `src/harmony/` [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h] [start:2026-01-14] [end:2026-01-15]
- [x] Verify/implement setup contract with `validatorAddress` install param [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h] [start:2026-01-15] [end:2026-01-15]
- [x] Ensure native token usage is explicit and documented [labels:type:task, area:contracts, area:docs] [status:DONE] [priority:MEDIUM] [estimate:8h] [start:2026-01-15] [end:2026-01-16]

### FEATURE-003: Deployment & Verification

[labels:type:feature, area:contracts, area:ops] [status:IN_PROGRESS] [priority:HIGH] [estimate:16h] [start:2026-01-16] [end:2026-01-20]

- [x] Update/confirm deploy script (`DeployHarmonyVotingRepos.s.sol`) [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:4h] [start:2026-01-16] [end:2026-01-16]
- [x] Deploy to Harmony mainnet [labels:type:task, area:contracts, area:ops] [status:DONE] [priority:HIGH] [estimate:4h] [start:2026-01-16] [end:2026-01-16]
- [x] Update `deployed_contracts_harmony.json` [labels:type:task, area:contracts] [status:DONE] [priority:HIGH] [estimate:2h] [start:2026-01-16] [end:2026-01-16]
- [ ] Resolve manual verification for setup contracts (Blockscout/Sourcify) [labels:type:task, area:contracts, area:ops] [status:TODO] [priority:MEDIUM] [estimate:4h] [start:2026-01-17] [end:2026-01-18]
- [ ] Reconcile verification status inconsistencies [labels:type:task, area:docs] [status:TODO] [priority:LOW] [estimate:2h] [start:2026-01-19] [end:2026-01-20]

### FEATURE-004: Integration & UX

[labels:type:feature, area:frontend, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:16h] [start:2026-01-21] [end:2026-01-25]

- [ ] Ensure frontend recognizes correct plugin repo addresses [labels:type:task, area:frontend] [status:TODO] [priority:HIGH] [estimate:6h] [start:2026-01-21] [end:2026-01-22]
- [ ] Add/update installation guidance and troubleshooting notes [labels:type:docs, area:frontend] [status:TODO] [priority:MEDIUM] [estimate:4h] [start:2026-01-23] [end:2026-01-24]
- [ ] Validate install flow with correct `validatorAddress` input [labels:type:qa, area:frontend] [status:TODO] [priority:HIGH] [estimate:6h] [start:2026-01-24] [end:2026-01-25]

### FEATURE-005: Testing & Validation

[labels:type:feature, area:qa, area:contracts] [status:DONE] [priority:HIGH] [estimate:24h] [start:2026-01-18] [end:2026-01-22]

- [x] Add/update tests for installation params and voting lifecycle [labels:type:test, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h] [start:2026-01-18] [end:2026-01-19]
- [x] Validate snapshot calculation on Harmony mainnet or fork [labels:type:qa, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h] [start:2026-01-19] [end:2026-01-20]
- [x] Confirm on-chain write happens only after `endDate` [labels:type:qa, area:contracts] [status:DONE] [priority:HIGH] [estimate:8h] [start:2026-01-20] [end:2026-01-22]

### FEATURE-006: Documentation

[labels:type:feature, area:docs] [status:DONE] [priority:MEDIUM] [estimate:8h] [start:2026-01-22] [end:2026-01-24]

- [x] Update `DEPLOY_GUIDE.md` with HarmonyDelegation specifics [labels:type:docs] [status:DONE] [priority:MEDIUM] [estimate:3h] [start:2026-01-22] [end:2026-01-22]
- [x] Update `DELEGATION_INSTALL_ERROR.md` with current resolution paths [labels:type:docs] [status:DONE] [priority:MEDIUM] [estimate:2h] [start:2026-01-23] [end:2026-01-23]
- [x] Add FAQ about snapshot timing and weight resolution [labels:type:docs] [status:DONE] [priority:LOW] [estimate:3h] [start:2026-01-23] [end:2026-01-24]

### EPIC-001: E2E Reliability

[labels:type:epic, area:contracts, area:backend] [status:TODO] [priority:HIGH] [estimate:48h] [start:2026-02-01] [end:2026-02-28]

**Uninstall Reliability:**

- [ ] Define uninstall invariants (no orphan permissions, no stuck executors) [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h] [start:2026-02-01] [end:2026-02-03]
- [ ] Verify uninstall path revokes all granted permissions [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h] [start:2026-02-03] [end:2026-02-05]
- [ ] Ensure uninstall works via governance permissions (not just admin) [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h] [start:2026-02-05] [end:2026-02-07]
- [ ] Add tests for install → uninstall → re-install cycles [labels:type:test, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:6h] [start:2026-02-07] [end:2026-02-10]
- [ ] Document uninstall requirements and expected behavior [labels:type:docs, area:contracts] [status:TODO] [priority:LOW] [estimate:2h] [start:2026-02-10] [end:2026-02-11]

**Event Completeness for Indexing:**

- [ ] Verify all critical events emitted (install, uninstall, proposal lifecycle) [labels:type:task, area:contracts, area:indexing] [status:TODO] [priority:HIGH] [estimate:4h] [start:2026-02-12] [end:2026-02-13]
- [ ] Ensure events include all data needed by indexers [labels:type:task, area:contracts, area:backend] [status:TODO] [priority:HIGH] [estimate:4h] [start:2026-02-13] [end:2026-02-14]
- [ ] Add creator/executor addresses to events where missing [labels:type:task, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:4h] [start:2026-02-14] [end:2026-02-15]
- [ ] Document event schemas for backend/subgraph teams [labels:type:docs, area:contracts] [status:TODO] [priority:LOW] [estimate:2h] [start:2026-02-15] [end:2026-02-16]

**Native Token Voting Support:**

- [ ] Implement RPC-based power provider for native token [labels:type:task, area:backend] [status:TODO] [priority:HIGH] [estimate:8h] [start:2026-02-17] [end:2026-02-20]
- [ ] Add support for DAO action execution in voting contracts [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h] [start:2026-02-20] [end:2026-02-22]
- [ ] Validate permission model for native token execution [labels:type:qa, area:contracts, area:security] [status:TODO] [priority:HIGH] [estimate:4h] [start:2026-02-22] [end:2026-02-24]
- [ ] Add tests for native token value transfer execution [labels:type:test, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:4h] [start:2026-02-24] [end:2026-02-26]
- [ ] Document native token voting setup and execution flow [labels:type:docs] [status:TODO] [priority:LOW] [estimate:2h] [start:2026-02-26] [end:2026-02-28]

---

## Milestones

- **Milestone 1:** Specifications & Design — 2026-01-10 → 2026-01-14 — ✅ DONE
- **Milestone 2:** Contract Implementation — 2026-01-14 → 2026-01-16 — ✅ DONE
- **Milestone 3:** Deployment & Verification — 2026-01-16 → 2026-01-20 — 🔄 80%
- **Milestone 4:** Integration & UX — 2026-01-21 → 2026-01-25 — ⬜ 0%
- **Milestone 5:** Testing & Validation — 2026-01-18 → 2026-01-22 — ✅ DONE
- **Milestone 6:** Documentation — 2026-01-22 → 2026-01-24 — ✅ DONE
- **Milestone 7:** E2E Reliability (Epic) — 2026-02-01 → 2026-02-28 — ⬜ 0%
- **Production Go-Live:** 2026-02-28

---

## Notes

### Snapshot Validation Result (Harmony mainnet)

| Parameter                | Value                                        |
| ------------------------ | -------------------------------------------- |
| Validator                | `0x3cb9F2120Ad5F5E1d58088b261053B62CaC0cdE8` |
| endDate (unix)           | `1768570403`                                 |
| endBlock                 | `83810922`                                   |
| endEpoch                 | `2730`                                       |
| snapshotEpoch            | `2728`                                       |
| snapshotBlock            | `83755007`                                   |
| snapshotTimestamp (unix) | `1768457992`                                 |
| delegationsCount         | `1747`                                       |
| totalDelegated (wei)     | `33958666148397424876964771`                 |

### Off-chain Weight Resolution Schema

- **Source:** Harmony RPC `hmyv2_getValidatorInformationByBlockNumber` on https://api.harmony.one
- **Input:** `validatorAddress` (installation param) + `snapshotBlock` (derived from `endDate`)
- **Output:** list of delegations under `validator.delegations`
- **Mapping:** `delegator_address` → `address`, `amount` → `votingPower`

### Verification Note

Blockscout verification failed with: `eth_feeHistory` not available on RPC. Use `--legacy` or manual Blockscout/Sourcify verification for setup contracts.

### Cross-Repo Plans

- [AragonOSX PLAN](../../../AragonOSX/docs/plans/PLAN.md) — E2E reliability epic
- [aragon-app PLAN](../../../aragon-app/docs/plans/PLAN.md) — UI/UX updates
- [Aragon-app-backend PLAN](../../../Aragon-app-backend/docs/plans/PLAN.md) — Backend indexing

---

**Version:** 2.0  
**Last Updated:** 2026-01-21  
**Template:** [PLAN.md](https://gist.github.com/mzfshark/2ab8856d6c0efc0dfa9d1f98d2a23fdf)
