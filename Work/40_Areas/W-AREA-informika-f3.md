---
type: area
domain: work
status: active
created: 2026-01-12
updated: 2026-01-12
tags:
  - area
---

# Informika — Ф3

## Definition
- Работы по фазе 3: публичный портфель (кейсы), события и аналитика; подготовка мокапов/интерфейсов.

## Projects
```dataview
TABLE status, updated, goal
FROM "Work/30_Projects"
WHERE type = "project" AND area = this.file.link
SORT updated DESC
```

