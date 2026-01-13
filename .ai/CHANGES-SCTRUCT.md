Baseline: 039375f9244f6b6878155b79c01eab43f94a4df1 → HEAD

Legend: + (new), * (changed), (untracked)

<pre>
.
├── .ai
│   ├── <a href=".ai/CHANGES-SCTRUCT.md">CHANGES-SCTRUCT.md</a> + — tree of repo changes with per-file notes
│   └── <a href=".ai/TODO.md">TODO.md</a> + — release plan v0.0.2 (MVP scope/DoD/steps)
├── .claude
│   ├── <a href=".claude/AiDevZoomcamp2025-PLAN.md">AiDevZoomcamp2025-PLAN.md</a> + — program plan and evaluation criteria
│   ├── <a href=".claude/CLAUDE.md">CLAUDE.md</a> + — assistant runbook: structure, commands, roles, tools
│   ├── plans
│   │   └── <a href=".claude/plans/rustling-spinning-metcalfe.md">rustling-spinning-metcalfe.md</a> + — incremental frontend/backlog plan
│   └── <a href=".claude/settings.local.json">settings.local.json</a> + — local permissions/settings for assistant tools
├── <a href=".envrc">.envrc</a> + — direnv/shdotenv loader; adds scripts/ to PATH
├── <a href=".gitignore">.gitignore</a> * — ignore /.run.log and backend/db.sqlite3
├── <a href="Justfile">Justfile</a> + — just recipes: link/unlink, tests, lint, web helpers
├── <a href="Makefile">Makefile</a> + — make targets mirroring just tasks
├── backend
│   ├── <a href="backend/.env.example">.env.example</a> + — backend env template
│   ├── <a href="backend/Justfile">Justfile</a> + — backend: setup/migrate/run/test
│   ├── <a href="backend/README.md">README.md</a> + — backend quickstart, endpoints, notes
│   ├── apps
│   │   ├── <a href="backend/apps/__init__.py">__init__.py</a> + — apps package init
│   │   ├── authentication
│   │   │   ├── <a href="backend/apps/authentication/__init__.py">__init__.py</a> + — auth app init
│   │   │   ├── <a href="backend/apps/authentication/apps.py">apps.py</a> + — Django AppConfig
│   │   │   ├── migrations
│   │   │   │   └── <a href="backend/apps/authentication/migrations/__init__.py">__init__.py</a> + — migrations package
│   │   │   ├── <a href="backend/apps/authentication/serializers.py">serializers.py</a> + — register/login validation
│   │   │   ├── tests
│   │   │   │   ├── <a href="backend/apps/authentication/tests/test_auth.py">test_auth.py</a> + — auth flow (login/refresh)
│   │   │   │   ├── <a href="backend/apps/authentication/tests/test_auth_extra.py">test_auth_extra.py</a> + — extra auth edge cases
│   │   │   │   └── <a href="backend/apps/authentication/tests/test_register_validation.py">test_register_validation.py</a> + — register validation
│   │   │   ├── __pycache__/... (untracked) — Python bytecode caches
│   │   │   └── <a href="backend/apps/authentication/views.py">views.py</a> + — AuthView: register/login/refresh/logout
│   │   ├── tasks
│   │   │   ├── <a href="backend/apps/tasks/__init__.py">__init__.py</a> + — tasks app init
│   │   │   ├── <a href="backend/apps/tasks/apps.py">apps.py</a> + — Django AppConfig
│   │   │   ├── migrations
│   │   │   │   ├── <a href="backend/apps/tasks/migrations/0001_initial.py">0001_initial.py</a> + — Task model migration
│   │   │   │   └── <a href="backend/apps/tasks/migrations/__init__.py">__init__.py</a> + — migrations package
│   │   │   ├── <a href="backend/apps/tasks/models.py">models.py</a> + — Task model (status/domain/dates)
│   │   │   ├── <a href="backend/apps/tasks/serializers.py">serializers.py</a> + — Task serializers
│   │   │   ├── tests
│   │   │   │   ├── <a href="backend/apps/tasks/tests/test_filters_permissions.py">test_filters_permissions.py</a> + — filters/permissions
│   │   │   │   ├── <a href="backend/apps/tasks/tests/test_permissions_unauth.py">test_permissions_unauth.py</a> + — unauth access tests
│   │   │   │   └── <a href="backend/apps/tasks/tests/test_tasks.py">test_tasks.py</a> + — CRUD and complete action
│   │   │   ├── __pycache__/... (untracked) — Python bytecode caches
│   │   │   └── <a href="backend/apps/tasks/views.py">views.py</a> + — TaskViewSet with CRUD/complete
│   ├── life_api
│   │   ├── <a href="backend/life_api/__init__.py">__init__.py</a> + — project package init
│   │   ├── <a href="backend/life_api/asgi.py">asgi.py</a> + — ASGI entrypoint
│   │   ├── settings
│   │   │   ├── <a href="backend/life_api/settings/__init__.py">__init__.py</a> + — settings package init
│   │   │   ├── <a href="backend/life_api/settings/base.py">base.py</a> + — DRF + JWT config; SQLite dev DB
│   │   │   └── <a href="backend/life_api/settings/development.py">development.py</a> + — dev overrides
│   │   ├── <a href="backend/life_api/urls.py">urls.py</a> + — root urls incl. API
│   │   ├── <a href="backend/life_api/urls_api.py">urls_api.py</a> + — /api routes (auth + tasks)
│   │   ├── <a href="backend/life_api/wsgi.py">wsgi.py</a> + — WSGI entrypoint
│   │   └── __pycache__/... (untracked) — Python bytecode caches
│   ├── <a href="backend/manage.py">manage.py</a> + — Django management script
│   ├── <a href="backend/pytest.ini">pytest.ini</a> + — pytest config
│   └── <a href="backend/requirements.txt">requirements.txt</a> + — backend dependencies
├── frontend
│   ├── <a href="frontend/.env.example">.env.example</a> + — VITE_API_BASE_URL template
│   ├── <a href="frontend/Justfile">Justfile</a> + — frontend: setup/dev/build/test
│   ├── <a href="frontend/README.md">README.md</a> + — frontend usage and test docs
│   ├── <a href="frontend/index.html">index.html</a> + — app entry HTML
│   ├── <a href="frontend/package.json">package.json</a> + — deps and npm scripts
│   ├── <a href="frontend/postcss.config.js">postcss.config.js</a> + — PostCSS config (Tailwind)
│   ├── <a href="frontend/tailwind.config.js">tailwind.config.js</a> + — Tailwind config
│   ├── tests
│   │   └── <a href="frontend/tests/setup.ts">setup.ts</a> + — Vitest setup (jsdom globals)
│   ├── <a href="frontend/tsconfig.json">tsconfig.json</a> + — TypeScript config
│   ├── <a href="frontend/vite.config.ts">vite.config.ts</a> + — Vite + Vue plugin + Vitest settings
│   ├── src
│   │   ├── <a href="frontend/src/App.vue">App.vue</a> + — root component
│   │   ├── <a href="frontend/src/main.ts">main.ts</a> + — app bootstrap
│   │   ├── router
│   │   │   ├── __tests__
│   │   │   │   └── <a href="frontend/src/router/__tests__/guard.test.ts">guard.test.ts</a> + — auth guard tests
│   │   │   └── <a href="frontend/src/router/index.ts">index.ts</a> + — router with auth guard
│   │   ├── services
│   │   │   ├── __tests__
│   │   │   │   ├── <a href="frontend/src/services/__tests__/api.test.ts">api.test.ts</a> + — axios instance tests
│   │   │   │   └── <a href="frontend/src/services/__tests__/refresh.test.ts">refresh.test.ts</a> + — token refresh logic tests
│   │   │   ├── <a href="frontend/src/services/api.ts">api.ts</a> + — axios client with JWT + refresh
│   │   │   ├── <a href="frontend/src/services/auth.service.ts">auth.service.ts</a> + — auth API wrappers
│   │   │   └── <a href="frontend/src/services/task.service.ts">task.service.ts</a> + — tasks API wrappers
│   │   ├── stores
│   │   │   ├── __tests__
│   │   │   │   └── <a href="frontend/src/stores/__tests__/auth.test.ts">auth.test.ts</a> + — auth store tests
│   │   │   └── <a href="frontend/src/stores/auth.ts">auth.ts</a> + — Pinia auth store (JWT state)
│   │   ├── views
│   │   │   ├── __tests__
│   │   │   │   ├── <a href="frontend/src/views/__tests__/Login.test.ts">Login.test.ts</a> + — login page tests
│   │   │   │   └── <a href="frontend/src/views/__tests__/Tasks.test.ts">Tasks.test.ts</a> + — tasks page tests
│   │   │   ├── <a href="frontend/src/views/Login.vue">Login.vue</a> + — login page
│   │   │   ├── <a href="frontend/src/views/Register.vue">Register.vue</a> + — register page
│   │   │   └── <a href="frontend/src/views/Tasks.vue">Tasks.vue</a> + — tasks list/form page
│   │   └── <a href="frontend/src/style.css">style.css</a> + — global styles (Tailwind)
│   ├── frontend/package-lock.json (untracked) — npm lockfile (v3), reproducible installs
│   ├── frontend/vitest.config.ts (untracked) — standalone Vitest config (jsdom)
│   └── frontend/node_modules/... (untracked) — installed dependencies (gitignored)
├── scripts
│   ├── <a href="scripts/.env-generator.sh">.env-generator.sh</a> + — fill empty *_PASSWORD/KEY in .env
│   ├── lib
│   │   └── <a href="scripts/lib/bash-utils.sh">bash-utils.sh</a> + — logging/helpers for scripts
│   ├── <a href="scripts/life.sh">life.sh</a> + — CLI to link/unlink repo into HOME; selftests
│   ├── tests
│   │   └── <a href="scripts/tests/life.bats">life.bats</a> + — Bats tests for life.sh
│   └── tools
│       └── <a href="scripts/tools/install-bash-tools.sh">install-bash-tools.sh</a> + — optional bash tooling installer
└── ...
</pre>
