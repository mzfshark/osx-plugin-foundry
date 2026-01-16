#!/bin/bash
# Verification helper for the 2026-01-16 Harmony deployment.
# Update any placeholder addresses before running.

set -e

CHAIN_ID="1666600000"
EXPLORER_URL="https://explorer.harmony.one/api"

HIP_SETUP="0xD872C4333CF09e3794DD8e8e8d4E09C0124E830D"
DELEGATION_SETUP="0x377Fa6d56066b81a7233043302B7e1569591253E"
VALIDATOR_OPT_IN="0x9ec4D1ea72ADA189Ae81328CB80c3276C5dCbe5d"
HIP_ALLOWLIST_PROXY="0x8D151e5021F495e23FbBC3180b4EeA1a6B251Fd0"

# Optional (fill if known)
HIP_ALLOWLIST_IMPL="0x3653c14Ca7bef3E7B02ca04E65f6fc174D48c5C0"
HIP_PLUGIN_IMPL="0x3a3be5C65EDFF8Cb52df0A6fA664d83B63B177bf"
DELEGATION_PLUGIN_IMPL="0x000286acDa5757cE8fDf00dA277b875bbb635eB9"

# Required constructor args
ORACLE_ADDRESS="0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1"
ALLOWLIST_ADDRESS="$HIP_ALLOWLIST_PROXY"

echo "=== Harmony Verification (2026-01-16) ==="

if [[ -n "$HIP_SETUP" ]]; then
  echo "[1/5] Verifying HarmonyHIPVotingSetup..."
  forge verify-contract \
    "$HIP_SETUP" \
    src/setup/HarmonyHIPVotingSetup.sol:HarmonyHIPVotingSetup \
    --chain-id "$CHAIN_ID" \
    --verifier blockscout \
    --verifier-url "$EXPLORER_URL" \
    --constructor-args $(cast abi-encode "constructor(address,address)" "$ORACLE_ADDRESS" "$ALLOWLIST_ADDRESS") \
    --watch || echo "⚠️  Verification failed or already verified"
fi

echo ""
if [[ -n "$DELEGATION_SETUP" ]]; then
  echo "[2/5] Verifying HarmonyDelegationVotingSetup..."
  forge verify-contract \
    "$DELEGATION_SETUP" \
    src/setup/HarmonyDelegationVotingSetup.sol:HarmonyDelegationVotingSetup \
    --chain-id "$CHAIN_ID" \
    --verifier blockscout \
    --verifier-url "$EXPLORER_URL" \
    --constructor-args $(cast abi-encode "constructor(address)" "$ORACLE_ADDRESS") \
    --watch || echo "⚠️  Verification failed or already verified"
fi

echo ""
if [[ -n "$VALIDATOR_OPT_IN" ]]; then
  echo "[3/5] Verifying HarmonyValidatorOptInRegistry..."
  forge verify-contract \
    "$VALIDATOR_OPT_IN" \
    src/harmony/HarmonyValidatorOptInRegistry.sol:HarmonyValidatorOptInRegistry \
    --chain-id "$CHAIN_ID" \
    --verifier blockscout \
    --verifier-url "$EXPLORER_URL" \
    --watch || echo "⚠️  Verification failed or already verified"
fi

echo ""
if [[ -n "$HIP_ALLOWLIST_IMPL" ]]; then
  echo "[4/5] Verifying HIPPluginAllowlist implementation..."
  forge verify-contract \
    "$HIP_ALLOWLIST_IMPL" \
    src/harmony/HIPPluginAllowlist.sol:HIPPluginAllowlist \
    --chain-id "$CHAIN_ID" \
    --verifier blockscout \
    --verifier-url "$EXPLORER_URL" \
    --watch || echo "⚠️  Verification failed or already verified"
fi

echo ""
if [[ -n "$HIP_PLUGIN_IMPL" ]]; then
  echo "[5/5] Verifying HarmonyHIPVotingPlugin implementation..."
  forge verify-contract \
    "$HIP_PLUGIN_IMPL" \
    src/harmony/HarmonyHIPVotingPlugin.sol:HarmonyHIPVotingPlugin \
    --chain-id "$CHAIN_ID" \
    --verifier blockscout \
    --verifier-url "$EXPLORER_URL" \
    --watch || echo "⚠️  Verification failed or already verified"
fi

echo ""
if [[ -n "$DELEGATION_PLUGIN_IMPL" ]]; then
  echo "[6/6] Verifying HarmonyDelegationVotingPlugin implementation..."
  forge verify-contract \
    "$DELEGATION_PLUGIN_IMPL" \
    src/harmony/HarmonyDelegationVotingPlugin.sol:HarmonyDelegationVotingPlugin \
    --chain-id "$CHAIN_ID" \
    --verifier blockscout \
    --verifier-url "$EXPLORER_URL" \
    --watch || echo "⚠️  Verification failed or already verified"
fi

if [[ -z "$HIP_PLUGIN_IMPL" || -z "$DELEGATION_PLUGIN_IMPL" || -z "$HIP_ALLOWLIST_IMPL" ]]; then
  echo ""
  echo "Note: Some implementation addresses are missing. Fill them before verifying those contracts."
fi
