#!/bin/bash

# Batch verification script for Harmony contracts
# Can be run in background while doing other work

set -e

CHAIN_ID=1666600000
VERIFIER="blockscout"
VERIFIER_URL="https://explorer.harmony.one/api"
ORACLE="0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1"
ALLOWLIST="0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6"

echo "=== Starting Harmony Contracts Verification ==="
echo "Chain: $CHAIN_ID"
echo "Verifier: $VERIFIER_URL"
echo ""

# Priority 1: HIP Setup (most important for users)
echo "[1/9] Verifying HarmonyHIPVotingSetup..."
forge verify-contract \
  0x08dF9f5984022D3539D505f79451938c43ed67aF \
  src/harmony/HarmonyHIPVotingSetup.sol:HarmonyHIPVotingSetup \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  --constructor-args $(cast abi-encode "constructor(address,address)" $ORACLE $ALLOWLIST) \
  || echo "Failed to verify HarmonyHIPVotingSetup"

sleep 5

# Priority 2: Delegation Setup
echo "[2/9] Verifying HarmonyDelegationVotingSetup..."
forge verify-contract \
  0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1 \
  src/harmony/HarmonyDelegationVotingSetup.sol:HarmonyDelegationVotingSetup \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  --constructor-args $(cast abi-encode "constructor(address)" $ORACLE) \
  || echo "Failed to verify HarmonyDelegationVotingSetup"

sleep 5

# Priority 3: Allowlist Proxy
echo "[3/9] Verifying HIPPluginAllowlist Proxy..."
forge verify-contract \
  0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6 \
  src/harmony/HIPPluginAllowlist.sol:HIPPluginAllowlist \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  --constructor-args $(cast abi-encode "constructor(address)" 0x700cBBB4881D286628ca9aD3d9DF390D9c0840a2) \
  || echo "Failed to verify HIPPluginAllowlist Proxy"

sleep 5

# Priority 4: HIP Implementation
echo "[4/9] Verifying HarmonyHIPVotingPlugin Implementation..."
forge verify-contract \
  0x96CF3f105d1C8b784d51852D5dbF11c8389Ec1ec \
  src/harmony/HarmonyHIPVotingPlugin.sol:HarmonyHIPVotingPlugin \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  --constructor-args $(cast abi-encode "constructor(address)" $ORACLE) \
  || echo "Failed to verify HarmonyHIPVotingPlugin Implementation"

sleep 5

# Priority 5: Delegation Implementation
echo "[5/9] Verifying HarmonyDelegationVotingPlugin Implementation..."
forge verify-contract \
  0xa107be98B1517890b9bB9E3C0f3a5746499e8866 \
  src/harmony/HarmonyDelegationVotingPlugin.sol:HarmonyDelegationVotingPlugin \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  --constructor-args $(cast abi-encode "constructor(address)" $ORACLE) \
  || echo "Failed to verify HarmonyDelegationVotingPlugin Implementation"

sleep 5

# Priority 6: Allowlist Implementation
echo "[6/9] Verifying HIPPluginAllowlist Implementation..."
forge verify-contract \
  0xa7872b2159521c96D53EddD9C123843953C3aDeC \
  src/harmony/HIPPluginAllowlist.sol:HIPPluginAllowlist \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  || echo "Failed to verify HIPPluginAllowlist Implementation"

sleep 5

# Priority 7: ValidatorOptInRegistry
echo "[7/9] Verifying HarmonyValidatorOptInRegistry..."
forge verify-contract \
  0xDe981B8DB1ECa238F3FBAB41e93cf4903e23d52b \
  src/harmony/HarmonyValidatorOptInRegistry.sol:HarmonyValidatorOptInRegistry \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  || echo "Failed to verify HarmonyValidatorOptInRegistry"

sleep 5

# Priority 8: HIP Plugin Repo
echo "[8/9] Verifying HarmonyHIPVotingPluginRepo..."
forge verify-contract \
  0xE51502ec20a59C6BE01809D19f06AC5e85eC3929 \
  lib/osx/packages/contracts/src/framework/plugin/repo/PluginRepo.sol:PluginRepo \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  || echo "Failed to verify HarmonyHIPVotingPluginRepo"

sleep 5

# Priority 9: Delegation Plugin Repo
echo "[9/9] Verifying HarmonyDelegationVotingPluginRepo..."
forge verify-contract \
  0xf280B3798F53155F400FD96c555F7F554A977EE7 \
  lib/osx/packages/contracts/src/framework/plugin/repo/PluginRepo.sol:PluginRepo \
  --chain-id $CHAIN_ID \
  --verifier $VERIFIER \
  --verifier-url $VERIFIER_URL \
  || echo "Failed to verify HarmonyDelegationVotingPluginRepo"

echo ""
echo "=== Verification Complete ==="
echo "Check Harmony Explorer for verification status:"
echo "https://explorer.harmony.one/address/0x08dF9f5984022D3539D505f79451938c43ed67aF"
