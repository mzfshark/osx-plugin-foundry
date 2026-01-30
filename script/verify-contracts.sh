#!/bin/bash
# Verify all Harmony Voting Plugin contracts on Blockscout
# Run after deployment to make contracts readable on explorer

set -e

EXPLORER_URL="https://explorer.harmony.one/api"
CHAIN_ID="1666600000"

echo "========================================="
echo "Verifying Harmony Voting Plugin Contracts"
echo "========================================="
echo ""

# Load env vars
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

echo "🔍 1/6 - Verifying HIPPluginAllowlist Implementation..."
forge verify-contract \
  0xa7872b2159521c96D53EddD9C123843953C3aDeC \
  src/harmony/HIPPluginAllowlist.sol:HIPPluginAllowlist \
  --chain-id $CHAIN_ID \
  --verifier blockscout \
  --verifier-url $EXPLORER_URL \
  --watch || echo "⚠️  Verification failed or already verified"

echo ""
echo "🔍 2/6 - Verifying HIPPluginAllowlist Proxy..."
forge verify-contract \
  0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6 \
  lib/osx-commons/src/utils/deployment/proxies/ERC1967Proxy.sol:ERC1967Proxy \
  --chain-id $CHAIN_ID \
  --verifier blockscout \
  --verifier-url $EXPLORER_URL \
  --constructor-args $(cast abi-encode "constructor(address,bytes)" 0xa7872b2159521c96D53EddD9C123843953C3aDeC $(cast abi-encode "initialize(address)" 0x700cBBB4881D286628ca9aD3d9DF390D9c0840a2)) \
  --watch || echo "⚠️  Verification failed or already verified"

echo ""
echo "🔍 3/6 - Verifying HarmonyHIPVotingPlugin Implementation..."
forge verify-contract \
  0x96CF3f105d1C8b784d51852D5dbF11c8389Ec1ec \
  src/harmony/HarmonyHIPVotingPlugin.sol:HarmonyHIPVotingPlugin \
  --chain-id $CHAIN_ID \
  --verifier blockscout \
  --verifier-url $EXPLORER_URL \
  --watch || echo "⚠️  Verification failed or already verified"

echo ""
echo "🔍 4/6 - Verifying HarmonyHIPVotingSetup..."
forge verify-contract \
  0x08dF9f5984022D3539D505f79451938c43ed67aF \
  src/setup/HarmonyHIPVotingSetup.sol:HarmonyHIPVotingSetup \
  --chain-id $CHAIN_ID \
  --verifier blockscout \
  --verifier-url $EXPLORER_URL \
  --constructor-args $(cast abi-encode "constructor(address,address)" $ORACLE_ADDRESS 0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6) \
  --watch || echo "⚠️  Verification failed or already verified"

echo ""
echo "🔍 5/6 - Verifying HarmonyDelegationVotingPlugin Implementation..."
forge verify-contract \
  0xa107be98B1517890b9bB9E3C0f3a5746499e8866 \
  src/harmony/HarmonyDelegationVotingPlugin.sol:HarmonyDelegationVotingPlugin \
  --chain-id $CHAIN_ID \
  --verifier blockscout \
  --verifier-url $EXPLORER_URL \
  --watch || echo "⚠️  Verification failed or already verified"

echo ""
echo "🔍 6/6 - Verifying HarmonyDelegationVotingSetup..."
forge verify-contract \
  0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1 \
  src/setup/HarmonyDelegationVotingSetup.sol:HarmonyDelegationVotingSetup \
  --chain-id $CHAIN_ID \
  --verifier blockscout \
  --verifier-url $EXPLORER_URL \
  --constructor-args $(cast abi-encode "constructor(address)" $ORACLE_ADDRESS) \
  --watch || echo "⚠️  Verification failed or already verified"

echo ""
echo "🔍 7/7 - Verifying HarmonyValidatorOptInRegistry..."
forge verify-contract \
  0xDe981B8DB1ECa238F3FBAB41e93cf4903e23d52b \
  src/harmony/HarmonyValidatorOptInRegistry.sol:HarmonyValidatorOptInRegistry \
  --chain-id $CHAIN_ID \
  --verifier blockscout \
  --verifier-url $EXPLORER_URL \
  --watch || echo "⚠️  Verification failed or already verified"

echo ""
echo "========================================="
echo "✅ Verification process complete!"
echo "========================================="
echo ""
echo "Check contracts on explorer:"
echo "- Allowlist: https://explorer.harmony.one/address/0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6"
echo "- HIP Setup: https://explorer.harmony.one/address/0x08dF9f5984022D3539D505f79451938c43ed67aF"
echo "- HIP Repo: https://explorer.harmony.one/address/0xE51502ec20a59C6BE01809D19f06AC5e85eC3929"
echo "- Delegation Setup: https://explorer.harmony.one/address/0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1"
echo "- Delegation Repo: https://explorer.harmony.one/address/0xf280B3798F53155F400FD96c555F7F554A977EE7"
echo "- OptIn Registry: https://explorer.harmony.one/address/0xDe981B8DB1ECa238F3FBAB41e93cf4903e23d52b"
