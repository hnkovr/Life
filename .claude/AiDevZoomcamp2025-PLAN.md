# План проекта AI Dev Zoomcamp 2025

## Обзор проекта

**Название:** Life - AI-Powered Personal Knowledge Management System

**Проблема:** Люди теряют информацию из разных источников (задачи из Todoist, заметки из Notion, голосовые заметки, документы DOCX/PPTX). Нет единого места для управления всем контекстом жизни и работы с возможностью AI-обработки.

**Решение:** Централизованная система на базе Obsidian + Django backend + Web UI для:
- Автоматического импорта задач из Todoist
- Автоматического импорта заметок из Notion
- Обработки входящих материалов (DOCX, PPTX, аудио)
- AI-агентов для обработки и организации информации
- Unified dashboard для управления всей информацией

## Критерии оценки и план реализации (24 балла)

### 1. Problem Description (2 балла) ✅ Частично готово

**Текущее состояние:**
- ✅ README.md с описанием проблематики
- ✅ Документация структуры (Personal/Work)
- ⚠️ Нужно усилить: конкретные метрики проблемы, целевая аудитория

**TODO:**
- [ ] Расширить README.md с:
  - Конкретными примерами проблем пользователей
  - Метриками: сколько времени тратится на поиск информации
  - Целевой аудиторией (knowledge workers, freelancers, project managers)
  - Примерами use cases
- [ ] Добавить диаграммы workflow
- [ ] Создать VIDEO demo для README

### 2. AI System Development (2 балла) ⚠️ Частично готово

**Текущее состояние:**
- ✅ Структура агентов (Router, Assistant, Coach, Repo-Maintainer)
- ✅ Промпты в 00_System/Prompts/
- ❌ Нет документации использования MCP

**TODO:**
- [ ] Создать `.claude/AI-DEVELOPMENT-LOG.md` с:
  - Какие AI tools использовались (Claude Code, API)
  - Все промпты для генерации кода
  - Workflow разработки с AI
- [ ] **КРИТИЧНО: Внедрить MCP (Model Context Protocol)**:
  - [ ] Создать MCP server для доступа к Obsidian vault
  - [ ] Создать MCP tools для: read_note, create_task, search_notes, link_entities
  - [ ] Документировать MCP workflow в AI-DEVELOPMENT-LOG.md
  - [ ] Примеры использования MCP в разработке
- [ ] Задокументировать все AI-generated code с метаданными

### 3. Technologies & Architecture (2 балла) ⚠️ Нужно расширить

**Текущий стек:**
- Frontend: ❌ Нет (только Obsidian UI)
- Backend: ❌ Нет (только bash scripts)
- Database: ❌ Нет (только Markdown files)
- Containerization: ❌ Нет

**Целевой стек:**
- **Frontend:** Vue.js 3 + TypeScript + Vite (легковесный, быстрый)
- **Backend:** Django 5.0 + Django REST Framework
- **Database:** PostgreSQL (prod) / SQLite (dev)
- **Cache:** Redis для сессий и rate limiting
- **Queue:** Celery для фоновых задач (импорт, обработка файлов)
- **Storage:** S3-compatible для файлов (MinIO локально)
- **Containerization:** Docker + docker-compose
- **CI/CD:** GitHub Actions
- **Deployment:** Railway / Render / DigitalOcean App Platform

**TODO:**
- [ ] Создать `docs/ARCHITECTURE.md` с:
  - Диаграммой системной архитектуры (C4 model)
  - Data flow диаграммами
  - Описанием каждого компонента
  - Обоснованием выбора технологий
- [ ] Создать `docs/TECH-STACK.md` с детальным описанием каждой технологии

### 4. Frontend Implementation (3 балла) ❌ Нужно создать

**Требования:**
- Функциональный UI
- Централизованное взаимодействие с backend
- Покрытие тестами
- Документация запуска

**Структура Frontend:**
```
frontend/
├── src/
│   ├── components/
│   │   ├── Dashboard.vue
│   │   ├── TaskList.vue
│   │   ├── NoteEditor.vue
│   │   ├── ProjectBoard.vue
│   │   ├── GoalTracker.vue
│   │   └── ImportWizard.vue
│   ├── services/
│   │   ├── api.ts (централизованный API client)
│   │   ├── auth.ts
│   │   ├── todoist.ts
│   │   └── notion.ts
│   ├── stores/
│   │   ├── auth.ts (Pinia)
│   │   ├── tasks.ts
│   │   └── notes.ts
│   ├── router/
│   │   └── index.ts
│   ├── types/
│   │   └── models.ts
│   └── App.vue
├── tests/
│   ├── unit/
│   └── e2e/
├── package.json
├── vite.config.ts
└── README.md
```

**TODO:**
- [ ] Инициализировать Vue 3 + TypeScript проект
- [ ] Реализовать компоненты:
  - [ ] Dashboard с overview всех entities
  - [ ] TaskList с фильтрацией и сортировкой
  - [ ] NoteEditor с Markdown preview
  - [ ] ProjectBoard (Kanban view)
  - [ ] GoalTracker с progress indicators
  - [ ] ImportWizard (Todoist + Notion)
- [ ] Реализовать централизованный API service (axios + interceptors)
- [ ] Настроить Pinia stores для state management
- [ ] Реализовать аутентификацию (JWT tokens)
- [ ] Написать unit tests (Vitest) - coverage > 70%
- [ ] Написать E2E tests (Playwright) для критичных flows
- [ ] Создать frontend/README.md с инструкциями запуска

### 5. API Contract/OpenAPI (2 балла) ❌ Нужно создать

**TODO:**
- [ ] Создать `api/openapi.yaml` с полной спецификацией:
  - [ ] Authentication endpoints (`/api/auth/login`, `/api/auth/refresh`)
  - [ ] Tasks endpoints (CRUD + filter/search)
  - [ ] Notes endpoints (CRUD + search)
  - [ ] Projects endpoints (CRUD + linked entities)
  - [ ] Goals endpoints (CRUD + metrics)
  - [ ] Import endpoints:
    - `/api/import/todoist/connect` (OAuth flow)
    - `/api/import/todoist/sync` (trigger import)
    - `/api/import/notion/connect` (OAuth flow)
    - `/api/import/notion/sync` (trigger import)
  - [ ] File processing endpoints (DOCX, PPTX, audio)
  - [ ] Search endpoint (unified search)
- [ ] Добавить все models, schemas, error responses
- [ ] Настроить Swagger UI для интерактивной документации
- [ ] Использовать OpenAPI для генерации TypeScript types (openapi-typescript)
- [ ] Contract testing (Dredd или Schemathesis)

### 6. Backend Implementation (3 балла) ❌ Нужно создать

**Структура Backend:**
```
backend/
├── life_api/
│   ├── settings/
│   │   ├── base.py
│   │   ├── development.py
│   │   └── production.py
│   ├── urls.py
│   └── wsgi.py
├── apps/
│   ├── authentication/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   └── tests/
│   ├── tasks/
│   │   ├── models.py (Task, Status, Priority)
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── services.py
│   │   └── tests/
│   ├── notes/
│   │   ├── models.py (Note, Tag)
│   │   ├── serializers.py
│   │   ├── views.py
│   │   └── tests/
│   ├── projects/
│   │   └── ... (аналогично)
│   ├── goals/
│   │   └── ... (аналогично)
│   ├── integrations/
│   │   ├── todoist/
│   │   │   ├── client.py
│   │   │   ├── sync.py
│   │   │   ├── oauth.py
│   │   │   └── tests/
│   │   └── notion/
│   │       ├── client.py
│   │       ├── sync.py
│   │       ├── oauth.py
│   │       └── tests/
│   └── processing/
│       ├── docx_processor.py
│       ├── audio_processor.py
│       └── tests/
├── requirements/
│   ├── base.txt
│   ├── development.txt
│   └── production.txt
├── manage.py
└── README.md
```

**TODO:**
- [ ] Инициализировать Django проект
- [ ] Реализовать models согласно OpenAPI spec:
  - [ ] User model с профилем
  - [ ] Task model с связями
  - [ ] Note model с tags
  - [ ] Project, Goal, Area models
  - [ ] Integration credentials (encrypted)
- [ ] Реализовать API views (DRF ViewSets):
  - [ ] CRUD для всех entities
  - [ ] Filtering, searching, pagination
  - [ ] Permissions (IsAuthenticated, IsOwner)
- [ ] Реализовать authentication:
  - [ ] JWT authentication (djangorestframework-simplejwt)
  - [ ] Token refresh mechanism
  - [ ] User registration/login
- [ ] Реализовать Todoist integration:
  - [ ] OAuth 2.0 flow (store tokens encrypted)
  - [ ] Sync tasks (incremental sync via webhooks)
  - [ ] Mapping Todoist → Obsidian format
  - [ ] Celery task для периодического sync
- [ ] Реализовать Notion integration:
  - [ ] OAuth 2.0 flow
  - [ ] Sync pages/databases
  - [ ] Convert Notion blocks → Markdown
  - [ ] Celery task для периодического sync
- [ ] Реализовать file processing:
  - [ ] DOCX → Markdown (используя существующие scripts)
  - [ ] Audio → Text (Whisper API или local model)
  - [ ] S3 storage для uploaded files
- [ ] Написать unit tests для models, serializers, services (coverage > 80%)
- [ ] Написать API tests для всех endpoints
- [ ] Создать backend/README.md с инструкциями

### 7. Database Integration (2 балла) ❌ Нужно создать

**TODO:**
- [ ] Настроить PostgreSQL для production
- [ ] Настроить SQLite для development/testing
- [ ] Создать database migrations:
  - [ ] Initial schema
  - [ ] Indexes для поисковых запросов
  - [ ] Full-text search (PostgreSQL tsquery)
- [ ] Настроить multiple database support:
  ```python
  DATABASES = {
      'default': {  # PostgreSQL в production
          'ENGINE': 'django.db.backends.postgresql',
          ...
      },
      'sqlite': {  # SQLite в dev
          'ENGINE': 'django.db.backends.sqlite3',
          ...
      }
  }
  ```
- [ ] Создать database fixtures для testing
- [ ] Создать seeds для demo data
- [ ] Документировать schema в `docs/DATABASE.md`:
  - [ ] ER-диаграмма
  - [ ] Описание всех таблиц
  - [ ] Индексы и их обоснование
  - [ ] Инструкции по миграциям
- [ ] Реализовать database backup strategy

### 8. Containerization (2 балла) ❌ Нужно создать

**TODO:**
- [ ] Создать `Dockerfile` для backend:
  ```dockerfile
  FROM python:3.11-slim
  # Multi-stage build для оптимизации размера
  # Install dependencies, copy app, setup entrypoint
  ```
- [ ] Создать `Dockerfile` для frontend:
  ```dockerfile
  FROM node:20-alpine AS builder
  # Build stage
  FROM nginx:alpine AS production
  # Serve static files
  ```
- [ ] Создать `docker-compose.yml`:
  ```yaml
  services:
    db:
      image: postgres:16
    redis:
      image: redis:7-alpine
    backend:
      build: ./backend
      depends_on: [db, redis]
    celery:
      build: ./backend
      command: celery worker
    frontend:
      build: ./frontend
      depends_on: [backend]
    nginx:
      image: nginx:alpine
      volumes:
        - ./nginx.conf:/etc/nginx/nginx.conf
  ```
- [ ] Создать `docker-compose.dev.yml` для development
- [ ] Создать `.dockerignore` files
- [ ] Настроить healthchecks для всех services
- [ ] Создать `docs/DOCKER.md` с инструкциями:
  - [ ] Как собрать images
  - [ ] Как запустить локально
  - [ ] Как troubleshoot проблемы
  - [ ] Environment variables

### 9. Integration Testing (2 балла) ❌ Нужно создать

**TODO:**
- [ ] Создать `tests/integration/` директорию
- [ ] Реализовать integration tests:
  - [ ] Test: Auth flow (register → login → refresh token)
  - [ ] Test: Create task → Link to project → Update status
  - [ ] Test: Import from Todoist → Verify tasks created
  - [ ] Test: Import from Notion → Verify notes created
  - [ ] Test: Upload DOCX → Process → Create note
  - [ ] Test: Full user workflow (E2E)
- [ ] Использовать pytest для integration tests
- [ ] Настроить test database (SQLite для быстроты)
- [ ] Использовать factories (factory_boy) для test data
- [ ] Mock external APIs (Todoist, Notion) с responses
- [ ] Создать `tests/README.md` с:
  - [ ] Как запустить integration tests
  - [ ] Описание test scenarios
  - [ ] Coverage requirements
- [ ] Настроить coverage reporting (pytest-cov)

### 10. Deployment (2 балла) ❌ Нужно реализовать

**Варианты платформ:**
1. **Railway** (рекомендуется) - простой деплой из GitHub
2. **Render** - бесплатный tier для демо
3. **DigitalOcean App Platform** - хороший баланс

**TODO:**
- [ ] Выбрать платформу: **Railway**
- [ ] Подготовить production config:
  - [ ] Environment variables (secrets)
  - [ ] Static files serving (WhiteNoise)
  - [ ] Media files (S3 bucket)
  - [ ] Database (Railway PostgreSQL)
  - [ ] Redis (Railway Redis)
- [ ] Создать `railway.json` или `Procfile`
- [ ] Настроить SSL (автоматически через Railway)
- [ ] Настроить custom domain (опционально)
- [ ] Создать `docs/DEPLOYMENT.md`:
  - [ ] Step-by-step инструкции
  - [ ] Environment variables список
  - [ ] Troubleshooting guide
  - [ ] Monitoring setup
- [ ] Задеплоить и получить working URL
- [ ] Создать demo user для reviewer'ов

### 11. CI/CD Pipeline (2 балла) ❌ Нужно создать

**TODO:**
- [ ] Создать `.github/workflows/ci.yml`:
  ```yaml
  name: CI
  on: [push, pull_request]
  jobs:
    test-backend:
      runs-on: ubuntu-latest
      steps:
        - Checkout code
        - Setup Python
        - Install dependencies
        - Run tests (pytest + coverage)
        - Upload coverage to Codecov
    test-frontend:
      runs-on: ubuntu-latest
      steps:
        - Checkout code
        - Setup Node
        - Install dependencies
        - Run tests (vitest + coverage)
        - Run linter (ESLint)
    integration-tests:
      needs: [test-backend, test-frontend]
      steps:
        - Start docker-compose
        - Run integration tests
        - Teardown
  ```
- [ ] Создать `.github/workflows/cd.yml`:
  ```yaml
  name: CD
  on:
    push:
      branches: [main]
  jobs:
    deploy:
      needs: [test]  # только если тесты прошли
      steps:
        - Deploy to Railway
        - Run smoke tests
        - Notify on failure
  ```
- [ ] Настроить GitHub Secrets для deployment
- [ ] Добавить status badges в README.md
- [ ] Настроить автоматический rollback при ошибках
- [ ] Создать `docs/CI-CD.md` с описанием pipeline

### 12. Reproducibility (2 балла) ⚠️ Частично готово

**Текущее состояние:**
- ✅ Makefile и Justfile с командами
- ✅ Некоторые инструкции в README.md
- ❌ Нет полных end-to-end инструкций для нового проекта

**TODO:**
- [ ] Создать `docs/SETUP.md` с полными инструкциями:
  - [ ] Prerequisites (Docker, Node, Python)
  - [ ] Clone repository
  - [ ] Setup environment variables
  - [ ] Build и run с Docker
  - [ ] Run locally для development
  - [ ] Run tests
  - [ ] Deploy to production
- [ ] Создать `CONTRIBUTING.md`
- [ ] Обновить главный `README.md`:
  - [ ] Quick start (одна команда)
  - [ ] Links ко всей документации
  - [ ] Screenshots/GIFs
  - [ ] Live demo URL
- [ ] Создать setup script: `scripts/setup.sh`
  ```bash
  #!/bin/bash
  # One-command setup for development
  ./scripts/setup.sh
  ```
- [ ] Протестировать все инструкции на чистой машине

## Дополнительные компоненты

### MCP Server (для AI System Development критерия)

**TODO:**
- [ ] Создать `mcp-server/` директорию
- [ ] Реализовать MCP server (TypeScript):
  ```
  mcp-server/
  ├── src/
  │   ├── server.ts
  │   ├── tools/
  │   │   ├── readNote.ts
  │   │   ├── createTask.ts
  │   │   ├── searchNotes.ts
  │   │   ├── linkEntities.ts
  │   │   └── analyzeVault.ts
  │   └── types.ts
  ├── package.json
  └── README.md
  ```
- [ ] Реализовать tools:
  - `read_note(path)` - читает заметку из vault
  - `create_task(title, project, due_date)` - создает задачу
  - `search_notes(query)` - поиск по заметкам
  - `link_entities(source, target)` - создает связь
  - `analyze_vault()` - анализ структуры vault
- [ ] Создать Claude Desktop config для MCP:
  ```json
  {
    "mcpServers": {
      "life-vault": {
        "command": "node",
        "args": ["path/to/mcp-server/dist/server.js"],
        "env": {
          "VAULT_PATH": "/path/to/vault"
        }
      }
    }
  }
  ```
- [ ] Документировать использование MCP в AI-DEVELOPMENT-LOG.md

### Интеграция с Todoist

**Выбор:** Todoist (самый популярный, отличный API, OAuth 2.0)

**TODO:**
- [ ] Зарегистрировать Todoist App в Developer Console
- [ ] Реализовать OAuth 2.0 flow:
  - [ ] Authorization URL redirect
  - [ ] Callback handler для получения access token
  - [ ] Хранение encrypted tokens в database
- [ ] Реализовать sync logic:
  - [ ] Fetch all tasks от последнего sync
  - [ ] Mapping Todoist fields → Life Task model:
    - `content` → `title`
    - `description` → `description`
    - `due` → `due_date`
    - `priority` → `priority`
    - `project_id` → link to Project
    - `labels` → `tags`
  - [ ] Create/Update tasks в vault
  - [ ] Генерация Markdown файлов в `Work/20_Tasks/` или `Personal/20_Tasks/`
  - [ ] Сохранение sync state (last_sync_timestamp)
- [ ] Реализовать incremental sync:
  - [ ] Webhook от Todoist при изменениях
  - [ ] Background job (Celery) для periodic sync
- [ ] Реализовать conflict resolution:
  - [ ] Last-write-wins strategy
  - [ ] Или manual conflict UI
- [ ] UI для настройки интеграции:
  - [ ] Connect/Disconnect button
  - [ ] Sync status indicator
  - [ ] Manual sync trigger
  - [ ] Mapping preferences (Work vs Personal)
- [ ] Tests:
  - [ ] Mock Todoist API responses
  - [ ] Test OAuth flow
  - [ ] Test sync logic
  - [ ] Test error handling

### Интеграция с Notion

**Выбор:** Notion (очень популярный, хороший API, OAuth 2.0)

**TODO:**
- [ ] Зарегистрировать Notion Integration
- [ ] Реализовать OAuth 2.0 flow:
  - [ ] Authorization URL redirect
  - [ ] Callback handler
  - [ ] Store encrypted tokens
- [ ] Реализовать sync logic:
  - [ ] Fetch pages и databases
  - [ ] Parse Notion blocks:
    - Paragraph → Markdown paragraph
    - Heading → Markdown heading
    - Bulleted list → Markdown list
    - Code → Markdown code block
    - Image → Download + link в Assets
  - [ ] Convert Notion page → Markdown note
  - [ ] Mapping metadata:
    - Page title → Note title
    - Properties → Frontmatter
    - Tags → Tags
    - Created time → `created`
    - Last edited → `updated`
  - [ ] Генерация файлов в `Work/50_Notes/` или `Personal/50_Notes/`
  - [ ] Download attachments в `*/90_Assets/`
- [ ] Реализовать incremental sync:
  - [ ] Track last_edited_time
  - [ ] Sync только измененные pages
- [ ] UI для настройки интеграции:
  - [ ] Connect/Disconnect
  - [ ] Select workspace
  - [ ] Choose databases/pages to sync
  - [ ] Sync status
  - [ ] Manual sync trigger
- [ ] Tests:
  - [ ] Mock Notion API
  - [ ] Test block parsing
  - [ ] Test Markdown conversion
  - [ ] Test error handling

## План реализации по этапам

### Этап 1: Архитектура и документация (1 неделя)
- [ ] Улучшить README.md с проблематикой и solution
- [ ] Создать ARCHITECTURE.md с диаграммами
- [ ] Создать OpenAPI spec (openapi.yaml)
- [ ] Создать AI-DEVELOPMENT-LOG.md
- [ ] Написать DATABASE.md

### Этап 2: Backend foundation (1.5 недели)
- [ ] Инициализировать Django проект
- [ ] Создать models (User, Task, Note, Project, Goal)
- [ ] Настроить PostgreSQL + SQLite
- [ ] Реализовать JWT authentication
- [ ] Создать базовые CRUD endpoints
- [ ] Написать unit tests для models/serializers
- [ ] Настроить Swagger UI с OpenAPI spec

### Этап 3: Frontend foundation (1.5 недели)
- [ ] Инициализировать Vue 3 проект
- [ ] Создать базовые компоненты (Dashboard, TaskList, NoteEditor)
- [ ] Реализовать API service с interceptors
- [ ] Настроить Pinia stores
- [ ] Реализовать authentication flow
- [ ] Написать unit tests (Vitest)
- [ ] Базовый responsive design

### Этап 4: Todoist integration (1 неделя)
- [ ] Зарегистрировать Todoist app
- [ ] Реализовать OAuth flow (backend + frontend)
- [ ] Реализовать sync service
- [ ] Реализовать Markdown generation
- [ ] Настроить Celery для background sync
- [ ] UI для настройки интеграции
- [ ] Tests

### Этап 5: Notion integration (1 неделя)
- [ ] Зарегистрировать Notion integration
- [ ] Реализовать OAuth flow
- [ ] Реализовать block parser
- [ ] Реализовать Markdown conversion
- [ ] Настроить sync service
- [ ] UI для настройки интеграции
- [ ] Tests

### Этап 6: MCP Server (0.5 недели)
- [ ] Создать MCP server (TypeScript)
- [ ] Реализовать основные tools
- [ ] Настроить Claude Desktop config
- [ ] Документировать использование в AI-DEVELOPMENT-LOG.md
- [ ] Примеры промптов с MCP tools

### Этап 7: Docker и CI/CD (1 неделя)
- [ ] Создать Dockerfiles (backend, frontend)
- [ ] Создать docker-compose.yml
- [ ] Настроить GitHub Actions (CI)
- [ ] Настроить GitHub Actions (CD)
- [ ] Протестировать локальный Docker setup
- [ ] Документация Docker

### Этап 8: Integration tests (0.5 недели)
- [ ] Написать integration tests
- [ ] Настроить test fixtures
- [ ] Mock external APIs
- [ ] Coverage reporting
- [ ] Документация tests

### Этап 9: Deployment (0.5 недели)
- [ ] Выбрать платформу (Railway)
- [ ] Настроить production config
- [ ] Deploy backend + database + redis
- [ ] Deploy frontend
- [ ] Настроить SSL
- [ ] Smoke tests
- [ ] Создать demo user

### Этап 10: Documentation и polish (1 неделя)
- [ ] Полный SETUP.md
- [ ] Полный DEPLOYMENT.md
- [ ] CI-CD.md
- [ ] DOCKER.md
- [ ] Video demo
- [ ] Screenshots для README
- [ ] Протестировать reproducibility на чистой машине
- [ ] Финальный review всей документации

### Этап 11: Peer review (по расписанию курса)
- [ ] Оценить 3 проекта других студентов
- [ ] Использовать rubric из курса
- [ ] Дать конструктивный feedback

## Итоговая оценка (прогноз)

| Критерий | Баллы | Статус |
|----------|-------|--------|
| 1. Problem Description | 2/2 | ✅ После улучшения README |
| 2. AI System Development | 2/2 | ✅ С MCP server |
| 3. Technologies & Architecture | 2/2 | ✅ С полной документацией |
| 4. Frontend Implementation | 3/3 | ✅ Vue 3 + tests |
| 5. API Contract/OpenAPI | 2/2 | ✅ Полный OpenAPI spec |
| 6. Backend Implementation | 3/3 | ✅ Django + DRF + tests |
| 7. Database Integration | 2/2 | ✅ Postgres + SQLite |
| 8. Containerization | 2/2 | ✅ Docker + compose |
| 9. Integration Testing | 2/2 | ✅ Полное покрытие |
| 10. Deployment | 2/2 | ✅ Railway с URL |
| 11. CI/CD Pipeline | 2/2 | ✅ GitHub Actions |
| 12. Reproducibility | 2/2 | ✅ Полная документация |
| **Итого** | **26/24** | ✅ + bonus |
| Peer Review Bonus | +9 | ✅ За 3 review |
| **Финал** | **35/24** | 🎯 Максимум |

## Технологический стек (финальный)

### Frontend
- **Framework:** Vue.js 3.4 + TypeScript
- **Build:** Vite 5
- **State:** Pinia
- **Routing:** Vue Router 4
- **HTTP:** Axios
- **UI Library:** Tailwind CSS + Headless UI
- **Forms:** VeeValidate + Zod
- **Testing:** Vitest + Playwright
- **Linting:** ESLint + Prettier

### Backend
- **Framework:** Django 5.0
- **API:** Django REST Framework 3.14
- **Auth:** djangorestframework-simplejwt
- **Database:** PostgreSQL 16 / SQLite 3
- **ORM:** Django ORM
- **Migrations:** Django migrations
- **Task Queue:** Celery 5 + Redis
- **File Storage:** django-storages (S3-compatible)
- **API Docs:** drf-spectacular (OpenAPI 3)
- **Testing:** pytest + pytest-django + factory_boy
- **Linting:** ruff + black

### Infrastructure
- **Containerization:** Docker + docker-compose
- **Web Server:** Nginx (для static files)
- **Database:** PostgreSQL 16 (production), SQLite (dev)
- **Cache/Queue:** Redis 7
- **Storage:** S3-compatible (MinIO locally)
- **CI/CD:** GitHub Actions
- **Deployment:** Railway
- **Monitoring:** Sentry (errors), Railway metrics

### Integrations
- **Todoist:** REST API v2 + OAuth 2.0
- **Notion:** REST API v1 + OAuth 2.0
- **File Processing:** Pandoc (DOCX), Whisper (audio)

### MCP
- **MCP Server:** TypeScript + @modelcontextprotocol/sdk
- **Tools:** Custom tools для Obsidian vault

## Риски и митигации

### Риск 1: Сложность интеграций
**Проблема:** OAuth flows и API integrations могут быть сложными
**Митигация:**
- Начать с mock'ов в тестах
- Использовать готовые библиотеки (todoist-api-python, notion-client)
- Подробное логирование
- Graceful error handling

### Риск 2: Время на реализацию
**Проблема:** 8-10 недель на все может не хватить
**Митигация:**
- MVP-first approach: сначала базовые features
- Использовать готовые UI components (Headless UI)
- Использовать AI для генерации boilerplate кода
- Параллельная работа над независимыми частями

### Риск 3: Deployment проблемы
**Проблема:** Production environment может отличаться от dev
**Митигация:**
- Docker для consistency
- Railway для простоты
- Extensive integration tests
- Staging environment для testing

### Риск 4: Недостаточное покрытие тестами
**Проблема:** Может не хватить времени на все tests
**Митигация:**
- Test-driven development (TDD) approach
- Покрывать критичные flows в первую очередь
- Использовать fixtures и factories
- CI pipeline для автоматического запуска

## Следующие шаги (immediate)

1. **Сегодня:**
   - [ ] Создать GitHub repository (если еще нет)
   - [ ] Улучшить README.md с проблематикой
   - [ ] Начать писать ARCHITECTURE.md

2. **Эта неделя:**
   - [ ] Закончить OpenAPI spec
   - [ ] Инициализировать Django проект
   - [ ] Инициализировать Vue проект
   - [ ] Создать docker-compose.yml

3. **Следующая неделя:**
   - [ ] Базовые models в Django
   - [ ] Базовые компоненты в Vue
   - [ ] Начать Todoist integration

## Полезные ресурсы

- **Django REST Framework:** https://www.django-rest-framework.org/
- **Vue 3 docs:** https://vuejs.org/
- **Todoist API:** https://developer.todoist.com/rest/v2/
- **Notion API:** https://developers.notion.com/
- **MCP Protocol:** https://modelcontextprotocol.io/
- **Railway docs:** https://docs.railway.app/
- **GitHub Actions:** https://docs.github.com/actions
- **OpenAPI spec:** https://swagger.io/specification/

## Заметки

- Документацию и код писать на **английском**
- План и внутренние заметки - на **русском**
- Коммиты делать часто, с осмысленными сообщениями
- Использовать AI (Claude Code) для ускорения разработки
- Документировать все использования AI в AI-DEVELOPMENT-LOG.md
- Приоритет: **working demo** > perfect code
- Все критичные решения документировать в ADR (Architecture Decision Records)
