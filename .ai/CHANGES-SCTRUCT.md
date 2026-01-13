Baseline: 039375f9244f6b6878155b79c01eab43f94a4df1 → HEAD

Legend: (new), (changed), (untracked)

```
.
├── .ai
│   ├── CHANGES-SCTRUCT.md (new) — tree of repo changes with per‑file notes
│   └── TODO.md (new) — release plan v0.0.2 (MVP scope/DoD/steps)
├── .claude
│   ├── AiDevZoomcamp2025-PLAN.md (new) — program plan and evaluation criteria
│   ├── CLAUDE.md (new) — assistant runbook: structure, commands, roles, tools
│   ├── plans
│   │   └── rustling-spinning-metcalfe.md (new) — incremental frontend/backlog plan
│   └── settings.local.json (new) — local permissions/settings for assistant tools
├── .envrc (new) — direnv/shdotenv loader; adds scripts/ to PATH
├── .gitignore (changed) — ignore /.run.log and backend/db.sqlite3
├── Justfile (new) — just recipes: link/unlink, tests, lint, web helpers
├── Makefile (new) — make targets mirroring just tasks
├── backend
│   ├── .env.example (new) — backend env template
│   ├── Justfile (new) — backend: setup/migrate/run/test
│   ├── README.md (new) — backend quickstart, endpoints, notes
│   ├── apps
│   │   ├── __init__.py (new) — apps package init
│   │   ├── authentication
│   │   │   ├── __init__.py (new) — auth app init
│   │   │   ├── apps.py (new) — Django AppConfig
│   │   │   ├── migrations
│   │   │   │   └── __init__.py (new) — migrations package
│   │   │   ├── serializers.py (new) — register/login validation
│   │   │   ├── tests
│   │   │   │   ├── test_auth.py (new) — auth flow (login/refresh)
│   │   │   │   ├── test_auth_extra.py (new) — extra auth edge cases
│   │   │   │   └── test_register_validation.py (new) — register validation
│   │   │   ├── __pycache__/... (untracked) — Python bytecode caches
│   │   │   └── views.py (new) — AuthView: register/login/refresh/logout
│   │   ├── tasks
│   │   │   ├── __init__.py (new) — tasks app init
│   │   │   ├── apps.py (new) — Django AppConfig
│   │   │   ├── migrations
│   │   │   │   ├── 0001_initial.py (new) — Task model migration
│   │   │   │   └── __init__.py (new) — migrations package
│   │   │   ├── models.py (new) — Task model (status/domain/dates)
│   │   │   ├── serializers.py (new) — Task serializers
│   │   │   ├── tests
│   │   │   │   ├── test_filters_permissions.py (new) — filters/permissions
│   │   │   │   ├── test_permissions_unauth.py (new) — unauth access tests
│   │   │   │   └── test_tasks.py (new) — CRUD and complete action
│   │   │   ├── __pycache__/... (untracked) — Python bytecode caches
│   │   │   └── views.py (new) — TaskViewSet with CRUD/complete
│   ├── life_api
│   │   ├── __init__.py (new) — project package init
│   │   ├── asgi.py (new) — ASGI entrypoint
│   │   ├── settings
│   │   │   ├── __init__.py (new) — settings package init
│   │   │   ├── base.py (new) — DRF + JWT config; SQLite dev DB
│   │   │   └── development.py (new) — dev overrides
│   │   ├── urls.py (new) — root urls incl. API
│   │   ├── urls_api.py (new) — /api routes (auth + tasks)
│   │   ├── wsgi.py (new) — WSGI entrypoint
│   │   └── __pycache__/... (untracked) — Python bytecode caches
│   ├── manage.py (new) — Django management script
│   ├── pytest.ini (new) — pytest config
│   └── requirements.txt (new) — backend dependencies
├── frontend
│   ├── .env.example (new) — VITE_API_BASE_URL template
│   ├── Justfile (new) — frontend: setup/dev/build/test
│   ├── README.md (new) — frontend usage and test docs
│   ├── index.html (new) — app entry HTML
│   ├── package.json (new) — deps and npm scripts
│   ├── postcss.config.js (new) — PostCSS config (Tailwind)
│   ├── tailwind.config.js (new) — Tailwind config
│   ├── tests
│   │   └── setup.ts (new) — Vitest setup (jsdom globals)
│   ├── tsconfig.json (new) — TypeScript config
│   ├── vite.config.ts (new) — Vite + Vue plugin + Vitest settings
│   ├── src
│   │   ├── App.vue (new) — root component
│   │   ├── main.ts (new) — app bootstrap
│   │   ├── router
│   │   │   ├── __tests__
│   │   │   │   └── guard.test.ts (new) — auth guard tests
│   │   │   └── index.ts (new) — router with auth guard
│   │   ├── services
│   │   │   ├── __tests__
│   │   │   │   ├── api.test.ts (new) — axios instance tests
│   │   │   │   └── refresh.test.ts (new) — token refresh logic tests
│   │   │   ├── api.ts (new) — axios client with JWT + refresh
│   │   │   ├── auth.service.ts (new) — auth API wrappers
│   │   │   └── task.service.ts (new) — tasks API wrappers
│   │   ├── stores
│   │   │   ├── __tests__
│   │   │   │   └── auth.test.ts (new) — auth store tests
│   │   │   └── auth.ts (new) — Pinia auth store (JWT state)
│   │   ├── views
│   │   │   ├── __tests__
│   │   │   │   ├── Login.test.ts (new) — login page tests
│   │   │   │   └── Tasks.test.ts (new) — tasks page tests
│   │   │   ├── Login.vue (new) — login page
│   │   │   ├── Register.vue (new) — register page
│   │   │   └── Tasks.vue (new) — tasks list/form page
│   │   └── style.css (new) — global styles (Tailwind)
│   ├── package-lock.json (untracked) — npm lockfile (v3), reproducible installs
│   ├── vitest.config.ts (untracked) — standalone Vitest config (jsdom)
│   └── node_modules/... (untracked) — installed dependencies (gitignored)
├── scripts
│   ├── .env-generator.sh (new) — fill empty *_PASSWORD/KEY in .env
│   ├── lib
│   │   └── bash-utils.sh (new) — logging/helpers for scripts
│   ├── life.sh (new; mode +x) — CLI to link/unlink repo into HOME; selftests
│   ├── tests
│   │   └── life.bats (new) — Bats tests for life.sh
│   └── tools
│   │   └── install-bash-tools.sh (new) — optional bash tooling installer
└── ...
```
