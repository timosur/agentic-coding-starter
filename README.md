# Agentic Coding Starter

My personal starter template for new private projects. Clone it, rename placeholders, and start building — the full agent-driven workflow, CI pipelines, and Kubernetes deploy chain come ready out of the box.

Takes you from product design to a production-ready full-stack app, all driven by specialized AI agents. Covers the entire lifecycle: product vision, UI design, feature specs, architecture, implementation, QA, and release.

**Stack:** Python FastAPI + SQLModel backend · React 19 + TypeScript + Tailwind frontend · GitHub Copilot agents · GitHub Actions CI → ghcr.io → ArgoCD (homelab)

## How It Works

1. **Clone this repo** for a new project and replace placeholders (see [Customization](#customization)).
2. **Design** — optionally use Design OS agents to plan the product and prototype UI screens.
3. **Implement** — use specialized agents (Requirements Engineer → Solution Architect → Backend/Frontend Developer → QA Engineer) to spec, architect, and build features.
4. **Release** — tag services, CI builds container images, then update Kubernetes manifests in `~/code/homelab` so ArgoCD deploys automatically.

Each project gets two independently versioned services (`frontend`, `backend`), each with its own GitHub Actions workflow, container image, and Kubernetes deployment.

## Quick Start

```bash
make setup        # Install deps (backend + frontend + design), create .env
make dev          # Start PostgreSQL + backend + frontend
make dev-design   # Start Design OS preview app
```

- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs
- Design OS: http://localhost:5174

## Customization

After cloning, replace these placeholders throughout the codebase:

| Placeholder        | Replace With                  | Example             |
| ------------------ | ----------------------------- | ------------------- |
| `{PROJECT_NAME}`   | Your project name             | "My Awesome App"    |
| `{PREFIX}`         | Feature ID prefix (3-5 chars) | "APP", "PROJ", "MY" |
| `starter-backend`  | Your backend package name     | "my-app-backend"    |
| `starter-frontend` | Your frontend package name    | "my-app-frontend"   |
| `starter-db-dev`   | Your Docker container name    | "my-app-db-dev"     |

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
│   ├── copilot-instructions.md       # Main Copilot config
│   ├── agents/                       # 16 specialized agents
│   ├── instructions/                 # Auto-applied coding rules
│   ├── skills/                       # /help, /frontend-design, /product-hub, /release
│   └── workflows/                    # CI: build & push container images on tag
│       ├── frontend.yml              #   triggers on frontend/v* tags
│       └── backend.yml               #   triggers on backend/v* tags
├── docs/
│   └── ARCHITECTURE.md               # System architecture
├── design/                           # Design OS app (standalone Vite on :5174)
│   ├── product/                      # Product planning files
│   ├── export/                       # Design export artifacts (generated)
│   └── src/                          # Screen designs & preview app
├── backend/                          # FastAPI backend
│   ├── app/                          # Application code
│   ├── tests/                        # Pytest tests
│   └── alembic/                      # DB migrations
├── frontend/                         # React frontend
│   ├── src/                          # Application code
│   └── e2e/                          # Playwright tests
├── Makefile                          # Dev commands
└── docker-compose.yml                # PostgreSQL (dev)
```

## Development Workflow

This template uses a structured agent-driven workflow with two phases:

### Phase 1: Design (optional)

```
Design: Product Vision → Product Roadmap → Data Shape → Design System → Shell
  → per section: Shape Section → Sample Data → Screen → Screenshot
  → Clickdummy → Export
```

Use Design OS agents to plan your product, design UI screens, and export artifacts before writing code. Start with `@Design: Product Vision`.

### Phase 2: Implementation

```
Requirements Engineer → Solution Architect → Backend/Frontend Developer → QA Engineer
```

1. **New project?** Switch to **Requirements Engineer** to create PRD and initial features (or use **Design: Export** output)
2. **New feature?** Switch to **Requirements Engineer** to create a spec
3. **Ready to design?** Switch to **Solution Architect** for tech design + plan
4. **Ready to build?** Switch to **Backend Developer** or **Frontend Developer**
5. **Ready to test?** Switch to **QA Engineer**

Use `/help` skill anytime to see project status and recommended next steps.

## Release & Deployment

Services are independently versioned via git tags (`<service>/v<semver>`). The `/release` skill handles the full lifecycle:

1. **Changelog** — collects commits since the last tag, appends to `CHANGELOG.md`
2. **Tagging** — creates git tags that trigger GitHub Actions CI → builds multi-arch images → pushes to `ghcr.io`
3. **Deploy** — updates Kubernetes manifests in `~/code/homelab` → ArgoCD syncs automatically

```bash
# Example: the /release skill handles all of this via Copilot chat
# "ship it"           → full flow for all changed services
# "bump frontend"     → changelog + tag for frontend only
# "deploy to preview" → update preview manifests in homelab
# "what's deployed?"  → show status table
```

Each project gets two environments in homelab:
- **Production** — `apps/<project-name>/` (stable tags like `v1.2.3`)
- **Preview** — `apps/<project-name>-preview/` (preview tags like `v1.2.3-preview.1`)

Preview → stable promotion retags the existing image instead of rebuilding.

## Commands

| Command              | Description                           |
| -------------------- | ------------------------------------- |
| `make setup`         | Install all dependencies, create .env |
| `make dev`           | Start PostgreSQL + backend + frontend |
| `make dev-design`    | Start Design OS preview app (5174)    |
| `make dev-stop`      | Stop PostgreSQL                       |
| `make kill`          | Kill all dev processes                |
| `make test-backend`  | Run pytest                            |
| `make test-frontend` | Run Playwright E2E                    |
| `make db-migrate`    | Run Alembic migrations                |
| `make db-reset`      | Reset database                        |
| `make clean`         | Remove venv, node_modules, dist       |

## Testing

```bash
# Backend
cd backend && uv run pytest
cd backend && uv run pytest -k test_name

# Frontend E2E
cd frontend && npx playwright test
cd frontend && npx playwright test --ui
```

## Credits

- **Design OS** — Created by **Brian Casel @ [Builder Methods](https://buildermethods.com)**. This template integrates a [community adaptation](https://github.com/timosur/design-os-gh-copilot-template) of [Design OS](https://buildermethods.com/design-os) for GitHub Copilot. All credit and intellectual property for Design OS belong to Brian Casel.
  - **Original repo:** [github.com/caselabs/design-os](https://github.com/caselabs/design-os)
  - **Website:** [buildermethods.com/design-os](https://buildermethods.com/design-os)

## License

MIT
