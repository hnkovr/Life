---
type: area
domain: personal
status: active
created: 2026-01-12
updated: 2026-01-12
tags:
  - area
---

# Личная система (Obsidian+Git)

## Definition
- Поддерживать личный контур заметок/задач/целей в vault и ритм обзоров.

## Projects
```dataview
TABLE status, updated, goal
FROM "Personal/30_Projects"
WHERE type = "project" AND area = this.file.link
SORT updated DESC
```

