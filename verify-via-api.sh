#!/bin/bash
# Submit flattened contracts directly via Blockscout API

BLOCKSCOUT_API="https://explorer.harmony.one/api"
CHAIN_ID=1666600000

echo "=== Submitting Flattened Contracts to Blockscout API ==="
echo ""

# Read the flattened file
HIP_SETUP_CODE=$(cat flattened/HarmonyHIPVotingSetup_flat.sol)
DELEGATION_SETUP_CODE=$(cat flattened/HarmonyDelegationVotingSetup_flat.sol)

echo "[1/2] Submitting HarmonyHIPVotingSetup..."
curl -X POST "$BLOCKSCOUT_API" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "module=contract" \
  -d "action=verifysourcecode" \
  -d "contractaddress=0x08dF9f5984022D3539D505f79451938c43ed67aF" \
  -d "sourceCode=$HIP_SETUP_CODE" \
  -d "codeformat=solidity-single-file" \
  -d "contractname=HarmonyHIPVotingSetup" \
  -d "compilerversion=v0.8.17+commit.8df45f5f" \
  -d "optimizationUsed=1" \
  -d "runs=200" \
  -d "constructorArguements=0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1000000000000000000000000b77f685442a72701df5c92e4efca70b6469f8cc6"

echo ""
echo ""
sleep 3

echo "[2/2] Submitting HarmonyDelegationVotingSetup..."
curl -X POST "$BLOCKSCOUT_API" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "module=contract" \
  -d "action=verifysourcecode" \
  -d "contractaddress=0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1" \
  -d "sourceCode=$DELEGATION_SETUP_CODE" \
  -d "codeformat=solidity-single-file" \
  -d "contractname=HarmonyDelegationVotingSetup" \
  -d "compilerversion=v0.8.17+commit.8df45f5f" \
  -d "optimizationUsed=1" \
  -d "runs=200" \
  -d "constructorArguements=0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1"

echo ""
echo ""
echo "=== Submission Complete ==="
echo "Check status in a few minutes at:"
echo "https://explorer.harmony.one/address/0x08dF9f5984022D3539D505f79451938c43ed67aF"
echo "https://explorer.harmony.one/address/0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1"
