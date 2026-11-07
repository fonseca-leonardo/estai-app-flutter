# Integração: lembretes avulsos e motor de lembretes genérico

Guia para o backend (`estai-app` API) implementar o que o app consome na etapa 3 do Diário da Embarcação:

- **Lembretes avulsos:** avisos que não são manutenção, como "Renovar a vaga na marina" ou "Tirar o barco antes do inverno". Têm data, repetição opcional em meses e aviso por push e/ou e-mail.
- **Motor de lembretes genérico:** o motor da fase 1 (`docs/integrar-manutencao-notificacao.md` §4) passa a atender qualquer alvo: manutenção, lembrete avulso e documento (etapa 4, `docs/integrar-documentos.md`).

As convenções (base, autenticação, envelope `{data}`, formato de erro, enums em PascalCase, datas ISO UTC, escopo por usuário) são as mesmas do guia de manutenção, §1.

---

## 1. Modelo `BoatReminder`

```json
{
  "id": "rem_123",
  "boatId": "boat_1",
  "title": "Renovar a vaga na marina",
  "notes": "Levar comprovante de seguro",
  "dueDate": "2026-12-01T03:00:00.000Z",
  "recurrenceMonths": 12,
  "status": "Pending",
  "completedAt": null,
  "reminder": {
    "enabled": true,
    "daysBefore": [7, 1],
    "hoursBefore": null,
    "channels": ["Push", "Email"]
  },
  "createdAt": "2026-11-07T12:00:00.000Z",
  "updatedAt": "2026-11-07T12:00:00.000Z"
}
```

| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| `id`, `boatId`, `title` | string | sim | `title` até 120 caracteres |
| `notes` | string \| null | | até 1000 caracteres |
| `dueDate` | ISO | sim | dia escolhido pelo usuário, mesma regra de datas do guia de manutenção (§1, "Datas de vencimento") |
| `recurrenceMonths` | int \| null | | repete a cada N meses (`> 0`) |
| `status` | enum | sim | `Pending` ou `Done`. Não há `Overdue`: o app mostra o atraso pela data |
| `completedAt` | ISO \| null | | preenchido ao marcar como feito |
| `reminder` | `ReminderSettings` | sim | mesmo formato do guia de manutenção (§2.2). `hoursBefore` vem sempre `null` aqui |
| `createdAt`, `updatedAt` | ISO | sim | |

---

## 2. Endpoints

### 2.1 Listar

`GET /boats/{boatId}/reminders?status=Pending|Done&page=1&limit=50` → `200` (lista paginada de `BoatReminder`, com `items`, `total`, `page`, `limit`)

| `status` | Ordem |
|---|---|
| `Pending` | `dueDate` asc |
| `Done` | `completedAt` desc |

### 2.2 Criar

`POST /boats/{boatId}/reminders` → `201` com `{ "data": BoatReminder }`

```json
{
  "title": "Renovar a vaga na marina",
  "notes": null,
  "dueDate": "2026-12-01T03:00:00.000Z",
  "recurrenceMonths": 12,
  "reminder": { "enabled": true, "daysBefore": [7, 1], "hoursBefore": null, "channels": ["Push", "Email"] }
}
```

**Validações (`400`):**
- `title` obrigatório, até 120 caracteres.
- `dueDate` obrigatório. Pode estar no passado (lembrete esquecido); nesse caso vale a regra de atraso de §3.2.
- `recurrenceMonths > 0` se informado.
- Com `reminder.enabled`, pelo menos um canal.

**Status inicial:** `Pending`. **Efeito:** agendar os avisos (§3).

### 2.3 Editar

`PUT /reminders/{id}` → `200` com `{ "data": BoatReminder }`

- O corpo e as validações são os mesmos de §2.2. O app sempre envia o objeto completo.
- Só lembretes `Pending` são editáveis. Um `Done` responde `400`: o app só mostra o resumo e permite excluir.
- **Efeito:** cancelar os avisos pendentes e reagendar.

### 2.4 Excluir

`DELETE /reminders/{id}` → `200` ou `204`. **Efeito:** cancelar os avisos pendentes.

### 2.5 Marcar como feito

`PATCH /reminders/{id}/done` → `200`

```json
// request
{ "completedAt": "2026-11-07T15:00:00.000Z" }

// response
{
  "data": {
    "reminder": { /* BoatReminder com status Done */ },
    "next": { /* BoatReminder criado pela recorrência, ou null */ }
  }
}
```

1. Marcar como `Done`, gravar `completedAt` e cancelar os avisos pendentes.
2. Se houver `recurrenceMonths`, criar o próximo:
   - Copiar `title`, `notes`, `recurrenceMonths` e `reminder`.
   - `dueDate` = `dueDate` anterior + `recurrenceMonths`. Conta a partir da data prevista, não da conclusão, para "renovar todo dezembro" não escorregar quando o usuário marca com atraso.
   - Se esse `dueDate` ainda cair no passado, some `recurrenceMonths` de novo até cair no futuro.
   - Status `Pending`, com avisos agendados.
3. Lembrete já `Done` responde `400`.

### 2.6 Resumo do diário (alteração)

`GET /boats/{boatId}/overview` passa a trazer também:

```json
{
  "data": {
    "...": "campos existentes",
    "upcomingReminders": [ /* BoatReminder Pending, no máximo 3, por dueDate asc */ ]
  }
}
```

---

## 3. Motor de lembretes genérico

Hoje o motor (guia de manutenção, §4) agenda avisos só para manutenções. Ele passa a trabalhar com **alvos**:

| `targetType` | Data de referência | Aviso por horímetro | Aviso de atraso |
|---|---|---|---|
| `Maintenance` | `dueDate` | sim (`dueEngineHours`) | sim, e muda o status para `Overdue` |
| `Reminder` | `dueDate` | não | sim, um aviso; o status continua `Pending` |
| `Document` | `expiresAt` | não | sim, um aviso no dia seguinte ao vencimento |

### 3.1 Regras comuns (iguais às da fase 1)
- **Envio:** às **09:00 no horário local** do usuário, para cada `d` em `reminder.daysBefore` (`0` = no dia).
- **Fuso:** o `timezone` do aparelho mais recente, ou `America/Sao_Paulo`.
- **Canais efetivos:** `reminder.channels` ∩ preferências do usuário (§4.4 da fase 1).
- **Datas no passado:** ao criar ou editar, não envie avisos cuja data já passou.

### 3.2 Atraso de lembrete avulso
- Se o dia de `dueDate` passou e o lembrete continua `Pending`, envie **um** aviso de atraso (`kind = overdue`) às 09:00 do dia seguinte.
- Se o lembrete nasce já vencido, envie esse aviso na próxima janela das 09:00.

### 3.3 Idempotência
`reminder_dispatches` passa a ser genérico:

| Coluna | Observação |
|---|---|
| `target_type` | `Maintenance`, `Reminder` ou `Document` |
| `target_id` | id do alvo |
| `kind` | `days:7`, `hours`, `overdue`… |
| `channel` | `Push` ou `Email` |
| `sent_at` | |

- Chave única: (`target_type`, `target_id`, `kind`, `channel`).
- Editar o alvo limpa os registros dele.
- Migração: os registros atuais viram `target_type = Maintenance`, `target_id = maintenance_id`.

### 3.4 Push

```json
"data": { "type": "reminder", "boatId": "boat_1", "id": "rem_123" }
```

O app abre a lista de lembretes do barco, com o item destacado. Todos os valores são strings, e `boatId` é obrigatório.

### 3.5 E-mail
- **Conteúdo:** mesmo texto do push, mais a data e o nome do barco.
- **Botão:** "Ver lembrete", com o deep link `estai://boats/{boatId}/reminders/{id}`, que o app já trata. Vale a mesma observação sobre o link `https` de redirecionamento da fase 1.

### 3.6 Textos sugeridos

| `kind` | pt | en |
|---|---|---|
| `days:N` (N ≥ 2) | **Lembrete em N dias** | **Reminder in N days** |
| `days:1` | **Lembrete para amanhã** | **Reminder for tomorrow** |
| `days:0` | **Lembrete para hoje** | **Reminder for today** |
| `overdue` | **Lembrete atrasado** | **Reminder overdue** |

Corpo: `{título do lembrete} · {nome do barco}`.

---

## 4. Modelo de dados sugerido

| Tabela | Colunas principais |
|---|---|
| `boat_reminders` | `id`, `boat_id`, `user_id`, `title`, `notes`, `due_date`, `recurrence_months`, `status`, `completed_at`, `reminder_enabled`, `reminder_days_before` (int[]), `reminder_channels` (text[]), `created_at`, `updated_at`, `deleted_at` |
| `reminder_dispatches` | `target_type`, `target_id`, `kind`, `channel`, `sent_at`; único (`target_type`, `target_id`, `kind`, `channel`) |

Índices: `boat_reminders (boat_id, status, due_date)` e `boat_reminders (status, due_date)` para o job.

---

## 5. Checklist de validação com o app

1. **Diário:** a ação rápida "Lembretes" abre a lista. A seção "Lembretes" do diário mostra os 3 próximos de `overview.upcomingReminders`.
2. **Criar:** "Novo lembrete" sem data é bloqueado no app. Com data, faz o `POST` e o lembrete aparece em "Pendentes".
3. **Repetir:** criar com "Repetir a cada 12 meses" e marcar como feito. Ele vai para "Feitos" e o próximo aparece em "Pendentes", 12 meses depois da data anterior (`next` na resposta).
4. **Editar e excluir:** tocar num pendente abre a edição. Tocar num feito abre o resumo, de onde dá para excluir.
5. **Aviso:** criar com data amanhã e `daysBefore: [1]`, e forçar o job. O push chega, e tocar abre a lista com o item destacado.
6. **Atraso:** criar com data de ontem. Chega um único aviso de atraso, e o app mostra "Atrasado há 1 dia" em vermelho.
7. **Manutenções continuam iguais:** depois da migração de `reminder_dispatches`, os avisos de manutenção não duplicam nem somem.
