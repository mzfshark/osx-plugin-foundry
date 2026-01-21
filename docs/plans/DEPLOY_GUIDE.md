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
PLUGIN_REPO_MAINTAINER_ADDRESS=0x700cBBB4881D286628ca9aD3d9DF390D9c0840a2  # Management DAO (recomendado para mainnet)
ORACLE_ADDRESS=0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1  # Mainnet Band Oracle
MANAGEMENT_DAO_ADDRESS=0x700cBBB4881D286628ca9aD3d9DF390D9c0840a2  # Management DAO Proxy
NETWORK_NAME=harmony
HARMONY_MAINNET_RPC=https://api.harmony.one
```

> **Nota sobre PLUGIN_REPO_MAINTAINER_ADDRESS:** Este endereço receberá permissões de manutenção (MAINTAINER_PERMISSION_ID, UPGRADE_REPO_PERMISSION_ID, ROOT_PERMISSION_ID) sobre os Plugin Repositories criados. **Recomendação:** Use o Management DAO (`0x700cBBB4881D286628ca9aD3d9DF390D9c0840a2`) para que atualizações dos plugins sejam governadas. Para testnet, pode usar uma EOA da equipe.

> **Nota sobre MANAGEMENT_DAO_ADDRESS:** Usa o mesmo endereço de `MANAGEMENT_DAO_PROXY_ADDRESS` do backend. Se não definido, o script deve usar `MANAGEMENT_DAO_PROXY_ADDRESS` como fallback.

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

````bash
cd osx-plugin-foundry

forge script script/DeployHarmonyVotingRepos.s.sol \
  --rpc-url $HARMONY_MAINNET_RPC \
  --broadcast \
  --verify \
  --etherscan-api-key <sua_api_key> # opcional

> **Note (English):** If the RPC does not support `eth_feeHistory`, rerun with `--legacy` to disable
> EIP-1559 fee estimation:
>
> ```bash
> forge script script/DeployHarmonyVotingRepos.s.sol \
>   --rpc-url $HARMONY_MAINNET_RPC \
>   --broadcast \
>   --verify \
>   --legacy
> ```
````

> **Importante:** O script usa `ORACLE_ADDRESS=0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1` (Mainnet Band Oracle). Se você quiser usar outro oracle ou o Band Adapter (`0x0A87139b65399102f5F9B9B245531CF1A04ec86d`), atualize o `.env` antes do deploy.

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

No backend (Aragon-app-backend), verificar `.env`:

```bash
# Oracle settings (já configurado no .env)
ORACLE_ADDRESS=0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1      # Mainnet Band
BAND_ADDRESS=0x0A87139b65399102f5F9B9B245531CF1A04ec86d        # Band Adapter (opcional)

# Management DAO (usado para controle do allowlist)
MANAGEMENT_DAO_PROXY_ADDRESS=0x700cBBB4881D286628ca9aD3d9DF390D9c0840a2

# Harmony Voting Finalizer Targets
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

> **Nota sobre BAND_ADDRESS:** O Band Adapter (`0x0A87139b65399102f5F9B9B245531CF1A04ec86d`) é um wrapper que expõe funções padrão de oracle (similar ao Chainlink). Use-o se o finalizer precisar de interface compatível com AggregatorV3Interface. Caso contrário, `ORACLE_ADDRESS` já é suficiente.

**Nota:** Para Delegation mode, o `validatorAddress` será lido automaticamente do contrato se não fornecido na config.

**Delegation voting data (English):** Delegation voting weights are resolved off-chain from Harmony RPC
(`hmyv2_getValidatorInformationByBlockNumber`) using the `validatorAddress` and a snapshot block derived
from `endDate`. Intermediate snapshots are for UI visibility only; the Merkle root and voting power are
written on-chain only after `endDate`.

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
