# Contract Uninstall & Native Executor Plan

## Goal

Ensure safe, reliable plugin uninstall path and implement native token voting with DAO action execution support.

## Current Status

- [x] HarmonyVoting contracts deployed
- [x] Installation works with validator address
- [ ] Uninstall tested and validated
- [ ] Uninstall permission model verified
- [ ] Native token voting power provider
- [ ] DAO action execution support

## Task Breakdown

### 1. Uninstall Safety & Reliability

#### Permission Cleanup

- [ ] Audit all permissions granted during install
- [ ] Verify uninstall revokes all permissions
- [ ] Test uninstall via governance (not just admin)
- [ ] Ensure no orphan permissions after uninstall
- [ ] Document required permissions for uninstall

#### Setup Contract Updates

- [ ] Review prepareUninstallation implementation
- [ ] Add comprehensive permission revocation
- [ ] Clear all plugin state references
- [ ] Emit uninstall events for indexers
- [ ] Add tests for uninstall edge cases

#### Installation Lifecycle Tests

- [ ] Install → vote → execute → uninstall
- [ ] Install → uninstall → reinstall (clean slate)
- [ ] Multiple plugins installed, uninstall one
- [ ] Uninstall with active proposals (should block or warn)

### 2. Event Completeness for Indexing

#### Current Events Audit

- [ ] ProposalCreated: ✓ (has proposalId, metadata, startDate, endDate, snapshotBlock)
- [ ] ProposalCreated: ✗ (missing creator address - requires tx lookup)
- [ ] VoteCast: ✓ (has proposalId, voter, option)
- [ ] VoteCast: ✗ (missing voting power - computed off-chain)
- [ ] Installed: ✓ (via PluginSetupProcessor)
- [ ] Uninstalled: ✓ (via PluginSetupProcessor)

#### Event Enhancements (Future)

- [ ] Consider adding `creator` to ProposalCreated event
- [ ] Consider adding `votingPower` to VoteCast event (if computed on-chain)
- [ ] Add metadata registry events (ProposalMetadataSet)
- [ ] Document event schemas for backend/subgraph

### 3. Native Token Voting Support

#### Power Provider Implementation

- [ ] Design RPC-based power provider interface
- [ ] Implement wallet balance query (eth_getBalance at snapshot block)
- [ ] Implement staked balance query (Harmony staking contract)
- [ ] Combine wallet + staked for total voting power
- [ ] Add caching to reduce RPC calls
- [ ] Handle snapshot block finality

#### Backend Integration

- [ ] Extend HarmonyVotingFinalizer with native token mode
- [ ] Add configuration for native token voting
- [ ] Test with Harmony mainnet data
- [ ] Document native token setup

#### DAO Action Execution

- [ ] Review current execution model (HarmonyVotingBase)
- [ ] Add support for DAO.execute() calls
- [ ] Define permission model (who can execute, when)
- [ ] Add value transfer support in execution
- [ ] Test execution with native token proposals

### 4. Metadata Registry (Future Enhancement)

#### Design

- [ ] Create MetadataRegistry contract
- [ ] Define access control (who can set metadata)
- [ ] Map proposalId → metadataURI on-chain
- [ ] Add events for metadata updates

#### Migration Path

- [ ] Maintain backward compatibility with bytes32 hash
- [ ] Provide migration script for existing proposals
- [ ] Update UI to read from registry
- [ ] Update backend to index registry events

## Implementation Steps

1. **Uninstall Tests** (test/HarmonyVotingSetup.t.sol)

   ```solidity
   function testUninstallRevokesAllPermissions() public {
     // Install → verify permissions → uninstall → verify revoked
   }
   ```

2. **Native Token Provider** (new: HarmonyNativeTokenProvider.sol)

   ```solidity
   interface IPowerProvider {
     function getVotingPower(address voter, uint256 snapshotBlock)
       external view returns (uint256);
   }
   ```

3. **Metadata Registry** (new: MetadataRegistry.sol)
   ```solidity
   contract MetadataRegistry {
     mapping(bytes32 => string) public metadata;
     event MetadataSet(bytes32 indexed proposalHash, string uri);
   }
   ```

## Testing Strategy

- [ ] Fork test: install/uninstall on Harmony mainnet fork
- [ ] Unit test: permission grant/revoke scenarios
- [ ] Integration test: native token power computation
- [ ] E2E test: create proposal → vote → execute with native token

## Acceptance Criteria

- Uninstall succeeds via governance permissions
- All permissions revoked after uninstall
- Reinstall works without manual cleanup
- Native token voting power computed correctly (wallet + staked)
- DAO actions can be executed via proposals
- Events provide enough data for indexers (minimal tx lookups)

## Dependencies

- Aragon OSx core (DAO, PluginSetupProcessor)
- Harmony RPC endpoint (archive node for historical queries)
- Backend finalizer integration

## Related

- Parent Epic: [AragonOSX PLAN.md](../../AragonOSX/PLAN.md)
- Backend: [Aragon-app-backend plans/indexing-backfill.md](../../Aragon-app-backend/plans/indexing-backfill.md)
- UI: [aragon-app plans/ui-resilience.md](../../aragon-app/plans/ui-resilience.md)
