---
type: plan
status: draft
version: 0.0.2
created: 2026-01-12
updated: 2026-01-12
---

# v0.0.2 — MVP «Список задач + Аутентификация» (Frontend + Backend)

Источник: консолидация из `.claude/plans/rustling-spinning-metcalfe.md` (FEATURE 1) и `.claude/AiDevZoomcamp2025-PLAN.md` (этапы Backend/Frontend).

## Цель релиза
- Дать работающий end‑to‑end поток: регистрация → логин (JWT) → список задач → создание/редактирование → завершение → логаут.
- Локальная разработка на SQLite. Без Docker/Postgres/интеграций — строго MVP.

## Скоуп (минимум)
- Backend (Django + DRF + SimpleJWT):
  - Модель `Task` (user, title, description?, status, domain, due_date?, created_at/updated_at).
  - Эндпоинты: `/api/auth/register|login|refresh|logout`, `/api/tasks/` (CRUD), `/api/tasks/{id}/complete/`.
  - Фильтры: `domain`, `status`, `due_date` (basic).
  - Тесты: базовый набор (auth flow, Task CRUD, permissions: только свои задачи).
- Frontend (Vue 3 + TS + Vite + Pinia + Tailwind):
  - Страницы: Login, Register, Tasks.
  - Компоненты: `TaskList`, `TaskItem`, `TaskForm`, `TaskFilters` (базово).
  - Хранение JWT в `localStorage`, axios‑интерсепторы, route‑guards.

## Вне скоупа (после 0.0.2)
- Docker/Compose, CI/CD, Postgres/Redis, Celery.
- Todoist/Notion интеграции, импорт файлов, MCP.
- Продвинутые фильтры/поиск, роли, проекты/цели, markdown‑редактор.

## Критерии готовности (Definition of Done)
- Успешная регистрация, логин/refresh, логаут.
- Отображение списка задач текущего пользователя.
- Создание/редактирование/удаление/завершение задачи работает через API.
- Frontend и Backend запускаются локально через инструкции в README, есть `.env.example`.
- Минимальные unit‑тесты backend проходят (pytest), покрытие критических путей.

## План по шагам

### 1) Backend — инициализация (Django + DRF)
- [ ] Создать каталог `backend/`, проект `life_api` (settings: base/dev, CORS включён).
- [ ] Установить пакеты: `djangorestframework`, `djangorestframework-simplejwt`, `pytest`, `pytest-django`.
- [ ] Подключить DRF и SimpleJWT в настройках; настроить `AUTH_USER_MODEL` (по MVP можно стандартный `User` с уникальным email).
- [ ] Настроить SQLite по умолчанию (dev).

### 2) Backend — домен задач и аутентификация
- [ ] Приложения: `apps/authentication`, `apps/tasks`.
- [ ] Модель `Task` (UUID PK, FK на пользователя, поля: title, description?, status: todo|doing|waiting|done|canceled, domain: work|personal, due_date?, created_at/updated_at).
- [ ] Сериализаторы и ViewSet для Task; роуты `/api/tasks/`.
- [ ] Эндпоинты auth: `/api/auth/register`, `/api/auth/login`, `/api/auth/refresh`, `/api/auth/logout`.
- [ ] Экшен `/api/tasks/{id}/complete/` (POST) — отметить выполненной.
- [ ] Базовые фильтры по `domain`, `status`, `due_date`.
- [ ] Миграции и локальный запуск.

### 3) Backend — тесты и документация
- [ ] Pytest конфиг; фикстуры пользователя и задачи.
- [ ] Тесты: регистрация/логин/JWT refresh; CRUD задач; доступ только к своим задачам.
- [ ] Обновить `README.md` (раздел Backend), добавить `backend/.env.example` и команды запуска.

### 4) Frontend — инициализация (Vue 3 + TS)
- [ ] Создать каталог `frontend/` через Vite (Vue + TS).
- [ ] Подключить Tailwind; настроить Vue Router и Pinia.
- [ ] Создать `src/services/api.ts` (axios с baseURL + интерсепторы для JWT и 401‑refresh).
- [ ] Создать `src/stores/auth.ts` (login/register/refresh/logout, хранение токенов).

### 5) Frontend — страницы и компоненты
- [ ] Страницы `Login`, `Register` (валидация базовая).
- [ ] Страница `Tasks` с guard (требует auth).
- [ ] Компоненты: `TaskList`, `TaskItem`, `TaskForm` (создание/редактирование), `TaskFilters` (domain/status/date — упрощённо).
- [ ] Сервис `task.service.ts` (CRUD + complete).

### 6) Интеграция и проверка сквозного потока
- [ ] Настроить `.env`/`.env.example` для frontend (`VITE_API_BASE_URL`).
- [ ] Пройти поток вручную: register → login → список пустой → создать задачу → изменить → завершить → логаут.
- [ ] Зафиксировать найденные баги, минимально поправить.

### 7) Минимальные тесты и полировка
- [ ] Backend: убедиться, что базовые pytest‑тесты зелёные; покрыть критические ветки.
- [ ] Frontend: smoke‑тесты stores/сервисов (Vitest) — по 1–2 кейса.
- [ ] Обновить корневой `README.md`: как запустить оба сервиса локально.

## Структура каталогов (после 0.0.2)
```
backend/
  apps/
    authentication/
    tasks/
  life_api/
  manage.py
frontend/
  src/
    components/
      tasks/
      auth/
    services/
    stores/
    router/
  index.html
```

## Релиз‑ноты (набросок)
- v0.0.2: первый работающий «Список задач + аутентификация» в dev‑окружении.
  - Backend: Django + DRF + JWT, Task CRUD.
  - Frontend: Login/Register, Tasks (листинг/создание/редактирование/комплит), базовые фильтры.
  - Тесты: базовые backend; smoke frontend.

## Следом (кандидаты на v0.0.3)
- Docker/Compose + Postgres; OpenAPI/Swagger; улучшенные фильтры/поиск.
- Канбан/проекты/цели; E2E (Playwright); подготовка к деплою (Railway).

