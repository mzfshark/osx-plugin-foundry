# [Plan] HarmonyVoting Plugin Fixes (osx-plugin-foundry)

This repository contains the HarmonyVoting plugins and setup contracts.

## Status Update (2026-01-29)

### The Graph Studio Limitation

**CRITICAL:** The Graph Studio registrar does **NOT** support Harmony network.  
Deployments to Studio fail with: `network not supported by registrar: no network harmony found on chain ethereum`

**Workarounds adopted:**

1. ✅ Local graph-node running via Docker (Postgres + IPFS + graph-node with Harmony RPC)
2. ✅ Subgraph build passes (`yarn build` OK, no warnings)
3. ⚠️ Alchemy Subgraphs as potential production alternative (requires investigation)

**Impact on plan:**

- Phase 4 (Subgraph) will use local graph-node for development/testing
- Production indexing may rely more heavily on backend direct event processing

---

## Scope

- Fix HarmonyDelegationVoting installation params (e.g., `processKey` and validator config)
- Ensure events/metadata required by indexers/UI are emitted
- Keep changes minimal, with tests and verification scripts updated

## Execution Checklist

### Phase 1 — Baseline & Diagnosis

- [x] Run `sudo /root/.foundry/bin/forge build -vv` ✅ (Done)
- [x] Run `sudo /root/.foundry/bin/forge test --match-contract Harmony -vvv` ✅ (Done)
- [x] Identify where `processKey` is currently sourced/hardcoded ✅ (Done — see EXECUTION_PLAN_REDHAT.md)
- [x] Identify what events are needed for backend/subgraph/UI ✅ (Done)
- [x] Subgraph build fixed (`bigint` → `BigInt`, `ts-node` → `node`) ✅
- [x] Local graph-node + IPFS + Postgres running via Docker ✅

### Phase 2 — Contract Fixes ✅ (2026-01-29)

- [x] Update `HarmonyDelegationVotingSetup` params decoding to accept user `processKey` ✅
- [x] Ensure validator address is stored and exposed (event + getter) ✅
- [x] Ensure proposal/vote events are consistent for indexing ✅
- [x] Update/extend Foundry tests for the new params/events ✅

**Test Results (6/6 passed):**

- `testProcessKeyConfiguredOnInit()`
- `test_InitialValidatorAddressStored()`
- `test_RevertWhen_SetValidatorAddressZero()`
- `test_UpdateValidatorAddressWithPermission()`
- `test_RevertWhen_UpdateValidatorWithoutPermission()`
- `test_Flow_CastThenSnapshotThenSubmitPowerThenClose()`

### Phase 3 — Verification & Handoff

- [x] Re-run tests and confirm no regressions ✅ (6/6 passed)
- [ ] Update flattened artifacts if required
- [ ] Document required addresses/events for backend/subgraph/app plans

## References

- Plan index: `docs/plans/INDEX_HARMONYVOTING.md`
- Execution plan: `docs/plans/EXECUTION_PLAN_REDHAT.md`
- Harmony API reference: `docs/plans/HARMONY_API_REFERENCE.md`
