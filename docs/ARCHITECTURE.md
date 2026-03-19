# {PROJECT_NAME} — Architecture

## System Overview

_{High-level architecture description}_

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│   Frontend  │──────▶│   Backend   │──────▶│  PostgreSQL │
│  (React)    │       │  (FastAPI)  │       │             │
└─────────────┘       └─────────────┘       └─────────────┘
```

## Services

### Backend (`backend/`)
- **Framework:** FastAPI (Python 3.12+)
- **Database:** PostgreSQL with asyncpg driver
- **ORM:** SQLModel (SQLAlchemy + Pydantic hybrid)
- **Migrations:** Alembic

### Frontend (`frontend/`)
- **Framework:** React 19 + TypeScript
- **Styling:** Tailwind CSS
- **Build:** Vite
- **Routing:** React Router v7

## API Endpoints

| Method | Path        | Description  |
| ------ | ----------- | ------------ |
| GET    | /api/health | Health check |
<!-- Add endpoints here -->

## Data Models

_{Document your models here}_

## Configuration

### Environment Variables

| Variable     | Description                  | Required |
| ------------ | ---------------------------- | -------- |
| DATABASE_URL | PostgreSQL connection string | Yes      |
| CORS_ORIGINS | Allowed CORS origins         | Yes      |
