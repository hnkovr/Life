Baseline: 039375f9244f6b6878155b79c01eab43f94a4df1 → HEAD

Legend: + (new), * (changed), (untracked)

.
├── .ai
│   ├── [CHANGES-SCTRUCT.md](.ai/CHANGES-SCTRUCT.md) + — tree of repo changes with per-file notes
│   └── [TODO.md](.ai/TODO.md) + — release plan v0.0.2 (MVP scope/DoD/steps)
├── .claude
│   ├── [AiDevZoomcamp2025-PLAN.md](.claude/AiDevZoomcamp2025-PLAN.md) + — program plan and evaluation criteria
│   ├── [CLAUDE.md](.claude/CLAUDE.md) + — assistant runbook: structure, commands, roles, tools
│   ├── plans
│   │   └── [rustling-spinning-metcalfe.md](.claude/plans/rustling-spinning-metcalfe.md) + — incremental frontend/backlog plan
│   └── [settings.local.json](.claude/settings.local.json) + — local permissions/settings for assistant tools
├── [.envrc](.envrc) + — direnv/shdotenv loader; adds scripts/ to PATH
├── [.gitignore](.gitignore) * — ignore /.run.log and backend/db.sqlite3
├── [Justfile](Justfile) + — just recipes: link/unlink, tests, lint, web helpers
├── [Makefile](Makefile) + — make targets mirroring just tasks
├── backend
│   ├── [.env.example](backend/.env.example) + — backend env template
│   ├── [Justfile](backend/Justfile) + — backend: setup/migrate/run/test
│   ├── [README.md](backend/README.md) + — backend quickstart, endpoints, notes
│   ├── apps
│   │   ├── [__init__.py](backend/apps/__init__.py) + — apps package init
│   │   ├── authentication
│   │   │   ├── [__init__.py](backend/apps/authentication/__init__.py) + — auth app init
│   │   │   ├── [apps.py](backend/apps/authentication/apps.py) + — Django AppConfig
│   │   │   ├── migrations
│   │   │   │   └── [__init__.py](backend/apps/authentication/migrations/__init__.py) + — migrations package
│   │   │   ├── [serializers.py](backend/apps/authentication/serializers.py) + — register/login validation
│   │   │   ├── tests
│   │   │   │   ├── [test_auth.py](backend/apps/authentication/tests/test_auth.py) + — auth flow (login/refresh)
│   │   │   │   ├── [test_auth_extra.py](backend/apps/authentication/tests/test_auth_extra.py) + — extra auth edge cases
│   │   │   │   └── [test_register_validation.py](backend/apps/authentication/tests/test_register_validation.py) + — register validation
│   │   │   ├── __pycache__/... (untracked) — Python bytecode caches
│   │   │   └── [views.py](backend/apps/authentication/views.py) + — AuthView: register/login/refresh/logout
│   │   ├── tasks
│   │   │   ├── [__init__.py](backend/apps/tasks/__init__.py) + — tasks app init
│   │   │   ├── [apps.py](backend/apps/tasks/apps.py) + — Django AppConfig
│   │   │   ├── migrations
│   │   │   │   ├── [0001_initial.py](backend/apps/tasks/migrations/0001_initial.py) + — Task model migration
│   │   │   │   └── [__init__.py](backend/apps/tasks/migrations/__init__.py) + — migrations package
│   │   │   ├── [models.py](backend/apps/tasks/models.py) + — Task model (status/domain/dates)
│   │   │   ├── [serializers.py](backend/apps/tasks/serializers.py) + — Task serializers
│   │   │   ├── tests
│   │   │   │   ├── [test_filters_permissions.py](backend/apps/tasks/tests/test_filters_permissions.py) + — filters/permissions
│   │   │   │   ├── [test_permissions_unauth.py](backend/apps/tasks/tests/test_permissions_unauth.py) + — unauth access tests
│   │   │   │   └── [test_tasks.py](backend/apps/tasks/tests/test_tasks.py) + — CRUD and complete action
│   │   │   ├── __pycache__/... (untracked) — Python bytecode caches
│   │   │   └── [views.py](backend/apps/tasks/views.py) + — TaskViewSet with CRUD/complete
│   ├── life_api
│   │   ├── [__init__.py](backend/life_api/__init__.py) + — project package init
│   │   ├── [asgi.py](backend/life_api/asgi.py) + — ASGI entrypoint
│   │   ├── settings
│   │   │   ├── [__init__.py](backend/life_api/settings/__init__.py) + — settings package init
│   │   │   ├── [base.py](backend/life_api/settings/base.py) + — DRF + JWT config; SQLite dev DB
│   │   │   └── [development.py](backend/life_api/settings/development.py) + — dev overrides
│   │   ├── [urls.py](backend/life_api/urls.py) + — root urls incl. API
│   │   ├── [urls_api.py](backend/life_api/urls_api.py) + — /api routes (auth + tasks)
│   │   ├── [wsgi.py](backend/life_api/wsgi.py) + — WSGI entrypoint
│   │   └── __pycache__/... (untracked) — Python bytecode caches
│   ├── [manage.py](backend/manage.py) + — Django management script
│   ├── [pytest.ini](backend/pytest.ini) + — pytest config
│   └── [requirements.txt](backend/requirements.txt) + — backend dependencies
├── frontend
│   ├── [.env.example](frontend/.env.example) + — VITE_API_BASE_URL template
│   ├── [Justfile](frontend/Justfile) + — frontend: setup/dev/build/test
│   ├── [README.md](frontend/README.md) + — frontend usage and test docs
│   ├── [index.html](frontend/index.html) + — app entry HTML
│   ├── [package.json](frontend/package.json) + — deps and npm scripts
│   ├── [postcss.config.js](frontend/postcss.config.js) + — PostCSS config (Tailwind)
│   ├── [tailwind.config.js](frontend/tailwind.config.js) + — Tailwind config
│   ├── tests
│   │   └── [setup.ts](frontend/tests/setup.ts) + — Vitest setup (jsdom globals)
│   ├── [tsconfig.json](frontend/tsconfig.json) + — TypeScript config
│   ├── [vite.config.ts](frontend/vite.config.ts) + — Vite + Vue plugin + Vitest settings
│   ├── src
│   │   ├── [App.vue](frontend/src/App.vue) + — root component
│   │   ├── [main.ts](frontend/src/main.ts) + — app bootstrap
│   │   ├── router
│   │   │   ├── __tests__
│   │   │   │   └── [guard.test.ts](frontend/src/router/__tests__/guard.test.ts) + — auth guard tests
│   │   │   └── [index.ts](frontend/src/router/index.ts) + — router with auth guard
│   │   ├── services
│   │   │   ├── __tests__
│   │   │   │   ├── [api.test.ts](frontend/src/services/__tests__/api.test.ts) + — axios instance tests
│   │   │   │   └── [refresh.test.ts](frontend/src/services/__tests__/refresh.test.ts) + — token refresh logic tests
│   │   │   ├── [api.ts](frontend/src/services/api.ts) + — axios client with JWT + refresh
│   │   │   ├── [auth.service.ts](frontend/src/services/auth.service.ts) + — auth API wrappers
│   │   │   └── [task.service.ts](frontend/src/services/task.service.ts) + — tasks API wrappers
│   │   ├── stores
│   │   │   ├── __tests__
│   │   │   │   └── [auth.test.ts](frontend/src/stores/__tests__/auth.test.ts) + — auth store tests
│   │   │   └── [auth.ts](frontend/src/stores/auth.ts) + — Pinia auth store (JWT state)
│   │   ├── views
│   │   │   ├── __tests__
│   │   │   │   ├── [Login.test.ts](frontend/src/views/__tests__/Login.test.ts) + — login page tests
│   │   │   │   └── [Tasks.test.ts](frontend/src/views/__tests__/Tasks.test.ts) + — tasks page tests
│   │   │   ├── [Login.vue](frontend/src/views/Login.vue) + — login page
│   │   │   ├── [Register.vue](frontend/src/views/Register.vue) + — register page
│   │   │   └── [Tasks.vue](frontend/src/views/Tasks.vue) + — tasks list/form page
│   │   └── [style.css](frontend/src/style.css) + — global styles (Tailwind)
│   ├── package-lock.json (untracked) — npm lockfile (v3), reproducible installs
│   ├── vitest.config.ts (untracked) — standalone Vitest config (jsdom)
│   └── node_modules/... (untracked) — installed dependencies (gitignored)
├── scripts
│   ├── [.env-generator.sh](scripts/.env-generator.sh) + — fill empty *_PASSWORD/KEY in .env
│   ├── lib
│   │   └── [bash-utils.sh](scripts/lib/bash-utils.sh) + — logging/helpers for scripts
│   ├── [life.sh](scripts/life.sh) + — CLI to link/unlink repo into HOME; selftests
│   ├── tests
│   │   └── [life.bats](scripts/tests/life.bats) + — Bats tests for life.sh
│   └── tools
│       └── [install-bash-tools.sh](scripts/tools/install-bash-tools.sh) + — optional bash tooling installer
└── ...

