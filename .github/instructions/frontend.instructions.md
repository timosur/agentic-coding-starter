---
applyTo: "frontend/**"
---

# Frontend Instructions

## Structure

All pages lazy-loaded in `App.tsx` with React Router v7. Import alias `@/*` → `src/*`.

- `src/pages/` — page components (default exports, one per route)
- `src/components/` — organized by feature domain
- `src/api/` — API client modules, one per backend resource

## Patterns

### API Client

Every backend resource has a matching `src/api/<resource>.ts` module. All use `apiFetch()` from `src/api/client.ts`.

- Always check existing API modules before creating new ones: `ls frontend/src/api/`
- Follow the established pattern: export typed functions that call `apiFetch()`

### Routing

- All page components use default exports and are lazy-loaded in `App.tsx`

### Styling

- **Tailwind CSS v4** via `@tailwindcss/vite` plugin
- No inline styles or CSS modules — Tailwind only
- Dark mode: use `dark:` variants (automatic via `prefers-color-scheme` or class toggle)
- Theme customization: use `@theme` directive in `src/index.css`

### Components

- Check existing components before creating new ones: `ls frontend/src/components/`
- Organize by feature domain, not by component type
- TypeScript interfaces for all props
- Handle loading, error, and empty states

## TypeScript

- Strict mode: `noUnusedLocals`, `noUnusedParameters`, `noFallthroughCasesInSwitch`
- No `any` types — use proper typing
- Prefer interfaces over type aliases for object shapes

## Testing

```bash
cd frontend && npx playwright test                    # all E2E tests
cd frontend && npx playwright test e2e/example.spec.ts   # single spec
```
