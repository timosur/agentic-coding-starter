---
applyTo: "backend/app/api/**,.env*,docker-compose.yml"
---

# Security Instructions

## Secrets

- **Never** commit secrets, API keys, or tokens to the repository
- All secrets go in `.env` (gitignored) — document new secrets in `.env.example`
- Docker Compose reads secrets from `.env` via `env_file`

## Input Validation

- **Backend:** Pydantic/SQLModel validation on all request bodies — never trust raw input
- **Frontend:** Client-side validation is UX only — all real validation happens server-side
- Sanitize user-provided content before rendering (XSS prevention)

## API Security

- CORS configured for allowed origins only
- Never expose internal errors to clients — use generic error responses
