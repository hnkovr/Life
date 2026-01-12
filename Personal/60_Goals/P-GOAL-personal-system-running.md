---
type: goal
domain: personal
status: active
created: 2026-01-12
updated: 2026-01-12
horizon: 2026-01
metric: "1 goal + 1 project + 3–5 tasks + 1 weekly review; dashboards show tasks"
tags:
  - goal
---

# Личный контур: система задач/заметок работает

## Почему это важно
- Снижается трение на “зафиксировать → разобрать → сделать”.
- Появляется регулярная обратная связь через weekly review.

## Метрика / критерий успеха
- В `Personal` есть связка goal → project → tasks.
- Задачи подтягиваются на странице проекта/цели через Tasks‑запросы.
- Создан weekly review за текущую неделю.

## План
- [[P-PROJ-personal-system-bootstrap]]

## Projects
```dataview
TABLE status, updated
FROM "Personal/30_Projects"
WHERE type = "project" AND goal = this.file.link
SORT updated DESC
```

## Tasks (open)
> Привязывай задачи к этой цели, добавляя ссылку `[[P-GOAL-personal-system-running]]` в строку задачи.

```tasks
not done
path includes Personal/20_Tasks
description includes [[P-GOAL-personal-system-running]]
```

