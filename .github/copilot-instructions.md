# Copilot Instructions

## Build & Run

```bash
make setup          # first time: .env, Python + Node deps (includes design/)
make dev            # PostgreSQL → migrations → backend (8000) + frontend (5173)
make dev-design     # Design OS preview app (5174)
make dev-stop       # stop containers
```

### Testing

```bash
make test-backend                          # all backend tests (pytest)
cd backend && uv run pytest tests/test_api/test_example.py  # single test file
cd backend && uv run pytest -k test_name   # single test by name

make test-frontend                         # Playwright E2E (all)
cd frontend && npx playwright test e2e/example.spec.ts  # single E2E spec
```

### Build

```bash
cd frontend && npm run build    # tsc -b + vite build
```

No linter is configured for either frontend or backend.

## Architecture

Three independent services in one repo, each with its own dependency management:

- **`frontend/`** — React 19 SPA. `npm` + `package.json`. Vite dev server proxied to backend.
- **`backend/`** — FastAPI REST API. `uv` + `pyproject.toml`. Alembic for DB migrations.
- **`design/`** — Design OS app. `npm` + `package.json`. Standalone Vite app on port 5174 for product planning, UI design, and screen prototyping. Working files in `design/product/`, screen designs in `design/src/sections/`. Export bridges artifacts into `design/export/`. Delete the entire `design/` folder after the design phase is complete.

Service-specific conventions and patterns are in `.github/instructions/`:
- `backend.instructions.md` — route/service/model patterns, migrations
- `frontend.instructions.md` — React patterns, Tailwind, API client
- `security.instructions.md` — secrets, input validation
- Design OS conventions are in `design/agents.md`

## Conventions

- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) — `feat({PREFIX}-X):`, `fix({PREFIX}-X):`, etc. Use the feature ID when working on a tracked feature.
- **TypeScript:** Strict mode with `noUnusedLocals`, `noUnusedParameters`, `noFallthroughCasesInSwitch`.
- **Python tests:** `asyncio_mode = "auto"` in pytest config — test functions can be `async def` without decorators.
- **Backend migrations:** Alembic in `backend/alembic/`. Run `cd backend && uv run alembic revision --autogenerate -m "description"` to create new migrations.

## Feature Tracking

All features, specs, and plans are managed in **Product Hub** — an external service accessed via MCP tools. See the `/product-hub` skill for full details on available tools and data formats.

**Before starting any work:**
1. Use `product_hub_list_features` to understand the current feature landscape
2. If the work relates to an existing feature, use `product_hub_get_feature` to read its spec
3. Use `product_hub_list_plans` to check for existing implementation plans
4. If it's a new feature not yet tracked, create a spec first (switch to the **Requirements Engineer** agent)

**After completing work:**
1. Use `product_hub_update_feature` to update the feature spec with what was built and any deviations
2. Use `product_hub_update_feature` to update status (Planned → In Progress → In Review → Deployed)
3. Use `product_hub_update_plan` to check off completed tasks and update the status line

**Feature IDs:** Sequential `{PREFIX}-1`, `{PREFIX}-2`, etc. Use `product_hub_list_features` to find the next available number.

## Product Context

Use `product_hub_get_prd` for product vision, target users, and roadmap.
See `docs/ARCHITECTURE.md` for system architecture, API endpoints, data models.
See `design/export/` for UI designs, components, and test specs exported from Design OS (available during/after design phase).

### Product Hub

Product data (PRD, feature specs, implementation plans) lives in **Product Hub**, accessed via `product_hub_*` MCP tools configured in `.vscode/mcp.json`. The only product-related file in the repo is `docs/ARCHITECTURE.md` (technical architecture needed for writing code). See the `/product-hub` skill for setup and available tools.

## Design Phase (Design OS)

The `design/` folder contains a standalone Design OS app for product planning and UI design. Use it **before** implementation to define what gets built.

### Design OS Workflow

1. `@Design: Product Vision` → Define product overview
2. `@Design: Product Roadmap` → Define sections/features
3. `@Design: Data Shape` → Sketch entities and relationships
4. `@Design: Design System` → Define colors, typography, brand
5. `@Design: Shell` → Design navigation and layout
6. Per section: `@Design: Shape Section` → `@Design: Sample Data` → `@Design: Screen` → `@Design: Screenshot`
7. `@Design: Clickdummy` → Assemble navigable prototype for stakeholder demos
8. `@Design: Export` → Bridge into ai-coding workflow

### What Export Produces

- **Product Hub** — PRD pushed via `product_hub_update_prd`
- `frontend/src/index.css` — Design tokens as `@theme` block
- `docs/ARCHITECTURE.md` — Data Models updated from data-shape
- `design/export/` — Components, instructions, test specs, data shapes

### After Export

Switch to **Requirements Engineer** to create feature specs from sections, or **Solution Architect** to create implementation plans directly from `design/export/instructions/`.

Design OS agents and implementation agents coexist — you can go back to design agents to iterate on UI designs at any time. Delete the `design/` folder once the design phase is complete.

## Development Workflow

Use specialized agents for structured feature development. Agents are selected from the **dropdown in the Copilot Chat window** (not slash commands — those are for skills). Each agent has a distinct persona with appropriate tool restrictions and handoff buttons:

```
Design OS agents → Export → Requirements Engineer → Solution Architect → Backend Developer ⟷ Frontend Developer → QA Engineer
```

### Design Agents (Product Planning & UI Design)

| Agent | Purpose |
|-------|---------|
| **Design: Product Vision** | Define product overview — name, description, problems, solutions |
| **Design: Product Roadmap** | Define sections (features) with titles and descriptions |
| **Design: Data Shape** | Sketch core entities and relationships |
| **Design: Design System** | Define colors, typography, brand identity |
| **Design: Shell** | Design the application shell (navigation, layout) |
| **Design: Shape Section** | Define section specification and scope |
| **Design: Sample Data** | Generate sample data and TypeScript types for a section |
| **Design: Screen** | Create screen design components for a section |
| **Design: Screenshot** | Capture screenshots of screen designs |
| **Design: Clickdummy** | Assemble navigable prototype from all sections |
| **Design: Export** | Export designs into `design/export/`, push PRD to Product Hub, write design tokens to `frontend/src/index.css` |

### Implementation Agents

| Agent | Purpose |
|-------|---------|
| **Requirements Engineer** | Create feature specs with user stories and acceptance criteria |
| **Solution Architect** | Design tech architecture + create implementation plan (stored in Product Hub) |
| **Frontend Developer** | Build UI components, pages, styling (React, Tailwind, TypeScript) |
| **Backend Developer** | Build APIs, database schemas, services, migrations (FastAPI, SQLModel, async Python) |
| **QA Engineer** | Test against acceptance criteria + security audit. Never fixes bugs — only documents them. |

Supporting skills (invoked via `/skill` slash commands):

| Skill | Purpose |
|-------|---------|
| `/help` | Check project status, plan progress, and get next-step guidance |
| `/product-hub` | Access and manage product data (PRD, features, plans) via Product Hub |
| `/frontend-design` | Create distinctive, production-grade frontend interfaces |
| `/release` | Release lifecycle — changelog, tagging, and deploy to Kubernetes via homelab |

Each agent uses `product_hub_list_features` at start to understand the feature landscape, and suggests the next agent on completion via handoff buttons. Handoffs are user-initiated — an agent never auto-proceeds to the next phase.

## Agent Behavior

### Workflow

For non-trivial changes, follow this sequence:
1. **Research** — read relevant files, search for existing patterns and reusable utilities before writing code.
2. **Plan** — decompose into small, self-contained tasks with clear acceptance criteria.
3. **Implement** — execute each task with surgical precision. Make minimal changes.
4. **Verify** — confirm the change works (build, tests, manual check) before moving on.

### Principles

- **Minimum necessary complexity.** Apply YAGNI/KISS — don't add unrequested features or speculative abstractions. Balance leanness with genuine robustness.
- **Verify before acting.** Never assume — read the actual code, check actual file paths, confirm actual API signatures. Base decisions on verified facts, not guesses.
- **Clean up as you go.** When changes make code obsolete, remove it immediately. No dead code, no orphaned imports.
- **Propagate change impact.** When modifying a function signature, type, or API contract, trace and update all upstream and downstream callers.
- **Reuse what exists.** Search for existing utilities, components, hooks, and helpers before creating new ones. Follow established patterns in the codebase.
- **Don't hammer.** If an approach fails twice, change strategy instead of retrying the same thing.
- **Constructive fixes only.** Address root causes — don't disable tests, suppress errors, or remove functionality to make something pass.
- **Keep architecture docs in sync.** After making non-trivial code changes (new endpoints, models), update `docs/ARCHITECTURE.md`.

## Parallel Sessions

Multiple Copilot CLI instances can run simultaneously in separate terminals to work on different parts of the project. Guidelines:

### Recommended Session Splits

- **Design session** — Product planning, UI design. Working directory: `design/`.
- **Frontend session** — UI components, pages, styles. Working directory: `frontend/`.
- **Backend session** — API routes, services, models, migrations. Working directory: `backend/`.
- **Cross-cutting session** — Docker, CI/CD, docs, root-level config.

### Avoiding Conflicts

- Each session should focus on one service boundary. Avoid editing the same files from multiple sessions.
- Coordinate database migrations — only one session should create Alembic revisions at a time.
- If sessions touch shared files (e.g., `docker-compose.yml`, `.env.example`), finish one edit before starting another.
- Run `git pull --rebase` before committing to pick up changes from other sessions.

### Tips

- Use `/rename` to label each session (e.g., "frontend-auth", "backend-api").
- Use `/diff` in each session to review changes before committing.
- Keep sessions focused — one feature or fix per session works best.
- If a change in one service requires a matching change in another (e.g., new API endpoint + frontend integration), plan the interface first, then implement in parallel.
