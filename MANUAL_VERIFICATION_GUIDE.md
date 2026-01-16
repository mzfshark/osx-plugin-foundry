# Guia de Verificação Manual - Harmony Contracts

## Status Real: Apenas 2/9 Verificados ✅

### ✅ Contratos Verificados (2)

1. **HarmonyValidatorOptInRegistry**: `0xDe981B8DB1ECa238F3FBAB41e93cf4903e23d52b`
2. **HIPPluginAllowlist (Implementation)**: `0xa7872b2159521c96D53EddD9C123843953C3aDeC`

### ❌ Contratos NÃO Verificados (7)

Os demais contratos foram submetidos ao Blockscout mas a verificação falhou silenciosamente.

## Arquivos Flattened Criados

Para facilitar a verificação manual via web UI:

```
flattened/
├── HarmonyHIPVotingSetup_flat.sol (7,028 linhas)
├── HarmonyDelegationVotingSetup_flat.sol (7,036 linhas)
├── HarmonyHIPVotingPlugin_flat.sol (255K)
├── HarmonyDelegationVotingPlugin_flat.sol (257K)
└── HIPPluginAllowlist_flat.sol (241K)
```

## Prioridade de Verificação

### 🔥 ALTA PRIORIDADE (Setup Contracts - usados por usuários)

#### 1. HarmonyHIPVotingSetup

- **Endereço**: `0x08dF9f5984022D3539D505f79451938c43ed67aF`
- **URL**: https://explorer.harmony.one/address/0x08dF9f5984022D3539D505f79451938c43ed67aF?activeTab=7
- **Arquivo**: `flattened/HarmonyHIPVotingSetup_flat.sol`
- **Constructor Args**: `0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1000000000000000000000000b77f685442a72701df5c92e4efca70b6469f8cc6`

**Passos:**

1. Abra a URL acima
2. Cole o conteúdo de `flattened/HarmonyHIPVotingSetup_flat.sol`
3. Compiler: `v0.8.17+commit.8df45f5f`
4. Optimization: `Enabled` (200 runs)
5. Constructor Args: cole o hex acima
6. Clique em "Verify & Publish"

#### 2. HarmonyDelegationVotingSetup

- **Endereço**: `0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1`
- **URL**: https://explorer.harmony.one/address/0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1?activeTab=7
- **Arquivo**: `flattened/HarmonyDelegationVotingSetup_flat.sol`
- **Constructor Args**: `0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1`

**Passos:** Mesmos do contrato acima, use o constructor args correspondente.

---

### 📊 MÉDIA PRIORIDADE (Implementations)

#### 3. HarmonyHIPVotingPlugin (Implementation)

- **Endereço**: `0x96CF3f105d1C8b784d51852D5dbF11c8389Ec1ec`
- **URL**: https://explorer.harmony.one/address/0x96CF3f105d1C8b784d51852D5dbF11c8389Ec1ec?activeTab=7
- **Arquivo**: `flattened/HarmonyHIPVotingPlugin_flat.sol`
- **Constructor Args**: `0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1`

#### 4. HarmonyDelegationVotingPlugin (Implementation)

- **Endereço**: `0xa107be98B1517890b9bB9E3C0f3a5746499e8866`
- **URL**: https://explorer.harmony.one/address/0xa107be98B1517890b9bB9E3C0f3a5746499e8866?activeTab=7
- **Arquivo**: `flattened/HarmonyDelegationVotingPlugin_flat.sol`
- **Constructor Args**: `0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1`

#### 5. HIPPluginAllowlist (Proxy)

- **Endereço**: `0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6`
- **URL**: https://explorer.harmony.one/address/0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6?activeTab=7
- **Arquivo**: `flattened/HIPPluginAllowlist_flat.sol`
- **Constructor Args**: `0x000000000000000000000000700cbbb4881d286628ca9ad3d9df390d9c0840a2`

---

### 🔽 BAIXA PRIORIDADE (Plugin Repos - OSx internals)

#### 6. HarmonyHIPVotingPluginRepo

- **Endereço**: `0xE51502ec20a59C6BE01809D19f06AC5e85eC3929`
- **Nota**: Este é um contrato OSx padrão (PluginRepo), não customizado

#### 7. HarmonyDelegationVotingPluginRepo

- **Endereço**: `0xf280B3798F53155F400FD96c555F7F554A977EE7`
- **Nota**: Este é um contrato OSx padrão (PluginRepo), não customizado

---

## Configurações de Compilação

**Para TODOS os contratos:**

- Solidity Compiler: `v0.8.17+commit.8df45f5f`
- Optimization: `Enabled`
- Optimization Runs: `200`
- EVM Version: `default`

## Alternativa: Sourcify

Se o Blockscout web UI continuar falhando, use Sourcify:

1. Acesse: https://sourcify.dev
2. Upload dos arquivos flattened
3. Sourcify fará verificação cross-chain

## Script Batch (se quiser tentar novamente)

```bash
# Compile primeiro
forge build --force

# Tente verificar um por um
forge verify-contract \
  0x08dF9f5984022D3539D505f79451938c43ed67aF \
  src/setup/HarmonyHIPVotingSetup.sol:HarmonyHIPVotingSetup \
  --chain-id 1666600000 \
  --verifier blockscout \
  --verifier-url https://explorer.harmony.one/api \
  --constructor-args 0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1000000000000000000000000b77f685442a72701df5c92e4efca70b6469f8cc6
```

## Impacto da Não Verificação

- ✅ **Funcionalidade**: ZERO impacto - todos os contratos funcionam normalmente
- ⚠️ **Transparência**: Usuários e auditores não podem ver o código-fonte facilmente
- ⚠️ **Confiança**: Verificação aumenta confiança na comunidade
- ✅ **Desenvolvimento**: Não afeta desenvolvimento/testes

## Recomendação

**Verificar manualmente apenas os 2 Setup contracts (alta prioridade).**

Os outros podem ser verificados posteriormente ou deixados como estão (bytecode deployado pode ser auditado via cast/foundry mesmo sem verificação do explorer).
