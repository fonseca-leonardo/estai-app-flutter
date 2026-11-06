# Integração: Diário de bordo e viagens

Guia para o backend (`estai-app` API) implementar o que o app consome na etapa 2 do Diário da Embarcação:

- **Diário de bordo (logbook):** entradas por embarcação.
- **Viagens automáticas:** ao encerrar uma navegação, o app oferece salvar a viagem (trajeto, distância, duração, velocidades) como entrada do tipo `Trip`.
- **Entradas manuais:** nota, fundeio, ocorrência e evento.

As convenções (base, autenticação, envelope `{data}`, formato de erro, enums em PascalCase, datas ISO UTC, escopo por usuário) são as mesmas de `docs/integrar-manutencao-notificacao.md` §1.

---

## 1. Modelo `LogbookEntry`

```json
{
  "id": "log_123",
  "boatId": "boat_1",
  "type": "Trip",
  "title": "Navegação de 26 de out.",
  "notes": "Vento NE 12 kn, mar calmo",
  "occurredAt": "2026-10-26T13:00:00.000Z",
  "endedAt": "2026-10-26T15:30:00.000Z",
  "distanceNm": 12.35,
  "durationMinutes": 150,
  "avgSpeedKn": 4.9,
  "maxSpeedKn": 18.3,
  "startPoint": { "lat": -23.98, "lng": -46.3 },
  "endPoint": { "lat": -23.81, "lng": -45.37 },
  "track": "nnhoCnwxyGAo}@...",
  "engineHoursEnd": 250,
  "passengers": 4,
  "createdAt": "2026-10-26T15:31:00.000Z",
  "updatedAt": "2026-10-26T15:31:00.000Z"
}
```

| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| `id`, `boatId`, `title` | string | sim | `title` até 120 caracteres |
| `type` | enum | sim | `Trip`, `Note`, `Anchorage`, `Incident`, `Event` |
| `notes` | string \| null | | até 2000 caracteres |
| `occurredAt` | ISO | sim | início da viagem, ou momento do registro manual |
| `endedAt` | ISO \| null | | fim da viagem |
| `distanceNm` | number \| null | | milhas náuticas, 2 casas |
| `durationMinutes` | int \| null | | duração total, incluindo paradas |
| `avgSpeedKn`, `maxSpeedKn` | number \| null | | nós, 1 casa. Média = distância ÷ duração |
| `startPoint`, `endPoint` | `{lat, lng}` \| null | | numa entrada manual, `startPoint` é a posição registrada (ex.: fundeio) |
| `track` | string \| null | | trajeto em [Encoded Polyline](https://developers.google.com/maps/documentation/utilities/polylinealgorithm), precisão 5, já simplificado pelo app (Douglas-Peucker, ~10 m) |
| `engineHoursEnd` | number \| null | | horímetro ao fim da viagem |
| `passengers` | int \| null | | `>= 0` |
| `createdAt`, `updatedAt` | ISO | sim | |

- **`track`:** guarde a string como veio (`text`). O app decodifica para desenhar o mapa. Se o backend precisar de geometria (ex.: PostGIS para estatísticas), decodifique na entrada e guarde também como `LINESTRING`, mas devolva sempre a string.
- **Métricas:** o app manda as métricas já calculadas. O backend não precisa recalcular.

---

## 2. Endpoints

### 2.1 Listar

`GET /boats/{boatId}/logbook?page=1&limit=20&type=Trip` → `200` (lista paginada de `LogbookEntry`)

- **Ordem:** `occurredAt` desc.
- **Filtro:** `type` é opcional (um tipo por vez). Sem ele, vêm todos.
- **Paginação:** o app pagina com rolagem infinita e usa `page * limit < total` para saber se há mais.
- **`track`:** pode vir na listagem. O app não o usa na lista, então, se o payload ficar pesado, devolva `track: null` aqui e a string completa no `GET /logbook/{id}`. Avise para o app buscar o detalhe ao abrir a entrada.

### 2.2 Criar

`POST /boats/{boatId}/logbook` → `201` com `{ "data": LogbookEntry }`

Corpo: todos os campos de §1, menos `id`, `boatId`, `createdAt` e `updatedAt`. O app envia `null` explicitamente nos que não usa.

**Viagem (enviada ao encerrar a navegação):**
```json
{
  "type": "Trip",
  "title": "Navegação de 26 de out.",
  "notes": null,
  "occurredAt": "2026-10-26T13:00:00.000Z",
  "endedAt": "2026-10-26T15:30:00.000Z",
  "distanceNm": 12.35,
  "durationMinutes": 150,
  "avgSpeedKn": 4.9,
  "maxSpeedKn": 18.3,
  "startPoint": { "lat": -23.98, "lng": -46.3 },
  "endPoint": { "lat": -23.81, "lng": -45.37 },
  "track": "nnhoCnwxyGAo}@...",
  "engineHoursEnd": 250,
  "passengers": 4
}
```

**Entrada manual (ex.: fundeio com posição):**
```json
{
  "type": "Anchorage",
  "title": "Saco do Sombrio",
  "notes": "Fundo de areia, 6 m",
  "occurredAt": "2026-10-26T17:20:00.000Z",
  "endedAt": null, "distanceNm": null, "durationMinutes": null,
  "avgSpeedKn": null, "maxSpeedKn": null,
  "startPoint": { "lat": -23.9, "lng": -45.2 },
  "endPoint": null, "track": null, "engineHoursEnd": null, "passengers": null
}
```

**Validações (`400`):**
- `type` válido.
- `title` obrigatório.
- `occurredAt` presente e não no futuro (tolerância de alguns minutos para relógio).
- Se houver `endedAt`, ele deve ser ≥ `occurredAt`.
- Números `>= 0`.
- `lat` entre -90 e 90; `lng` entre -180 e 180.
- `track` até ~200 KB.

**Efeitos de uma viagem com `engineHoursEnd`:**
- Se `engineHoursEnd` for **maior** que a última leitura do barco, registre uma leitura com `source: "Trip"` e `readAt` = `endedAt`, igual a `POST /boats/{id}/engine-hours`.
- Isso atualiza `Boat.engineHours` e reavalia os lembretes e o atraso por horímetro das manutenções. Ver o guia de manutenção, §3.2 e §4.2.
- Se for menor, só grave na entrada.

**Envio pela fila offline:**
- Sem conexão, o app guarda a viagem e reenvia depois, ao reabrir o app, ao abrir o diário ou quando a sessão é renovada. A mesma viagem pode chegar horas depois do `endedAt`; aceite normalmente.
- **Reenvio:**
  - Se a resposta for `5xx` ou `401`, ou a requisição não completar, o app tenta de novo depois.
  - Se for `4xx`, o app descarta a viagem da fila.
  - Por isso, só responda `400` para dados realmente inválidos.
- **Idempotência (recomendado):** num retry após timeout, a mesma viagem pode chegar duas vezes. Trate como duplicata o mesmo `boatId` + `type: Trip` + `occurredAt` + `endedAt` e devolva a entrada existente com `200`.

### 2.3 Buscar

`GET /logbook/{id}` → `200` com `{ "data": LogbookEntry }`

### 2.4 Editar

`PUT /logbook/{id}` → `200` com `{ "data": LogbookEntry }`

- O app sempre envia o objeto completo. Mesmo corpo e validações de §2.2.
- Numa viagem, o app só deixa editar `title` e `notes` e reenvia o resto como recebeu (trajeto, métricas, horímetro).
  - O backend deve aceitar sem recalcular.
  - Não registre leitura de horímetro de novo numa edição.
- Trocar o `type` de/para `Trip` não é permitido (`400`).

### 2.5 Excluir

`DELETE /logbook/{id}` → `200` ou `204`

- Não desfaz a leitura de horímetro registrada pela viagem; ela já faz parte do histórico do motor.

### 2.6 Resumo do diário (alteração)

`GET /boats/{boatId}/overview` passa a trazer também:

```json
{
  "data": {
    "...": "campos existentes",
    "recentLogbookEntries": [ /* LogbookEntry, no máximo 3, por occurredAt desc */ ]
  }
}
```

No resumo, pode mandar `track: null` para aliviar o payload, porque o app busca a entrada completa ao abrir.

---

## 3. Modelo de dados sugerido

| Tabela | Colunas principais |
|---|---|
| `logbook_entries` | `id`, `boat_id`, `user_id`, `type`, `title`, `notes`, `occurred_at`, `ended_at`, `distance_nm`, `duration_minutes`, `avg_speed_kn`, `max_speed_kn`, `start_lat`, `start_lng`, `end_lat`, `end_lng`, `track` (text), `engine_hours_end`, `passengers`, `created_at`, `updated_at`, `deleted_at` |

- **Índices:** `logbook_entries (boat_id, occurred_at desc)` e `logbook_entries (boat_id, type, occurred_at desc)`.
- **Idempotência:** índice único parcial em `(boat_id, occurred_at, ended_at) where type = 'Trip'`.

---

## 4. Checklist de validação com o app

1. **Salvar viagem:** iniciar uma navegação, andar mais de 2 min e mais de 0,1 NM, e encerrar. O app abre "Salvar viagem no diário", e salvar faz o `POST` de §2.2 com `track` e métricas.
2. **Diário:** a viagem aparece em "Últimas entradas" (`overview`) e no Diário de bordo (`GET /boats/{id}/logbook`).
3. **Mapa:** abrir a viagem desenha o trajeto e mostra duração, distância, velocidades, horímetro e passageiros.
4. **Horímetro:** informar o horímetro final maior que o atual atualiza o horímetro do barco e cria uma leitura `Trip`.
5. **Navegação curta:** encerrar uma navegação curta não oferece salvar e não faz nenhuma chamada.
6. **Modo avião:** encerrar e salvar em modo avião mostra "Sem conexão…". Ao voltar a conexão e abrir o diário, a viagem é enviada uma única vez.
7. **Entradas manuais:** criar uma nota e um fundeio com posição faz o `POST` com `startPoint`. Editar e excluir funcionam, e o filtro por tipo envia `type`.
8. **Editar viagem:** trocar o título faz o `PUT` com o objeto completo. O trajeto continua igual.
