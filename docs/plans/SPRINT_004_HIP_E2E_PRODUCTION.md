# [PLAN-HarmonyVoting | SPRINT-004] HIP Voting E2E Production Readiness

**Repository:** osx-plugin-foundry (mzfshark/osx-plugin-foundry)  
**Parent:** [PLAN-HarmonyVoting](#) <!-- Link to parent PLAN issue -->  
**Sprint Duration:** 2 weeks (2026-02-10 → 2026-02-24)  
**Priority:** HIGH  
**Estimative Hours:** 44h  
**Status:** COMPLETED

---

## Executive Summary

This sprint delivers **end-to-end production readiness** for the HIP Voting Plugin by closing all integration gaps between existing contracts (`HarmonyVotingBase`, `HarmonyHIPVotingPlugin`, `HIPPluginAllowlist`, `HarmonyValidatorOptInRegistry`). The core outcome is a fully functional validator-governed voting system where:

- **Only opted-in validators** (or their registered alias wallets) can create proposals and vote.
- **Validators who miss 2 consecutive proposals** are automatically opted-out, requiring re-registration.
- **DAO allowlist is enforced at runtime** (not just installation), enabling license revocation.
- **Alias voting works end-to-end**: validator registers alias via CLI `optIn(votingAddress)`, alias casts votes on behalf of the validator.
- **Validator set is enumerable** on-chain via the OptInRegistry (needed for oracle/backend to build Merkle trees).

### Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Alias resolution | Plugin reads from OptInRegistry at `castVote` time | Single source of truth; no duplication of alias state |
| Auto opt-out trigger | Checked at proposal creation time (lazy evaluation) | Gas-efficient; avoids needing a keeper/cron |
| Allowlist runtime check | Modifier on `createProposal` and `castVote` | Enables effective license revocation without uninstall |
| Validator enumeration | `EnumerableSet.AddressSet` in OptInRegistry | Oracle needs full list to build Merkle tree |
| Missed vote tracking | Per-validator counter reset on vote; incremented at proposal close | Accurate tracking without oracle dependency |
| Proposer gate | OptInRegistry check replaces balance gate | Only validators participate; removes wallet-as-spam vector |

---

## Sprint Goals

- [x] Goal 1: Integrate OptInRegistry with HarmonyVotingBase so alias wallets can vote on behalf of validators
- [x] Goal 2: Implement auto opt-out mechanism for validators missing 2 consecutive proposals
- [x] Goal 3: Add runtime allowlist enforcement on `createProposal()` and `castVote()`
- [x] Goal 4: Restrict proposal creation to opted-in validators or their aliases
- [x] Goal 5: Make validator set enumerable on-chain for oracle consumption
- [x] Goal 6: Full test coverage for all new and existing contracts (HIPPluginAllowlist, OptInRegistry, integration)
- [x] Goal 7: Update Setup contract to wire OptInRegistry reference into the plugin

---

## Architecture Changes

```
Before (current):
┌──────────────────────┐       ┌─────────────────────────┐
│  HarmonyVotingBase   │       │  HarmonyValidatorOptIn   │
│  ──────────────────  │       │  Registry (standalone)   │
│  castVote(msg.sender)│       │  ────────────────────    │
│  createProposal(     │       │  optIn(votingAddr)       │
│    balance >= 1 ONE) │       │  optOut()                │
│  NO alias check      │       │  isOptedIn()             │
│  NO allowlist check  │       │  votingAddressOf()       │
└──────────────────────┘       └─────────────────────────┘
       (disconnected)                 (disconnected)

After (this sprint):
┌──────────────────────────────────────────────┐
│  HarmonyVotingBase (v2)                      │
│  ──────────────────────────────────────────  │
│  + IOptInRegistry public optInRegistry       │
│  + IHIPAllowlist  public hipAllowlist        │
│  ──────────────────────────────────────────  │
│  createProposal():                           │
│    ✓ onlyIfDAOAllowed (runtime allowlist)    │
│    ✓ onlyOptedInValidatorOrAlias             │
│  castVote():                                 │
│    ✓ onlyIfDAOAllowed                        │
│    ✓ resolveVoter(msg.sender) → validator    │
│      (alias → operator lookup)               │
│  _closeProposal():                           │
│    ✓ track participation per validator       │
│    ✓ increment missedVotes for non-voters    │
└──────────────────────┬───────────────────────┘
                       │ reads
                       ▼
┌──────────────────────────────────────────────┐
│  HarmonyValidatorOptInRegistry (v2)          │
│  ──────────────────────────────────────────  │
│  + EnumerableSet _operators                  │
│  + mapping consecutiveMissedVotes            │
│  + optIn(votingAddress) → adds to set        │
│  + optOut() → removes from set               │
│  + autoOptOut(operator) → called by plugin   │
│  + resetMissedVotes(operator)                │
│  + getOperators() → address[] (enumerable)   │
│  + operatorCount() → uint256                 │
│  + operatorByAlias(alias) → operator         │
│  + isAlias(alias) → bool                     │
└──────────────────────────────────────────────┘
```

---

## Tasks (Linked)

### Week 1 (2026-02-10 → 2026-02-17) — Core Contract Changes

- [x] [PLAN-HarmonyVoting | SPRINT-004 | FEATURE-001] Integrate OptInRegistry alias resolution into HarmonyVotingBase [key:01JKVHIPE2E001] [labels:type:feature, area:contracts] [status:COMPLETED] [priority:HIGH] [estimate:6h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | FEATURE-002] Auto opt-out after 2 consecutive missed votes [key:01JKVHIPE2E002] [labels:type:feature, area:contracts] [status:COMPLETED] [priority:HIGH] [estimate:8h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | FEATURE-003] Runtime HIPAllowlist enforcement on createProposal and castVote [key:01JKVHIPE2E003] [labels:type:feature, area:contracts] [status:COMPLETED] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-001] Restrict proposer to opted-in validators or aliases [key:01JKVHIPE2E004] [labels:type:task, area:contracts] [status:COMPLETED] [priority:HIGH] [estimate:3h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-002] Add EnumerableSet and reverse-alias lookup to OptInRegistry [key:01JKVHIPE2E005] [labels:type:task, area:contracts] [status:COMPLETED] [priority:HIGH] [estimate:4h]

### Week 2 (2026-02-17 → 2026-02-24) — Setup, Tests & Integration

- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-003] Update HarmonyHIPVotingSetup to wire OptInRegistry + Allowlist references [key:01JKVHIPE2E006] [labels:type:task, area:contracts] [status:COMPLETED] [priority:HIGH] [estimate:3h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-004] Comprehensive unit tests for HIPPluginAllowlist [key:01JKVHIPE2E007] [labels:type:task, area:tests] [status:COMPLETED] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-005] Comprehensive unit tests for OptInRegistry v2 (enumeration, alias, auto opt-out) [key:01JKVHIPE2E008] [labels:type:task, area:tests] [status:COMPLETED] [priority:HIGH] [estimate:4h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-006] E2E integration tests: full lifecycle (opt-in → propose → alias vote → close → auto opt-out) [key:01JKVHIPE2E009] [labels:type:task, area:tests] [status:COMPLETED] [priority:HIGH] [estimate:6h]
- [x] [PLAN-HarmonyVoting | SPRINT-004 | TASK-007] Storage layout validation for UUPS upgrade safety [key:01JKVHIPE2E010] [labels:type:task, area:contracts] [status:COMPLETED] [priority:MEDIUM] [estimate:2h]

---

## Detailed Task Specifications

### FEATURE-001: Integrate OptInRegistry Alias Resolution into HarmonyVotingBase

**Scope:** Modify `HarmonyVotingBase` to accept an `IHarmonyValidatorOptInRegistry` reference and resolve alias wallets in `castVote()`.

**Changes:**
- Add `IHarmonyValidatorOptInRegistry public optInRegistry` storage slot to `HarmonyVotingBase`
- Add `_setOptInRegistry(address)` internal setter (called during init)
- Modify `castVote()`: resolve `msg.sender` → check if it's a direct operator or an alias via `operatorByAlias(msg.sender)`. Record the vote under the **operator** address (not the alias).
- Add `_resolveVoter(address caller) internal view returns (address operator)` helper
- Requires: TASK-002 (reverse-alias lookup in registry)

**Acceptance Criteria:**
- [x] Validator can vote directly from operator wallet
- [x] Validator's registered alias can vote on behalf of operator
- [x] Vote is recorded under operator address (for power submission consistency)
- [x] Non-opted-in address cannot vote
- [x] Alias change takes effect immediately for future votes

### FEATURE-002: Auto Opt-Out After 2 Consecutive Missed Votes

**Scope:** Track per-validator participation and auto-opt-out validators who miss 2 consecutive proposals.

**Design:**
- Add `mapping(address => uint256) public consecutiveMissedVotes` to `OptInRegistry`
- At `_closeProposal()`, the plugin iterates opted-in validators and:
  - For each validator that voted: reset `consecutiveMissedVotes[operator] = 0`
  - For each validator that did NOT vote: increment `consecutiveMissedVotes[operator]++`
  - If `consecutiveMissedVotes[operator] >= 2`: call `OptInRegistry.autoOptOut(operator)`
- Add `AUTO_OPT_OUT_PERMISSION_ID` on OptInRegistry, granted to the HIP plugin
- `autoOptOut(operator)` is permission-gated (only the plugin can call it)
- Add `event AutoOptedOut(address indexed operator, uint256 missedCount)`

**Gas consideration:** Iterating all validators at close time is O(n). For Harmony's validator set (~100 validators), this is acceptable. If the set grows > 500, consider off-chain tracking with Merkle proof.

**Acceptance Criteria:**
- [x] Validator missing 1 proposal: counter = 1, still opted in
- [x] Validator missing 2 consecutive proposals: auto opt-out triggered
- [x] Voting in any proposal resets the counter to 0
- [x] Auto-opted-out validator must re-register via `optIn()` to participate again
- [x] Event emitted on auto opt-out

### FEATURE-003: Runtime HIPAllowlist Enforcement

**Scope:** Add allowlist check on `createProposal()` and `castVote()` so that revoking a DAO from the allowlist effectively pauses the plugin.

**Changes:**
- Add `IHIPPluginAllowlist public hipAllowlist` storage slot to `HarmonyVotingBase`
- Add modifier `onlyIfDAOAllowed()` that checks `hipAllowlist.isDAOAllowed(address(dao()))`
- Apply modifier to `createProposal()` and `castVote()`
- `submitVotingPower()` and `closeProposal()` do NOT require the check (allow finalization of in-flight proposals)

**Acceptance Criteria:**
- [x] If DAO is removed from allowlist, new proposals cannot be created
- [x] If DAO is removed from allowlist, new votes cannot be cast
- [x] In-flight proposals (already created) can still be finalized and closed
- [x] Re-allowing the DAO restores full functionality

### TASK-001: Restrict Proposer to Opted-In Validators/Aliases

**Scope:** Replace the `msg.sender.balance >= 1 ether` gate with an OptInRegistry check.

**Changes:**
- In `createProposal()`: replace balance check with `_resolveVoter(msg.sender)` — reverts if caller is not an opted-in validator or alias
- Remove or deprecate `PROPOSER_PERMISSION_ID` constant (or keep for future use)
- Consider keeping a minimum balance gate as an anti-spam measure (e.g., 100 ONE) alongside the validator check

**Acceptance Criteria:**
- [x] Only opted-in validators or their aliases can create proposals
- [x] Non-validator addresses are rejected even if funded
- [x] A formerly opted-in validator who was auto-opted-out cannot create proposals

### TASK-002: Add EnumerableSet and Reverse-Alias Lookup to OptInRegistry

**Scope:** Upgrade `HarmonyValidatorOptInRegistry` to support enumeration and reverse lookups.

**Changes:**
- Import `EnumerableSet` from OpenZeppelin
- Add `EnumerableSet.AddressSet private _operators` — all opted-in operator addresses
- Add `mapping(address => address) private _operatorByAlias` — alias → operator reverse lookup
- Update `optIn()`: add to set, register reverse alias mapping
- Update `optOut()`: remove from set, delete reverse alias mapping
- Add view functions:
  - `getOperators() → address[]` (full list)
  - `operatorCount() → uint256`
  - `operatorAt(uint256 index) → address`
  - `operatorByAlias(address alias) → address` (returns operator or address(0))
  - `isAlias(address alias) → bool`
- Handle alias re-registration: if operator changes alias, delete old reverse mapping

**Acceptance Criteria:**
- [ ] `getOperators()` returns all currently opted-in validators
- [ ] `operatorByAlias(alias)` correctly resolves alias → operator
- [ ] Old alias is invalidated when operator re-opts-in with a new alias
- [ ] Enumeration is consistent after opt-in/opt-out sequences

### TASK-003: Update HarmonyHIPVotingSetup to Wire References

**Scope:** Pass OptInRegistry and HIPAllowlist addresses to the plugin during installation.

**Changes:**
- Modify `HarmonyHIPVotingSetup` constructor to also accept `HarmonyValidatorOptInRegistry` address
- Update `prepareInstallation()` to pass registry and allowlist references to plugin `initialize()`
- Update `HarmonyHIPVotingPlugin.initialize()` to accept and store both references
- Grant `AUTO_OPT_OUT_PERMISSION_ID` from OptInRegistry to the plugin

**Acceptance Criteria:**
- [ ] Plugin is initialized with valid OptInRegistry and HIPAllowlist references
- [ ] Plugin has permission to call `autoOptOut()` on the registry
- [ ] Setup still validates allowlist status before installation

### TASK-004: Unit Tests for HIPPluginAllowlist

**Scope:** Full test coverage for the allowlist contract.

**Test cases:**
- `allowDAO` / `disallowDAO` — happy paths
- `isDAOAllowed` — true/false cases
- Batch operations — `allowDAOsBatch`, `disallowDAOsBatch`
- Permission enforcement — unauthorized caller reverts
- Edge cases — zero address, double allow/disallow
- Event verification

### TASK-005: Unit Tests for OptInRegistry v2

**Scope:** Full test coverage for the upgraded registry.

**Test cases:**
- `optIn` with alias — happy path, event emission
- `optOut` — cleanup of set + reverse mapping
- Enumeration — `getOperators()`, `operatorCount()`, `operatorAt()`
- Reverse lookup — `operatorByAlias()`, `isAlias()`
- Re-opt-in with different alias — old alias invalidated
- Auto opt-out — permission check, state cleanup
- `consecutiveMissedVotes` — increment, reset, threshold trigger

### TASK-006: E2E Integration Tests

**Scope:** Full lifecycle test combining all contracts.

**Scenarios:**
1. **Happy path:** Validator opts in with alias → DAO allowed → alias creates proposal → alias votes → oracle sets root → power submitted → proposal closed → vote counts correct
2. **Auto opt-out path:** Validator opts in → 2 proposals created → validator doesn't vote either → auto-opted-out on second close → cannot create proposal 3
3. **Allowlist revocation:** DAO allowed → plugin installed → proposal created → DAO disallowed → new proposal reverts → in-flight proposal can still close
4. **Alias change:** Validator opts in with alias A → votes → changes alias to B → A cannot vote → B can vote
5. **Re-registration:** Validator auto-opted-out → re-opts-in → can vote again, counter reset

### TASK-007: Storage Layout Validation

**Scope:** Verify UUPS upgrade safety for modified contracts.

**Tasks:**
- Run `forge inspect HarmonyVotingBase storage-layout` before and after changes
- Verify new storage slots are appended (not inserted between existing slots)
- Ensure `__gap` is decremented correctly for each new slot
- Document storage layout changes for upgrade audit

---

## Execution Instructions

1. **Setup:**
   - Ensure Foundry is installed (`forge --version`)
   - Run `forge build` to verify current compilation
   - Review `foundry.toml` for remappings

2. **Implementation Order (dependency chain):**
   ```
   TASK-002 (Registry v2: enumeration + reverse lookup)
     → FEATURE-001 (Alias integration in VotingBase)
       → TASK-001 (Proposer restriction)
     → FEATURE-002 (Auto opt-out tracking)
   FEATURE-003 (Runtime allowlist) — independent, parallel
   TASK-003 (Setup wiring) — after FEATURE-001 + FEATURE-003
   TASK-004..006 (Tests) — after all features
   TASK-007 (Storage layout) — final validation
   ```

3. **Validation:**
   - `make test` — all unit tests pass
   - `make test-coverage` — coverage report generated
   - `make storage-info` — storage layout documented

4. **Rollback:**
   - All changes on a feature branch
   - No deployment until full test pass + review
   - Existing deployed contracts (registry, allowlist) need UUPS upgrade path if modified

---

## Acceptance Criteria

- [ ] All 11 tasks marked as DONE
- [ ] All existing tests still pass (no regression)
- [ ] New test coverage: HIPPluginAllowlist (≥90%), OptInRegistry (≥90%), VotingBase integration (≥85%)
- [ ] Storage layout verified for UUPS upgrade safety
- [ ] Full E2E flow validated: opt-in with alias → propose → vote via alias → close → auto opt-out after 2 misses
- [ ] Code reviewed and merged to feature branch

---

## Milestones

| Milestone | Description | Target | Status |
|-----------|-------------|--------|--------|
| M1 | Core contract changes compiled (FEATURE-001..003, TASK-001..002) | 2026-02-17 | TODO |
| M2 | Setup wiring + unit tests passing (TASK-003..005) | 2026-02-21 | TODO |
| M3 | E2E integration tests + storage validation (TASK-006..007) | 2026-02-24 | TODO |

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Gas cost of iterating validators at close | High gas if >500 validators | Harmony has ~100 active validators; add circuit breaker at 500 |
| UUPS storage collision on VotingBase upgrade | Bricked proxies | TASK-007 validates layout; new slots appended to `__gap` |
| OptInRegistry is standalone (not UUPS) | Cannot upgrade in-place | Current deployment has no proxied state; redeploy + migrate |
| Alias change during active proposal | Inconsistent vote attribution | Vote recorded under operator; alias change doesn't affect in-flight votes |
| Allowlist revocation mid-proposal | Finalization blocked | `submitVotingPower` and `closeProposal` exempt from allowlist check |

---

## Cross-Repo Impact

| Repository | Impact | When |
|------------|--------|------|
| **Aragon-app-backend** | Oracle must read OptInRegistry `getOperators()` to build Merkle tree; API must expose validator list with opt-in status | After M1 |
| **aragon-app** | Frontend must display opt-in status, alias wallet, missed votes counter; proposal creation restricted to validators | After M2 |
| **AragonOSX** | Subgraph needs new events: `AutoOptedOut`, updated `OptedIn`/`OptedOut` with enumeration data | After M1 |

---

**Version:** 1.0  
**Created:** 2026-02-10  
**Last Updated:** 2026-02-10
