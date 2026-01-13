# Deploy Guide - Harmony Voting Plugins

Este guia cobre o deploy dos plugins Harmony (HIP e Delegator) com as novas features:

- HarmonyDelegationVotingPlugin com `validatorAddress` storage configurável
- HIPPluginAllowlist para controle de acesso ao HIP plugin
- NativeTokenVotingPlugin (em AragonOSX)

## Pré-requisitos

### osx-plugin-foundry (Harmony Plugins)

1. Configurar `.env` na raiz do repo:

```bash
DEPLOYMENT_PRIVATE_KEY=<sua_private_key>
PLUGIN_REPO_FACTORY_ADDRESS=0x753e32a799F319d25aCf138b343003ce0A5171eB
PLUGIN_REPO_MAINTAINER_ADDRESS=<endereço_do_maintainer>
ORACLE_ADDRESS=<endereço_do_oracle_backend>
MANAGEMENT_DAO_ADDRESS=0x8f9a805603B6fd5df7e8d284CA66CcaF77C3BeF6
NETWORK_NAME=harmony
HARMONY_MAINNET_RPC=https://api.harmony.one
```

2. Instalar dependências:

```bash
forge install
```

3. Compilar:

```bash
forge build
```

### AragonOSX (NativeTokenVoting)

1. Configurar `.env` em `AragonOSX/packages/contracts`:

```bash
ETH_KEY=<sua_private_key>
HARMONY_MAINNET_RPC=https://api.harmony.one
```

2. Instalar dependências:

```bash
cd AragonOSX/packages/contracts
yarn install
```

## Deploy - osx-plugin-foundry

### 1. Deploy Harmony Voting Plugins

```bash
cd osx-plugin-foundry

forge script script/DeployHarmonyVotingRepos.s.sol \
  --rpc-url $HARMONY_MAINNET_RPC \
  --broadcast \
  --verify \
  --etherscan-api-key <sua_api_key> # opcional
```

**Contratos deployados:**

- `HIPPluginAllowlist` (implementation + UUPS proxy)
- `HarmonyHIPVotingSetup`
- `HarmonyHIPVotingPluginRepo`
- `HarmonyDelegationVotingSetup`
- `HarmonyDelegationVotingPluginRepo`
- `HarmonyValidatorOptInRegistry`

Após deploy, os endereços serão salvos em:
`artifacts/deployment-harmony-voting-harmony-<timestamp>.json`

### 2. Atualizar deployed_contracts_harmony.json

Usar o script helper para atualizar cada contrato:

```bash
./script/update-deployed-contracts.sh HIPPluginAllowlist <address> <tx_hash>
./script/update-deployed-contracts.sh HarmonyHIPVotingSetup <address> <tx_hash>
# ... repita para cada contrato
```

Ou manualmente editar `deployed_contracts_harmony.json`.

### 3. Permitir DAOs no HIPPluginAllowlist

O HIP plugin é restrito por padrão. Para permitir um DAO usar o HIP:

```bash
# Via cast (CLI)
cast send <ALLOWLIST_PROXY_ADDRESS> \
  "allowDAO(address)" \
  <DAO_ADDRESS> \
  --rpc-url $HARMONY_MAINNET_RPC \
  --private-key $MANAGEMENT_DAO_SIGNER_KEY
```

Ou criar uma proposal no ManagementDAO com a action:

```
target: <ALLOWLIST_PROXY_ADDRESS>
function: allowDAO(address)
params: [<DAO_ADDRESS>]
```

### 4. Configurar Oracle Backend

No backend (Aragon-app-backend), atualizar `.env`:

```bash
HARMONY_VOTING_FINALIZER_TARGETS='[
  {
    "network": "harmonyMainnet",
    "pluginAddress": "<HIP_PLUGIN_REPO_ADDRESS>",
    "mode": "validators",
    "electedOnly": true,
    "fromBlock": <block_number>,
    "optInRegistryAddress": "<OPT_IN_REGISTRY_ADDRESS>",
    "optInFromBlock": <block_number>
  },
  {
    "network": "harmonyMainnet",
    "pluginAddress": "<DELEGATION_PLUGIN_REPO_ADDRESS>",
    "mode": "delegators",
    "fromBlock": <block_number>
  }
]'
```

**Nota:** Para Delegation mode, o `validatorAddress` será lido automaticamente do contrato se não fornecido na config.

## Deploy - AragonOSX (NativeTokenVoting)

### 1. Deploy via Hardhat

```bash
cd AragonOSX/packages/contracts

yarn deploy:harmony
```

Ou deploy específico do NativeTokenVoting:

```bash
yarn hardhat deploy \
  --network harmony \
  --tags NativeTokenVoting
```

### 2. Verificar deployment

```bash
yarn hardhat verify --network harmony <CONTRACT_ADDRESS>
```

### 3. Registrar plugin repo

O script já registra no PluginRepoFactory automaticamente. Após deploy, atualizar `deployed_contracts.json` com os endereços.

## Verificação Pós-Deploy

### osx-plugin-foundry

1. **HIPPluginAllowlist:**

```bash
cast call <ALLOWLIST_PROXY_ADDRESS> \
  "isDAOAllowed(address)(bool)" \
  <DAO_ADDRESS> \
  --rpc-url $HARMONY_MAINNET_RPC
```

2. **HarmonyDelegationVoting:**

```bash
cast call <PLUGIN_ADDRESS> \
  "validatorAddress()(address)" \
  --rpc-url $HARMONY_MAINNET_RPC
```

3. **Permissões:**

```bash
# Verificar UPDATE_VALIDATOR_PERMISSION no Delegator
cast call <PLUGIN_ADDRESS> \
  "UPDATE_VALIDATOR_PERMISSION_ID()(bytes32)" \
  --rpc-url $HARMONY_MAINNET_RPC
```

### AragonOSX

1. **NativeTokenVoting:**

```bash
cast call <PLUGIN_ADDRESS> \
  "minProposerVotingPower()(uint256)" \
  --rpc-url $HARMONY_MAINNET_RPC
```

## Estrutura de Arquivos Deployados

```
osx-plugin-foundry/
  ├── deployed_contracts_harmony.json  # Estado de deploy
  ├── artifacts/
  │   └── deployment-harmony-voting-harmony-*.json  # Resultado de cada deploy
  └── script/
      ├── DeployHarmonyVotingRepos.s.sol
      └── update-deployed-contracts.sh

AragonOSX/packages/contracts/
  ├── deploy/deployed_contracts.json  # Estado de deploy
  └── deploy/new/30_native-token-voting/
      └── 00_native-token-voting.ts  # Script de deploy
```

## Troubleshooting

### Erro: "DAO_NOT_AUTHORIZED" no HIP setup

- Verificar se o DAO foi adicionado ao allowlist via `allowDAO()`
- Confirmar que o ManagementDAO é o owner do allowlist

### Erro: "INVALID_VALIDATOR_ADDRESS" no Delegator setup

- Verificar que o `validatorAddress` não é `address(0)`
- Confirmar formato dos installation params (abi.encode)

### Erro: "transaction underpriced" (Harmony)

- Aumentar `HARMONY_GAS_PRICE` no `.env`
- Exemplo: `HARMONY_GAS_PRICE=30000000000` (30 gwei)

### Backend não lê validatorAddress

- Verificar que o plugin foi deployado com a nova versão (com storage)
- Confirmar que o RPC endpoint está acessível
- Checar logs do finalizer: `docker logs -f service-aragon-indexer`

## Próximos Passos

1. **Frontend:** Implementar UI de setup para Delegator (input validator address)
2. **Frontend:** Desabilitar HIP no fluxo padrão (mostrar como disabled)
3. **Frontend:** Criar módulo harmonyVotingProposal (vote dialog, proposal details)
4. **Testes:** Aumentar coverage backend (harmonyRpc.ts, harmonySnapshot.ts)
5. **Docs:** Documentar diferença HIP vs Delegator para usuários finais
