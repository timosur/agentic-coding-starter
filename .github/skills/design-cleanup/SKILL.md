---
name: design-cleanup
description: Remove all design phase artifacts and references after design is complete. Use when the user says "clean up design", "remove design", "design phase done", "finish design", "delete design", or "design cleanup".
---

# Design Phase Cleanup

One-time skill that removes all Design OS artifacts, agent files, and references from the project after the design phase is complete. This is a destructive operation — the design folder and all design agent files will be permanently deleted.

## Prerequisites

Design export must be complete before running this skill. All design artifacts (PRD, design tokens, architecture docs) should already be pushed to Product Hub and written to `frontend/src/index.css` and `docs/ARCHITECTURE.md` via the `Design: Export` agent.

## Workflow

### Step 1: Safety Checks

Before doing anything destructive:

1. Run `git status` and check for uncommitted changes in `design/`. If any exist, **warn the user** and ask them to commit or discard before proceeding.
2. Ask the user to confirm: "This will permanently delete the `design/` folder, all 11 design agent files, and remove design references from project config files. Proceed?"
3. Do NOT proceed without explicit confirmation.

### Step 2: Delete the `design/` Folder

```bash
rm -rf design/
```

### Step 3: Delete Design Agent Files

Delete all 11 design agent definition files:

```bash
rm -f .github/agents/00-design-productvision.agent.md
rm -f .github/agents/01-design-productroadmap.agent.md
rm -f .github/agents/02-design-datashape.agent.md
rm -f .github/agents/03-design-system.agent.md
rm -f .github/agents/04-design-shell.agent.md
rm -f .github/agents/05-design-shapesection.agent.md
rm -f .github/agents/06-design-sampledata.agent.md
rm -f .github/agents/07-design-screen.agent.md
rm -f .github/agents/08-design-screenshot.agent.md
rm -f .github/agents/09-design-clickdummy.agent.md
rm -f .github/agents/10-design-export.agent.md
```

### Step 4: Edit `.github/copilot-instructions.md`

Apply these edits in order:

**4a.** In the `## Build & Run` code block, remove the `(includes design/)` suffix and the `dev-design` line. Change:
```
make setup          # first time: .env, Python + Node deps (includes design/)
make dev            # PostgreSQL → migrations → backend (8000) + frontend (5173)
make dev-design     # Design OS preview app (5174)
make dev-stop       # stop containers
```
To:
```
make setup          # first time: .env, Python + Node deps
make dev            # PostgreSQL → migrations → backend (8000) + frontend (5173)
make dev-stop       # stop containers
```

**4b.** In the `## Architecture` section, change from three services to two. Remove the `design/` bullet and the `Design OS conventions` line. Change:
```
Three independent services in one repo, each with its own dependency management:

- **`frontend/`** — React 19 SPA. `npm` + `package.json`. Vite dev server proxied to backend.
- **`backend/`** — FastAPI REST API. `uv` + `pyproject.toml`. Alembic for DB migrations.
- **`design/`** — Design OS app. `npm` + `package.json`. Standalone Vite app on port 5174 for product planning, UI design, and screen prototyping. Working files in `design/product/`, screen designs in `design/src/sections/`. Export bridges artifacts into `design/export/`. Delete the entire `design/` folder after the design phase is complete.

Service-specific conventions and patterns are in `.github/instructions/`:
- `backend.instructions.md` — route/service/model patterns, migrations
- `frontend.instructions.md` — React patterns, Tailwind, API client
- `security.instructions.md` — secrets, input validation
- Design OS conventions are in `design/agents.md`
```
To:
```
Two independent services in one repo, each with its own dependency management:

- **`frontend/`** — React 19 SPA. `npm` + `package.json`. Vite dev server proxied to backend.
- **`backend/`** — FastAPI REST API. `uv` + `pyproject.toml`. Alembic for DB migrations.

Service-specific conventions and patterns are in `.github/instructions/`:
- `backend.instructions.md` — route/service/model patterns, migrations
- `frontend.instructions.md` — React patterns, Tailwind, API client
- `security.instructions.md` — secrets, input validation
```

**4c.** In `## Product Context`, remove the `design/export/` reference line. Change:
```
See `docs/ARCHITECTURE.md` for system architecture, API endpoints, data models.
See `design/export/` for UI designs, components, and test specs exported from Design OS (available during/after design phase).
```
To:
```
See `docs/ARCHITECTURE.md` for system architecture, API endpoints, data models.
```

**4d.** Remove the entire `## Design Phase (Design OS)` section — from the `## Design Phase (Design OS)` header through the line `Delete the \`design/\` folder once the design phase is complete.` (includes subsections: Design OS Workflow, What Export Produces, After Export).

**4e.** In `## Development Workflow`, simplify the workflow arrow. Change:
```
Design OS agents → Export → Requirements Engineer → Solution Architect → Backend Developer ⟷ Frontend Developer → QA Engineer
```
To:
```
Requirements Engineer → Solution Architect → Backend Developer ⟷ Frontend Developer → QA Engineer
```

**4f.** Remove the entire `### Design Agents (Product Planning & UI Design)` subsection — from the `### Design Agents` header through the last table row (`| **Design: Export** | ... |`).

**4g.** In the skills table, remove the `/design-cleanup` row (if it was added in step 5 below — this is self-cleanup).

**4h.** In `## Parallel Sessions` → `### Recommended Session Splits`, remove the design session bullet. Change:
```
- **Design session** — Product planning, UI design. Working directory: `design/`.
- **Frontend session** — UI components, pages, styles. Working directory: `frontend/`.
```
To:
```
- **Frontend session** — UI components, pages, styles. Working directory: `frontend/`.
```

### Step 5: Edit `Makefile`

**5a.** In the `.PHONY` line, remove `setup-design` and `dev-design`. Change:
```
.PHONY: help setup setup-design dev dev-design dev-stop db-up db-stop db-migrate db-reset db-shell test-backend test-frontend build-frontend clean
```
To:
```
.PHONY: help setup dev dev-stop db-up db-stop db-migrate db-reset db-shell test-backend test-frontend build-frontend clean
```

**5b.** Remove `cd design && npm install` from the `setup` target.

**5c.** Remove the entire `dev-design` target:
```
dev-design: ## Start Design OS preview app (5174)
	cd design && npm run dev
```

**5d.** In the `kill` target, remove the design port kill block and update the comment. Change the comment from:
```
kill: ## Kill any running dev processes (backend on 8000, frontend on 5173, design on 5174)
```
To:
```
kill: ## Kill any running dev processes (backend on 8000, frontend on 5173)
```
And remove these lines:
```
	@echo "Killing processes on port 5174 (design)..."
	-@lsof -ti:5174 | xargs kill -9 2>/dev/null || true
```

**5e.** In the `clean` target, remove:
```
	rm -rf design/node_modules
	rm -rf design/dist
```

### Step 6: Edit `README.md`

**6a.** In `## How It Works`, remove step 2 about Design and renumber. Change:
```
1. **Clone this repo** for a new project and replace placeholders (see [Customization](#customization)).
2. **Design** — optionally use Design OS agents to plan the product and prototype UI screens.
3. **Implement** — use specialized agents (Requirements Engineer → Solution Architect → Backend/Frontend Developer → QA Engineer) to spec, architect, and build features.
4. **Release** — tag services, CI builds container images, then update Kubernetes manifests in `~/code/homelab` so ArgoCD deploys automatically.
```
To:
```
1. **Clone this repo** for a new project and replace placeholders (see [Customization](#customization)).
2. **Implement** — use specialized agents (Requirements Engineer → Solution Architect → Backend/Frontend Developer → QA Engineer) to spec, architect, and build features.
3. **Release** — tag services, CI builds container images, then update Kubernetes manifests in `~/code/homelab` so ArgoCD deploys automatically.
```

**6b.** In `## Quick Start`, remove the `make dev-design` line and the Design OS URL. Change:
```bash
make setup        # Install deps (backend + frontend + design), create .env
make dev          # Start PostgreSQL + backend + frontend
make dev-design   # Start Design OS preview app
```
To:
```bash
make setup        # Install deps (backend + frontend), create .env
make dev          # Start PostgreSQL + backend + frontend
```

And remove:
```
- Design OS: http://localhost:5174
```

**6c.** In `## Project Structure`, remove the `design/` block:
```
├── design/                           # Design OS app (standalone Vite on :5174)
│   ├── product/                      # Product planning files
│   ├── export/                       # Design export artifacts (generated)
│   └── src/                          # Screen designs & preview app
```

Also update the agents count comment from `# 16 specialized agents` to reflect the reduced count (subtract 11 design agents → `# 5 specialized agents`).

**6d.** Remove the entire `### Phase 1: Design (optional)` section and restructure. Remove:
```
### Phase 1: Design (optional)

\`\`\`
Design: Product Vision → Product Roadmap → Data Shape → Design System → Shell
  → per section: Shape Section → Sample Data → Screen → Screenshot
  → Clickdummy → Export
\`\`\`

Use Design OS agents to plan your product, design UI screens, and export artifacts before writing code. Start with `@Design: Product Vision`.

### Phase 2: Implementation
```
Replace with just:
```
### Implementation
```

Also in the implementation steps, remove the `Design: Export` reference. Change:
```
1. **New project?** Switch to **Requirements Engineer** to create PRD and initial features (or use **Design: Export** output)
```
To:
```
1. **New project?** Switch to **Requirements Engineer** to create PRD and initial features
```

**6e.** In `## Commands`, remove the `make dev-design` row:
```
| `make dev-design`    | Start Design OS preview app (5174)    |
```

**6f.** Remove the entire `## Credits` section about Design OS:
```
## Credits

- **Design OS** — Created by **Brian Casel @ [Builder Methods](https://buildermethods.com)**. This template integrates a [community adaptation](https://github.com/timosur/design-os-gh-copilot-template) of [Design OS](https://buildermethods.com/design-os) for GitHub Copilot. All credit and intellectual property for Design OS belong to Brian Casel.
  - **Original repo:** [github.com/caselabs/design-os](https://github.com/caselabs/design-os)
  - **Website:** [buildermethods.com/design-os](https://buildermethods.com/design-os)
```

### Step 7: Edit Implementation Agent Files

**7a.** In `.github/agents/11-dev-requirements.agent.md`, in the `## Before Starting` section, remove step 4 about `design/export/`. Change:
```
3. Read the `/product-hub` skill for feature spec format and conventions
4. Check `design/export/` — if it exists, Design OS has exported UI designs, components, and data shapes. Use these as input when creating feature specs (reference specific components, screenshots, and test specs from the export).

**If `product_hub_get_prd` returns empty or no content** → Go to **Init Mode** (new project setup)
```
To:
```
3. Read the `/product-hub` skill for feature spec format and conventions

**If `product_hub_get_prd` returns empty or no content** → Go to **Init Mode** (new project setup)
```

**7b.** In `.github/agents/12-dev-architecture.agent.md`, in the `## Before Starting` section, remove step 4 about `design/export/` and renumber step 5. Change:
```
3. Read `docs/ARCHITECTURE.md` for current system architecture
4. Check `design/export/` — if it exists, read `design/export/instructions/overview.md` and the relevant section instruction in `design/export/instructions/sections/`. These contain UI component specs, data shapes, user flows, and test specs from Design OS that should inform your architecture decisions and implementation plan.
5. Check what already exists:
```
To:
```
3. Read `docs/ARCHITECTURE.md` for current system architecture
4. Check what already exists:
```

### Step 8: Renumber Implementation Agent Files

Rename the remaining agent files to close the numbering gap left by the deleted design agents:

```bash
mv .github/agents/11-dev-requirements.agent.md .github/agents/1-dev-requirements.agent.md
mv .github/agents/12-dev-architecture.agent.md .github/agents/2-dev-architecture.agent.md
mv .github/agents/13-dev-backend.agent.md .github/agents/3-dev-backend.agent.md
mv .github/agents/14-dev-frontend.agent.md .github/agents/4-dev-frontend.agent.md
mv .github/agents/15-dev-qa.agent.md .github/agents/5-dev-qa.agent.md
```

Note: Agent matching uses the `name:` field in YAML frontmatter, not filenames. No content changes needed inside the files — this is purely cosmetic.

### Step 9: Self-Cleanup

Delete this skill and its registration:

```bash
rm -rf .github/skills/design-cleanup/
```

Remove the `/design-cleanup` row from the skills table in `.github/copilot-instructions.md` (if it was added during registration).

### Step 10: Verify

Run these checks to confirm cleanup is complete:

```bash
# Should return no results (except possibly docs/ARCHITECTURE.md content that was updated by export)
grep -r "design/" --include="*.md" .github/ || echo "✓ No design/ references in .github/"

# Should return no results
grep -r "Design OS" . --include="*.md" --exclude-dir=node_modules || echo "✓ No Design OS references"

# Should return no results
grep -r "dev-design" . --exclude-dir=node_modules || echo "✓ No dev-design references"

# Should fail (directory deleted)
ls design/ 2>/dev/null && echo "✗ design/ still exists" || echo "✓ design/ deleted"

# Should fail (skill self-deleted)
ls .github/skills/design-cleanup/ 2>/dev/null && echo "✗ skill still exists" || echo "✓ skill self-deleted"
```

If any references remain, clean them up manually.

### Step 11: Commit

Ask the user if they want to commit:

```bash
git add -A
git commit -m "chore: remove design phase artifacts and references"
```
