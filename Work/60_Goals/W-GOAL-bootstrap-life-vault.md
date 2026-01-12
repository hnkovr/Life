---
type: goal
domain: work
status: active
created: 2026-01-12
updated: 2026-01-12
horizon: 2026-01
metric: "1 goal + 1 project + 3–5 tasks + 1 weekly review; dashboards show tasks"
tags:
  - goal
---

# Bootstrap: рабочая система заметок/задач

## Почему это важно
- Быстро фиксировать входящее и превращать в задачи/проекты без хаоса.
- Видеть прогресс через обзоры и дашборды.

## Метрика / критерий успеха
- Dataview и Tasks включены в Obsidian.
- Есть связка goal → project → tasks, и задачи подтягиваются в проект/цель по запросам.
- Создан первый weekly review.

## План
- [[W-PROJ-bootstrap-life-vault]]

## Projects
```dataview
TABLE status, updated
FROM "Work/30_Projects"
WHERE type = "project" AND goal = this.file.link
SORT updated DESC
```

## Tasks (open)
> Привязывай задачи к этой цели, добавляя ссылку `[[W-GOAL-bootstrap-life-vault]]` в строку задачи.

```tasks
not done
path includes Work/20_Tasks
description includes [[W-GOAL-bootstrap-life-vault]]
```

