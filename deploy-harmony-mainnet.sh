#!/bin/bash
# Deploy Harmony Voting Plugins to Harmony Mainnet
# Harmony requires legacy transactions (no EIP-1559)

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Harmony Voting Plugins Deployment ===${NC}"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    exit 1
fi

# Load environment variables
export $(grep -v '^#' .env | xargs)

# Validate required env vars
if [ -z "$DEPLOYMENT_PRIVATE_KEY" ]; then
    echo -e "${RED}Error: DEPLOYMENT_PRIVATE_KEY not set in .env${NC}"
    exit 1
fi

# Get current gas price
echo -e "${YELLOW}Checking Harmony mainnet gas price...${NC}"
GAS_PRICE=$(cast gas-price --rpc-url https://api.harmony.one)
echo -e "${GREEN}Current gas price: $GAS_PRICE wei ($(($GAS_PRICE / 1000000000)) Gwei)${NC}"
echo ""

# Check deployer balance
DEPLOYER_ADDRESS=$(cast wallet address --private-key "$DEPLOYMENT_PRIVATE_KEY")
BALANCE=$(cast balance "$DEPLOYER_ADDRESS" --rpc-url https://api.harmony.one)
BALANCE_ONE=$(echo "scale=4; $BALANCE / 1000000000000000000" | bc)
echo -e "${GREEN}Deployer: $DEPLOYER_ADDRESS${NC}"
echo -e "${GREEN}Balance: $BALANCE_ONE ONE${NC}"
echo ""

if (( $(echo "$BALANCE_ONE < 0.5" | bc -l) )); then
    echo -e "${RED}Warning: Balance is low (< 0.5 ONE). Deploy may fail.${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Build contracts
echo -e "${YELLOW}Building contracts...${NC}"
forge build
echo -e "${GREEN}Build complete!${NC}"
echo ""

# Deploy
echo -e "${YELLOW}Starting deployment to Harmony mainnet...${NC}"
echo -e "${YELLOW}Using legacy transactions (no EIP-1559)${NC}"
echo ""

forge script script/DeployHarmonyVotingRepos.s.sol \
  --rpc-url https://api.harmony.one \
  --private-key "$DEPLOYMENT_PRIVATE_KEY" \
  --broadcast \
  --legacy \
  --gas-price "$GAS_PRICE" \
  --verify \
  --verifier blockscout \
  --verifier-url https://explorer.harmony.one/api \
  -vvvv

DEPLOY_STATUS=$?

if [ $DEPLOY_STATUS -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Deployment completed successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Check artifacts/deployment-harmony-voting-*.json for deployed addresses"
    echo "2. Update deployed_contracts_harmony.json using:"
    echo "   ./script/update-deployed-contracts.sh <contract_name> <address> <tx_hash>"
    echo "3. Allow DAOs in HIPPluginAllowlist (Management DAO action required)"
    echo "4. Update backend HARMONY_VOTING_FINALIZER_TARGETS in .env"
else
    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}Deployment failed!${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    echo -e "${YELLOW}Common issues:${NC}"
    echo "- Transaction underpriced: Increase gas price (current: $GAS_PRICE wei)"
    echo "- Out of gas: Check deployer balance"
    echo "- RPC timeout: Try again or use different RPC endpoint"
    exit 1
fi
