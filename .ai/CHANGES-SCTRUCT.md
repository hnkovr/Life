Baseline: 039375f9244f6b6878155b79c01eab43f94a4df1 → HEAD

Legend: (new), (changed), (untracked)

```
.
├── .ai
│   ├── CHANGES-SCTRUCT.md (new)
│   └── TODO.md (new)
├── .claude
│   ├── AiDevZoomcamp2025-PLAN.md (new)
│   ├── CLAUDE.md (new)
│   ├── plans
│   │   └── rustling-spinning-metcalfe.md (new)
│   └── settings.local.json (new)
├── .envrc (new)
├── .gitignore (changed)
├── Justfile (new)
├── Makefile (new)
├── backend
│   ├── .env.example (new)
│   ├── Justfile (new)
│   ├── README.md (new)
│   ├── apps
│   │   ├── __init__.py (new)
│   │   ├── authentication
│   │   │   ├── __init__.py (new)
│   │   │   ├── apps.py (new)
│   │   │   ├── migrations
│   │   │   │   └── __init__.py (new)
│   │   │   ├── serializers.py (new)
│   │   │   ├── tests
│   │   │   │   ├── test_auth.py (new)
│   │   │   │   ├── test_auth_extra.py (new)
│   │   │   │   └── test_register_validation.py (new)
│   │   │   ├── __pycache__/... (untracked)
│   │   │   └── views.py (new)
│   │   ├── tasks
│   │   │   ├── __init__.py (new)
│   │   │   ├── apps.py (new)
│   │   │   ├── migrations
│   │   │   │   ├── 0001_initial.py (new)
│   │   │   │   └── __init__.py (new)
│   │   │   ├── models.py (new)
│   │   │   ├── serializers.py (new)
│   │   │   ├── tests
│   │   │   │   ├── test_filters_permissions.py (new)
│   │   │   │   ├── test_permissions_unauth.py (new)
│   │   │   │   └── test_tasks.py (new)
│   │   │   ├── __pycache__/... (untracked)
│   │   │   └── views.py (new)
│   ├── life_api
│   │   ├── __init__.py (new)
│   │   ├── asgi.py (new)
│   │   ├── settings
│   │   │   ├── __init__.py (new)
│   │   │   ├── base.py (new)
│   │   │   └── development.py (new)
│   │   ├── urls.py (new)
│   │   ├── urls_api.py (new)
│   │   ├── wsgi.py (new)
│   │   └── __pycache__/... (untracked)
│   ├── manage.py (new)
│   ├── pytest.ini (new)
│   └── requirements.txt (new)
├── frontend
│   ├── .env.example (new)
│   ├── Justfile (new)
│   ├── README.md (new)
│   ├── index.html (new)
│   ├── package.json (new)
│   ├── postcss.config.js (new)
│   ├── tailwind.config.js (new)
│   ├── tests
│   │   └── setup.ts (new)
│   ├── tsconfig.json (new)
│   ├── vite.config.ts (new)
│   ├── src
│   │   ├── App.vue (new)
│   │   ├── main.ts (new)
│   │   ├── router
│   │   │   ├── __tests__
│   │   │   │   └── guard.test.ts (new)
│   │   │   └── index.ts (new)
│   │   ├── services
│   │   │   ├── __tests__
│   │   │   │   ├── api.test.ts (new)
│   │   │   │   └── refresh.test.ts (new)
│   │   │   ├── api.ts (new)
│   │   │   ├── auth.service.ts (new)
│   │   │   └── task.service.ts (new)
│   │   ├── stores
│   │   │   ├── __tests__
│   │   │   │   └── auth.test.ts (new)
│   │   │   └── auth.ts (new)
│   │   ├── views
│   │   │   ├── __tests__
│   │   │   │   ├── Login.test.ts (new)
│   │   │   │   └── Tasks.test.ts (new)
│   │   │   ├── Login.vue (new)
│   │   │   ├── Register.vue (new)
│   │   │   └── Tasks.vue (new)
│   │   └── style.css (new)
│   ├── package-lock.json (untracked)
│   ├── vitest.config.ts (untracked)
│   └── node_modules/... (untracked)
├── scripts
│   ├── .env-generator.sh (new)
│   ├── lib
│   │   └── bash-utils.sh (new)
│   ├── life.sh (new; mode +x)
│   ├── tests
│   │   └── life.bats (new)
│   └── tools
│   │   └── install-bash-tools.sh (new)
└── ...
```
