---
type: area
domain: work
status: active
created: 2026-01-12
updated: 2026-01-12
tags:
  - area
---

# Система работы (Obsidian+Git)

## Definition
- Поддерживать работоспособность vault (Obsidian+Git), шаблоны/плагины и ритм обзоров.

## Projects
```dataview
TABLE status, updated, goal
FROM "Work/30_Projects"
WHERE type = "project" AND area = this.file.link
SORT updated DESC
```

