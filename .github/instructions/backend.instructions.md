---
applyTo: "backend/**"
---

# Backend Instructions

## Structure

All API routes mount under `/api` via `app.api.api_router`. Follow the route → service → model pattern:

- `app/api/` — FastAPI route handlers (thin: validate input, call service, return response)
- `app/services/` — business logic (database queries, external API calls, etc.)
- `app/models/` — SQLModel ORM models (also serve as Pydantic schemas)
- `app/schemas/` — request/response schemas when they differ from models

## Database

- **ORM:** SQLModel (SQLAlchemy + Pydantic hybrid)
- **Async driver:** asyncpg
- **Migrations:** Alembic in `backend/alembic/`
  - Create: `cd backend && uv run alembic revision --autogenerate -m "description"`
  - Apply: `cd backend && uv run alembic upgrade head`

## Patterns

- **Route handlers should be thin.** Extract business logic into services. Routes validate input, call a service, and return the result.
- **Check existing routes before creating new ones:** `ls backend/app/api/`
- **Check existing services before creating new ones:** `ls backend/app/services/`
- **Check existing models before creating new ones:** `ls backend/app/models/`
- **Pydantic validation** on all request bodies via SQLModel or custom schemas

## Configuration

- Config loaded via `pydantic-settings` from `.env`

## Testing

```bash
cd backend && uv run pytest                           # all tests
cd backend && uv run pytest tests/test_api/test_X.py  # single file
cd backend && uv run pytest -k test_name              # single test
```

- `asyncio_mode = "auto"` — test functions can be `async def` without decorators
- Tests use an isolated test database
