# Integração: Diário da Embarcação, manutenções e notificações

Guia para o backend (`estai-app` API) implementar o que as novas telas do app consomem:

- **Diário da embarcação:** resumo do barco e horímetro.
- **Manutenções:** criar, editar, excluir, concluir e repetir.
- **Lembretes:** o backend agenda e envia por push (FCM) e/ou e-mail.
- **Dispositivos:** registro do token de push de cada aparelho.
- **Preferências de notificação** do usuário.

O app **não agenda nada localmente**. Ele envia a configuração do lembrete junto da manutenção, e o backend decide quando e por onde avisar.

---

## 1. Convenções (iguais às dos endpoints existentes)

- **Base:** `/estai-app`. Autenticação com `Authorization: Bearer {accessToken}`, o token devolvido por `GET /me`.
- **Sucesso:** a resposta vem envelopada em `{ "data": ... }`.
- **Listas paginadas:** `{ "data": { "items": [], "total": 0, "page": 1, "limit": 50 } }`.
- **Erro:** `{ "message": "texto" }` ou `{ "message": ["erro 1", "erro 2"] }`. O app junta a lista com quebra de linha. Use os status codes:
  - `400` para validação
  - `401` sem sessão
  - `404` para recurso inexistente ou de outro usuário
- **Enums** são strings em PascalCase (`Scheduled`, `Engine`, `Push`…).
- **Datas** vêm em ISO 8601 UTC (`2026-11-01T03:00:00.000Z`).
- **Números** de horas e custo são `number` (decimais permitidos).
- **Campos opcionais** podem vir `null` no corpo. O app envia `null` explicitamente em create/update.
- **Escopo:** o usuário só acessa barcos e manutenções próprios. Recurso de outro usuário responde `404`.

### Datas de vencimento

O usuário escolhe **um dia** no calendário. O app envia a meia-noite local convertida para UTC; por exemplo, 01/11/2026 em `America/Sao_Paulo` vira `2026-11-01T03:00:00.000Z`.

O backend deve tratar `dueDate` como um **dia**: converta usando o fuso do usuário (ver §4.1) antes de comparar com "hoje".

---

## 2. Modelos de resposta

### 2.1 `Maintenance`

```json
{
  "id": "mnt_123",
  "boatId": "boat_1",
  "title": "Troca de óleo do motor",
  "description": "Óleo 15W40 + filtro",
  "category": "Engine",
  "status": "Scheduled",
  "dueDate": "2026-11-01T03:00:00.000Z",
  "dueEngineHours": 250,
  "recurrenceMonths": 12,
  "recurrenceHours": 100,
  "completedAt": null,
  "completedEngineHours": null,
  "cost": null,
  "provider": "Oficina do Porto",
  "notes": null,
  "serviceOrderId": null,
  "reminder": {
    "enabled": true,
    "daysBefore": [7, 1],
    "hoursBefore": 10,
    "channels": ["Push", "Email"]
  },
  "createdAt": "2026-10-26T12:00:00.000Z",
  "updatedAt": "2026-10-26T12:00:00.000Z"
}
```

| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| `id`, `boatId`, `title` | string | sim | |
| `category` | enum | sim | `Engine`, `Hull`, `Electrical`, `Plumbing`, `Safety`, `Rigging`, `Electronics`, `Other` |
| `status` | enum | sim | `Scheduled`, `Overdue`, `Done` (ver §4.3) |
| `dueDate` | ISO \| null | * | vencimento por data |
| `dueEngineHours` | number \| null | * | vencimento por horímetro |
| `recurrenceMonths` | int \| null | | repete a cada N meses |
| `recurrenceHours` | number \| null | | repete a cada N horas de motor |
| `completedAt`, `completedEngineHours`, `cost`, `notes` | | | preenchidos ao concluir |
| `provider` | string \| null | | oficina ou responsável |
| `serviceOrderId` | string \| null | | reservado para vincular OS da marina (futuro) |
| `reminder` | `ReminderSettings` | sim | se vier ausente, o app trata como desligado |
| `createdAt`, `updatedAt` | ISO | sim | |

\* Pelo menos um entre `dueDate` e `dueEngineHours` é obrigatório. Vale o que chegar primeiro.

### 2.2 `ReminderSettings`

| Campo | Tipo | Observação |
|---|---|---|
| `enabled` | bool | |
| `daysBefore` | int[] | dias de antecedência. O app oferece `30, 15, 7, 1, 0` (`0` = no dia) |
| `hoursBefore` | int \| null | horas de antecedência para vencimento por horímetro. O app oferece `5, 10, 25, 50` |
| `channels` | enum[] | `Push`, `Email`. Pelo menos um quando `enabled` |

Quando o lembrete está desligado, o app envia `{ "enabled": false, "daysBefore": [], "hoursBefore": null, "channels": [] }`.

### 2.3 `Boat` (alteração)

Adicionar `engineHours: number | null` (última leitura) em `GET /boats` e `GET /boats/{id}`.

---

## 3. Endpoints

### 3.1 Resumo do diário

`GET /boats/{boatId}/overview` → `200`

```json
{
  "data": {
    "boatId": "boat_1",
    "engineHours": 235.5,
    "engineHoursReadAt": "2026-10-20T15:00:00.000Z",
    "overdueMaintenancesCount": 1,
    "upcomingMaintenances": [ /* Maintenance, no máximo 3 */ ]
  }
}
```

- `overdueMaintenancesCount` conta as manutenções com status `Overdue`.
- `upcomingMaintenances` traz no máximo 3 pendentes (`Scheduled` e `Overdue`), na mesma ordem de `upcoming=true` (§3.3).
- Barco sem leitura: `engineHours` e `engineHoursReadAt` vêm `null`.

### 3.2 Horímetro

`POST /boats/{boatId}/engine-hours` → `201`

```json
// request
{ "hours": 240, "readAt": "2026-10-26T18:00:00.000Z", "source": "Manual" }

// response
{ "data": { "id": "ehr_1", "boatId": "boat_1", "hours": 240, "readAt": "2026-10-26T18:00:00.000Z", "source": "Manual" } }
```

- `source`: `Manual`, `Trip` (fase 2: fim de viagem) ou `Maintenance` (ao concluir).
- **Validação:** `hours >= 0` e não menor que a última leitura do barco (`400`). O app já valida, mas o backend é a fonte da verdade.
- **Efeitos:**
  - Atualizar `Boat.engineHours`.
  - Reavaliar os lembretes por horímetro e o status `Overdue` das manutenções pendentes do barco (§4.2).

### 3.3 Listar manutenções

`GET /boats/{boatId}/maintenances?page=1&limit=50&upcoming=true|false` → `200` (lista paginada de `Maintenance`)

| `upcoming` | Status retornados | Ordem |
|---|---|---|
| `true` | `Scheduled` e `Overdue` | `dueDate` asc (sem data por último); empate por `dueEngineHours` asc |
| `false` | `Done` | `completedAt` desc |

### 3.4 Criar manutenção

`POST /boats/{boatId}/maintenances` → `201` com `{ "data": Maintenance }`

```json
{
  "title": "Troca de óleo do motor",
  "description": null,
  "category": "Engine",
  "dueDate": "2026-11-01T03:00:00.000Z",
  "dueEngineHours": 250,
  "recurrenceMonths": 12,
  "recurrenceHours": null,
  "provider": null,
  "reminder": { "enabled": true, "daysBefore": [7, 1], "hoursBefore": 10, "channels": ["Push", "Email"] },
  "completion": null
}
```

**Validações (`400`):**
- `title` obrigatório, até 120 caracteres.
- `category` válida.
- `dueDate` ou `dueEngineHours` presente, **exceto quando `completion` vier preenchido** (ver abaixo).
- `recurrenceMonths` maior que 0 se informado; `recurrenceHours` maior que 0 se informado.
- Com `reminder.enabled`, pelo menos um canal.
- `description` até 1000 caracteres.

**Status inicial:** `Scheduled`, ou `Overdue` se já nasce vencida.

**Efeito:** agendar os lembretes (§4).

#### Registrar uma manutenção já realizada

O usuário pode cadastrar manutenções que já aconteceram, para montar o histórico do barco. Nesse caso o app envia `completion` preenchido e, normalmente, sem vencimento:

```json
{
  "title": "Pintura de fundo",
  "description": null,
  "category": "Hull",
  "dueDate": null,
  "dueEngineHours": null,
  "recurrenceMonths": 12,
  "recurrenceHours": null,
  "provider": "Estaleiro Sul",
  "reminder": { "enabled": true, "daysBefore": [30, 7], "hoursBefore": null, "channels": ["Push", "Email"] },
  "completion": {
    "completedAt": "2026-03-10T03:00:00.000Z",
    "engineHours": 180,
    "cost": 3500.0,
    "notes": "Antiincrustante vermelho"
  }
}
```

| Campo de `completion` | Tipo | Obrig. | Observação |
|---|---|---|---|
| `completedAt` | ISO | sim | dia escolhido pelo usuário (mesma regra de §1); não pode ser no futuro |
| `engineHours` | number \| null | | horímetro no dia da realização |
| `cost` | number \| null | | `>= 0` |
| `notes` | string \| null | | até 1000 caracteres |

Com `completion` preenchido:

1. **Status `Done`**, com `completedAt`, `completedEngineHours` (= `engineHours`), `cost` e `notes` gravados. Nenhum lembrete é agendado para ela.
2. **Vencimento opcional:** `dueDate` e `dueEngineHours` deixam de ser obrigatórios e são gravados como vierem.
3. **Horímetro:** se `engineHours` for **maior** que a última leitura do barco, registre a leitura com `source: "Maintenance"` e `readAt` = `completedAt`. Se for menor (registro antigo), só grave `completedEngineHours`, sem mexer no horímetro do barco.
4. **Recorrência:** se for recorrente, crie a próxima ocorrência com a mesma regra de §3.7, passo 3, a partir de `completedAt` e `engineHours`.
   - Se a próxima já nascer vencida (registro antigo), ela entra como `Overdue` e segue §4.2 para o aviso de atraso.
   - A resposta continua sendo `{ "data": Maintenance }` com a manutenção concluída. O app recarrega as listas e encontra a próxima em `upcoming=true`.
5. **Lembrete:** o `reminder` enviado vale para a próxima ocorrência. Sem recorrência, o app manda `enabled: false`.

### 3.5 Editar manutenção

`PUT /maintenances/{id}` → `200` com `{ "data": Maintenance }`

- O corpo e as validações são os mesmos de §3.4. O app sempre envia o objeto completo.
- **Efeito:** cancelar os lembretes pendentes e reagendar com os novos dados. Recalcular o status.
- **Só manutenções pendentes** (`Scheduled` ou `Overdue`) são editáveis. O app envia sempre `completion: null` aqui.
  - Manutenção `Done` é registro histórico e não se edita: o app só mostra os detalhes (somente leitura) e permite excluir. `PUT` numa manutenção `Done`, ou com `completion` preenchido, responde `400`.
  - Concluir é sempre por §3.7.

### 3.6 Excluir manutenção

`DELETE /maintenances/{id}` → `200` ou `204`

- **Efeito:** cancelar os lembretes pendentes.

### 3.7 Concluir manutenção

`PATCH /maintenances/{id}/complete` → `200`

```json
// request (engineHours, cost e notes são opcionais e podem não vir)
{ "completedAt": "2026-10-26T03:00:00.000Z", "engineHours": 248, "cost": 450.0, "notes": "Filtro trocado" }

// response
{
  "data": {
    "maintenance": { /* Maintenance com status Done */ },
    "next": { /* Maintenance criada pela recorrência */ }
  }
}
```

1. Marcar a manutenção como `Done` e gravar `completedAt`, `completedEngineHours` (= `engineHours`), `cost` e `notes`. Cancelar os lembretes pendentes.
2. Se `engineHours` vier e for maior que a última leitura, registrar a leitura com `source: "Maintenance"` (§3.2).
3. Se for recorrente, criar a próxima ocorrência e devolvê-la em `next`. Sem recorrência, `next` vem `null`.
   - Copiar `title`, `description`, `category`, `provider`, `recurrence*` e `reminder`.
   - `dueDate` = dia de `completedAt` + `recurrenceMonths`, se houver.
   - `dueEngineHours` = (`engineHours` informado, ou a última leitura do barco) + `recurrenceHours`, se houver.
   - Status `Scheduled`, com lembretes agendados.
4. Manutenção já `Done` responde `400`.

### 3.8 Dispositivos (token de push)

`POST /devices` → `200` ou `201`

```json
{ "token": "fcm-token…", "platform": "ios", "locale": "pt", "timezone": "America/Sao_Paulo" }
```

- **Upsert por `token`.**
  - Se o token já existe para **outro usuário** (troca de conta no mesmo aparelho), transfira-o para o usuário atual.
  - Atualize `platform`, `locale`, `timezone` e `lastSeenAt`.
- **Chamadas repetidas:** o app chama a cada login/abertura com sessão e quando o FCM gira o token. Precisa ser idempotente.
- **Campos:**
  - `platform`: `ios` ou `android`.
  - `locale`: `pt` ou `en`, o idioma do push e do e-mail.
  - `timezone`: fuso IANA, pode vir ausente.

`DELETE /devices/{token}` (token URL-encoded) → `200`, `204` ou `404` (o app aceita os três)

- O app chama no logout, antes de limpar a sessão. Remove só o vínculo daquele aparelho.

### 3.9 Preferências de notificação

`GET /me/notification-preferences` → `200`

```json
{ "data": { "pushEnabled": true, "emailEnabled": true, "email": "usuario@exemplo.com" } }
```

- Usuário sem registro: devolver o padrão `pushEnabled: true` e `emailEnabled: true`.
- `email` é o e-mail da conta (somente leitura). O app só mostra.

`PUT /me/notification-preferences` → `200` com o mesmo formato

```json
{ "pushEnabled": false, "emailEnabled": true }
```

`POST /me/notifications/test` → `200`, `201` ou `202`

- Envia uma notificação de teste por **todos os canais ativos** do usuário: push para todos os aparelhos registrados e e-mail.
- Use o mesmo pipeline dos lembretes, para validar a integração de ponta a ponta.
- Payload do push: `data: { "type": "test" }`. O app ignora o toque, porque não há tela de destino.

---

## 4. Motor de lembretes (responsabilidade do backend)

### 4.1 Fuso e horário de envio

- **Fuso do usuário:** o `timezone` do aparelho registrado mais recentemente. Sem nenhum, use `America/Sao_Paulo`.
- **Horário:** lembretes por data saem às **09:00 no horário local** do usuário.

### 4.2 Quando disparar

| Tipo | Gatilho | Quando |
|---|---|---|
| Por data | job agendado (ex.: a cada 15 min, ou fila com `runAt`) | para cada `d` em `daysBefore`: às 09:00 do dia `dueDate − d` |
| Por horímetro | nova leitura (§3.2, §3.7) | quando `dueEngineHours − leitura atual ≤ hoursBefore` |
| Atraso | job diário às 09:00 local e cada nova leitura | quando a data passou ou `leitura atual ≥ dueEngineHours` |

- Só manutenções com status `Scheduled` ou `Overdue`, `reminder.enabled = true`, de barcos existentes.
- **Datas no passado:** ao criar ou editar, não envie os lembretes cuja data já passou. Exceção: se a manutenção nasce vencida, envie um único aviso de atraso.
- **Idempotência:** guarde cada envio em `reminder_dispatches` (`maintenanceId`, `kind` = `days:7` | `hours` | `overdue`, `channel`), com chave única. Assim retries e reavaliações não duplicam. Edição (§3.5) limpa os registros dessa manutenção.

### 4.3 Status `Overdue`

- O backend é a fonte da verdade do status.
- Um job diário, mais a reavaliação a cada leitura de horímetro, move `Scheduled` para `Overdue` quando:
  - o dia de `dueDate` (no fuso do usuário) é anterior a hoje; **ou**
  - a última leitura é maior ou igual a `dueEngineHours`.
- O app também calcula o atraso localmente para exibir, mas a contagem do resumo (`overdueMaintenancesCount`) vem do backend.

### 4.4 Canais efetivos

Canais de envio = `reminder.channels` ∩ preferências do usuário:

- **Push** só se `pushEnabled = true` e houver ao menos um aparelho registrado.
- **E-mail** só se `emailEnabled = true` e a conta tiver e-mail.

### 4.5 Push (FCM HTTP v1)

Envie para todos os tokens do usuário, com o texto no `locale` de cada aparelho:

```json
{
  "message": {
    "token": "…",
    "notification": {
      "title": "Manutenção em 7 dias",
      "body": "Troca de óleo do motor · Veleiro Azul"
    },
    "data": { "type": "maintenance", "boatId": "boat_1", "id": "mnt_123" },
    "android": { "notification": { "channel_id": "reminders" } },
    "apns": { "payload": { "aps": { "sound": "default" } } }
  }
}
```

- **Mensagem:** use mensagem do tipo **notification**, não data-only. Assim o sistema exibe o push com o app fechado.
- **`data`:** o app usa esses dados para abrir a tela de manutenções do barco, com o item destacado. Todos os valores precisam ser **strings**, e `boatId` é obrigatório.
- **Canal Android:** o canal `reminders` já é criado pelo app.
- **Tokens inválidos:** se o FCM responder `UNREGISTERED` ou `INVALID_ARGUMENT` para um token, remova o dispositivo.

### 4.6 E-mail

- **Conteúdo:** mesmo título e texto do push, mais a data e/ou horímetro de vencimento e o nome do barco.
- **Botão:** "Ver manutenção", com o deep link `estai://boats/{boatId}/maintenances/{id}`, que o app já trata.
  - Vários clientes de e-mail bloqueiam esquemas customizados. Se possível, use um link `https` que redirecione para o deep link (ou, no futuro, um universal/app link).

### 4.7 Textos sugeridos

| `kind` | pt | en |
|---|---|---|
| `days:N` (N ≥ 2) | **Manutenção em N dias** | **Maintenance due in N days** |
| `days:1` | **Manutenção amanhã** | **Maintenance due tomorrow** |
| `days:0` | **Manutenção vence hoje** | **Maintenance due today** |
| `hours` | **Faltam X h de motor para a manutenção** | **X engine hours until maintenance** |
| `overdue` | **Manutenção atrasada** | **Maintenance overdue** |

Corpo: `{título da manutenção} · {nome do barco}`.

---

## 5. Modelo de dados sugerido

| Tabela | Colunas principais |
|---|---|
| `maintenances` | `id`, `boat_id`, `user_id`, `title`, `description`, `category`, `status`, `due_date`, `due_engine_hours`, `recurrence_months`, `recurrence_hours`, `completed_at`, `completed_engine_hours`, `cost`, `provider`, `notes`, `service_order_id`, `reminder_enabled`, `reminder_days_before` (int[]), `reminder_hours_before`, `reminder_channels` (text[]), `created_at`, `updated_at`, `deleted_at` |
| `engine_hours_readings` | `id`, `boat_id`, `hours`, `read_at`, `source`, `created_at` |
| `boats` | + `engine_hours`, `engine_hours_read_at` (cache da última leitura) |
| `devices` | `token` (único), `user_id`, `platform`, `locale`, `timezone`, `last_seen_at` |
| `notification_preferences` | `user_id` (PK), `push_enabled`, `email_enabled` |
| `reminder_dispatches` | `maintenance_id`, `kind`, `channel`, `sent_at`; único (`maintenance_id`, `kind`, `channel`) |

Índices úteis: `maintenances (boat_id, status, due_date)` e `maintenances (status, due_date)` para o job.

---

## 6. Checklist de validação com o app

1. **Diário:** abrir o diário de um barco faz `GET /boats/{id}/overview`. Com dados, o card de horímetro e as "Próximas manutenções" aparecem.
2. **Horímetro:** "Atualizar" faz `POST /boats/{id}/engine-hours`. O resumo recarrega com a nova leitura, e uma leitura menor que a atual é recusada com `400`.
3. **Criar manutenção:** "Nova manutenção" sem data nem horímetro é bloqueada no app. Com data, faz `POST` e a manutenção aparece em "Próximas".
4. **Permissão e dispositivo:** ao salvar com lembrete por Push, o app pede permissão e chama `POST /devices`. O token aparece na tabela `devices`.
5. **Notificação de teste:** em Configurações → Notificações → "Enviar notificação de teste", o push chega com o app aberto, em segundo plano e fechado, e o e-mail chega.
6. **Toque no lembrete:** criar uma manutenção com vencimento amanhã e `daysBefore: [1]`, e forçar o job. O push chega, e tocar abre a lista de manutenções com o item destacado.
7. **Concluir:** concluir uma manutenção recorrente pelo app. Ela vai para "Histórico", a próxima ocorrência aparece em "Próximas", e `next` vem na resposta.
8. **Excluir:** excluir uma manutenção pela tela de edição. Os lembretes pendentes não disparam mais.
9. **Logout:** fazer logout chama `DELETE /devices/{token}`, e nenhum push chega mais naquele aparelho.
10. **Já realizada:** em "Nova manutenção", ligar "Já realizada", informar data passada e horímetro, e salvar. Ela aparece direto em "Histórico". Se estava com "Repetir" ligado, a próxima ocorrência aparece em "Próximas".
11. **Atraso por horímetro:** criar com `dueEngineHours` = leitura atual + 5 e `hoursBefore: 10`. O aviso por horímetro sai na criação ou na próxima leitura. Registrar uma leitura acima de `dueEngineHours` faz o status virar `Overdue` e o diário mostrar o alerta vermelho.
