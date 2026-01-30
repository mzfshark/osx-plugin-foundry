#!/bin/bash
# Verify contracts using Sourcify

echo "=== Verifying via Sourcify ==="
echo "Sourcify supports flattened files better than Blockscout"
echo ""

# HarmonyHIPVotingSetup
echo "[1/2] Verifying HarmonyHIPVotingSetup..."
forge verify-contract \
  0x08dF9f5984022D3539D505f79451938c43ed67aF \
  src/setup/HarmonyHIPVotingSetup.sol:HarmonyHIPVotingSetup \
  --chain-id 1666600000 \
  --verifier sourcify \
  --constructor-args 0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1000000000000000000000000b77f685442a72701df5c92e4efca70b6469f8cc6 \
  || echo "Failed - try manual upload to https://sourcify.dev"

echo ""
sleep 3

# HarmonyDelegationVotingSetup  
echo "[2/2] Verifying HarmonyDelegationVotingSetup..."
forge verify-contract \
  0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1 \
  src/setup/HarmonyDelegationVotingSetup.sol:HarmonyDelegationVotingSetup \
  --chain-id 1666600000 \
  --verifier sourcify \
  --constructor-args 0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1 \
  || echo "Failed - try manual upload to https://sourcify.dev"

echo ""
echo "=== If automatic verification failed ==="
echo "Upload manually at: https://sourcify.dev"
echo "Flattened files available in: flattened/"
