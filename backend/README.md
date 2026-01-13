# Backend (Django + DRF) — v0.0.2 MVP

Цель: аутентификация (JWT) и CRUD для задач в dev‑окружении (SQLite).

## Быстрый старт (uv или python)

1) Установите Python 3.11+ и virtualenv.
2) С использованием just:
```
pwd
cd backend
pwd
just setup
just migrate
just run
```
Или вручную (uv → fallback python):
```
cd backend
uv venv .venv && uv pip install -r requirements.txt --python .venv/bin/python || true
test -d .venv || (python3 -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt)
python manage.py migrate
python manage.py runserver 8000
```
3) Настройте окружение:
```
cp .env.example .env  # опционально, если используете direnv — добавьте .envrc
```
4) Примените миграции и запустите сервер:
```
python manage.py migrate
python manage.py runserver 8000
```

## Эндпоинты
- POST `/api/auth/register` — { email, username?, password }
- POST `/api/auth/login` — { email, password } → { access, refresh }
- POST `/api/auth/refresh` — { refresh } → { access }
- POST `/api/auth/logout`
- CRUD `/api/tasks/` (+ `POST /api/tasks/{id}/complete/`)

Передавайте `Authorization: Bearer <access>` для защищённых эндпоинтов.

## Тесты
```
just test
```

## Примечания
- По умолчанию `DEBUG=1`, база — SQLite (`db.sqlite3`).
- Для MVP blacklist refresh токенов не используется; logout — статлесс (удаление токенов на клиенте).
