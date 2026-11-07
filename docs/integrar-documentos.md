# Integração: documentos, vencimentos e anexos

Guia para o backend (`estai-app` API) implementar o que o app consome na etapa 4 do Diário da Embarcação:

- **Documentos do barco:** TIE/TIEM, seguro, vistoria, licença de rádio e itens de segurança com validade (extintor, sinalizadores, coletes, balsa), no diário de cada barco.
- **Documentos pessoais:** habilitação náutica (CHA) e certificados, em "Meus documentos", na conta do usuário. Não pertencem a um barco.
- **Vencimentos:** aviso antes de vencer, pelo motor de lembretes genérico (`docs/integrar-lembretes-avulsos.md` §3, `targetType: Document`).
- **Anexos:** fotos e PDFs do documento, com upload `multipart/form-data`. O mesmo contrato será reaproveitado depois para manutenções e despesas.

As convenções (base, autenticação, envelope `{data}`, formato de erro, enums em PascalCase, datas ISO UTC, escopo por usuário) são as mesmas do guia de manutenção, §1.

---

## 1. Modelos

### 1.1 `Document`

```json
{
  "id": "doc_123",
  "boatId": "boat_1",
  "type": "Insurance",
  "title": null,
  "number": "AP-998877",
  "issuer": "Seguradora Mar",
  "issuedAt": "2026-01-10T03:00:00.000Z",
  "expiresAt": "2027-01-10T03:00:00.000Z",
  "notes": null,
  "reminder": {
    "enabled": true,
    "daysBefore": [30, 7],
    "hoursBefore": null,
    "channels": ["Push", "Email"]
  },
  "attachments": [ /* Attachment */ ],
  "createdAt": "2026-11-07T12:00:00.000Z",
  "updatedAt": "2026-11-07T12:00:00.000Z"
}
```

| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| `id`, `type` | string | sim | |
| `boatId` | string \| null | | `null` = documento pessoal |
| `title` | string \| null | | nome livre, até 120 caracteres. Vazio: o app mostra o nome do tipo |
| `number` | string \| null | | até 60 caracteres |
| `issuer` | string \| null | | órgão emissor ou seguradora, até 120 caracteres |
| `issuedAt` | ISO \| null | | emissão |
| `expiresAt` | ISO \| null | | validade. `null` = sem validade, sem avisos |
| `notes` | string \| null | | até 1000 caracteres |
| `reminder` | `ReminderSettings` | sim | formato do guia de manutenção (§2.2). Sem `expiresAt`, o app envia desligado |
| `attachments` | `Attachment[]` | sim | pode vir vazio |
| `createdAt`, `updatedAt` | ISO | sim | |

**Tipos por escopo:**

| Escopo | `type` |
|---|---|
| Barco | `Registration` (TIE/TIEM), `Insurance`, `Inspection` (vistoria), `RadioLicense`, `FireExtinguisher`, `Flares`, `LifeJackets`, `LifeRaft`, `OtherBoat` |
| Pessoal | `NauticalLicense` (CHA: Arrais-Amador, Motonauta, Mestre…), `RadioOperatorCertificate`, `OtherPersonal` |

**Status:** o app calcula pela validade e não precisa vir na API.
- `Expired`: o dia de `expiresAt` já passou.
- `ExpiringSoon`: vence em até 30 dias, inclusive hoje.
- `Valid`: vence depois disso.
- `NoExpiry`: sem `expiresAt`.

### 1.2 `Attachment`

```json
{
  "id": "att_1",
  "fileName": "apolice.pdf",
  "contentType": "application/pdf",
  "sizeBytes": 482113,
  "url": "https://files.estai.com.br/...&X-Amz-Expires=900",
  "createdAt": "2026-11-07T12:01:00.000Z"
}
```

- **`url`:** assinada e temporária (sugestão: 15 min). O app sempre busca o documento (`GET /documents/{id}`) ao abrir o detalhe, para ter URLs válidas.
- **Na listagem:** os anexos podem vir sem `url` (`null`) para aliviar o payload. O app só usa a contagem na lista.

---

## 2. Endpoints

### 2.1 Listar

| Rota | Retorna |
|---|---|
| `GET /boats/{boatId}/documents` | documentos do barco |
| `GET /me/documents` | documentos pessoais do usuário |

`200` com `{ "data": { "items": [Document] } }`, sem paginação: são poucos por barco.

Ordem sugerida: `expiresAt` asc, sem validade por último. O app reordena por urgência.

### 2.2 Criar

| Rota | Escopo |
|---|---|
| `POST /boats/{boatId}/documents` | barco |
| `POST /me/documents` | pessoal |

`201` com `{ "data": Document }`.

```json
{
  "type": "Insurance",
  "title": null,
  "number": "AP-998877",
  "issuer": "Seguradora Mar",
  "issuedAt": "2026-01-10T03:00:00.000Z",
  "expiresAt": "2027-01-10T03:00:00.000Z",
  "notes": null,
  "reminder": { "enabled": true, "daysBefore": [30, 7], "hoursBefore": null, "channels": ["Push", "Email"] }
}
```

**Validações (`400`):**
- `type` válido **e compatível com o escopo**: tipo pessoal em barco, ou de barco em `/me`, responde `400`.
- Se houver `issuedAt` e `expiresAt`, `issuedAt <= expiresAt`.
- Com `reminder.enabled`, `expiresAt` presente e pelo menos um canal.
- Limites de tamanho dos textos (§1.1).

**Efeito:** agendar os avisos por `expiresAt` (§3).

Os anexos não vão no corpo: depois de criar, o app envia cada arquivo por §2.6.

### 2.3 Buscar

`GET /documents/{id}` → `200` com `{ "data": Document }`, com as `url` dos anexos renovadas.

- Vale para documento de barco e pessoal.
- Documento de outro usuário responde `404`.

### 2.4 Editar

`PUT /documents/{id}` → `200` com `{ "data": Document }`

- O corpo e as validações são os mesmos de §2.2. O app sempre envia o objeto completo.
- Não é possível trocar o escopo: o tipo tem que continuar compatível.
- **Renovação:** o usuário renova editando `expiresAt` para a nova data.
  - **Efeito:** limpar os registros de envio do documento em `reminder_dispatches` e reagendar.

### 2.5 Excluir

`DELETE /documents/{id}` → `200` ou `204`.

**Efeitos:**
- Cancelar os avisos pendentes.
- Remover os arquivos do storage (pode ser assíncrono).

### 2.6 Anexos

**Enviar:** `POST /documents/{id}/attachments` → `201` com `{ "data": Attachment }`

- **Corpo:** `multipart/form-data`, com o arquivo no campo **`file`**. O app envia o `Content-Type` da parte (`image/jpeg`, `image/png`, `image/heic` ou `application/pdf`) e o `filename`.
- Um arquivo por requisição: o app envia em sequência e mostra o progresso.
- **Limites:**

  | Regra | Resposta |
  |---|---|
  | Até **10 MB** por arquivo | `413` |
  | JPG, PNG, HEIC ou PDF; confira pelo conteúdo, não só pela extensão | `415` |
  | Até **5 anexos** por documento | `400` |

- **Armazenamento:** S3 ou similar, numa chave privada (ex.: `users/{userId}/documents/{documentId}/{attachmentId}`). Nunca público.

**Remover:** `DELETE /documents/{id}/attachments/{attachmentId}` → `200`, `204` ou `404` (o app aceita os três).

**Falhas no meio do envio:** se um upload falhar, o documento já está salvo. O app mantém o arquivo pendente e, quando o usuário toca em "Tentar novamente", faz `PUT` do documento e reenvia só os anexos que faltaram. Não há transação entre documento e anexos.

### 2.7 Resumo do diário (alteração)

`GET /boats/{boatId}/overview` passa a trazer também:

```json
{ "data": { "...": "campos existentes", "expiringDocumentsCount": 2 } }
```

- Conta os documentos **do barco** vencidos ou que vencem em até 30 dias. Os pessoais não entram.
- Com valor maior que 0, o diário mostra o alerta âmbar "N documentos vencidos ou vencendo".

---

## 3. Avisos de vencimento

Usam o motor genérico (`docs/integrar-lembretes-avulsos.md` §3) com `targetType: Document`:

- **Antecedência:** para cada `d` em `reminder.daysBefore`, às 09:00 locais do dia `expiresAt − d`. O app sugere `[30, 7]`.
- **Vencido:** um aviso (`kind = overdue`) às 09:00 do dia seguinte ao vencimento.
- **Sem `expiresAt`, ou lembrete desligado:** nada é agendado.

### 3.1 Push

```json
"data": { "type": "document", "id": "doc_123", "boatId": "boat_1" }
```

- **Documento pessoal:** mande `boatId` vazio (`""`) ou omita.
- **Ao tocar:** o app abre o detalhe do documento pelo `id`, que é obrigatório.

### 3.2 E-mail
- **Conteúdo:** mesmo texto do push, mais a data de validade e, se houver, o nome do barco.
- **Botão:** "Ver documento". Os deep links que o app já trata são:
  - `estai://boats/{boatId}/documents/{id}` (barco)
  - `estai://me/documents/{id}` (pessoal)

### 3.3 Textos sugeridos

| `kind` | pt | en |
|---|---|---|
| `days:N` (N ≥ 2) | **Documento vence em N dias** | **Document expires in N days** |
| `days:1` | **Documento vence amanhã** | **Document expires tomorrow** |
| `days:0` | **Documento vence hoje** | **Document expires today** |
| `overdue` | **Documento vencido** | **Document expired** |

Corpo:
- Barco: `{título ou nome do tipo} · {nome do barco}`.
- Pessoal: só o título ou o nome do tipo.

---

## 4. Modelo de dados sugerido

| Tabela | Colunas principais |
|---|---|
| `documents` | `id`, `user_id`, `boat_id` (nullable), `type`, `title`, `number`, `issuer`, `issued_at`, `expires_at`, `notes`, `reminder_enabled`, `reminder_days_before` (int[]), `reminder_channels` (text[]), `created_at`, `updated_at`, `deleted_at` |
| `attachments` | `id`, `user_id`, `owner_type` (`Document`; depois `Maintenance` e `Expense`), `owner_id`, `file_name`, `content_type`, `size_bytes`, `storage_key`, `created_at`, `deleted_at` |

Índices:
- `documents (user_id, boat_id)`
- `documents (expires_at)`, para o job
- `attachments (owner_type, owner_id)`

`attachments` já nasce genérica por `owner_type`, para a etapa de anexos em manutenções e despesas usar as mesmas rotas no formato `POST /{recurso}/{id}/attachments`.

---

## 5. Checklist de validação com o app

1. **Diário do barco:** a ação rápida "Documentos" abre a lista do barco. "Novo documento" mostra só os tipos de barco.
2. **Meus documentos:** em Configurações → Conta → "Meus documentos", criar uma habilitação. Só os tipos pessoais aparecem, e o `POST` vai para `/me/documents`.
3. **Status:** um documento com validade em 10 dias aparece em "Atenção" como "Vencendo". O diário mostra o alerta, com `expiringDocumentsCount = 1`.
4. **Anexos:** adicionar uma foto da câmera, uma da galeria e um PDF, e salvar.
   - O app faz o `POST` do documento e depois 3 uploads multipart.
   - No detalhe, a foto abre em tela cheia e o PDF abre fora do app.
5. **Limites:** um arquivo acima de 10 MB é recusado no próprio app. Se mesmo assim chegar, o backend responde `413`.
6. **Falha no upload:** derrubar a rede depois de criar o documento. O app mostra "O documento foi salvo, mas alguns anexos não foram enviados". Ao voltar a rede, "Tentar novamente" envia só o que faltou, sem duplicar o documento.
7. **Remover anexo:** na edição, remover um anexo e salvar faz o `DELETE /documents/{id}/attachments/{attachmentId}`.
8. **Renovação:** editar a validade para o ano seguinte. O status volta a "Em dia" e os avisos são reagendados.
9. **Push:** com validade amanhã e `daysBefore: [1]`, forçar o job. Tocar no push abre o detalhe do documento, inclusive se for pessoal, sem `boatId`.
