# [PLAN-HarmonyVoting | SPRINT-001] Diagnosis & Reproduction

**Parent:** [PLAN-HarmonyVoting](PLAN_HARMONYVOTING_FIXES.md)  
**Repository:** osx-plugin-foundry (mzfshark/osx-plugin-foundry)  
**Sprint Duration:** 2026-01-28 → 2026-01-31  
**Priority:** HIGH  
**Estimative Hours:** 18h  
**Status:** IN PROGRESS

---

## Sprint Goals

1. Reproduce all reported issues in staging environment
2. Collect transaction receipts, logs, and console output
3. Identify root causes for each issue
4. Document findings with evidence (tx hashes, screenshots, code references)

---

## Execution Instructions

### Environment Setup

```bash
# Frontend (aragon-app)
cd aragon-app
pnpm install
pnpm dev

# Backend (Aragon-app-backend)
cd Aragon-app-backend
pnpm install
pnpm run service:aragon-api

# Contracts (osx-plugin-foundry)
cd osx-plugin-foundry
forge build
```

### Staging Network

- **Network:** Harmony Testnet or Mainnet (as applicable)
- **RPC:** Use `.env` configured RPC_URL
- **Block Explorer:** https://explorer.harmony.one

---

## Tasks (Linked)

### TASK-001: Reproduce NativeTokenVoting UNKNOWN issue

**Key:** `01JK8QXYZ0001`  
**Estimate:** 4h  
**Status:** IN REVIEW  
**Assignee:** TBD

#### Description

Install NativeTokenVoting plugin on a test DAO and document the UNKNOWN name issue.

#### Steps

1. Open staging frontend, navigate to DAO settings → Install Plugin
2. Select NativeTokenVoting from plugin list
3. Complete installation form and submit
4. Capture transaction hash and receipt
5. After installation, check plugin display name in UI
6. Document: expected name vs actual name (UNKNOWN)
7. Check Setup contract events for metadata emission

#### Acceptance Criteria

- [ ] Transaction receipt captured
- [ ] Console/network logs saved
- [ ] Screenshot of UNKNOWN name in UI
- [ ] Setup contract event logs analyzed
- [ ] Root cause hypothesis documented

#### Static Analysis Findings (Code Review)

- UI name resolution uses `daoUtils.getPluginName()` which prefers `plugin.name`, then `plugin.subdomain`, then `plugin.interfaceType` (see aragon-app/src/shared/utils/daoUtils/daoUtils.ts).
- No explicit "UNKNOWN" string found in frontend; likely "unknown" originates from missing `name`/`subdomain` combined with backend `interfaceType = unknown`.
- Backend type detection is bytecode-based; if the NativeTokenVoting deployment is missing expected selectors or metadata, it will default to `IPluginInterfaceType.unknown` (see Aragon-app-backend/src/helpers/pluginDetector.ts).
- Frontend enum includes `nativeTokenVoting`, but backend `PluginDetector` does not emit it (only `tokenVoting`), so naming can fall back inconsistently when subdomain is missing.

**Next evidence needed:** reproduce install to capture tx + plugin record from backend and verify `interfaceType`, `name`, `subdomain` fields.

#### Files to Inspect

```
osx-plugin-foundry/src/setup/HarmonyNativeTokenVotingSetup.sol
aragon-app/src/shared/constants/networkDefinitions.ts
```

---

### TASK-002: Reproduce DelegationVoting processKey issue

**Key:** `01JK8QXYZ0002`  
**Estimate:** 4h  
**Status:** IN REVIEW  
**Assignee:** TBD

#### Description

Install DelegationVoting plugin with custom processKey and verify it's ignored.

#### Steps

1. Open staging frontend, navigate to DAO settings → Install Plugin
2. Select DelegationVoting from plugin list
3. Fill form with custom `processKey` (e.g., `MY_CUSTOM_KEY`)
4. Submit installation
5. Capture transaction hash and check payload sent
6. After installation, verify plugin shows `HARMONYDELEGATIONVOTING` instead of custom key
7. Trace frontend form → prepareInstallation() call → Setup contract

#### Acceptance Criteria

- [ ] Transaction receipt with payload captured
- [ ] Form submission payload logged (browser console/network)
- [ ] Mismatch between form value and installed value documented
- [ ] Code path traced: form → dialog → SDK call → contract

#### Static Analysis Findings (Code Review)

- The frontend installs DelegationVoting via `buildPrepareHarmonyVotingInstallData()`.
- `buildDelegationInstallData()` supports a `processKey` parameter, but the install flow never passes it; it only passes `validatorAddress`.
- When `processKey` is undefined, the code defaults to `stringToHex('delegation', { size: 32 })`.
- The membership form only collects `validatorAddress` (no `processKey` input), so custom values cannot be provided.

**Code refs:**
- aragon-app/src/plugins/harmonyVotingPlugin/utils/harmonyVotingTransactionUtils.ts
- aragon-app/src/modules/settings/dialogs/installHarmonyVotingDialog/installHarmonyVotingDialog.tsx (no processKey input)

**Hypothesis:** custom processKey is ignored because the UI does not collect or forward it.

#### Files to Inspect

```
aragon-app/src/**/PrepareProcessDialog*
osx-plugin-foundry/src/setup/HarmonyDelegationVotingSetup.sol
```

---

### TASK-003: Reproduce DelegationVoting validator/delegators issue

**Key:** `01JK8QXYZ0003`  
**Estimate:** 4h  
**Status:** IN REVIEW  
**Assignee:** TBD

#### Description

After installing DelegationVoting with validator address, verify that validator, delegators, and token counts are missing from UI.

#### Steps

1. Install DelegationVoting with a valid validator address (e.g., `0x1234...`)
2. Capture installation transaction
3. After installation, navigate to plugin details page
4. Document: expected fields (validator, delegators, tokens) vs actual (missing)
5. Check if Setup contract emits `ValidatorRegistered` or similar event
6. Check if subgraph/indexer has mapping for this event
7. Check if backend API returns validator data

#### Acceptance Criteria

- [ ] Installation tx with validator parameter captured
- [ ] Plugin details page screenshot (showing missing data)
- [ ] Setup contract event emission verified (present/absent)
- [ ] Subgraph mapping checked for HarmonyDelegation events
- [ ] Backend API response logged

#### Static Analysis Findings (Code Review)

- The install dialog collects `validatorAddress`, but there is no UI component rendering validator/delegator data after install.
- The Delegation membership form only validates/stores `validatorAddress`; no `processKey` or delegator data is persisted from UI.
- Backend persists validator/processKey via `HarmonyVotingConfigHandler` into `ValidatorConfig` and keeps `Plugin.processKey` in sync.
- No frontend query found that reads `ValidatorConfig` to render validator/delegators.

**Code refs:**
- aragon-app/src/modules/settings/dialogs/installHarmonyVotingDialog/installHarmonyVotingDialog.tsx
- Aragon-app-backend/src/handlers/harmonyVotingConfigHandler.ts
- Aragon-app-backend/src/models/schema/validatorConfig.ts

#### Files to Inspect

```
osx-plugin-foundry/src/setup/HarmonyDelegationVotingSetup.sol
AragonOSX/packages/subgraph/src/**
Aragon-app-backend/src/models/**
```

---

### TASK-004: Reproduce DelegationVoting proposals not listed

**Key:** `01JK8QXYZ0004`  
**Estimate:** 4h  
**Status:** IN REVIEW  
**Assignee:** TBD

#### Description

Create and execute a proposal on DelegationVoting plugin and verify it doesn't appear in the proposal list.

#### Steps

1. Install DelegationVoting plugin (if not already installed)
2. Create a new proposal via UI
3. Capture proposal creation transaction (should NOT revert)
4. Vote on proposal and execute (if applicable)
5. Navigate to proposal list page
6. Document: proposal should appear but doesn't
7. Check on-chain: call plugin contract to verify proposal exists
8. Check subgraph: query for ProposalCreated events
9. Check backend API: query proposals endpoint

#### Acceptance Criteria

- [ ] Proposal creation tx captured (no revert)
- [ ] On-chain proposal existence verified (contract read)
- [ ] Subgraph query result documented
- [ ] Backend API response documented
- [ ] Gap identified: where is the data lost?

#### Static Analysis Findings (Code Review)

- Backend `PluginDetector` reports Harmony Voting as `IPluginInterfaceType.harmonyVoting` (single type).
- Frontend registry only registers `HARMONY_HIP_VOTING` and `HARMONY_DELEGATION_VOTING` plugin IDs; no registry entry for `harmonyVoting`.
- If backend returns `interfaceType = harmonyVoting`, frontend proposal UI slots will not resolve, which can hide proposal creation/list views.

**Code refs:**
- Aragon-app-backend/src/helpers/pluginDetector.ts
- aragon-app/src/plugins/harmonyVotingPlugin/index.ts

**Hypothesis:** interface type mismatch prevents proposal list components from rendering for Harmony Voting installs.

#### Files to Inspect

```
osx-plugin-foundry/src/harmony/HarmonyDelegationVoting.sol
AragonOSX/packages/subgraph/src/**
Aragon-app-backend/src/models/schema/proposal.ts
aragon-app/src/modules/**/proposals**
```

---

### TASK-005: Document HIPVoting permission flow gaps

**Key:** `01JK8QXYZ0005`  
**Estimate:** 2h  
**Status:** IN REVIEW  
**Assignee:** TBD

#### Description

Document the current HIPVoting allowlist permission flow and identify gaps in UX/documentation.

#### Steps

1. Read `HIPPluginAllowlist.sol` contract source
2. Identify: who can call `allowDAO()`, what's the expected flow
3. Check if frontend has UI for requesting/granting permission
4. Check if there's admin documentation for allowlist management
5. Document the ideal flow vs current state
6. Propose UX improvements

#### Acceptance Criteria

- [ ] Contract permission model documented
- [ ] Current frontend flow (or lack thereof) documented
- [ ] Admin runbook checked for allowlist instructions
- [ ] Gap analysis: what's missing for smooth UX
- [ ] Recommendations written

#### Static Analysis Findings (Code Review)

- `HIPPluginAllowlist` restricts allowlist management to holders of `MANAGE_ALLOWLIST_PERMISSION_ID` on the Management DAO.
- Frontend marks HIP plugin as `requiresAllowlist: true`, but no explicit allowlist management UI was found in the Harmony voting components.

**Code refs:**
- osx-plugin-foundry/src/harmony/HIPPluginAllowlist.sol

**Hypothesis:** UX gap is due to missing admin UI + runbook steps for Management DAO operations.

#### Files to Inspect

```
osx-plugin-foundry/src/harmony/HIPPluginAllowlist.sol
osx-plugin-foundry/docs/plans/*
aragon-app/src/**/HIPVoting**
```

---

## Sprint Deliverables

1. **Diagnosis Report** — Summary of all findings with evidence
2. **Root Cause Matrix** — Issue → Cause → Affected files
3. **Screenshots & Logs** — Captured during reproduction
4. **Transaction Hashes** — For all test operations

---

## Definition of Done

- [ ] All 5 tasks completed
- [ ] Each issue has documented reproduction steps
- [ ] Root causes identified for at least 4/5 issues
- [ ] Evidence collected (tx hashes, screenshots, logs)
- [ ] Diagnosis report written and shared
