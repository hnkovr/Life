---
type: area
domain: work
status: active
created: 2026-01-12
updated: 2026-01-12
tags:
  - area
---

# BI core XP

## Definition
- Интеграции аналитики и исторических рядов, проверка вводных и запуск работ.

## Projects
```dataview
TABLE status, updated, goal
FROM "Work/30_Projects"
WHERE type = "project" AND area = this.file.link
SORT updated DESC
```

