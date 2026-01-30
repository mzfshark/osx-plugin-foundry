# Execution Plan — HarmonyVoting Plugin Fixes

**For:** RedHat Dev Agent  
**Created:** 2026-01-28  
**Updated:** 2026-01-29  
**Status:** Phase 2 Complete — Contracts Verified (6/6 tests passed)  
**Estimated Duration:** 3 weeks

---

## Critical Discovery: The Graph Studio Limitation

**Date:** 2026-01-29  
**Finding:** The Graph Studio registrar does NOT support Harmony network.

```
Error: network not supported by registrar: no network harmony found on chain ethereum
```

**Resolution:**

- ✅ Local graph-node deployed via Docker for development/testing
- ✅ Subgraph build passes (fixed `bigint` → `BigInt`, `ts-node` → `node`)
- ⚠️ Production indexing will rely on backend direct event processing OR Alchemy Subgraphs

**Local Graph-Node Stack (Running):**

- Postgres: `localhost:5432`
- IPFS: `localhost:5001` (API), `localhost:8080` (Gateway)
- Graph-Node: `localhost:8020` (Admin), `localhost:8000` (GraphQL)

---

## Execution Order

```
Phase 1: Diagnosis (Day 1-2)
    └── SPRINT-001 tasks across all repos

Phase 2: Contract Fixes (Day 3-7)
    └── SPRINT-002 in osx-plugin-foundry

Phase 3: Backend Integration (Day 8-12)
    └── PLAN-HarmonyVotingBE in Aragon-app-backend

Phase 4: Subgraph Mappings (Day 8-12, parallel)
    └── PLAN-HarmonyVotingSG in AragonOSX

Phase 5: Frontend Integration (Day 13-17)
    └── PLAN-HarmonyVotingFE in aragon-app

Phase 6: E2E Validation (Day 18-21)
    └── Cross-repo testing
```

---

## Phase 1: Diagnosis (SPRINT-001)

**Repo:** osx-plugin-foundry  
**Duration:** 2 days  
**Goal:** Reproduce all issues and identify root causes

### Tasks

```markdown
TASK-001: Reproduce NativeTokenVoting UNKNOWN issue
├── Install plugin on test DAO
├── Capture tx receipt
├── Check Setup contract events
└── Document: expected vs actual name

TASK-002: Reproduce DelegationVoting processKey issue
├── Install with custom processKey
├── Trace form → SDK → contract
├── Verify payload includes processKey
└── Document mismatch location

TASK-003: Reproduce validator/delegators issue
├── Install with validator address
├── Check Setup event emission
├── Query Harmony API for validator data
└── Document missing data points

TASK-004: Reproduce proposals not listed
├── Create proposal (should NOT revert)
├── Verify on-chain existence
├── Query subgraph/backend
└── Identify where data is lost

TASK-005: Document HIPVoting permission flow
├── Read HIPPluginAllowlist.sol
├── Identify admin requirements
├── Document current vs expected UX
└── Propose improvements
```

### Commands to Run

```bash
# Terminal: osx-plugin-foundry
cd /mnt/d/Rede/Github/mzfshark/osx-plugin-foundry
forge build
forge test --match-contract HarmonyVoting -vvv

# Check deployed addresses
cat deployed_contracts_harmony.json
```

### Expected Outputs

- [ ] Diagnosis report with root causes
- [ ] Transaction hashes for reproductions
- [ ] Code locations for each bug

---

## Phase 2: Contract Fixes (SPRINT-002)

**Repo:** osx-plugin-foundry  
**Duration:** 5 days  
**Goal:** Fix Setup contracts and re-verify

### Tasks

```markdown
BUG-001: Fix NativeTokenVoting metadata
├── Add PLUGIN_TYPE constant
├── Emit PluginMetadataSet event
├── Update prepareInstallation()
└── Write unit test

BUG-002: Fix DelegationVoting processKey
├── Add processKey to installation params
├── Decode in prepareInstallation()
├── Store in plugin state
├── Emit event with processKey
└── Write unit test

BUG-003: Fix validator event emission
├── Add ValidatorConfigured event
├── Emit in prepareInstallation()
├── Add public validator() getter
└── Write unit test

FEATURE-001: HIPVoting allowlist flow
├── Add requestAllowlist() function
├── Add AllowlistRequested event
├── Update frontend integration docs
└── Write admin runbook

TASK-001: Re-verify contracts
├── Run forge flatten
├── Verify on Sourcify
├── Verify on Blockscout
└── Update deployed_contracts_harmony.json
```

### Key Files to Edit

```solidity
// Primary targets
src/setup/HarmonyNativeTokenVotingSetup.sol
src/setup/HarmonyDelegationVotingSetup.sol
src/setup/HarmonyHIPVotingSetup.sol
src/harmony/HarmonyDelegationVoting.sol
src/harmony/HIPPluginAllowlist.sol

// Tests
test/setup/HarmonyNativeTokenVotingSetup.t.sol
test/setup/HarmonyDelegationVotingSetup.t.sol
test/harmony/HIPPluginAllowlist.t.sol
```

### Commands to Run

```bash
# Build and test
forge build
forge test --match-contract HarmonyVoting -vvv
forge test --match-contract HIPPluginAllowlist -vvv

# Coverage
forge coverage --match-contract Harmony

# Flatten for verification
forge flatten src/setup/HarmonyDelegationVotingSetup.sol > flattened/HarmonyDelegationVotingSetup_flat.sol

# Deploy (if needed)
forge script script/DeployHarmonyVotingRepos.s.sol --rpc-url $RPC_URL --broadcast

# Verify
forge verify-contract <address> HarmonyDelegationVotingSetup --chain harmony
```

### Expected Outputs

- [ ] All tests pass
- [ ] Contracts verified on explorers
- [ ] Events emit correct data

---

## Phase 3: Backend Integration (PLAN-HarmonyVotingBE)

**Repo:** Aragon-app-backend  
**Duration:** 5 days  
**Goal:** Index HarmonyVoting data correctly

### Tasks

```markdown
TASK-001: Fix TypeScript errors
├── Fix proposal.ts duplicates
├── Fix backfillHarmony.ts parseInt
├── Fix reindexDaoRegistry.ts enums
└── Run npx tsc --noEmit

BUG-001: Add proposal indexing
├── Create HarmonyVoting event handlers
├── Map ProposalCreated to Proposal model
├── Add plugin type discriminator
└── Write unit tests

BUG-002: Index validator data
├── Create ValidatorConfig model
├── Handle ValidatorAddressUpdated + ProcessKeyConfigured events
├── Expose via API endpoint
└── Write unit tests

TASK-002: Harmony API integration
├── Create src/services/harmonyApi.ts
├── Implement getDelegationsByValidator()
├── Implement getValidatorInfo()
├── Cache responses (TTL: 5min)

TASK-003: Run backfill
├── Fix script errors
├── Run on staging
├── Verify data in DB
└── Verify API responses
```

### Key Files to Edit

```typescript
// Models
src / models / schema / proposal.ts; // Fix duplicates + add HarmonyVoting support
src / models / schema / plugin.ts; // Add validator field
src / models / schema / validatorConfig.ts; // Create new

// Services
src / services / harmonyApi.ts; // Create new
src / services / proposalService.ts; // Add HarmonyVoting queries
src / services / indexer / harmonyIndexer.ts; // Create new

// Scripts
scripts / backfillHarmony.ts; // Fix TypeScript errors

// Jobs
src / jobs / harmonyBackfillJob.ts; // Fix TypeScript errors
```

### Commands to Run

```bash
# Terminal: Backend local
cd /mnt/d/Rede/Github/mzfshark/Aragon-app-backend

# Type check
npx tsc --noEmit

# Run tests
pnpm test:unit

# Start services
pnpm run service:aragon-api
pnpm run service:aragon-indexer

# Run backfill
npx ts-node scripts/backfillHarmony.ts --network harmony --from-block 50000000
```

### Expected Outputs

- [ ] TypeScript errors fixed
- [ ] API returns HarmonyVoting proposals
- [ ] Validator data accessible

---

## Phase 4: Subgraph Mappings (PLAN-HarmonyVotingSG)

**Repo:** AragonOSX  
**Duration:** 5 days (parallel with Phase 3)  
**Goal:** Index HarmonyVoting events in subgraph

> ⚠️ **NOTE:** The Graph Studio does NOT support Harmony. Use local graph-node for dev/test.  
> Production indexing should rely on backend direct processing or Alchemy Subgraphs.

### Tasks

```markdown
TASK-001: Add ABIs
├── Copy from osx-plugin-foundry/out/
├── HarmonyNativeTokenVoting.json
├── HarmonyDelegationVoting.json
└── HarmonyHIPVoting.json

TASK-002: Update schema
├── Add HarmonyProposal entity
├── Add HarmonyVote entity
├── Add ValidatorConfig entity
└── Add AllowlistRequest entity

TASK-003: Configure data sources
├── Add to subgraph.yaml
├── Set contract addresses
├── Configure start blocks

TASK-004: Implement mappings
├── handleProposalCreated()
├── handleVoteCast()
├── handleValidatorConfigured()
├── handleAllowlistRequested()

TASK-005: Deploy
├── Test with local graph-node
├── Deploy to hosted service
└── Verify queries work
```

### Key Files to Create/Edit

```yaml
# packages/subgraph/
subgraph.yaml                           # Add data sources
schema.graphql                          # Add entities

# ABIs
abis/HarmonyNativeTokenVoting.json
abis/HarmonyDelegationVoting.json
abis/HarmonyHIPVoting.json

# Mappings
src/mappings/harmonyNativeTokenVoting.ts
src/mappings/harmonyDelegationVoting.ts
src/mappings/harmonyHIPVoting.ts
```

### Commands to Run

```bash
# Terminal: AragonOSX
cd /mnt/d/Rede/Github/mzfshark/AragonOSX/packages/subgraph

# Generate types
yarn codegen

# Build
yarn build

# Deploy (example)
yarn deploy --node https://api.thegraph.com/deploy/ <subgraph-name>
```

### Expected Outputs

- [ ] Subgraph builds without errors
- [ ] Queries return HarmonyVoting data
- [ ] Proposals indexed in real-time

---

## Phase 5: Frontend Integration (PLAN-HarmonyVotingFE)

**Repo:** aragon-app  
**Duration:** 5 days  
**Goal:** Fix forms, display, and queries

### Tasks

```markdown
BUG-001: Fix processKey form submission
├── Locate DelegationVoting form
├── Add processKey to payload
├── Verify SDK call includes field
└── Test with staging

BUG-002: Fix plugin metadata display
├── Add HarmonyVoting to plugin registry
├── Map addresses to names
├── Update networkDefinitions.ts

TASK-001: Add validator display
├── Create ValidatorInfo component
├── Fetch from Harmony API
├── Display in plugin details

TASK-002: Fix proposal list
├── Update query to include HarmonyVoting
├── Add plugin type filter
├── Test with staging data

TASK-003: E2E tests
├── Install each plugin type
├── Create proposal
├── Verify display
└── Document results
```

### Key Files to Edit

```typescript
// Constants
src / shared / constants / networkDefinitions.ts; // Update addresses

// Components
src / modules / dao / plugins / PrepareProcessDialog.tsx; // Fix form
src / modules / dao / plugins / PluginDetails.tsx; // Add validator
src / modules / proposals / ProposalList.tsx; // Fix query

// Services
src / shared / services / harmonyApi.ts; // Create new
src / hooks / useHarmonyVoting.ts; // Create new

// Types
src / types / plugins.ts; // Add HarmonyVoting types
```

### Commands to Run

```bash
# Terminal: Frontend local
cd /mnt/d/Rede/Github/mzfshark/aragon-app

# Install Harmony SDK
pnpm add @harmony-js/core @harmony-js/crypto @harmony-js/utils

# Clear cache and rebuild
rm -rf .next
pnpm build

# Development
pnpm dev

# Tests
pnpm test
pnpm type-check
```

### Expected Outputs

- [ ] processKey saved correctly
- [ ] Plugin names display correctly
- [ ] Validator info visible
- [ ] Proposals listed

---

## Phase 6: E2E Validation

**Duration:** 3 days  
**Goal:** Full integration test

### Test Matrix

| #   | Scenario          | Plugin            | Expected                |
| --- | ----------------- | ----------------- | ----------------------- |
| 1   | Install           | NativeTokenVoting | Name displays correctly |
| 2   | Install           | DelegationVoting  | processKey saved        |
| 3   | Install           | DelegationVoting  | Validator shown         |
| 4   | Create proposal   | DelegationVoting  | Appears in list         |
| 5   | Vote              | DelegationVoting  | Vote counted            |
| 6   | Execute           | DelegationVoting  | State updated           |
| 7   | Request allowlist | HIPVoting         | Event emitted           |
| 8   | Approve           | HIPVoting         | DAO can install         |
| 9   | Install           | HIPVoting         | Success                 |
| 10  | Full flow         | All               | No regressions          |

### Validation Checklist

```markdown
## Contracts

- [ ] All tests pass: `forge test`
- [ ] Contracts verified on explorers
- [ ] Events emit correct data

## Backend

- [ ] TypeScript clean: `npx tsc --noEmit`
- [ ] Unit tests pass: `pnpm test:unit`
- [ ] API returns correct data
- [ ] Backfill completes

## Subgraph

- [ ] Builds: `yarn build`
- [ ] Deployed and synced
- [ ] Queries return data

## Frontend

- [ ] Type check: `pnpm type-check`
- [ ] Tests pass: `pnpm test`
- [ ] Build succeeds: `pnpm build`
- [ ] All 10 scenarios pass
```

---

## Agent Instructions

### For RedHat Dev Agent

```markdown
## Mode

Use "Developer" or "Code" mode with file editing capabilities.

## Approach

1. Work phase by phase, repo by repo
2. Run tests after each change
3. Commit frequently with descriptive messages
4. Ask for approval before deploying

## When Stuck

- Check HARMONY_API_REFERENCE.md for API details
- Check existing tests for patterns
- Ask Morpheus agent for planning clarification

## Git Workflow

1. Create feature branch: `feat/harmonyvoting-fixes`
2. Commit after each task completion
3. Push and create PR when phase complete
4. Request review before merge

## Error Handling

- If tests fail, fix before proceeding
- If deployment fails, check verification guide
- If API errors, check network/RPC endpoints
```

---

## Quick Reference

### Terminal Mapping

| Terminal       | Repo               | Commands                      |
| -------------- | ------------------ | ----------------------------- |
| Backend local  | Aragon-app-backend | `pnpm run service:aragon-api` |
| Frontend local | aragon-app         | `pnpm dev`                    |
| AragonOSX      | AragonOSX          | `yarn codegen && yarn build`  |
| Gitissue       | GitIssue-Manager   | Sync issues                   |

### Key Addresses (update from deployed_contracts_harmony.json)

```json
{
  "HarmonyNativeTokenVotingRepo": "0x...",
  "HarmonyDelegationVotingRepo": "0x...",
  "HarmonyHIPVotingRepo": "0x...",
  "HIPPluginAllowlist": "0x..."
}
```

### RPC Endpoints

```
Mainnet: https://api.harmony.one
Testnet: https://api.s0.b.hmny.io
```

---

## Success Criteria

✅ All three plugins install without errors  
✅ NativeTokenVoting displays correct name  
✅ DelegationVoting respects user processKey  
✅ DelegationVoting shows validator and delegators  
✅ Proposals appear in frontend after creation  
✅ HIPVoting has clear permission flow  
✅ All tests pass across all repos  
✅ E2E validation: 10/10 scenarios pass
