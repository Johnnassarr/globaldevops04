# Solução para Erro de Paralelismo no Azure DevOps

## Erro
```
No hosted parallelism has been purchased or granted
```

## Soluções

### Opção 1: Solicitar Paralelismo Gratuito (Recomendado)

1. Acesse o formulário: https://aka.ms/azpipelines-parallelism-request
2. Preencha o formulário com:
   - Nome da organização Azure DevOps
   - Email
   - Motivo do uso
3. Aguarde aprovação (geralmente é rápida para contas acadêmicas)

### Opção 2: Usar Self-Hosted Agent

Se você tem um agente self-hosted configurado:

1. Edite `azure-pipeline.yml`
2. Altere a linha do pool de:
   ```yaml
   pool:
     vmImage: 'ubuntu-latest'
   ```
   Para:
   ```yaml
   pool:
     name: 'self-hosted-pool'  # Nome do seu pool
   ```

### Opção 3: Usar Microsoft-hosted com Paralelismo Limitado

Se você já tem paralelismo mas limitado, a pipeline já está configurada para usar apenas 1 job por vez.

## Status Atual

A pipeline está configurada para usar `ubuntu-latest` (Microsoft-hosted agent), que requer paralelismo.

**Ação necessária:** Solicite o paralelismo gratuito usando o link acima.

