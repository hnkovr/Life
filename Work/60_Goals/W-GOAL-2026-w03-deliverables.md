---
type: goal
domain: work
status: active
created: 2026-01-12
updated: 2026-01-12
horizon: 2026-W03
metric: "Ф3: мокапы новых интерфейсов готовы до 2026-01-14; BI core XP: вводные по историке проверены до 2026-01-13"
tags:
  - goal
---

# Deliverables недели (Work) — 2026-W03

## Почему это важно
- Упаковать требования в понятные интерфейсы/мокапы и вовремя снять риски по историке.

## Метрика / критерий успеха
- Мокапы интерфейсов Ф3 готовы и согласуемы.
- По историке есть: список недостающих рядов/качества данных, вопросы и next steps.

## План
- [[W-PROJ-f3-interface-mockups]]
- [[W-PROJ-bi-core-xp-historic-inputs]]

## Projects
```dataview
TABLE status, updated
FROM "Work/30_Projects"
WHERE type = "project" AND goal = this.file.link
SORT updated DESC
```

## Tasks (open)
> Привязывавай задачи к этой цели, добавляя ссылку `[[W-GOAL-2026-w03-deliverables]]` в строку задачи.

```tasks
not done
path includes Work/20_Tasks
description includes [[W-GOAL-2026-w03-deliverables]]
```

