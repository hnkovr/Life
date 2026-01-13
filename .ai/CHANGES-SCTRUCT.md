Baseline: 039375f9244f6b6878155b79c01eab43f94a4df1 → HEAD

Legend: + (new), * (changed), (untracked)

```
.
├── .ai
│   ├── CHANGES-SCTRUCT.md + — tree of repo changes with per‑file notes
│   └── TODO.md + — release plan v0.0.2 (MVP scope/DoD/steps)
├── .claude
│   ├── AiDevZoomcamp2025-PLAN.md + — program plan and evaluation criteria
│   ├── CLAUDE.md + — assistant runbook: structure, commands, roles, tools
│   ├── plans
│   │   └── rustling-spinning-metcalfe.md + — incremental frontend/backlog plan
│   └── settings.local.json + — local permissions/settings for assistant tools
├── .envrc + — direnv/shdotenv loader; adds scripts/ to PATH
├── .gitignore * — ignore /.run.log and backend/db.sqlite3
├── Justfile + — just recipes: link/unlink, tests, lint, web helpers
├── Makefile + — make targets mirroring just tasks
├── backend
│   ├── .env.example + — backend env template
│   ├── Justfile + — backend: setup/migrate/run/test
│   ├── README.md + — backend quickstart, endpoints, notes
│   ├── apps
│   │   ├── __init__.py + — apps package init
│   │   ├── authentication
│   │   │   ├── __init__.py + — auth app init
│   │   │   ├── apps.py + — Django AppConfig
│   │   │   ├── migrations
│   │   │   │   └── __init__.py + — migrations package
│   │   │   ├── serializers.py + — register/login validation
│   │   │   ├── tests
│   │   │   │   ├── test_auth.py + — auth flow (login/refresh)
│   │   │   │   ├── test_auth_extra.py + — extra auth edge cases
│   │   │   │   └── test_register_validation.py + — register validation
│   │   │   ├── __pycache__/... (untracked) — Python bytecode caches
│   │   │   └── views.py + — AuthView: register/login/refresh/logout
│   │   ├── tasks
│   │   │   ├── __init__.py + — tasks app init
│   │   │   ├── apps.py + — Django AppConfig
│   │   │   ├── migrations
│   │   │   │   ├── 0001_initial.py + — Task model migration
│   │   │   │   └── __init__.py + — migrations package
│   │   │   ├── models.py + — Task model (status/domain/dates)
│   │   │   ├── serializers.py + — Task serializers
│   │   │   ├── tests
│   │   │   │   ├── test_filters_permissions.py + — filters/permissions
│   │   │   │   ├── test_permissions_unauth.py + — unauth access tests
│   │   │   │   └── test_tasks.py + — CRUD and complete action
│   │   │   ├── __pycache__/... (untracked) — Python bytecode caches
│   │   │   └── views.py + — TaskViewSet with CRUD/complete
│   ├── life_api
│   │   ├── __init__.py + — project package init
│   │   ├── asgi.py + — ASGI entrypoint
│   │   ├── settings
│   │   │   ├── __init__.py + — settings package init
│   │   │   ├── base.py + — DRF + JWT config; SQLite dev DB
│   │   │   └── development.py + — dev overrides
│   │   ├── urls.py + — root urls incl. API
│   │   ├── urls_api.py + — /api routes (auth + tasks)
│   │   ├── wsgi.py + — WSGI entrypoint
│   │   └── __pycache__/... (untracked) — Python bytecode caches
│   ├── manage.py + — Django management script
│   ├── pytest.ini + — pytest config
│   └── requirements.txt + — backend dependencies
├── frontend
│   ├── .env.example + — VITE_API_BASE_URL template
│   ├── Justfile + — frontend: setup/dev/build/test
│   ├── README.md + — frontend usage and test docs
│   ├── index.html + — app entry HTML
│   ├── package.json + — deps and npm scripts
│   ├── postcss.config.js + — PostCSS config (Tailwind)
│   ├── tailwind.config.js + — Tailwind config
│   ├── tests
│   │   └── setup.ts + — Vitest setup (jsdom globals)
│   ├── tsconfig.json + — TypeScript config
│   ├── vite.config.ts + — Vite + Vue plugin + Vitest settings
│   ├── src
│   │   ├── App.vue + — root component
│   │   ├── main.ts + — app bootstrap
│   │   ├── router
│   │   │   ├── __tests__
│   │   │   │   └── guard.test.ts + — auth guard tests
│   │   │   └── index.ts + — router with auth guard
│   │   ├── services
│   │   │   ├── __tests__
│   │   │   │   ├── api.test.ts + — axios instance tests
│   │   │   │   └── refresh.test.ts + — token refresh logic tests
│   │   │   ├── api.ts + — axios client with JWT + refresh
│   │   │   ├── auth.service.ts + — auth API wrappers
│   │   │   └── task.service.ts + — tasks API wrappers
│   │   ├── stores
│   │   │   ├── __tests__
│   │   │   │   └── auth.test.ts + — auth store tests
│   │   │   └── auth.ts + — Pinia auth store (JWT state)
│   │   ├── views
│   │   │   ├── __tests__
│   │   │   │   ├── Login.test.ts + — login page tests
│   │   │   │   └── Tasks.test.ts + — tasks page tests
│   │   │   ├── Login.vue + — login page
│   │   │   ├── Register.vue + — register page
│   │   │   └── Tasks.vue + — tasks list/form page
│   │   └── style.css + — global styles (Tailwind)
│   ├── package-lock.json (untracked) — npm lockfile (v3), reproducible installs
│   ├── vitest.config.ts (untracked) — standalone Vitest config (jsdom)
│   └── node_modules/... (untracked) — installed dependencies (gitignored)
├── scripts
│   ├── .env-generator.sh + — fill empty *_PASSWORD/KEY in .env
│   ├── lib
│   │   └── bash-utils.sh + — logging/helpers for scripts
│   ├── life.sh + (mode +x) — CLI to link/unlink repo into HOME; selftests
│   ├── tests
│   │   └── life.bats + — Bats tests for life.sh
│   └── tools
│   │   └── install-bash-tools.sh + — optional bash tooling installer
└── ...
```
