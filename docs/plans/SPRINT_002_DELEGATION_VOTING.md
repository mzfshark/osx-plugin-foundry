# [PLAN-HarmonyVoting | SPRINT-002] DelegationVoting Full Implementation

**Parent:** [PLAN-HarmonyVoting](PLAN_HARMONYVOTING_FIXES.md)  
**Repositories:** aragon-app, Aragon-app-backend, osx-plugin-foundry  
**Sprint Duration:** 2026-02-05 → 2026-02-12  
**Priority:** CRITICAL  
**Estimative Hours:** 32h  
**Status:** IN PROGRESS

---

## Executive Summary

This sprint delivers the complete DelegationVoting plugin experience: correct metadata propagation during installation, validator data display (stakers, voting power), proposal creation/listing, and delegator voting functionality.

### Target Outcomes

1. **Installation respects UI metadata** — `processKey`, title, description persisted correctly
2. **Validator data displayed** — members count, individual voting power, total staking
3. **Proposals created and listed** — delegators can vote using their staked amount as voting power
4. **Full indexing** — proposals indexed and visible in DAO governance UI

---

## Problem Analysis

| Issue                  | Current State          | Root Cause                      | Target State                    |
| ---------------------- | ---------------------- | ------------------------------- | ------------------------------- |
| processKey ignored     | Hardcoded `delegation` | UI doesn't pass to install call | Custom key from form used       |
| Validator data missing | No fetch/display       | No Harmony API integration      | Fetch via `hmyv2_*` APIs        |
| Proposals not listed   | Created but invisible  | Backend type mismatch           | Correct interface type returned |
| Voting power absent    | Zero/null              | No delegation data fetch        | Staked amount = voting power    |

---

## Harmony API Reference

**Base URL:** `https://api.harmony.one` (mainnet) | `https://api.s0.t.hmny.io` (testnet)  
**Docs:** https://api.hmny.io | https://api.hmny.io/#cb814338-a4b3-4603-a98f-f569dd4ff1e2

### Key Methods

| Method                            | Purpose               | Response                             |
| --------------------------------- | --------------------- | ------------------------------------ |
| `hmyv2_getValidatorInformation`   | Get validator details | name, rate, delegations, total stake |
| `hmyv2_getDelegationsByValidator` | List all delegators   | array of {delegator, amount, reward} |
| `hmyv2_getBalance`                | Get ONE balance       | balance in atto                      |
| `hmyv2_getDelegationsByDelegator` | User's delegations    | array of validator delegations       |

### Example Requests

```bash
# Get validator info
curl -X POST https://api.harmony.one -H "Content-Type: application/json" -d '{
  "jsonrpc": "2.0",
  "method": "hmyv2_getValidatorInformation",
  "params": ["one1...validatorAddress"],
  "id": 1
}'

# Get delegations by validator
curl -X POST https://api.harmony.one -H "Content-Type: application/json" -d '{
  "jsonrpc": "2.0",
  "method": "hmyv2_getDelegationsByValidator",
  "params": ["one1...validatorAddress"],
  "id": 1
}'
```

### Response Structure (getValidatorInformation)

```json
{
  "validator": {
    "address": "one1...",
    "name": "Validator Name",
    "rate": "0.050000000000000000",
    "max-rate": "0.500000000000000000",
    "max-change-rate": "0.050000000000000000",
    "min-self-delegation": 10000000000000000000000,
    "max-total-delegation": 100000000000000000000000000
  },
  "current-epoch-performance": { ... },
  "metrics": {
    "by-shard": [ ... ]
  },
  "total-delegation": 1234567890000000000000000,
  "currently-in-committee": true,
  "epos-status": "currently elected",
  "epos-winning-stake": "...",
  "booted-status": null,
  "active-status": "active",
  "lifetime": { ... }
}
```

### Response Structure (getDelegationsByValidator)

```json
[
  {
    "validator_address": "one1...",
    "delegator_address": "one1...",
    "amount": 1000000000000000000000,
    "reward": 12345678900000000000,
    "Undelegations": []
  },
  ...
]
```

---

## Tasks (Linked)

### TASK-001: Fix Installation Metadata Propagation

**Key:** `01JK9DV00001`  
**Estimate:** 6h  
**Status:** IN-PROGRESS  
**Area:** Frontend (aragon-app)  
**Priority:** HIGH

#### Description

Ensure all metadata from the installation UI (processKey, title, description) is correctly encoded and sent to the contract.

#### Implementation Steps

1. **Verify current form fields in `installHarmonyVotingDialog.tsx`**
   - Confirm `processKey` input exists and is collected
   - Confirm `validatorAddress` is validated (checksum)

2. **Trace data flow**

   ```
   Form → buildPrepareHarmonyVotingInstallData() → encodeAbiParameters() → contract
   ```

3. **Verify ABI encoding**
   - `processKey` must be `bytes32` (pad/truncate string)
   - `validatorAddress` must be valid `address`

4. **Add E2E test**
   - Install with custom `processKey`
   - Read back from contract and verify match

#### Files to Modify

```
aragon-app/src/modules/settings/dialogs/installHarmonyVotingDialog/installHarmonyVotingDialog.tsx
aragon-app/src/plugins/harmonyVotingPlugin/utils/harmonyVotingTransactionUtils.ts
aragon-app/src/plugins/harmonyVotingPlugin/utils/harmonyVotingTransactionUtils.test.ts
```

#### Acceptance Criteria

- [x] Custom `processKey` from UI is encoded in install tx
- [x] `validatorAddress` is validated before submission
- [ ] Contract stores correct values (verified via setup/install read)
- [x] Unit tests cover custom processKey scenarios

---

### TASK-002: Implement Harmony API Service

**Key:** `01JK9DV00002`  
**Estimate:** 5h  
**Status:** DONE  
**Area:** Backend (Aragon-app-backend)  
**Priority:** HIGH

#### Description

Create a reusable service to fetch validator and delegation data from Harmony RPC.

#### Implementation Steps

1. **Create `src/services/harmonyRpcService.ts`**

```typescript
import axios from "axios";

const HARMONY_RPC_MAINNET = "https://api.harmony.one";
const HARMONY_RPC_TESTNET = "https://api.s0.t.hmny.io";

export interface ValidatorInfo {
  address: string;
  name: string;
  rate: string;
  totalDelegation: bigint;
  activeStatus: string;
  currentlyInCommittee: boolean;
}

export interface Delegation {
  validatorAddress: string;
  delegatorAddress: string;
  amount: bigint;
  reward: bigint;
}

export class HarmonyRpcService {
  private rpcUrl: string;

  constructor(isMainnet: boolean = true) {
    this.rpcUrl = isMainnet ? HARMONY_RPC_MAINNET : HARMONY_RPC_TESTNET;
  }

  async getValidatorInformation(
    validatorAddress: string,
  ): Promise<ValidatorInfo> {
    const response = await axios.post(this.rpcUrl, {
      jsonrpc: "2.0",
      method: "hmyv2_getValidatorInformation",
      params: [validatorAddress],
      id: 1,
    });

    const result = response.data.result;
    return {
      address: result.validator.address,
      name: result.validator.name || "Unknown Validator",
      rate: result.validator.rate,
      totalDelegation: BigInt(result["total-delegation"] || "0"),
      activeStatus: result["active-status"],
      currentlyInCommittee: result["currently-in-committee"],
    };
  }

  async getDelegationsByValidator(
    validatorAddress: string,
  ): Promise<Delegation[]> {
    const response = await axios.post(this.rpcUrl, {
      jsonrpc: "2.0",
      method: "hmyv2_getDelegationsByValidator",
      params: [validatorAddress],
      id: 1,
    });

    return (response.data.result || []).map((d: any) => ({
      validatorAddress: d.validator_address,
      delegatorAddress: d.delegator_address,
      amount: BigInt(d.amount || "0"),
      reward: BigInt(d.reward || "0"),
    }));
  }

  async getDelegationsByDelegator(
    delegatorAddress: string,
  ): Promise<Delegation[]> {
    const response = await axios.post(this.rpcUrl, {
      jsonrpc: "2.0",
      method: "hmyv2_getDelegationsByDelegator",
      params: [delegatorAddress],
      id: 1,
    });

    return (response.data.result || []).map((d: any) => ({
      validatorAddress: d.validator_address,
      delegatorAddress: d.delegator_address,
      amount: BigInt(d.amount || "0"),
      reward: BigInt(d.reward || "0"),
    }));
  }
}
```

2. **Add caching layer** (Redis or in-memory with TTL)

3. **Add address conversion utils** (hex ↔ bech32)

```typescript
// one1... → 0x...
export function bech32ToHex(oneAddress: string): string { ... }
// 0x... → one1...
export function hexToBech32(hexAddress: string): string { ... }
```

#### Files to Create/Modify

```
Aragon-app-backend/src/services/harmonyRpcService.ts (NEW)
Aragon-app-backend/src/utils/harmonyAddressUtils.ts (NEW)
Aragon-app-backend/src/services/index.ts (export)
```

#### Acceptance Criteria

- [x] Service fetches validator info correctly
- [x] Service fetches delegations list correctly
- [x] Address conversion works (hex ↔ bech32)
- [x] Caching prevents excessive RPC calls
- [x] Unit tests cover happy path and error cases

---

### TASK-003: Create Validator Data API Endpoint

**Key:** `01JK9DV00003`  
**Estimate:** 4h  
**Status:** DONE  
**Area:** Backend (Aragon-app-backend)  
**Priority:** HIGH

#### Description

Expose an API endpoint that returns validator data (members, voting power, totals) for the frontend.

#### Implementation Steps

1. **Create endpoint `GET /v2/plugins/delegation-voting/:network/:pluginAddress/validator`**

2. **Response schema**

```typescript
interface DelegationVotingValidatorResponse {
  validatorAddress: string; // 0x format
  validatorAddressOne: string; // one1 format
  validatorName: string;
  commissionRate: string; // e.g., "5.00%"
  isActive: boolean;
  isInCommittee: boolean;
  totalVotingPower: string; // formatted ONE amount
  totalVotingPowerRaw: string; // wei string
  membersCount: number;
  members: Array<{
    address: string; // 0x format
    addressOne: string; // one1 format
    votingPower: string; // formatted ONE
    votingPowerRaw: string; // wei string
    pendingReward: string; // formatted ONE
  }>;
}
```

3. **Wire to controller**

```typescript
// src/controllers/pluginController.ts
router.get(
  "/v2/plugins/delegation-voting/:network/:pluginAddress/validator",
  validateNetwork,
  delegationVotingValidatorHandler,
);
```

#### Files to Create/Modify

```
Aragon-app-backend/src/controllers/pluginController.ts
Aragon-app-backend/src/handlers/delegationVotingHandler.ts (NEW)
Aragon-app-backend/src/routes/v2/plugins.ts
```

#### Acceptance Criteria

- [x] Endpoint returns validator info with members list
- [x] Voting power calculated from staked amount
- [x] Response includes both hex and bech32 addresses
- [x] Pagination supported for large member lists
- [x] Error handling for invalid validator/network

---

### TASK-004: Frontend Validator Data Display

**Key:** `01JK9DV00004`  
**Estimate:** 6h  
**Status:** DONE  
**Area:** Frontend (aragon-app)  
**Priority:** HIGH

#### Description

Create UI components to display validator data (members, voting power) in the plugin settings/members view and in Governance → Members.

#### Implementation Steps

1. **Reuse existing plugins service queries**

```typescript
// src/plugins/harmonyVotingPlugin/hooks/useValidatorData.ts
export const useValidatorData = (network: Network, pluginAddress: Address) => {
  return useQuery({
    queryKey: ["delegation-voting", "validator", network, pluginAddress],
    queryFn: () => fetchValidatorData(network, pluginAddress),
    staleTime: 60_000, // 1 minute
  });
};
```

2. **Validator + delegators view (Settings → Members info)**

```tsx
// Display:
// - Validator name and address
// - Commission rate
// - Total voting power (sum of all delegations)
// - Members table:
//   - Address | Voting Power | % of Total | Pending Reward
// - Active/Committee status badges
```

3. **Register in plugin slots (Settings + Governance)**

```typescript
// SETTINGS_MEMBERS_INFO slot for HARMONY_DELEGATION_VOTING
```

4. **Add formatting utils**

```typescript
// Format ONE amounts (18 decimals)
export function formatONE(weiAmount: bigint): string {
  return formatUnits(weiAmount, 18);
}
```

#### Files to Create/Modify

```
aragon-app/src/plugins/harmonyVotingPlugin/components/harmonyVotingSetupMembership/harmonyDelegationMemberInfoView.tsx
aragon-app/src/plugins/harmonyVotingPlugin/components/harmonyDelegationMemberList/** (NEW)
aragon-app/src/plugins/harmonyVotingPlugin/hooks/useHarmonyDelegationMemberStats/** (NEW)
aragon-app/src/plugins/harmonyVotingPlugin/components/harmonyDelegationMemberPanel/** (NEW)
aragon-app/src/plugins/harmonyVotingPlugin/index.ts
```

#### Acceptance Criteria

- [x] Validator info displayed (name, address, commission)
- [x] Total voting power shown
- [x] Members list with individual voting power
- [x] Percentage of total calculated per member
- [x] Loading and error states handled
- [x] Responsive design for mobile

---

### TASK-005: Fix Proposal Listing & Indexing

**Key:** `01JK9DV00005`  
**Estimate:** 5h  
**Status:** TODO  
**Area:** Backend + Frontend  
**Priority:** CRITICAL

#### Description

Ensure DelegationVoting proposals are correctly indexed and displayed in the DAO governance UI.

#### Implementation Steps

1. **Backend: Verify `pluginDetector.ts`**
   - Confirm `harmonyDelegationVoting` is returned (not generic `harmonyVoting`)
   - Check bytecode selector matching includes delegation-specific functions

2. **Backend: Verify proposal indexing**
   - `ProposalCreated` event handler exists for DelegationVoting
   - Proposal model includes `pluginType = harmonyDelegationVoting`

3. **Frontend: Verify proposal list query**
   - Query includes `harmonyDelegationVoting` plugin type
   - Proposal list component renders for this plugin type

4. **Frontend: Verify proposal slots**
   - `PROPOSAL_LIST` slot registered for `HARMONY_DELEGATION_VOTING`
   - `PROPOSAL_DETAILS` slot registered

#### Files to Modify

```
Aragon-app-backend/src/helpers/pluginDetector.ts
Aragon-app-backend/src/handlers/proposalHandler.ts
aragon-app/src/plugins/harmonyVotingPlugin/index.ts
aragon-app/src/plugins/harmonyVotingPlugin/harmonyVotingPlugin.registry.ts
```

#### Acceptance Criteria

- [ ] Backend returns `harmonyDelegationVoting` interface type
- [ ] Proposals indexed with correct plugin type
- [ ] Proposal list renders in frontend
- [ ] Proposal details page loads correctly
- [ ] Vote action available for delegators

---

### TASK-006: Voting Power Integration

**Key:** `01JK9DV00006`  
**Estimate:** 6h  
**Status:** IN PROGRESS  
**Area:** Frontend + Backend  
**Priority:** HIGH

#### Description

Integrate delegator voting power (staked amount) into the voting flow.

#### Implementation Steps

1. **Backend: Create voting power endpoint** (DONE)

```typescript
// GET /v2/plugins/delegation-voting/:network/:pluginAddress/voting-power/:voterAddress
// Returns: { votingPower: string, votingPowerRaw: string, canVote: boolean }
```

2. **Frontend: Create `useVotingPower()` hook**

```typescript
export const useVotingPower = (
  network: Network,
  pluginAddress: Address,
  voterAddress: Address,
) => {
  return useQuery({
    queryKey: [
      "delegation-voting",
      "voting-power",
      network,
      pluginAddress,
      voterAddress,
    ],
    queryFn: () => fetchVotingPower(network, pluginAddress, voterAddress),
  });
};
```

3. **Frontend: Update vote dialog**
   - Show user's voting power before voting
   - Disable vote if voting power is 0
   - Show "You must delegate to this validator to vote" message

4. **Contract interaction**
   - Verify contract's `getVotingPower(address)` matches backend calculation

#### Files to Create/Modify

```
Aragon-app-backend/src/handlers/delegationVotingHandler.ts
aragon-app/src/plugins/harmonyVotingPlugin/hooks/useVotingPower.ts (NEW)
aragon-app/src/plugins/harmonyVotingPlugin/components/voteDialog/delegationVoteDialog.tsx
```

#### Acceptance Criteria

- [ ] Voting power fetched from Harmony API
- [ ] Voting power displayed in vote dialog
- [ ] Non-delegators see appropriate message
- [ ] Vote transaction uses correct voting power
- [ ] Voting power matches contract calculation

---

## Execution Order

```
Phase 1: Backend Foundation (TASK-002, TASK-003)
   └── Harmony RPC service
   └── Validator data endpoint
   └── Voting power endpoint

Phase 2: Frontend Display (TASK-004)
   └── Query hooks
   └── Members view component
   └── Slot registration

Phase 3: Installation Fix (TASK-001)
   └── Form validation
   └── Data propagation
   └── E2E verification

Phase 4: Proposal Flow (TASK-005, TASK-006)
   └── Indexing verification
   └── Proposal listing
   └── Voting integration
```

---

## Testing Checklist

### Installation Flow

- [ ] Install DelegationVoting with custom `processKey`
- [ ] Verify `processKey` stored on-chain matches input
- [ ] Verify `validatorAddress` stored correctly

### Validator Display

- [ ] Validator name and address displayed
- [ ] Members list populated from Harmony API
- [ ] Voting power calculated correctly (sum of delegations)
- [ ] Commission rate displayed

### Proposal Flow

- [ ] Create proposal via UI
- [ ] Proposal appears in list within 30s
- [ ] Proposal details page loads
- [ ] Vote action available for delegators
- [ ] Non-delegators cannot vote

### Voting

- [ ] Voting power shown before vote
- [ ] Vote transaction succeeds
- [ ] Vote reflected in proposal tally

---

## Definition of Done

- [ ] Installation metadata (processKey, validatorAddress) persisted correctly
- [ ] Validator data displayed (name, members, voting power)
- [ ] Delegators listed with individual voting power
- [ ] Proposals created and indexed
- [ ] Proposals listed in governance UI
- [ ] Voting works with staked amount as voting power
- [ ] All unit tests pass
- [ ] E2E tests pass on staging
- [ ] No regressions in HIP voting

---

## Related Documents

- [PLAN-HarmonyVoting](PLAN_HARMONYVOTING_FIXES.md) — Master plan
- [SPRINT-001A](SPRINT_001A_DELEGATION_FIXES.md) — Previous delegation fixes
- [Harmony API Docs](https://api.hmny.io) — RPC reference

---

**Last Updated:** 2026-02-05  
**Author:** Copilot Planning Agent
