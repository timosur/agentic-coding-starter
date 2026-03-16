# Python + React Starter Template

A starter template for Python (FastAPI) + React projects with AI coding support via GitHub Copilot agents.

## Features

- **Backend:** FastAPI + SQLModel + Alembic (Python 3.12+)
- **Frontend:** React 19 + TypeScript + Tailwind CSS + Vite
- **AI Coding:** 5 specialized Copilot agents for structured development
- **Feature Tracking:** Built-in spec-driven workflow with implementation plans

## Quick Start

```bash
make setup    # Install deps, create .env
make dev      # Start PostgreSQL + backend + frontend
```

- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## Customization

After cloning, replace these placeholders throughout the codebase:

| Placeholder | Replace With | Example |
|-------------|--------------|---------|
| `{PROJECT_NAME}` | Your project name | "My Awesome App" |
| `{PREFIX}` | Feature ID prefix (3-5 chars) | "APP", "PROJ", "MY" |
| `starter-backend` | Your backend package name | "my-app-backend" |
| `starter-frontend` | Your frontend package name | "my-app-frontend" |
| `starter-db-dev` | Your Docker container name | "my-app-db-dev" |

### Files to update:
- `backend/pyproject.toml` — package name
- `frontend/package.json` — package name
- `frontend/index.html` — page title
- `docker-compose.yml` — container name
- `Makefile` — container name in `db-shell`
- All `.github/` files — project name and feature prefix

## Project Structure

```
├── .github/
│   ├── copilot-instructions.md   # Main Copilot config
│   ├── agents/                   # 5 specialized agents
│   │   ├── requirements.agent.md # Feature spec creation
│   │   ├── architecture.agent.md # Tech design
│   │   ├── backend.agent.md      # API development
│   │   ├── frontend.agent.md     # UI development
│   │   └── qa.agent.md           # Testing & security
│   ├── instructions/             # Auto-applied rules
│   └── skills/help/              # Project status skill
├── project/
│   ├── PRD.md                    # Product requirements
│   ├── ARCHITECTURE.md           # System architecture
│   ├── features/                 # Feature specs
│   └── plans/                    # Implementation plans
├── backend/                      # FastAPI backend
│   ├── app/                      # Application code
│   ├── tests/                    # Pytest tests
│   └── alembic/                  # DB migrations
├── frontend/                     # React frontend
│   ├── src/                      # Application code
│   └── e2e/                      # Playwright tests
├── Makefile                      # Dev commands
└── docker-compose.yml            # PostgreSQL
```

## Development Workflow

This template uses a structured agent-driven workflow:

```
Requirements Engineer → Solution Architect → Backend/Frontend Developer → QA Engineer
```

1. **New project?** Switch to **Requirements Engineer** to create PRD and initial features
2. **New feature?** Switch to **Requirements Engineer** to create a spec
3. **Ready to design?** Switch to **Solution Architect** for tech design + plan
4. **Ready to build?** Switch to **Backend Developer** or **Frontend Developer**
5. **Ready to test?** Switch to **QA Engineer**

Use `/help` skill anytime to see project status and recommended next steps.

## Commands

| Command | Description |
|---------|-------------|
| `make setup` | Install dependencies, create .env |
| `make dev` | Start PostgreSQL + backend + frontend |
| `make dev-stop` | Stop PostgreSQL |
| `make test-backend` | Run pytest |
| `make test-frontend` | Run Playwright E2E |
| `make db-migrate` | Run Alembic migrations |
| `make db-reset` | Reset database |
| `make clean` | Remove venv, node_modules, dist |

## Testing

```bash
# Backend
cd backend && uv run pytest
cd backend && uv run pytest -k test_name

# Frontend E2E
cd frontend && npx playwright test
cd frontend && npx playwright test --ui
```

## License

MIT
