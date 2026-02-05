# [PLAN-HarmonyVoting | SPRINT-001A] DelegationVoting Fixes

**Parent:** [PLAN-HarmonyVoting | SPRINT-001](SPRINT_001_DIAGNOSIS.md)  
**Repositories:** aragon-app, Aragon-app-backend, AragonOSX  
**Sprint Duration:** 2026-02-04 → 2026-02-07  
**Priority:** HIGH  
**Estimative Hours:** 12h  
**Status:** COMPLETED

---

## Executive Summary

Focused sprint to resolve the three critical DelegationVoting plugin issues identified during SPRINT-001 diagnosis:

1. **processKey ignored** — Custom processKey from installation form is not passed to contract
2. **Validator data missing** — Validator address, delegators, and token counts not displayed in UI
3. **Proposals not listed** — Created proposals don't appear in the proposal list due to type mismatch

---

## Sprint Goals

1. Enable custom `processKey` input during DelegationVoting installation
2. Display validator configuration data after plugin installation
3. Fix proposal listing for DelegationVoting plugins

---

## Root Cause Analysis Summary

### TASK-002: processKey Ignored

| Component                                | Issue                                                 |
| ---------------------------------------- | ----------------------------------------------------- |
| `buildDelegationInstallData()`           | Accepts `processKey` param but caller doesn't pass it |
| `buildPrepareHarmonyVotingInstallData()` | Only passes `validatorAddress`, ignores `processKey`  |
| `installHarmonyVotingDialog.tsx`         | No UI input for `processKey`                          |

**Result:** Always uses hardcoded `stringToHex('delegation', { size: 32 })`

### TASK-003: Validator/Delegators Not Displayed

| Component                            | Status                                        |
| ------------------------------------ | --------------------------------------------- |
| Backend `HarmonyVotingConfigHandler` | ✅ Correctly persists `ValidatorConfig`       |
| `ValidatorConfig` model              | ✅ Stores `validatorAddress` and `processKey` |
| Frontend plugin details              | ❌ No component reads/renders this data       |

**Result:** Data exists in DB but no UI to display it

### TASK-004: Proposals Not Listed

| Component                | Issue                                                               |
| ------------------------ | ------------------------------------------------------------------- |
| Backend `PluginDetector` | Returns generic `harmonyVoting` type                                |
| Frontend registry        | Only registers `HARMONY_HIP_VOTING` and `HARMONY_DELEGATION_VOTING` |
| Type mismatch            | Frontend can't find slots for `harmonyVoting` interface             |

**Result:** Proposal list components don't render for Harmony Voting installs

---

## Tasks (Linked)

### TASK-002: Fix processKey Propagation

**Key:** `01JK8QXYZ0002`  
**Estimate:** 4h

### TASK-005: HIP allowlist / permissions (finalization)

**Key:** 01JK8QXYZ0005  
**Estimate:** 3h  
**Status:** COMPLETED

#### Description

Document the end-to-end flow for HIP allowlist and permissions: where the on-chain gating happens, which permission controls the allowlist, how the UI treats `requiresAllowlist`, and recommended operational runbook (post-creation enablement or admin allowlisting).

#### Outcome

- Confirmed: installation gated in `HarmonyHIPVotingSetup.prepareInstallation` via `ALLOWLIST.isDAOAllowed(_dao)` and reverts `DAONotAuthorized` when not allowed.
- Confirmed: `MANAGE_ALLOWLIST_PERMISSION_ID` guards `allowDAO`/`disallowDAO`.
- App UX: HIP marked `requiresAllowlist: true` and is disabled during DAO creation; recommended post-creation enablement flow documented.

**Status:** COMPLETED  
**Area:** Frontend (aragon-app)  
**Priority:** HIGH

#### Description

Add optional `processKey` input to DelegationVoting installation dialog and propagate it through the install data chain.

#### Implementation Steps

1. **Add processKey state to `installHarmonyVotingDialog.tsx`**

   ```typescript
   const [processKey, setProcessKey] = useState<string>("");
   ```

2. **Add input field (optional, with default hint)**
   - Label: "Process Key (optional)"
   - Placeholder: "Leave empty for default 'delegation'"
   - Help text: "Custom identifier for this voting process"

3. **Update `IPrepareHarmonyVotingInstallationDialogParams`**

   ```typescript
   processKey?: string;
   ```

4. **Update `buildPrepareHarmonyVotingInstallData()`**
   - Accept `processKey` from params
   - Pass to `buildDelegationInstallData(validatorAddress, processKey)`

5. **Update tests**
   - `harmonyVotingTransactionUtils.test.ts` — verify custom processKey encoding

#### Files to Modify

```
aragon-app/src/modules/settings/dialogs/installHarmonyVotingDialog/installHarmonyVotingDialog.tsx
aragon-app/src/modules/settings/dialogs/prepareHarmonyVotingInstallationDialog/prepareHarmonyVotingInstallationDialog.tsx
aragon-app/src/plugins/harmonyVotingPlugin/utils/harmonyVotingTransactionUtils.ts
aragon-app/src/plugins/harmonyVotingPlugin/utils/harmonyVotingTransactionUtils.test.ts
```

#### Acceptance Criteria

- [x] processKey input visible in DelegationVoting install dialog
- [x] Custom processKey encoded in installation transaction
- [x] Default "delegation" used when field is empty
- [x] Unit tests pass
- [x] No regressions in HIP voting installation

---

### TASK-003: Display Validator Configuration

**Key:** `01JK8QXYZ0003`  
**Estimate:** 5h  
**Status:** COMPLETED  
**Area:** Frontend + Backend  
**Priority:** HIGH

#### Description

Create UI components to display validator address, delegators count, and processKey after DelegationVoting plugin installation.

#### Implementation Steps

1. **Backend: Verify/Add API endpoint**
   - Verified existing endpoint used by the app: `GET /v2/plugins/harmony-config/:network/:pluginAddress`
   - Response: `{ validatorAddress, processKey }`

2. **Frontend: Create hook `useHarmonyValidatorConfig()`**

   ```typescript
   // Implemented via pluginsService query hook
   ```

3. **Frontend: Create display component**

   ```typescript
    - Implemented as a Settings member info slot component for the DelegationVoting plugin
    - Displays validator address + processKey (with fallback), plus member/eligible voters info
   ```

4. **Register component in plugin registry**
   - Registered `SETTINGS_MEMBERS_INFO` slot for `HARMONY_DELEGATION_VOTING`

#### Files to Modify/Create

```
# Backend
Aragon-app-backend: existing `/v2/plugins/harmony-config/:network/:pluginAddress` endpoint

# Frontend
aragon-app/src/shared/api/pluginsService/* (service + query hook)
aragon-app/src/plugins/harmonyVotingPlugin/components/harmonyVotingSetupMembership/harmonyDelegationMemberInfoView.tsx
aragon-app/src/plugins/harmonyVotingPlugin/index.ts (registry update)
```

#### Acceptance Criteria

- [x] Validator address displayed
- [x] Process key displayed (decoded from bytes32 if applicable)
- [x] Data loads without errors
- [x] Loading and error states handled
- [x] Responsive design maintained

---

### TASK-004: Fix Proposal Listing for DelegationVoting

**Key:** `01JK8QXYZ0004`  
**Estimate:** 3h  
**Status:** COMPLETED  
**Area:** Backend + Frontend  
**Priority:** CRITICAL

#### Description

Fix the interface type mismatch that prevents DelegationVoting proposals from appearing in the UI.

#### Implementation Steps

1. **Backend: Update `pluginDetector.ts`**
   - Ensure DelegationVoting returns `IPluginInterfaceType.harmonyDelegationVoting` (not generic `harmonyVoting`)
   - Check bytecode selectors include delegation-specific functions:
     - `validatorAddress()` selector: `0x...`
     - `processKey()` selector: `0x...`

2. **Frontend: Verify registry mappings**
   - Confirm `harmonyVotingPlugin/index.ts` registers correct interface types
   - Ensure proposal list slots are mapped for `HARMONY_DELEGATION_VOTING`

3. **Fallback mapping (if needed)**
   - Add mapping in frontend to treat `harmonyVoting` → `harmonyDelegationVoting` for legacy data

4. **Test proposal flow end-to-end**
   - Install DelegationVoting plugin
   - Create proposal
   - Verify proposal appears in list
   - Verify proposal details load

#### Files to Modify

```
# Backend
Aragon-app-backend/src/helpers/pluginDetector.ts

# Frontend
aragon-app/src/plugins/harmonyVotingPlugin/index.ts
aragon-app/src/plugins/harmonyVotingPlugin/harmonyVotingPlugin.registry.ts (if exists)
```

#### Acceptance Criteria

- [x] Backend returns `harmonyDelegationVoting` for DelegationVoting plugins
- [x] Frontend renders proposal list for DelegationVoting
- [x] Existing proposals (if any) still visible after fix
- [x] No regressions in HIP voting proposal list

---

## Execution Order

```
Phase 1: TASK-004 (Critical — Proposals)
   └── Backend pluginDetector fix
   └── Frontend registry verification
   └── E2E test

Phase 2: TASK-002 (High — processKey)
   └── Dialog UI update
   └── Transaction utils update
   └── Unit tests

Phase 3: TASK-003 (High — Validator Display)
   └── Backend endpoint (if needed)
   └── Frontend hook + component
   └── Registry integration
```

---

## Cross-Repository Checklist

### aragon-app (Frontend)

- [x] `installHarmonyVotingDialog.tsx` — Add processKey input
- [x] `prepareHarmonyVotingInstallationDialog.tsx` — Pass processKey
- [x] `harmonyVotingTransactionUtils.ts` — Use processKey param
- [x] `harmonyVotingPlugin/index.ts` — Verify registry
- [x] New: `useHarmonyValidatorConfig` query hook
- [x] New: Delegation member info Settings slot component

### Aragon-app-backend

- [x] `pluginDetector.ts` — Return specific interface type
- [x] API endpoint — Verified existing validator-config endpoint used by frontend

### AragonOSX (Subgraph) — Optional

- [ ] Verify `pluginSetupProcessor.ts` decodes processKey correctly
- [ ] Confirm `Plugin` entity has `processKey` field populated

---

## Risks & Mitigations

| Risk                            | Mitigation                                                      |
| ------------------------------- | --------------------------------------------------------------- |
| Breaking existing installations | Test with existing DelegationVoting plugins before deploy       |
| processKey format mismatch      | Validate bytes32 encoding/decoding in both frontend and backend |
| Cache issues hiding fixes       | Clear Next.js cache, test in incognito                          |
| Subgraph data inconsistency     | Backend can fallback to RPC reads via `HarmonyBackfillJob`      |

---

## Definition of Done

- [x] Custom processKey can be set during DelegationVoting installation
- [x] Validator address and processKey displayed in Settings member info
- [x] DelegationVoting proposals appear in the proposal list
- [x] All unit tests pass
- [x] No regressions in HIP voting functionality
- [ ] Changes tested on Harmony Mainnet staging

---

## Related Documents

- [PLAN-HarmonyVoting | SPRINT-001](SPRINT_001_DIAGNOSIS.md) — Parent diagnosis sprint
- [PLAN_HARMONYVOTING_FIXES.md](PLAN_HARMONYVOTING_FIXES.md) — Master plan
- [PLAN_HARMONYVOTING_FRONTEND.md](../../../aragon-app/docs/plans/PLAN_HARMONYVOTING_FRONTEND.md) — Frontend plan
- [PLAN_HARMONYVOTING_INDEXER.md](../../../Aragon-app-backend/docs/plans/PLAN_HARMONYVOTING_INDEXER.md) — Backend plan

---

**Last Updated:** 2026-02-04  
**Author:** Copilot Planning Agent
