# Harmony API Reference — HarmonyVoting Plugins

**Source:** https://api.hmny.io/  
**Docs:** https://docs.harmony.one/home/developers/api/methods/staking-related-methods  
**Created:** 2026-01-28

---

## Overview

This document provides API reference for the Harmony Node API methods needed to implement HarmonyVoting plugin functionality (validators, delegators, staking power).

---

## RPC Endpoints

### Mainnet

```
https://api.harmony.one
https://api.s0.t.hmny.io  # Shard 0
https://api.s1.t.hmny.io  # Shard 1
```

### Testnet

```
https://api.s0.b.hmny.io  # Shard 0
https://api.s1.b.hmny.io  # Shard 1
```

---

## Staking-Related Methods

### 1. Get Delegations by Delegator

Returns all delegations for a given delegator address.

```bash
curl -X POST https://api.harmony.one \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "hmyv2_getDelegationsByDelegator",
    "params": ["one1...delegator_address"],
    "id": 1
  }'
```

**Response:**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    {
      "validator_address": "one1...",
      "delegator_address": "one1...",
      "amount": 1000000000000000000,
      "reward": 500000000000000,
      "undelegations": []
    }
  ]
}
```

**Use case:** DelegationVoting — list delegators for a validator, calculate voting power.

---

### 2. Get Delegations by Validator

Returns all delegations to a specific validator.

```bash
curl -X POST https://api.harmony.one \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "hmyv2_getDelegationsByValidator",
    "params": ["one1...validator_address"],
    "id": 1
  }'
```

**Response:**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    {
      "delegator_address": "one1...",
      "amount": 5000000000000000000,
      "reward": 250000000000000,
      "undelegations": []
    }
  ]
}
```

**Use case:** DelegationVoting — get all delegators for installed validator, display in UI.

---

### 3. Get Validator Information

Returns detailed information about a validator.

```bash
curl -X POST https://api.harmony.one \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "hmyv2_getValidatorInformation",
    "params": ["one1...validator_address"],
    "id": 1
  }'
```

**Response:**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "validator": {
      "address": "one1...",
      "name": "Validator Name",
      "identity": "keybase_id",
      "website": "https://...",
      "details": "Description",
      "commission": {
        "rate": "0.100000000000000000",
        "max_rate": "0.500000000000000000",
        "max_change_rate": "0.050000000000000000"
      },
      "min_self_delegation": 10000000000000000000,
      "max_total_delegation": 1000000000000000000000
    },
    "current_epoch_performance": {
      "current_epoch_signing_percent": {
        "current_epoch_signed": 100,
        "current_epoch_to_sign": 100
      }
    },
    "total_delegation": 50000000000000000000000,
    "epos_status": "currently elected",
    "active_status": "active"
  }
}
```

**Use case:** NativeTokenVoting & DelegationVoting — display validator info, verify eligibility.

---

### 4. Get All Validator Information

Returns information for all validators (paginated).

```bash
curl -X POST https://api.harmony.one \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "hmyv2_getAllValidatorInformation",
    "params": [0],
    "id": 1
  }'
```

**Use case:** HIPVoting — allowlist validators, build validator selector UI.

---

### 5. Get Staking Network Info

Returns overall staking network statistics.

```bash
curl -X POST https://api.harmony.one \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "hmyv2_getStakingNetworkInfo",
    "params": [],
    "id": 1
  }'
```

**Response:**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "total-supply": "12600000000.000000000000000000",
    "circulating-supply": "10500000000.000000000000000000",
    "epoch-last-block": 12345678,
    "total-staking": 4500000000000000000000000000,
    "median-raw-stake": 1000000000000000000000000
  }
}
```

**Use case:** Display network stats, calculate quorum thresholds.

---

### 6. Get Balance (for ONE token)

```bash
curl -X POST https://api.harmony.one \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "hmyv2_getBalance",
    "params": ["one1...address"],
    "id": 1
  }'
```

**Use case:** NativeTokenVoting — calculate voting power from ONE balance.

---

## SDKs

| Language       | Repository                              | Notes                    |
| -------------- | --------------------------------------- | ------------------------ |
| **JavaScript** | https://github.com/harmony-one/sdk      | Recommended for frontend |
| **Golang**     | https://github.com/harmony-one/go-sdk   | CLI tools                |
| **Python**     | https://github.com/harmony-one/pyhmy    | Scripts/backend          |
| **Java**       | https://github.com/harmony-one/harmonyj | Android apps             |

### JavaScript SDK Usage

```javascript
const { Harmony } = require("@harmony-js/core");
const { ChainID, ChainType } = require("@harmony-js/utils");

const hmy = new Harmony("https://api.harmony.one", {
  chainType: ChainType.Harmony,
  chainId: ChainID.HmyMainnet,
});

// Get delegations
const delegations = await hmy.blockchain.getDelegationsByDelegator({
  delegatorAddress: "one1...",
});

// Get validator info
const validatorInfo = await hmy.blockchain.getValidatorInformation({
  validatorAddress: "one1...",
});
```

---

## Integration Points

### DelegationVoting Plugin

| Feature                | API Method                        | Notes                     |
| ---------------------- | --------------------------------- | ------------------------- |
| Get validator details  | `hmyv2_getValidatorInformation`   | On install, display in UI |
| List delegators        | `hmyv2_getDelegationsByValidator` | Show members list         |
| Calculate voting power | `hmyv2_getDelegationsByValidator` | Sum delegation amounts    |
| Verify eligibility     | `hmyv2_getValidatorInformation`   | Check `epos_status`       |

### NativeTokenVoting Plugin

| Feature              | API Method                        | Notes                  |
| -------------------- | --------------------------------- | ---------------------- |
| Get user balance     | `hmyv2_getBalance`                | Voting power = balance |
| Check staking status | `hmyv2_getDelegationsByDelegator` | Include staked amount? |

### HIPVoting Plugin

| Feature             | API Method                         | Notes                     |
| ------------------- | ---------------------------------- | ------------------------- |
| List all validators | `hmyv2_getAllValidatorInformation` | For allowlist management  |
| Verify validator    | `hmyv2_getValidatorInformation`    | Before allowlist approval |

---

## Address Format

Harmony uses two address formats:

| Format               | Example          | Usage              |
| -------------------- | ---------------- | ------------------ |
| **one1...** (bech32) | `one1a2b3c4d...` | Display, API calls |
| **0x...** (hex)      | `0x1234abcd...`  | Smart contracts    |

### Conversion

```javascript
const { toBech32, fromBech32 } = require("@harmony-js/crypto");

// Hex to Bech32
const oneAddress = toBech32("0x1234...");

// Bech32 to Hex
const hexAddress = fromBech32("one1...");
```

---

## Rate Limits & Best Practices

1. **Cache responses** — Validator info doesn't change often
2. **Batch requests** — Use `hmyv2_getAllValidatorInformation` instead of individual calls
3. **Use websockets** — For real-time updates (if available)
4. **Handle errors** — API may return errors for invalid addresses

---

## Related Files

| File                                                    | Purpose                  |
| ------------------------------------------------------- | ------------------------ |
| `osx-plugin-foundry/src/harmony/*.sol`                  | Contract implementations |
| `aragon-app/src/shared/constants/networkDefinitions.ts` | RPC endpoints config     |
| `Aragon-app-backend/src/services/*`                     | Backend API integration  |
