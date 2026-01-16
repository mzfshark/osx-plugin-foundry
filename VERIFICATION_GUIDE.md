# Manual Contract Verification Guide - Harmony Explorer

Devido a limitações do Blockscout na Harmony, você pode precisar verificar os contratos manualmente via interface web.

## Status da Verificação Automática

⏳ **Verificação em andamento** via `verify-batch.sh` (rodando em background, PID 65283)

📝 Para acompanhar o progresso:

```bash
tail -f verification.log
```

## Dados Consolidados

Todos os dados de verificação estão em: `verification-data.json`

## Endereços dos Contratos

### Implementations (bytecode deployado)

- **HIPPluginAllowlist**: `0xa7872b2159521c96D53EddD9C123843953C3aDeC`
- **HarmonyHIPVotingPlugin**: `0x96CF3f105d1C8b784d51852D5dbF11c8389Ec1ec`
- **HarmonyDelegationVotingPlugin**: `0xa107be98B1517890b9bB9E3C0f3a5746499e8866`

### Setup Contracts

- **HarmonyHIPVotingSetup**: `0x08dF9f5984022D3539D505f79451938c43ed67aF`
  - Constructor: `(address _oracle, address _allowlist)`
  - Args: `0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1`, `0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6`
- **HarmonyDelegationVotingSetup**: `0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1`
  - Constructor: `(address _oracle)`
  - Args: `0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1`

### Proxies & Registries

- **HIPPluginAllowlist Proxy**: `0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6`
  - Type: ERC1967Proxy
  - Implementation: `0xa7872b2159521c96D53EddD9C123843953C3aDeC`
- **HarmonyValidatorOptInRegistry**: `0xDe981B8DB1ECa238F3FBAB41e93cf4903e23d52b`

### Plugin Repos (não precisam verificação - são proxies do OSx)

- **HarmonyHIPVotingPluginRepo**: `0xE51502ec20a59C6BE01809D19f06AC5e85eC3929`
- **HarmonyDelegationVotingPluginRepo**: `0xf280B3798F53155F400FD96c555F7F554A977EE7`

## Verificação Manual via Web

Acesse: https://explorer.harmony.one/address/<CONTRACT_ADDRESS>?activeTab=7

1. Cole o código Solidity do contrato
2. Selecione o compilador: **v0.8.17+commit.8df45f5f**
3. Ative otimização: **200 runs**
4. Para contratos com constructor args, encode usando:
   ```bash
   cast abi-encode "constructor(address,address)" 0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1 0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6
   ```

## Alternativa: Sourcify

Se o Blockscout falhar, tente Sourcify:

```bash
forge verify-contract \
  <ADDRESS> \
  <CONTRACT_PATH:CONTRACT_NAME> \
  --chain-id 1666600000 \
  --verifier sourcify
```

## Prioridade de Verificação

**Alta prioridade** (contratos que usuários irão interagir):

1. ✅ HIPPluginAllowlist Proxy - `0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6`
2. ✅ HarmonyHIPVotingSetup - `0x08dF9f5984022D3539D505f79451938c43ed67aF`
3. ✅ HarmonyDelegationVotingSetup - `0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1`

**Média prioridade** (para auditoria/transparência): 4. HarmonyHIPVotingPlugin Implementation 5. HarmonyDelegationVotingPlugin Implementation 6. HIPPluginAllowlist Implementation

**Baixa prioridade**: 7. HarmonyValidatorOptInRegistry 8. Plugin Repos (não precisam - são padrão do Aragon)

## Comandos Individuais para Retry

```bash
# Setup HIP
forge verify-contract 0x08dF9f5984022D3539D505f79451938c43ed67aF \
  src/setup/HarmonyHIPVotingSetup.sol:HarmonyHIPVotingSetup \
  --chain-id 1666600000 \
  --verifier blockscout \
  --verifier-url https://explorer.harmony.one/api \
  --constructor-args $(cast abi-encode "constructor(address,address)" 0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1 0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6)

# Setup Delegation
forge verify-contract 0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1 \
  src/setup/HarmonyDelegationVotingSetup.sol:HarmonyDelegationVotingSetup \
  --chain-id 1666600000 \
  --verifier blockscout \
  --verifier-url https://explorer.harmony.one/api \
  --constructor-args $(cast abi-encode "constructor(address)" 0xA55d9ef16Af921b70Fed1421C1D298Ca5A3a18F1)

# Allowlist Implementation
forge verify-contract 0xa7872b2159521c96D53EddD9C123843953C3aDeC \
  src/harmony/HIPPluginAllowlist.sol:HIPPluginAllowlist \
  --chain-id 1666600000 \
  --verifier blockscout \
  --verifier-url https://explorer.harmony.one/api
```
