# Harmony Contracts Verification Status

Date: 2026-01-16

## Update (Harmony mainnet redeploy)

New deployment addresses (pending verification):

- HIP Allowlist Proxy: `0x3653c14Ca7bef3E7B02ca04E65f6fc174D48c5C0`
- HarmonyHIPVotingSetup: `0x8D151e5021F495e23FbBC3180b4EeA1a6B251Fd0`
- HarmonyHIPVotingPluginRepo: `0x377Fa6d56066b81a7233043302B7e1569591253E`
- HarmonyDelegationVotingSetup: `0xD872C4333CF09e3794DD8e8e8d4E09C0124E830D`
- HarmonyDelegationVotingPluginRepo: `0x908a794F6e59872cB9b5Da0465a667833eEBdcFD`
- HarmonyValidatorOptInRegistry: `0x1E1F6128f1e611c6bD9696a758aF9310017C993B`

Verification status for the new deployment is **PENDING**. If Blockscout fails with
`eth_feeHistory` errors, use `--legacy` or manual verification.

---

Data: 13 de janeiro de 2026

## ✅ Verificados com Sucesso (7/9)

| Prioridade | Contrato                                           | Endereço                                     | Status      |
| ---------- | -------------------------------------------------- | -------------------------------------------- | ----------- |
| 3          | **HIPPluginAllowlist (Proxy)**                     | `0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6` | ✅ VERIFIED |
| 4          | **HarmonyHIPVotingPlugin (Implementation)**        | `0x96CF3f105d1C8b784d51852D5dbF11c8389Ec1ec` | ✅ VERIFIED |
| 5          | **HarmonyDelegationVotingPlugin (Implementation)** | `0xa107be98B1517890b9bB9E3C0f3a5746499e8866` | ✅ VERIFIED |
| 6          | **HIPPluginAllowlist (Implementation)**            | `0xa7872b2159521c96D53EddD9C123843953C3aDeC` | ✅ VERIFIED |
| 7          | **HarmonyValidatorOptInRegistry**                  | `0xDe981B8DB1ECa238F3FBAB41e93cf4903e23d52b` | ✅ VERIFIED |
| 8          | **HarmonyHIPVotingPluginRepo**                     | `0xE51502ec20a59C6BE01809D19f06AC5e85eC3929` | ✅ VERIFIED |
| 9          | **HarmonyDelegationVotingPluginRepo**              | `0xf280B3798F53155F400FD96c555F7F554A977EE7` | ✅ VERIFIED |

## ❌ Falha na Verificação (2/9)

| Prioridade | Contrato                         | Endereço                                     | Erro                     |
| ---------- | -------------------------------- | -------------------------------------------- | ------------------------ |
| 1          | **HarmonyHIPVotingSetup**        | `0x08dF9f5984022D3539D505f79451938c43ed67aF` | ❌ Path resolution error |
| 2          | **HarmonyDelegationVotingSetup** | `0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1` | ❌ Path resolution error |

### Erro nos Setup Contracts

```
Error: Failed to get standard json input
Context:
- cannot resolve file at "/mnt/d/Rede/Github/mzfshark/osx-plugin-foundry/src/harmony/HarmonyHIPVotingSetup.sol"
```

**Causa**: Os Setup contracts têm dependências complexas de imports que o Blockscout não conseguiu resolver automaticamente.

## 📋 Verificação Manual Pendente

Para completar a verificação dos 2 Setup contracts, você pode:

### Opção 1: Via Interface Web do Blockscout

1. **HarmonyHIPVotingSetup**: https://explorer.harmony.one/address/0x08dF9f5984022D3539D505f79451938c43ed67aF?activeTab=7

2. **HarmonyDelegationVotingSetup**: https://explorer.harmony.one/address/0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1?activeTab=7

**Configuração**:

- Compiler: `v0.8.17+commit.8df45f5f`
- Optimization: Enabled (200 runs)
- EVM Version: `default`

**Constructor Args** (já encodados):

- **HIPVotingSetup**: `0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1000000000000000000000000b77f685442a72701df5c92e4efca70b6469f8cc6`
- **DelegationVotingSetup**: `0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1`

### Opção 2: Via Sourcify

```bash
# Flatten dos contratos
forge flatten src/harmony/HarmonyHIPVotingSetup.sol > HarmonyHIPVotingSetup_flat.sol
forge flatten src/harmony/HarmonyDelegationVotingSetup.sol > HarmonyDelegationVotingSetup_flat.sol

# Upload em https://sourcify.dev
```

### Opção 3: Retry com forge verify-contract (manual)

```bash
# Compile primeiro para garantir cache atualizado
forge build

# HIP Setup
forge verify-contract \
  0x08dF9f5984022D3539D505f79451938c43ed67aF \
  src/harmony/HarmonyHIPVotingSetup.sol:HarmonyHIPVotingSetup \
  --chain-id 1666600000 \
  --verifier blockscout \
  --verifier-url https://explorer.harmony.one/api \
  --constructor-args 0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1000000000000000000000000b77f685442a72701df5c92e4efca70b6469f8cc6

# Delegation Setup
forge verify-contract \
  0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1 \
  src/harmony/HarmonyDelegationVotingSetup.sol:HarmonyDelegationVotingSetup \
  --chain-id 1666600000 \
  --verifier blockscout \
  --verifier-url https://explorer.harmony.one/api \
  --constructor-args 0x000000000000000000000000a55d9ef16af921b70fed1421c1d298ca5a3a18f1
```

## 🎯 Impacto

### Funcionalidade: ✅ SEM IMPACTO

- Todos os contratos estão deployados e funcionando
- A verificação é apenas para transparência/auditoria
- Setup contracts são usados apenas uma vez durante instalação do plugin

### Prioridade de Verificação Manual

1. **Alta**: HarmonyHIPVotingSetup (mais usado pelos usuários)
2. **Média**: HarmonyDelegationVotingSetup

### Contratos Críticos Já Verificados

- ✅ Ambas implementações de plugins (HIP + Delegation)
- ✅ Allowlist Proxy (controle de acesso do HIP)
- ✅ Allowlist Implementation
- ✅ ValidatorOptInRegistry
- ✅ Ambos PluginRepos

## 📊 Taxa de Sucesso: 78% (7/9)

Os contratos mais importantes para auditoria e transparência **já estão verificados**. Os Setup contracts podem ser verificados manualmente quando conveniente.
