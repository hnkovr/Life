# Backend (Django + DRF) — v0.0.2 MVP

Цель: аутентификация (JWT) и CRUD для задач в dev‑окружении (SQLite).

## Быстрый старт

1) Установите Python 3.11+ и virtualenv.
2) Создайте виртуальное окружение и установите зависимости:
```
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
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
pytest -q
```

## Примечания
- По умолчанию `DEBUG=1`, база — SQLite (`db.sqlite3`).
- Для MVP blacklist refresh токенов не используется; logout — статлесс (удаление токенов на клиенте).

