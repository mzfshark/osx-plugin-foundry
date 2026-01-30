#!/bin/bash
# Check verification status for all contracts

ADDRESSES=(
  "0x08dF9f5984022D3539D505f79451938c43ed67aF:HarmonyHIPVotingSetup"
  "0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1:HarmonyDelegationVotingSetup"
  "0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6:HIPPluginAllowlist_Proxy"
  "0x96CF3f105d1C8b784d51852D5dbF11c8389Ec1ec:HarmonyHIPVotingPlugin_Impl"
  "0xa107be98B1517890b9bB9E3C0f3a5746499e8866:HarmonyDelegationVotingPlugin_Impl"
  "0xa7872b2159521c96D53EddD9C123843953C3aDeC:HIPPluginAllowlist_Impl"
  "0xDe981B8DB1ECa238F3FBAB41e93cf4903e23d52b:HarmonyValidatorOptInRegistry"
  "0xE51502ec20a59C6BE01809D19f06AC5e85eC3929:HarmonyHIPVotingPluginRepo"
  "0xf280B3798F53155F400FD96c555F7F554A977EE7:HarmonyDelegationVotingPluginRepo"
)

echo "=== Checking Verification Status on Harmony Explorer ==="
echo ""

for addr_name in "${ADDRESSES[@]}"; do
  IFS=':' read -r addr name <<< "$addr_name"
  echo "[$name]"
  echo "Address: $addr"
  echo "URL: https://explorer.harmony.one/address/$addr"
  
  # Check via API if contract is verified
  response=$(curl -s "https://explorer.harmony.one/api?module=contract&action=getsourcecode&address=$addr")
  
  if echo "$response" | grep -q '"SourceCode":""'; then
    echo "Status: ❌ NOT VERIFIED"
  elif echo "$response" | grep -q '"ABI":"Contract source code not verified"'; then
    echo "Status: ❌ NOT VERIFIED"
  elif echo "$response" | grep -q '"SourceCode"'; then
    echo "Status: ✅ VERIFIED"
  else
    echo "Status: ⏳ UNKNOWN (check manually)"
  fi
  
  echo ""
  sleep 1
done

echo "=== Check Complete ==="
