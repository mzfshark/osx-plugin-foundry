# [PLAN-HarmonyVoting | SPRINT-002] Contract & Setup Fixes

**Parent:** [PLAN-HarmonyVoting](PLAN_HARMONYVOTING_FIXES.md)  
**Repository:** osx-plugin-foundry (mzfshark/osx-plugin-foundry)  
**Sprint Duration:** 2026-02-01 → 2026-02-07  
**Priority:** HIGH  
**Estimative Hours:** 38h  
**Status:** TODO

---

## Sprint Goals

1. Fix Setup contracts to emit correct metadata/names
2. Ensure `processKey` is persisted and emitted correctly
3. Add validator event emission for DelegationVoting
4. Implement HIPVoting allowlist UX flow
5. Re-verify all Setup contracts on block explorers

---

## Prerequisites

- SPRINT-001 diagnosis completed
- Root causes identified
- Test DAO available on staging

---

## Tasks (Linked)

### BUG-001: Fix NativeTokenVoting metadata/name emission

**Key:** `01JK8QXYZ0006`  
**Estimate:** 8h  
**Status:** TODO  
**Assignee:** TBD  
**Depends On:** SPRINT-001/TASK-001

#### Description

Fix the NativeTokenVoting Setup contract to emit correct plugin name/metadata so frontend can display it properly.

#### Root Cause Hypothesis

The Setup contract may not be emitting metadata in the expected format, or the plugin implementation doesn't expose `pluginType()` or similar identifier.

#### Implementation Steps

1. Review `HarmonyNativeTokenVotingSetup.sol` for metadata handling
2. Check `prepareInstallation()` return data for name/type fields
3. Compare with working Aragon plugins (e.g., TokenVoting) for expected pattern
4. Add/fix metadata emission in Setup contract
5. Write unit test verifying metadata is emitted
6. Deploy to staging and verify

#### Acceptance Criteria

- [ ] Setup contract emits correct plugin name
- [ ] Unit test passes for metadata emission
- [ ] Staging deployment shows correct name in UI
- [ ] Contract verified on Blockscout/Sourcify

#### Files to Modify

```solidity
// Primary
osx-plugin-foundry/src/setup/HarmonyNativeTokenVotingSetup.sol

// Test
osx-plugin-foundry/test/setup/HarmonyNativeTokenVotingSetup.t.sol
```

---

### BUG-002: Fix DelegationVoting processKey persistence

**Key:** `01JK8QXYZ0007`  
**Estimate:** 8h  
**Status:** TODO  
**Assignee:** TBD  
**Depends On:** SPRINT-001/TASK-002

#### Description

Ensure the `processKey` parameter from installation form is stored in the plugin contract and emitted in events.

#### Root Cause Hypothesis

Either:

- Frontend doesn't include `processKey` in `prepareInstallation()` params
- Setup contract doesn't decode/store `processKey` from installation data
- Plugin contract has hardcoded `processKey` value

#### Implementation Steps

1. Review `HarmonyDelegationVotingSetup.sol` `prepareInstallation()` params
2. Check `decodeInstallationParams()` helper for `processKey` field
3. Verify plugin contract stores `processKey` in state
4. Add event emission for `processKey` if missing
5. Write test: install with custom key → verify stored value
6. Deploy and test on staging

#### Acceptance Criteria

- [ ] `processKey` parameter decoded in Setup
- [ ] Plugin contract stores custom `processKey`
- [ ] Event emitted with correct `processKey`
- [ ] Unit test verifies custom key persistence
- [ ] Staging shows custom key in UI

#### Files to Modify

```solidity
// Primary
osx-plugin-foundry/src/setup/HarmonyDelegationVotingSetup.sol
osx-plugin-foundry/src/harmony/HarmonyDelegationVoting.sol

// Test
osx-plugin-foundry/test/setup/HarmonyDelegationVotingSetup.t.sol
```

---

### BUG-003: Fix DelegationVoting validator event emission

**Key:** `01JK8QXYZ0008`  
**Estimate:** 6h  
**Status:** TODO  
**Assignee:** TBD  
**Depends On:** SPRINT-001/TASK-003

#### Description

Ensure validator address is stored and an event is emitted so indexers can track validator, delegators, and token counts.

#### Root Cause Hypothesis

- Setup contract receives validator but doesn't emit event
- Plugin contract doesn't expose validator state publicly
- Indexer has no mapping for validator-related events

#### Implementation Steps

1. Review `HarmonyDelegationVotingSetup.sol` for validator handling
2. Add `ValidatorConfigured(address indexed dao, address indexed validator)` event
3. Emit event in `prepareInstallation()` completion
4. Add public getter for validator in plugin contract
5. Write test verifying event emission
6. Coordinate with SPRINT-003 for indexer mapping

#### Acceptance Criteria

- [ ] `ValidatorConfigured` event defined and emitted
- [ ] Plugin has public `validator()` getter
- [ ] Unit test verifies event emission
- [ ] Event visible in block explorer after staging deploy

#### Files to Modify

```solidity
// Primary
osx-plugin-foundry/src/setup/HarmonyDelegationVotingSetup.sol
osx-plugin-foundry/src/harmony/HarmonyDelegationVoting.sol

// Test
osx-plugin-foundry/test/harmony/HarmonyDelegationVoting.t.sol
```

---

### FEATURE-001: Implement HIPVoting allowlist UX flow

**Key:** `01JK8QXYZ0009`  
**Estimate:** 12h  
**Status:** TODO  
**Assignee:** TBD  
**Depends On:** SPRINT-001/TASK-005

#### Description

Design and implement a clear UX flow for DAOs to request and receive HIPVoting installation permission.

#### Implementation Options

| Option | Description                                                | Pros          | Cons                  |
| ------ | ---------------------------------------------------------- | ------------- | --------------------- |
| A      | Pre-approval: Admin adds DAO to allowlist before install   | Simple        | Requires coordination |
| B      | Request flow: DAO requests → Admin approves → DAO installs | Clear UX      | More complex          |
| C      | Management DAO: Proposal to add DAO to allowlist           | Decentralized | Slow                  |

#### Recommended: Option B (Request Flow)

#### Implementation Steps

1. Add `requestAllowlist(address dao)` function to `HIPPluginAllowlist.sol`
2. Emit `AllowlistRequested(address indexed dao, address indexed requester)` event
3. Admin can then call `allowDAO(address dao)` to approve
4. Frontend shows: (a) Request button if not allowed, (b) Install button if allowed
5. Add status check: `isAllowed(address dao)` → display in UI
6. Write admin runbook for approval process

#### Acceptance Criteria

- [ ] `requestAllowlist()` function added
- [ ] `AllowlistRequested` event emitted
- [ ] Frontend shows request/install button based on status
- [ ] Admin runbook written
- [ ] E2E test: request → approve → install

#### Files to Modify

```solidity
// Contract
osx-plugin-foundry/src/harmony/HIPPluginAllowlist.sol

// Test
osx-plugin-foundry/test/harmony/HIPPluginAllowlist.t.sol

// Docs
osx-plugin-foundry/docs/RUNBOOK_HIP_ALLOWLIST.md
```

---

### TASK-001: Re-verify Setup contracts on Blockscout/Sourcify

**Key:** `01JK8QXYZ0010`  
**Estimate:** 4h  
**Status:** TODO  
**Assignee:** TBD  
**Depends On:** BUG-001, BUG-002, BUG-003

#### Description

After contract fixes, re-verify all Setup contracts on block explorers.

#### Steps

1. Run `make flatten` for each Setup contract
2. Attempt automated verification: `make verify-sourcify`
3. If fails, use manual upload via Sourcify/Blockscout UI
4. Document verification status in `VERIFICATION_STATUS.md`
5. Update `deployed_contracts_harmony.json` with verification links

#### Acceptance Criteria

- [ ] All 3 Setup contracts verified
- [ ] Verification links added to deployed_contracts_harmony.json
- [ ] VERIFICATION_STATUS.md updated

#### Files to Update

```
osx-plugin-foundry/docs/plans/VERIFICATION_STATUS.md
osx-plugin-foundry/deployed_contracts_harmony.json
```

---

## Sprint Deliverables

1. **Fixed Setup Contracts** — All 3 plugins with correct metadata/events
2. **HIPVoting Allowlist Flow** — Request → Approve → Install
3. **Verification Complete** — All contracts verified on explorers
4. **Unit Tests** — Tests for all fixes

---

## Definition of Done

- [ ] All 5 tasks completed
- [ ] Unit tests pass: `make test`
- [ ] Staging deployment successful
- [ ] Contracts verified on block explorers
- [ ] Ready for SPRINT-003 integration
