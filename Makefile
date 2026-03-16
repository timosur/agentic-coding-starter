# Load .env if it exists
-include .env
export

COMPOSE_DEV := docker compose -f docker-compose.yml

.PHONY: help setup setup-design dev dev-design dev-stop db-up db-stop db-migrate db-reset db-shell test-backend test-frontend build-frontend clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

setup: db-up ## Create .env from template, install deps
	@test -f .env || (cp .env.example .env && echo "Created .env from .env.example")
	cd backend && uv sync --all-extras
	cd frontend && npm install
	cd design && npm install

dev: db-up db-migrate ## Start PostgreSQL, run migrations, launch backend + frontend
	cd backend && uv run honcho start -f ../Procfile.dev -e ../.env

dev-stop: db-stop ## Stop the PostgreSQL dev container

dev-design: ## Start Design OS preview app (5174)
	cd design && npm run dev

kill: ## Kill any running dev processes (backend on 8000, frontend on 5173, design on 5174)
	@echo "Killing processes on port 8000 (backend)..."
	-@lsof -ti:8000 | xargs kill -9 2>/dev/null || true
	@echo "Killing processes on port 5173 (frontend)..."
	-@lsof -ti:5173 | xargs kill -9 2>/dev/null || true
	@echo "Killing processes on port 5174 (design)..."
	-@lsof -ti:5174 | xargs kill -9 2>/dev/null || true
	@echo "Killing honcho processes..."
	-@pkill -f "honcho start" 2>/dev/null || true
	@echo "Done."

db-up: ## Start PostgreSQL container
	$(COMPOSE_DEV) up -d --wait

db-stop: ## Stop all dev containers
	$(COMPOSE_DEV) down

db-migrate: ## Run alembic migrations
	cd backend && uv run alembic upgrade head

db-reset: ## Destroy volume, recreate database, migrate
	$(COMPOSE_DEV) down -v
	$(COMPOSE_DEV) up -d --wait
	cd backend && uv run alembic upgrade head

db-shell: ## Open psql shell in the database container
	docker exec -it starter-db-dev psql -U app -d app

test-backend: ## Run backend tests with pytest
	cd backend && uv run pytest

test-frontend: ## Run frontend E2E tests with Playwright
	cd frontend && npx playwright test

build-frontend: ## Build frontend for production
	cd frontend && npm run build

clean: ## Remove venv, node_modules, and dist
	rm -rf backend/.venv
	rm -rf frontend/node_modules
	rm -rf frontend/dist
	rm -rf design/node_modules
	rm -rf design/dist
