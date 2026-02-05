# [PLAN] HIP Allowlist Manager — DAO-Governed Licensing

## Technical Info

| Field               | Value                         |
| ------------------- | ----------------------------- |
| **Repository**      | `mzfshark/osx-plugin-foundry` |
| **Slug**            | `PLAN-HIPAllowlist`           |
| **Priority**        | HIGH                          |
| **Status**          | DRAFT                         |
| **End Date Goal**   | 2026-02-28                    |
| **Estimated Hours** | 40h                           |

---

## Executive Summary

This plan defines a **DAO-governed licensing system** for the HIP Voting Plugin. The core concept:

1. **Manager DAO** (e.g., Think in Coin DAO at `0x1b0f7e8fA531F56D5e8cAF76F1FCC2dB0FE6058a`) receives `MANAGE_ALLOWLIST_PERMISSION_ID` on the `HIPPluginAllowlist` contract.
2. Through governance (proposal → vote → execute), the Manager DAO can **grant or revoke** allowlist permissions to other DAOs.
3. **Grantee DAOs** with allowlist status can install the HIP Voting Plugin.
4. **Revocation** removes the DAO from the allowlist, and the HIP Plugin checks allowlist status on critical operations (voting/execution), effectively "pausing" the plugin for revoked DAOs.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              HARMONY MAINNET                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌──────────────────────────────────────────────────────────────────────────┐   │
│  │                    HIPPluginAllowlist (Proxy)                            │   │
│  │                    0xa7872b2159521c96D53EddD9C123843953C3aDeC            │   │
│  │  ────────────────────────────────────────────────────────────────────    │   │
│  │  • allowDAO(address)        → adds DAO to allowlist                      │   │
│  │  • disallowDAO(address)     → removes DAO from allowlist                 │   │
│  │  • isDAOAllowed(address)    → checks if DAO can install HIP              │   │
│  │  • allowedDAOs[address]     → mapping of allowed DAOs                    │   │
│  │                                                                          │   │
│  │  PERMISSION: MANAGE_ALLOWLIST_PERMISSION_ID                              │   │
│  │  HOLDER: Management DAO (0x700cBBB4881D286628ca9aD3d9DF390D9c0840a2)     │   │
│  └──────────────────────────────────────────────────────────────────────────┘   │
│                            │                                                    │
│                            │ MANAGE_ALLOWLIST_PERMISSION_ID                     │
│                            │ (must be GRANTED to Manager DAO)                   │
│                            ▼                                                    │
│  ┌──────────────────────────────────────────────────────────────────────────┐   │
│  │                 Manager DAO (Think in Coin DAO)                          │   │
│  │                 0x1b0f7e8fA531F56D5e8cAF76F1FCC2dB0FE6058a               │   │
│  │  ────────────────────────────────────────────────────────────────────    │   │
│  │  • Receives MANAGE_ALLOWLIST_PERMISSION_ID via DAO.grant()               │   │
│  │  • Creates proposals to allowDAO() / disallowDAO()                       │   │
│  │  • Governance: proposal → vote → execute                                 │   │
│  │                                                                          │   │
│  │  ACTION COMPOSER INTEGRATION:                                            │   │
│  │  • "Allowlist HIP" action type                                          │   │
│  │  • "Revoke HIP" action type                                             │   │
│  └──────────────────────────────────────────────────────────────────────────┘   │
│                            │                                                    │
│                            │ execute() → allowDAO(granteeDAO)                   │
│                            ▼                                                    │
│  ┌──────────────────────────────────────────────────────────────────────────┐   │
│  │                      Grantee DAO (Requester)                             │   │
│  │                      0x<any-dao-address>                                 │   │
│  │  ────────────────────────────────────────────────────────────────────    │   │
│  │  • Once allowed, can install HarmonyHIPVotingPlugin                      │   │
│  │  • Badge in UI: "Allowed" / "Available"                                 │   │
│  │  • If revoked: plugin operations fail (voting/execution blocked)         │   │
│  └──────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Current State Analysis

### Deployed Contracts

| Contract                   | Address                                      | Status               |
| -------------------------- | -------------------------------------------- | -------------------- |
| HIPPluginAllowlist (Impl)  | `0x3653c14Ca7bef3E7B02ca04E65f6fc174D48c5C0` | ✅ Deployed          |
| HIPPluginAllowlist (Proxy) | `0xa7872b2159521c96D53EddD9C123843953C3aDeC` | ✅ Deployed          |
| HarmonyHIPVotingSetup      | `0xD872C4333CF09e3794DD8e8e8d4E09C0124E830D` | ✅ Deployed          |
| Management DAO             | `0x700cBBB4881D286628ca9aD3d9DF390D9c0840a2` | ✅ Holds permissions |

### Current Permission Problem

The `MANAGE_ALLOWLIST_PERMISSION_ID` is currently held only by the **Management DAO** (`0x700cBB...`), not by the Think in Coin DAO (`0x1b0f7e...`).

**Solution**: Grant `MANAGE_ALLOWLIST_PERMISSION_ID` to Think in Coin DAO (or install a plugin that acts as intermediary).

---

## Implementation Options

### Option A: Direct Permission Grant (Simpler)

Grant `MANAGE_ALLOWLIST_PERMISSION_ID` directly to Think in Coin DAO on the `HIPPluginAllowlist` contract.

**Pros:**

- Simplest implementation
- No new contracts needed
- Direct governance flow

**Cons:**

- Requires Management DAO to execute a `grant()` on its own DAO contract
- Less modular (single DAO controls allowlist)

**Steps:**

1. Management DAO creates proposal to execute:
   ```solidity
   // On Management DAO (0x700cBB...)
   DAO.grant(
       HIPPluginAllowlist,                        // where
       ThinkInCoinDAO,                            // who
       MANAGE_ALLOWLIST_PERMISSION_ID             // permissionId
   )
   ```
2. Once granted, Think in Coin DAO can create proposals with actions:
   ```solidity
   HIPPluginAllowlist.allowDAO(granteeDAOAddress)
   HIPPluginAllowlist.disallowDAO(granteeDAOAddress)
   ```

### Option B: Allowlist Manager Plugin (More Modular)

Create a dedicated plugin installed on Think in Coin DAO that wraps allowlist operations.

**Pros:**

- Encapsulated logic
- Can add additional business logic (fees, cooldowns, etc.)
- Better separation of concerns

**Cons:**

- Requires new contract deployment
- More complexity

---

## Recommended Approach: Option A + UI Integration

Given the existing contract infrastructure, **Option A** is recommended with the following enhancements:

### Phase 1: Permission Setup (Contracts/Backend)

1. **Grant permission to Manager DAO** via Management DAO proposal
2. **Update backend indexer** to track `DAOAllowed` / `DAODisallowed` events
3. **Add API endpoint** to check allowlist status: `GET /api/v1/dao/:address/hip-allowlist-status`

### Phase 2: Frontend Integration (aragon-app)

1. **New Action Type**: "HIP Allowlist Management"
   - `allowDAO(address)` — Grant HIP installation permission
   - `disallowDAO(address)` — Revoke HIP installation permission

2. **Plugin Selection Badge**:
   - If `isDAOAllowed(currentDAO) === true`: Badge "✅ Available"
   - If `isDAOAllowed(currentDAO) === false`: Badge "🔒 By Request"

3. **Plugin Operation Guards** (if revoked):
   - Show "This plugin has been disabled by the licensor" message
   - Block voting/execution UI

---

## Sprint Breakdown

### SPRINT-001: Permission & Contract Setup

| Task ID  | Title                                               | Estimate | Status |
| -------- | --------------------------------------------------- | -------- | ------ |
| TASK-001 | Grant MANAGE_ALLOWLIST_PERMISSION_ID to Manager DAO | 2h       | TODO   |
| TASK-002 | Verify permission grant on-chain                    | 1h       | TODO   |
| TASK-003 | Test allowDAO/disallowDAO from Manager DAO          | 2h       | TODO   |

### SPRINT-002: Backend Integration

| Task ID  | Title                                       | Estimate | Status |
| -------- | ------------------------------------------- | -------- | ------ |
| TASK-004 | Add DAOAllowed/DAODisallowed event indexing | 4h       | TODO   |
| TASK-005 | Create allowlist status API endpoint        | 3h       | TODO   |
| TASK-006 | Add allowlist status to DAO detail response | 2h       | TODO   |

### SPRINT-003: Frontend — Action Composer

| Task ID  | Title                                         | Estimate | Status |
| -------- | --------------------------------------------- | -------- | ------ |
| TASK-007 | Create "HIP Allowlist" action type definition | 4h       | TODO   |
| TASK-008 | Build allowDAO action form (address input)    | 3h       | TODO   |
| TASK-009 | Build disallowDAO action form                 | 2h       | TODO   |
| TASK-010 | Add action preview/summary component          | 2h       | TODO   |

### SPRINT-004: Frontend — Plugin Selection & Status

| Task ID  | Title                                            | Estimate | Status |
| -------- | ------------------------------------------------ | -------- | ------ |
| TASK-011 | Fetch allowlist status in plugin selection flow  | 3h       | TODO   |
| TASK-012 | Implement badge component (Available/By Request) | 2h       | TODO   |
| TASK-013 | Add revoked plugin warning in DAO dashboard      | 3h       | TODO   |
| TASK-014 | Block voting UI for revoked plugins              | 4h       | TODO   |

### SPRINT-005: Testing & Documentation

| Task ID  | Title                                                 | Estimate | Status |
| -------- | ----------------------------------------------------- | -------- | ------ |
| TASK-015 | E2E test: grant allowlist via governance              | 3h       | TODO   |
| TASK-016 | E2E test: revoke allowlist and verify plugin disabled | 3h       | TODO   |
| TASK-017 | Update user documentation                             | 2h       | TODO   |

---

## Action Composer Specification

### Action Type: `hip-allowlist-grant`

```typescript
{
  id: 'hip-allowlist-grant',
  label: 'Grant HIP Plugin Access',
  description: 'Allow a DAO to install the HIP Voting Plugin',
  icon: 'shield-check',
  targetContract: '0xa7872b2159521c96D53EddD9C123843953C3aDeC', // HIPPluginAllowlist
  functionName: 'allowDAO',
  functionSignature: 'allowDAO(address)',
  inputs: [
    {
      name: '_dao',
      type: 'address',
      label: 'DAO Address',
      description: 'The address of the DAO to grant HIP plugin access',
      validation: {
        required: true,
        isAddress: true,
      }
    }
  ],
  availableFor: ['manager-dao'] // Only visible for DAOs with MANAGE_ALLOWLIST_PERMISSION
}
```

### Action Type: `hip-allowlist-revoke`

```typescript
{
  id: 'hip-allowlist-revoke',
  label: 'Revoke HIP Plugin Access',
  description: 'Remove a DAO from the HIP Plugin allowlist',
  icon: 'shield-x',
  targetContract: '0xa7872b2159521c96D53EddD9C123843953C3aDeC',
  functionName: 'disallowDAO',
  functionSignature: 'disallowDAO(address)',
  inputs: [
    {
      name: '_dao',
      type: 'address',
      label: 'DAO Address',
      description: 'The address of the DAO to revoke HIP plugin access',
      validation: {
        required: true,
        isAddress: true,
      }
    }
  ],
  availableFor: ['manager-dao']
}
```

---

## Plugin Enforcement Enhancement

### Current Behavior

The `HIPPluginAllowlist` only controls **installation**. Once installed, the plugin operates independently.

### Enhanced Behavior (Optional)

To support **runtime enforcement** (plugin stops working if revoked):

```solidity
// In HarmonyHIPVotingPlugin.sol — add modifier
modifier onlyIfDAOAllowed() {
    require(
        IHIPPluginAllowlist(allowlistAddress).isDAOAllowed(address(dao())),
        "HIP: DAO not authorized"
    );
    _;
}

// Apply to critical functions
function createProposal(...) external onlyIfDAOAllowed { ... }
function vote(...) external onlyIfDAOAllowed { ... }
function execute(...) external onlyIfDAOAllowed { ... }
```

**Trade-off**: This adds gas cost and external call to every operation. Consider caching or event-driven approach.

---

## Immediate Next Step: Grant Permission

Execute this from Management DAO (`0x700cBB...`):

```bash
# Step 1: Calculate permission hash
cast keccak "MANAGE_ALLOWLIST_PERMISSION"
# Result: 0x... (use this as permissionId)

# Step 2: Encode grant call
cast calldata "grant(address,address,bytes32)" \
  0xa7872b2159521c96D53EddD9C123843953C3aDeC \
  0x1b0f7e8fA531F56D5e8cAF76F1FCC2dB0FE6058a \
  0x<MANAGE_ALLOWLIST_PERMISSION_ID>

# Step 3: Create proposal on Management DAO with this action
# Target: Management DAO itself (0x700cBB...)
# Action: grant(where, who, permissionId)
```

---

## Risks & Mitigations

| Risk                              | Impact                         | Mitigation                              |
| --------------------------------- | ------------------------------ | --------------------------------------- |
| Manager DAO compromised           | All HIP licenses revoked       | Multi-sig on Manager DAO, timelock      |
| Permission grant to wrong address | Unauthorized allowlist changes | Double-check addresses, simulation      |
| Plugin enforcement overhead       | Gas cost increase              | Cache allowlist status, optimize checks |
| Frontend out of sync with chain   | Incorrect badge display        | Real-time event subscription, polling   |

---

## Acceptance Criteria

- [ ] Manager DAO (Think in Coin) has `MANAGE_ALLOWLIST_PERMISSION_ID`
- [ ] Manager DAO can create proposals to `allowDAO()` / `disallowDAO()`
- [ ] Backend indexes allowlist events and exposes status API
- [ ] Frontend shows correct badge (Available/By Request) in plugin selection
- [ ] Frontend action composer includes HIP Allowlist actions for Manager DAO
- [ ] (Optional) Revoked DAOs see disabled plugin UI with explanation

---

**Version:** 1.0  
**Created:** 2026-02-05  
**Author:** Copilot Planning Agent
