#!/bin/bash
# Update deployed_contracts JSON files after deployment
# Usage: ./update-deployed-contracts.sh <contract_name> <address> <tx_hash> [repo]

set -e

CONTRACT_NAME=$1
ADDRESS=$2
TX_HASH=$3
REPO=${4:-"osx-plugin-foundry"}

if [ -z "$CONTRACT_NAME" ] || [ -z "$ADDRESS" ] || [ -z "$TX_HASH" ]; then
    echo "Usage: $0 <contract_name> <address> <tx_hash> [repo]"
    echo "Example: $0 HarmonyHIPVotingSetup 0x1234...5678 0xabcd...ef01"
    echo "Repo options: osx-plugin-foundry (default), AragonOSX"
    exit 1
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

if [ "$REPO" == "AragonOSX" ]; then
    JSON_FILE="AragonOSX/packages/contracts/deploy/deployed_contracts.json"
elif [ "$REPO" == "osx-plugin-foundry" ]; then
    JSON_FILE="osx-plugin-foundry/deployed_contracts_harmony.json"
else
    echo "Unknown repo: $REPO"
    exit 1
fi

echo "Updating $JSON_FILE..."
echo "Contract: $CONTRACT_NAME"
echo "Address: $ADDRESS"
echo "TxHash: $TX_HASH"

# Use jq to update the JSON
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Install with: sudo apt install jq"
    exit 1
fi

TMP_FILE=$(mktemp)

jq --arg name "$CONTRACT_NAME" \
   --arg addr "$ADDRESS" \
   --arg tx "$TX_HASH" \
   --arg ts "$TIMESTAMP" \
   '.contracts[$name].address = $addr | 
    .contracts[$name].txHash = $tx | 
    .contracts[$name] |= del(.note) |
    .generatedAt = $ts' \
   "$JSON_FILE" > "$TMP_FILE"

mv "$TMP_FILE" "$JSON_FILE"

echo "✅ Updated $CONTRACT_NAME in $JSON_FILE"
echo ""
cat "$JSON_FILE" | jq ".contracts.\"$CONTRACT_NAME\""
