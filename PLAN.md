# HarmonyDelegation Plugin Execution Plan

## Goals
- Implement and ship HarmonyDelegation voting strategy with validator-based delegation weights.
- Align snapshot logic with backend behavior (penultimate epoch based on `endDate`).
- Ensure on-chain writes only happen after vote end, with intermediate snapshots as read-only/visual data.

## Requirements (Functional)
- **Installation**: DAO admin installs governance using `HarmonyDelegation` strategy and provides `validatorAddress` during setup.
- **Weight source**: Off-chain fetch of delegators + stake amount via Harmony API at https://api.harmony.one.
- **Token**: Native token stake (address `0x0000000000000000000000000000000000000000`).
- **Voting**:
  - Intermediate snapshots are allowed for UI visibility only.
  - On-chain write happens **only** after `endDate`.
  - Final weight snapshot must use the **last epoch after `endDate`** consistent with backend snapshot computation (see below).

## Backend Alignment (Snapshot Logic)
- Mirror backend snapshot behavior from `Aragon-app-backend/src/helpers/harmonySnapshot.ts`:
  - Resolve `endEpoch` from the last block at or before `endDate`.
  - Use `snapshotEpoch = endEpoch - 2`.
  - Use `snapshotBlock` as the last block of `snapshotEpoch`.

## Scope
- HarmonyDelegation plugin contract(s) and setup contract(s).
- Deployment scripts and addresses for Harmony mainnet.
- Verification steps and manual verification items.
- Documentation and troubleshooting (install + UI cache considerations).

## Task Breakdown
### 1) Specifications & Design
- [ ] Confirm `validatorAddress` parameter in `HarmonyDelegationSetup` and how it is persisted.
- [ ] Define the off-chain weight resolution schema (delegator address → stake) from Harmony API.
- [ ] Confirm how intermediate snapshots are exposed to UI (read-only) without on-chain writes.
- [ ] Lock the final snapshot rule to match backend logic (`endEpoch - 2`).

### 2) Contract Implementation
- [ ] Verify or implement `HarmonyDelegation` plugin contract in `src/harmony/`.
- [ ] Verify or implement setup contract (e.g., `HarmonyDelegationSetup.sol`) with `validatorAddress` install param.
- [ ] Ensure native token usage is explicit and documented.

### 3) Deployment & Verification
- [ ] Update/confirm deploy script (e.g., `DeployHarmonyVotingRepos.s.sol`).
- [ ] Deploy to Harmony mainnet and update `deployed_contracts_harmony.json`.
- [ ] Resolve manual verification for setup contracts (Blockscout/Sourcify) and update status docs.
- [ ] Reconcile verification status inconsistencies across verification reports.

### 4) Integration & UX
- [ ] Ensure frontend recognizes the correct plugin repo addresses (avoid cached old repo).
- [ ] Add or update installation guidance and troubleshooting notes.
- [ ] Validate install flow with correct `validatorAddress` input.

### 5) Testing & Validation
- [ ] Add or update tests for installation params and voting lifecycle.
- [ ] Validate snapshot calculation in a realistic scenario (Harmony mainnet or fork).
- [ ] Confirm on-chain write happens only after `endDate`.

### 6) Documentation
- [ ] Update `DEPLOY_GUIDE.md` with HarmonyDelegation specifics.
- [ ] Update `DELEGATION_INSTALL_ERROR.md` with current resolution paths.
- [ ] Add a short FAQ about snapshot timing and weight resolution.

## Dependencies
- Harmony RPC: https://api.harmony.one
- Management DAO address (for allowlist and admin operations)
- Correct plugin repo addresses exposed to UI
- Access to Harmony API endpoints for delegator/stake

## Acceptance Criteria
- HarmonyDelegation installs successfully with `validatorAddress`.
- Voting weights are derived from off-chain Harmony delegator stake.
- Intermediate snapshots are visible but do not trigger on-chain writes.
- Final on-chain write occurs only after `endDate` using snapshot epoch `endEpoch - 2`.
- Deployment artifacts and verification status are consistent and documented.
- Frontend install flow works without cached repo mismatch.
