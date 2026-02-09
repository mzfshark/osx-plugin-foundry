# [EPIC] Vote Delegation & Multi-Validator for HarmonyVoting Suite

**Repository:** osx-plugin-foundry (mzfshark/osx-plugin-foundry) + aragon-app + Aragon-app-backend  
**Slug:** `EPIC-VoteDelegation`  
**End Date Goal:** 2026-03-08  
**Priority:** HIGH  
**Estimative Hours:** 56h  
**Status:** Backlog

---

## Executive Summary

This epic introduces **vote delegation** (wallet-to-wallet) and **multi-validator voting power aggregation** across the three HarmonyVoting plugins (`HarmonyDelegationVotingPlugin`, `HarmonyHIPVotingPlugin`, and `HarmonyVotingBase`).

### Origin

Feedback from active Harmony validator (EasyNodePRO):

> "As harmony validators cannot change their wallets ever, it would make sense to allow the actual wallet to authorize another validator (or wallet) to vote for them."
>
> "I believe it would be fine and good to add a 'wallet delegation' option to allow another validator to use your voting power."

### Core Features

1. **Vote delegation (on-chain)** — Any voter can delegate their vote to another address (1-to-1, ERC20Votes-style). Once delegated, only the delegatee may cast the vote using the delegator's power. The delegator **cannot** override; they must revoke delegation first.
2. **Multi-validator power aggregation (off-chain MVP → on-chain v2)** — A DAO may reference multiple validator addresses. The oracle/backend builds the Merkle tree by taking the **union** of all delegators and **summing** amounts per delegator address across validators. Phase 1 is off-chain (oracle + DB config). Phase 2 optionally moves the validator list on-chain.

### Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Override after delegation | **No** — delegator cannot vote while delegation is active | Keeps model simple and predictable; ERC20Votes parity |
| Delegation cardinality | **1-to-1** (one delegator → one delegatee) | Simplicity, auditability, ERC20Votes parity |
| Multi-validator storage (Phase 1) | **Off-chain** (backend config + oracle) | No UUPS upgrade needed; faster to ship |
| Multi-validator storage (Phase 2) | **On-chain** (`validatorAddresses[]` in plugin) | Full transparency; requires plugin upgrade |
| Power aggregation unit | **Per delegator address** | A delegator staking to 2 validators gets sum of both amounts |
| Affected plugins | All 3 (HarmonyVotingBase → inherited by HIP + Delegation) | Single change in base contract propagates |

### Success Criteria

- [ ] A voter can call `setVotingDelegate(delegatee)` and `clearVotingDelegate()` on any HarmonyVoting plugin
- [ ] When casting a vote, the contract checks `msg.sender == voter || msg.sender == votingDelegate[voter]`
- [ ] A delegatee calling `castVote` or `castVoteFor(delegator, ...)` records the vote under the delegator's address
- [ ] Vote power submission (Merkle proof) still references the delegator leaf, preventing double-counting
- [ ] Backend `/v2/members` response includes `delegatedTo` field when delegation is active
- [ ] Frontend displays delegation status and allows delegate/undelegate actions
- [ ] Oracle supports multi-validator config: builds Merkle tree from N validators, summing power per delegator
- [ ] Backend `/v2/members` correctly aggregates voting power from multiple validators when configured

---

## Hierarchy Overview

```
[EPIC] Vote Delegation & Multi-Validator for HarmonyVoting Suite (this document - PAI)
├── [EPIC-VoteDelegation | SPRINT-001] On-Chain Vote Delegation
│   ├── [EPIC-VoteDelegation | SPRINT-001 | TASK-001] Add delegation storage + events to HarmonyVotingBase
│   ├── [EPIC-VoteDelegation | SPRINT-001 | TASK-002] Modify castVote to support delegatee caller
│   ├── [EPIC-VoteDelegation | SPRINT-001 | TASK-003] Write Foundry tests for delegation flows
│   ├── [EPIC-VoteDelegation | SPRINT-001 | TASK-004] Backend: index DelegationSet/DelegationCleared events
│   ├── [EPIC-VoteDelegation | SPRINT-001 | TASK-005] Backend: expose delegatedTo in /v2/members response
│   ├── [EPIC-VoteDelegation | SPRINT-001 | FEATURE-001] Frontend: delegate/undelegate UI in member detail
│   └── [EPIC-VoteDelegation | SPRINT-001 | FEATURE-002] Frontend: show delegation badge on members list
├── [EPIC-VoteDelegation | SPRINT-002] Multi-Validator Off-Chain MVP
│   ├── [EPIC-VoteDelegation | SPRINT-002 | TASK-001] Backend: ValidatorConfig supports multiple validators per plugin
│   ├── [EPIC-VoteDelegation | SPRINT-002 | TASK-002] Oracle: aggregate delegations from N validators into Merkle tree
│   ├── [EPIC-VoteDelegation | SPRINT-002 | TASK-003] Backend: /v2/members merges power from multi-validator
│   ├── [EPIC-VoteDelegation | SPRINT-002 | FEATURE-001] Frontend: multi-validator setup in Create DAO flow
│   └── [EPIC-VoteDelegation | SPRINT-002 | FEATURE-002] Frontend: show validator breakdown in member detail
└── [EPIC-VoteDelegation | SPRINT-003] Multi-Validator On-Chain (Optional v2)
    ├── [EPIC-VoteDelegation | SPRINT-003 | TASK-001] Evolve DelegationVotingPlugin storage: validatorAddresses[]
    ├── [EPIC-VoteDelegation | SPRINT-003 | TASK-002] Update Setup contract for array param + upgrade path
    └── [EPIC-VoteDelegation | SPRINT-003 | TASK-003] Foundry tests for multi-validator on-chain
```

---

## Sprints (Linked)

### [EPIC-VoteDelegation | SPRINT-001] On-Chain Vote Delegation

**Duration:** 2 weeks (2026-02-10 → 2026-02-23)  
**Estimate:** 28h  
**Priority:** HIGH

- [ ] [EPIC-VoteDelegation | SPRINT-001 | TASK-001] Add delegation storage + events to HarmonyVotingBase [key:01JKN1GQXR0000000000000001] [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]
- [ ] [EPIC-VoteDelegation | SPRINT-001 | TASK-002] Modify castVote to support delegatee caller [key:01JKN1GQXR0000000000000002] [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:4h]
- [ ] [EPIC-VoteDelegation | SPRINT-001 | TASK-003] Write Foundry tests for delegation flows [key:01JKN1GQXR0000000000000003] [labels:type:task, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h]
- [ ] [EPIC-VoteDelegation | SPRINT-001 | TASK-004] Backend: index DelegationSet/DelegationCleared events [key:01JKN1GQXR0000000000000004] [labels:type:task, area:backend] [status:TODO] [priority:MEDIUM] [estimate:4h]
- [ ] [EPIC-VoteDelegation | SPRINT-001 | TASK-005] Backend: expose delegatedTo in /v2/members response [key:01JKN1GQXR0000000000000005] [labels:type:task, area:backend] [status:TODO] [priority:MEDIUM] [estimate:2h]
- [ ] [EPIC-VoteDelegation | SPRINT-001 | FEATURE-001] Frontend: delegate/undelegate UI in member detail [key:01JKN1GQXR0000000000000006] [labels:type:feature, area:frontend] [status:TODO] [priority:MEDIUM] [estimate:4h]
- [ ] [EPIC-VoteDelegation | SPRINT-001 | FEATURE-002] Frontend: show delegation badge on members list [key:01JKN1GQXR0000000000000007] [labels:type:feature, area:frontend] [status:TODO] [priority:LOW] [estimate:4h]

### [EPIC-VoteDelegation | SPRINT-002] Multi-Validator Off-Chain MVP

**Duration:** 2 weeks (2026-02-24 → 2026-03-08)  
**Estimate:** 20h  
**Priority:** MEDIUM

- [ ] [EPIC-VoteDelegation | SPRINT-002 | TASK-001] Backend: ValidatorConfig supports multiple validators per plugin [key:01JKN1GQXR0000000000000008] [labels:type:task, area:backend] [status:TODO] [priority:HIGH] [estimate:4h]
- [ ] [EPIC-VoteDelegation | SPRINT-002 | TASK-002] Oracle: aggregate delegations from N validators into Merkle tree [key:01JKN1GQXR0000000000000009] [labels:type:task, area:backend] [status:TODO] [priority:HIGH] [estimate:6h]
- [ ] [EPIC-VoteDelegation | SPRINT-002 | TASK-003] Backend: /v2/members merges power from multi-validator [key:01JKN1GQXR000000000000000A] [labels:type:task, area:backend] [status:TODO] [priority:MEDIUM] [estimate:3h]
- [ ] [EPIC-VoteDelegation | SPRINT-002 | FEATURE-001] Frontend: multi-validator setup in Create DAO flow [key:01JKN1GQXR000000000000000B] [labels:type:feature, area:frontend] [status:TODO] [priority:MEDIUM] [estimate:4h]
- [ ] [EPIC-VoteDelegation | SPRINT-002 | FEATURE-002] Frontend: show validator breakdown in member detail [key:01JKN1GQXR000000000000000C] [labels:type:feature, area:frontend] [status:TODO] [priority:LOW] [estimate:3h]

### [EPIC-VoteDelegation | SPRINT-003] Multi-Validator On-Chain (Optional v2)

**Duration:** TBD (after SPRINT-002 validation)  
**Estimate:** 8h  
**Priority:** LOW

- [ ] [EPIC-VoteDelegation | SPRINT-003 | TASK-001] Evolve DelegationVotingPlugin storage: validatorAddresses[] [key:01JKN1GQXR000000000000000D] [labels:type:task, area:contracts] [status:TODO] [priority:LOW] [estimate:3h]
- [ ] [EPIC-VoteDelegation | SPRINT-003 | TASK-002] Update Setup contract for array param + upgrade path [key:01JKN1GQXR000000000000000E] [labels:type:task, area:contracts] [status:TODO] [priority:LOW] [estimate:3h]
- [ ] [EPIC-VoteDelegation | SPRINT-003 | TASK-003] Foundry tests for multi-validator on-chain [key:01JKN1GQXR000000000000000F] [labels:type:task, area:contracts] [status:TODO] [priority:LOW] [estimate:2h]

---

## Technical Design

### SPRINT-001: On-Chain Vote Delegation

#### Contract Changes (HarmonyVotingBase.sol)

```
New storage (appended before __gap):
  mapping(address => address) public votingDelegate;      // delegator → delegatee
  mapping(address => address) public delegatedFrom;        // delegatee → delegator (reverse lookup, 1:1)

New events:
  event VotingDelegationSet(address indexed delegator, address indexed delegatee);
  event VotingDelegationCleared(address indexed delegator, address indexed previousDelegatee);

New functions:
  function setVotingDelegate(address delegatee) external
    - Requires: delegatee != address(0), delegatee != msg.sender
    - Requires: delegatedFrom[delegatee] == address(0) (delegatee not already used by someone else)
    - If msg.sender already has a delegate, clear old reverse mapping first
    - Sets votingDelegate[msg.sender] = delegatee
    - Sets delegatedFrom[delegatee] = msg.sender
    - Emits VotingDelegationSet(msg.sender, delegatee)

  function clearVotingDelegate() external
    - Requires: votingDelegate[msg.sender] != address(0)
    - Clears delegatedFrom[old delegatee]
    - Clears votingDelegate[msg.sender]
    - Emits VotingDelegationCleared(msg.sender, old delegatee)

Modified function — castVote:
  function castVote(uint256 _proposalId, VoteOption _option) external
    → becomes:
  function castVote(uint256 _proposalId, VoteOption _option) public  // make public for castVoteFor

  function castVoteFor(uint256 _proposalId, address _delegator, VoteOption _option) external
    - Requires: votingDelegate[_delegator] == msg.sender (caller must be the delegatee)
    - Records vote under _delegator address (not msg.sender)
    - Same constraints: proposal open, not already voted, etc.

  // Original castVote becomes a self-delegator shortcut:
  function castVote(uint256 _proposalId, VoteOption _option) public
    - Requires: votingDelegate[msg.sender] == address(0) (caller has NOT delegated to someone else)
    - Records vote as before (under msg.sender)
```

#### Storage Layout Safety

Current `__gap` in `HarmonyVotingBase` has no explicit size (storage is in individual vars + mappings).
`HarmonyDelegationVotingPlugin` has `uint256[47] private __gap`.
`HarmonyHIPVotingPlugin` has `uint256[50] private __gap`.

Adding 2 mappings to `HarmonyVotingBase` consumes 2 storage slots → reduce child `__gap` by 2 each.

**Verification:** Run `make storage-info` after implementation to confirm layout compatibility.

#### Invariants

1. `votingDelegate[A] == B` ⟺ `delegatedFrom[B] == A` (bidirectional consistency)
2. If `votingDelegate[A] != 0`, then A **cannot** call `castVote` directly
3. `castVoteFor(pid, A, opt)` only succeeds if `msg.sender == votingDelegate[A]`
4. Vote power proof (Merkle leaf) always uses the **delegator** address, never the delegatee
5. `submitVotingPower` is unchanged — the leaf is `keccak256(abi.encodePacked(voter, power))` where `voter = delegator`

#### Backend Changes

- New event handler for `VotingDelegationSet` / `VotingDelegationCleared`:
  - Store delegation relationship in a new `VotingDelegation` collection (or field on `PluginMember`)
- `/v2/members` response gets new field: `delegatedTo: HexAddress | null`
- `/v2/members/:address` response also includes `delegatedTo` and `delegatedFrom` fields

#### Frontend Changes

- Member detail panel shows "Delegated to: 0x..." with an "Undelegate" button (if own address)
- Member detail of a delegatee shows "Votes on behalf of: 0x..."
- Members list shows a delegation badge/icon on delegated members
- New "Delegate vote" button in member actions that calls `setVotingDelegate(delegateeAddress)`

### SPRINT-002: Multi-Validator Off-Chain MVP

#### Backend Changes

- `ValidatorConfig` model gains an array field: `validatorAddresses: string[]` (in addition to the legacy `validatorAddress` for backward compat)
- `HarmonyDelegationGovernance.findAndPaginateMembers()`:
  - Reads all configured validator addresses
  - Calls `getDelegationsByValidator` for each
  - Builds a merged map: `delegatorAddress → sum(amounts)`
  - Sorts and paginates as before
- Oracle (finalizer) service:
  - When building Merkle tree, iterates over all validators
  - Sums power per unique delegator
  - Leaf = `keccak256(delegator, totalPower)`

#### Frontend Changes

- Create DAO "DelegationVoting membership" step: allow adding **multiple** validator addresses (dynamic list)
- Member detail: optional "Validator breakdown" section showing per-validator stake

#### No Contract Change Required

The contract only stores 1 `validatorAddress` but that's irrelevant for the off-chain MVP:
- The oracle knows the full validator list from config
- The Merkle root already encapsulates the aggregated power
- Voters just need a valid Merkle proof against the root

### SPRINT-003: Multi-Validator On-Chain (v2, optional)

- Evolve `validatorAddress → validatorAddresses[]` in `HarmonyDelegationVotingPlugin`
- Requires UUPS upgrade (new implementation, `prepareUpdate` in Setup)
- Lower priority — only needed if the community values on-chain validator list transparency

---

## Phases

| Phase | Duration | Description | Status |
|-------|----------|-------------|--------|
| **1. Design/Specification** | 1 week | This document, contract interface review | In Progress |
| **2. SPRINT-001 Implementation** | 2 weeks | On-chain delegation + backend/frontend | TODO |
| **3. SPRINT-002 Implementation** | 2 weeks | Multi-validator off-chain MVP | TODO |
| **4. SPRINT-003 (optional)** | TBD | On-chain multi-validator upgrade | Backlog |

---

## Milestones

- **Milestone 1:** Vote delegation contract deployed to Harmony testnet — TODO — 2026-02-17
- **Milestone 2:** Vote delegation end-to-end on testnet (contract + backend + frontend) — TODO — 2026-02-23
- **Milestone 3:** Multi-validator MVP on staging — TODO — 2026-03-08
- **Milestone 4:** Production deployment (delegation + multi-validator) — TODO — 2026-03-15

---

## Risks & Mitigations

- 🚨 **Storage layout collision on UUPS upgrade (SPRINT-001)**
  → Mitigation: Append-only storage additions in base; reduce `__gap` in children. Run `make storage-info` before deploy.
  → Contingency: Deploy as new plugin version (v2) instead of in-place upgrade.

- ⚠️ **Delegatee abuse — voting against delegator intent**
  → Mitigation: By user decision, delegation is a trust action. Users accept the delegatee's votes. UI clearly warns "you are giving your vote to this address".
  → Contingency: `clearVotingDelegate()` is always available.

- ⚠️ **Multi-validator RPC load (SPRINT-002)**
  → Mitigation: Cache delegations per validator (30s TTL already in `HarmonyRpcService`). Parallelize N RPC calls.
  → Contingency: Limit max validators per plugin to 10.

- ℹ️ **Oracle Merkle tree complexity with aggregated power**
  → Mitigation: Oracle already computes tree per proposal; adding aggregation is a data merge step, not a crypto change.
  → Contingency: Fallback to single-validator if aggregation fails.

---

## Recommended Agent/Model Mapping

| Task | Agent | Model |
|------|-------|-------|
| Contract changes (Solidity) | Principal RedHat / Architect | GPT5.2 or Claude Opus |
| Foundry tests | Codegen Specialist | GPT5.2Codex |
| Backend event indexing | Feature Dev | GPT4.1 or Qwen2.5 |
| Frontend UI components | Feature Dev | GPT4.1 |
| Storage layout verification | On-call / Severity handler | GPT4.1 |

Reference: [GitHub Copilot Model Comparison](https://github.com/features/copilot/ai-models)

---

**Version:** 1.0  
**Last Updated:** 2026-02-08  
**Status:** Ready for review
