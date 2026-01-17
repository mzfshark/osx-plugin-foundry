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

- [x] Confirm `validatorAddress` parameter in `HarmonyDelegationSetup` and how it is persisted.
- [x] Define the off-chain weight resolution schema (delegator address → stake) from Harmony API.
- [x] Confirm how intermediate snapshots are exposed to UI (read-only) without on-chain writes.
- [x] Lock the final snapshot rule to match backend logic (`endEpoch - 2`).

#### Off-chain Weight Resolution Schema

- Source: Harmony RPC `hmyv2_getValidatorInformationByBlockNumber` on https://api.harmony.one.
- Input: `validatorAddress` (installation param) + `snapshotBlock` (derived from `endDate`).
- Output: list of delegations under `validator.delegations`.
- Mapping:
  - `delegator_address` (or `delegatorAddress` / `delegator`) → `address`
  - `amount` (or `delegatedAmount`) → `votingPower`
- Resulting entries feed Merkle root computation for finalization.

### 2) Contract Implementation

- [x] Verify or implement `HarmonyDelegation` plugin contract in `src/harmony/`.
- [x] Verify or implement setup contract (e.g., `HarmonyDelegationSetup.sol`) with `validatorAddress` install param.
- [x] Ensure native token usage is explicit and documented.

### 3) Deployment & Verification

- [x] Update/confirm deploy script (e.g., `DeployHarmonyVotingRepos.s.sol`).
- [x] Deploy to Harmony mainnet and update `deployed_contracts_harmony.json`.
- [ ] Resolve manual verification for setup contracts (Blockscout/Sourcify) and update status docs.
- [ ] Reconcile verification status inconsistencies across verification reports.

#### Deployment Output (2026-01-16)

- Allowlist Proxy: `0x3653c14Ca7bef3E7B02ca04E65f6fc174D48c5C0`
- HIP Setup: `0x8D151e5021F495e23FbBC3180b4EeA1a6B251Fd0`
- HIP Repo: `0x377Fa6d56066b81a7233043302B7e1569591253E`
- Delegation Setup: `0xD872C4333CF09e3794DD8e8e8d4E09C0124E830D`
- Delegation Repo: `0x908a794F6e59872cB9b5Da0465a667833eEBdcFD`
- Opt-In Registry: `0x1E1F6128f1e611c6bD9696a758aF9310017C993B`

#### Verification Note

- Blockscout verification failed with: `eth_feeHistory` not available on RPC.
- Use `--legacy` or manual Blockscout/Sourcify verification for setup contracts.

### 4) Integration & UX

- [ ] Ensure frontend recognizes the correct plugin repo addresses (avoid cached old repo).
- [ ] Add or update installation guidance and troubleshooting notes.
- [ ] Validate install flow with correct `validatorAddress` input.

### 5) Testing & Validation

- [x] Add or update tests for installation params and voting lifecycle.
- [x] Validate snapshot calculation in a realistic scenario (Harmony mainnet or fork).
- [x] Confirm on-chain write happens only after `endDate`.

#### Snapshot Validation Result (Harmony mainnet)

- Validator: `0x3cb9F2120Ad5F5E1d58088b261053B62CaC0cdE8`
- endDate (unix): `1768570403`
- endBlock: `83810922`
- endEpoch: `2730`
- snapshotEpoch: `2728`
- snapshotBlock: `83755007`
- snapshotTimestamp (unix): `1768457992`
- delegationsCount: `1747`
- totalDelegated (wei): `33958666148397424876964771`
- selfStake (wei): `0`
- totalPower (wei): `33958666148397424876964771`

### 6) Documentation

- [x] Update `DEPLOY_GUIDE.md` with HarmonyDelegation specifics.
- [x] Update `DELEGATION_INSTALL_ERROR.md` with current resolution paths.
- [x] Add a short FAQ about snapshot timing and weight resolution.

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

## E2E Reliability (New Requirements)

### Uninstall Reliability

- [ ] Define uninstall invariants (no orphan permissions, no stuck executors)
- [ ] Verify uninstall path in setup contracts revokes all granted permissions
- [ ] Ensure uninstall works via governance permissions (not just admin)
- [ ] Add tests for install → uninstall → re-install cycles
- [ ] Document uninstall requirements and expected behavior

### Event Completeness for Indexing

- [ ] Verify all critical events are emitted (install, uninstall, proposal lifecycle)
- [ ] Ensure events include all data needed by indexers (avoid tx lookup where possible)
- [ ] Add creator/executor addresses to events where missing
- [ ] Document event schemas for backend/subgraph teams

### Native Token Voting Support

- [ ] Implement RPC-based power provider for native token (wallet + staked)
- [ ] Add support for DAO action execution in voting contracts
- [ ] Validate permission model for native token execution
- [ ] Add tests for native token value transfer execution
- [ ] Document native token voting setup and execution flow

### Metadata Registry (Future Enhancement)

- [ ] Design on-chain metadata registry contract (hash → URI mapping)
- [ ] Define access control for metadata updates
- [ ] Plan migration path from bytes32 to registry-based metadata
- [ ] Document registry integration for backend/app

## Related Plans

- [../AragonOSX/PLAN.md](../AragonOSX/PLAN.md) - E2E reliability epic
- [../aragon-app/PLAN.md](../aragon-app/PLAN.md) - UI/UX updates
- [../Aragon-app-backend/PLAN.md](../Aragon-app-backend/PLAN.md) - Backend indexing
