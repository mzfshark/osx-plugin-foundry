# Troubleshooting: Falha na Instalação do Plugin Delegation

## Problema Identificado

**Transação**: `0x4ec6bd4954519bb02b3862763e54e2a34a358fb33010e9ab207799e7c904c7b4`
**Erro**: `PluginRepoNonexistent()`
**Causa**: Frontend está usando endereço INCORRETO do plugin repo

### Análise da Transação

```
Função chamada: prepareInstallation()
Endereço usado: 0xACcA531400E43aBF8d4DD778D4e63465d27b0D47 ❌
Endereço correto: 0xf280B3798F53155F400FD96c555F7F554A977EE7 ✅

Erro retornado: PluginRepoNonexistent()
```

O `PluginSetupProcessor` consultou o PluginRepoRegistry e não encontrou o plugin repo no endereço `0xACcA...D47` (que parece ser de testnet ou outro plugin antigo).

---

## Causa Raiz

O `networkDefinitions.ts` **JÁ TEM O ENDEREÇO CORRETO**:

```typescript
harmonyPlugins: {
    delegationVotingPluginRepo: '0xf280B3798F53155F400FD96c555F7F554A977EE7', // ✅ CORRETO
    // ...
}
```

**Mas o frontend está usando um endereço antigo/cached.**

### Possíveis Causas:

1. **Cache do Browser**: App carregou dados antigos do localStorage/sessionStorage
2. **Build Cache**: Next.js cache não foi limpo após atualização
3. **Dados Salvos**: DAO/Plugin config salvo localmente com endereço antigo
4. **ENV vars antigas**: Variáveis de ambiente não atualizadas

---

## Soluções

### Solução 1: Limpar Cache do App (Recomendado)

No navegador onde o app está rodando:

```
1. Abra DevTools (F12)
2. Application/Storage → Local Storage → Clear All
3. Session Storage → Clear All
4. Hard Refresh (Ctrl+Shift+R ou Cmd+Shift+R)
5. Tente instalar plugin novamente
```

### Solução 2: Rebuild do Frontend

No terminal do frontend:

```bash
cd aragon-app

# Limpar cache do Next.js
rm -rf .next
rm -rf node_modules/.cache

# Rebuild
pnpm build

# Restart dev server
pnpm dev
```

### Solução 3: Verificar Variáveis de Ambiente

Verifique se há variáveis de ambiente override:

```bash
# aragon-app/.env.local ou .env
grep -i "DELEGATION\|PLUGIN" .env*
```

Se houver endereços antigos, remova ou atualize.

### Solução 4: Instalar Via Contract Direto

Se o frontend continuar com problemas, instale manualmente via cast:

```bash
# Construir os parametros de instalação
PLUGIN_REPO="0xf280B3798F53155F400FD96c555F7F554A977EE7"
DAO_ADDRESS="<seu_dao_address>"
VALIDATOR_ADDRESS="<seu_validator_address>"

# Encode installation params (validatorAddress)
INSTALL_PARAMS=$(cast abi-encode "f(address)" $VALIDATOR_ADDRESS)

# Chamar prepareInstallation via PluginSetupProcessor
cast send 0x6300477942944d2501db08cD5b7e37DC6423E77C \
  "prepareInstallation(address,(((uint8,uint16),address),bytes))" \
  $DAO_ADDRESS \
  "((1,1),$PLUGIN_REPO,$INSTALL_PARAMS)" \
  --rpc-url https://api.harmony.one \
  --private-key <your_key> \
  --legacy \
  --gas-price 100000000000 \
  --gas-limit 5000000
```

---

## Verificação

### Confirmar Endereço Correto Registrado

```bash
# Verificar se plugin repo está registrado
cast call 0x24416Fcd035314C952A16549b47E8251aCdd844E \
  "entries(address)(uint256)" \
  0xf280B3798F53155F400FD96c555F7F554A977EE7 \
  --rpc-url https://api.harmony.one
```

**Resultado esperado**: Um número > 0 (número de versões)

### Verificar Última Versão do Plugin Repo

```bash
cast call 0xf280B3798F53155F400FD96c555F7F554A977EE7 \
  "latestRelease()(uint8)" \
  --rpc-url https://api.harmony.one
```

**Resultado esperado**: `1` (release 1, version 1.1)

---

## Endereços Corretos (Referência)

**Delegation Voting Plugin:**

- Plugin Repo: `0xf280B3798F53155F400FD96c555F7F554A977EE7`
- Setup Contract: `0xaAc7608C92Dd9570c2715EE9C079096347Fb0cF1`
- Implementation: `0xa107be98B1517890b9bB9E3C0f3a5746499e8866`

**HIP Voting Plugin:**

- Plugin Repo: `0xE51502ec20a59C6BE01809D19f06AC5e85eC3929`
- Setup Contract: `0x08dF9f5984022D3539D505f79451938c43ed67aF`
- Implementation: `0x96CF3f105d1C8b784d51852D5dbF11c8389Ec1ec`

**Outros Contratos:**

- PluginSetupProcessor: `0x6300477942944d2501db08cD5b7e37DC6423E77C`
- PluginRepoRegistry: `0x24416Fcd035314C952A16549b47E8251aCdd844E`
- ValidatorOptInRegistry: `0xDe981B8DB1ECa238F3FBAB41e93cf4903e23d52b`
- HIPPluginAllowlist: `0xb77F685442A72701df5c92E4EFCA70B6469F8Cc6`

---

## Próximos Passos

1. **Limpar cache do browser** (Solução 1)
2. **Tentar instalar novamente** via frontend
3. Se falhar novamente com mesmo erro → **Rebuild frontend** (Solução 2)
4. Se continuar falhando → **Instalar via cast** (Solução 4)
5. **Reportar** qual solução funcionou para debug do frontend

---

## Notas Importantes

⚠️ O plugin **Delegation Voting** requer o parâmetro `validatorAddress` durante instalação. Certifique-se de:

1. Fornecer um endereço de validador válido da Harmony
2. O validador deve existir no staking contract
3. O validador pode estar ou não no OptInRegistry (não é obrigatório para Delegation, apenas para HIP)

✅ Após instalação bem-sucedida, você verá um novo plugin instalado no DAO via:

```bash
cast call <DAO_ADDRESS> "plugins()(address[])" --rpc-url https://api.harmony.one
```

## Delegation Voting Notes (English)

- **Weight source**: `hmyv2_getValidatorInformationByBlockNumber` from https://api.harmony.one using the
  `validatorAddress` and the snapshot block.
- **Snapshot rule**: The final snapshot uses the last epoch after `endDate` (backend computes
  `snapshotEpoch = endEpoch - 2`).
- **On-chain write**: Merkle root and voting power are submitted only after `endDate`.
- **Token**: Native token stake (address `0x0000000000000000000000000000000000000000`).

## FAQ (English)

**Q: Why does the snapshot use `endEpoch - 2`?**

A: The backend computes `endEpoch` from the last block at or before `endDate`. The snapshot uses the
penultimate epoch to avoid inconsistencies during epoch transitions and to ensure stable delegation
data when finalizing the vote.

**Q: Do intermediate snapshots affect the final tally?**

A: No. Intermediate snapshots are UI-only. The Merkle root and voting power are written on-chain only
after `endDate`.
