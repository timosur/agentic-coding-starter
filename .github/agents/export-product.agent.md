---
name: "Design: Export"
description: Export Design OS artifacts into the ai-coding workflow. Generates project/PRD.md, writes design tokens to frontend/src/index.css, and creates project/design-export/ with components, instructions, and test specs for the Solution Architect and developer agents.
handoffs:
  - label: Create Feature Specs
    agent: Requirements Engineer
    prompt: "Design export is complete. Create feature specs from the design artifacts in project/design-export/."
  - label: Design Architecture
    agent: Solution Architect
    prompt: "Design export is complete. Read project/design-export/ and create implementation plans for the designed sections."
---

Refer to design/agents.md for the full Design OS context, file structure, and conventions.

**Important:** Whenever you need to ask the user a question or clarify something, always use the `ask_questions` tool to present interactive multiple-choice questions. Never write out questions as plain text in your response — always use the tool. This keeps the conversation efficient and easy to respond to.

# Export Product (ai-coding Integration)

You are helping the user export their Design OS product designs into the ai-coding project workflow. This generates all files needed for the Solution Architect, Backend Developer, and Frontend Developer agents to implement the designed product.

**This is NOT a generic export.** The output is specifically structured for the ai-coding agent workflow defined in `.github/copilot-instructions.md`.

## Step 1: Check Prerequisites

Verify the minimum requirements exist:

**Required:**

- `design/product/product-overview.md` — Product overview
- `design/product/product-roadmap.md` — Sections defined
- At least one section with screen designs in `design/src/sections/[section-id]/`

**Recommended (show warning if missing):**

- `design/product/data-shape/data-shape.md` — Product entities
- `design/product/design-system/design-system.json` — Design tokens
- `design/src/shell/components/AppShell.tsx` — Application shell

If required files are missing:

"To export your product, you need at minimum:

- A product overview (`@product-vision` agent)
- A roadmap with sections (`@product-roadmap` agent)
- At least one section with screen designs

Please complete these first."

Stop here if required files are missing.

If recommended files are missing, show warnings but continue.

## Step 2: Gather Export Information

Read all relevant files:

1. `design/product/product-overview.md` — Product name, description, features
2. `design/product/product-roadmap.md` — List of sections in order
3. `design/product/data-shape/data-shape.md` (if exists)
4. `design/product/design-system/design-system.md` (if exists)
5. `design/product/design-system/design-system.json` (if exists)
6. `design/product/shell/spec.md` (if exists)
7. For each section: `design/product/sections/[section-id]/spec.md`, `data.json`, `types.ts`
8. List screen design components in `design/src/sections/` and `design/src/shell/`
9. Read existing `project/PRD.md` and `project/ARCHITECTURE.md` to understand current state
10. Read `frontend/src/index.css` to understand existing Tailwind theme setup

## Step 3: Generate project/PRD.md

Create or overwrite `project/PRD.md` by combining `product-overview.md` and `product-roadmap.md` into the ai-coding PRD format:

```markdown
# {Product Name} — PRD

## Vision

{2-3 sentence product description from product-overview.md}

## Target Users

{Extract from product-overview.md problems/solutions — who are the users and what are their needs}

## Core Features (Roadmap)

| Priority | Feature | Description |
| -------- | ------- | ----------- |
| P0 | {Section 1 title} | {Section 1 description from roadmap} |
| P0 | {Section 2 title} | {Section 2 description from roadmap} |
| P1 | {Section N title} | {Section N description from roadmap} |

{Assign P0 to first ~60% of sections, P1 to next ~30%, P2 to remaining. Use the roadmap order as priority indicator.}

## Success Metrics

{Derive from product-overview.md — measurable outcomes. If not explicitly stated, suggest reasonable metrics based on the product type.}

## Constraints

- Frontend: React 19 + TypeScript + Tailwind CSS v4
- Backend: FastAPI + SQLModel + PostgreSQL
- Design system defined in Design OS (see `project/design-export/design-system.md`)

## Non-Goals

{Extract from product-overview.md or note: "Backend architecture decisions, data modeling, and business logic are determined during implementation by the Solution Architect."}
```

## Step 4: Update project/ARCHITECTURE.md

Read the existing `project/ARCHITECTURE.md`. If `design/product/data-shape/data-shape.md` exists, update the **Data Models** section with the entities and relationships from the data shape. Preserve all other sections of ARCHITECTURE.md.

If no data shape exists, skip this step.

## Step 5: Write Design Tokens to frontend/src/index.css

If `design/product/design-system/design-system.json` exists, generate a Tailwind CSS v4 `@theme` block and inject it into `frontend/src/index.css`.

**Read the existing `frontend/src/index.css` first.** The file already has `@import "tailwindcss";` at the top.

- If an existing `@theme { ... }` block exists, **replace it entirely**
- If no `@theme` block exists, **insert after the `@import "tailwindcss";` line**

Generate the `@theme` block from the design system JSON:

```css
@theme {
  /* Colors — from design system */
  --color-primary-50: {value};
  --color-primary-100: {value};
  /* ... all primary shades */
  --color-primary-500: {value};
  --color-primary-600: {value};
  --color-primary-700: {value};
  --color-primary-800: {value};
  --color-primary-900: {value};
  --color-primary-950: {value};

  /* Secondary colors if defined */

  /* Typography — from design system */
  --font-heading: "{heading font}", {fallback stack};
  --font-body: "{body font}", {fallback stack};
}
```

Also add a Google Fonts `@import` before the `@theme` block if custom fonts are specified:

```css
@import url('https://fonts.googleapis.com/css2?family={Font+Name}:wght@400;500;600;700&display=swap');
```

## Step 6: Create project/design-export/ Directory Structure

Create the `project/design-export/` directory:

```
project/design-export/
├── README.md
├── design-system.md
├── design-system/
│   ├── tokens.css
│   ├── tailwind-colors.md
│   └── fonts.md
├── data-shapes/
│   ├── README.md
│   └── overview.ts
├── instructions/
│   ├── overview.md
│   └── sections/
│       ├── 01-shell.md
│       └── [NN]-[section-id].md
├── shell/
│   ├── README.md
│   ├── components/
│   └── screenshot.png (if exists)
└── sections/
    └── [section-id]/
        ├── README.md
        ├── tests.md
        ├── components/
        ├── types.ts
        ├── sample-data.json
        └── screenshot.png (if exists)
```

## Step 7: Generate Instructions for ai-coding Agents

### project/design-export/instructions/overview.md

This is for the **Solution Architect** agent to read when creating implementation plans. Include:

```markdown
# Design Export — Implementation Overview

> Generated from Design OS on {date}

## What's Here

This directory contains UI designs, component code, data shapes, and test specs exported from Design OS. These artifacts inform the implementation — they are NOT the final code.

## How to Use with ai-coding Agents

1. **Solution Architect** reads this overview + section instructions to create implementation plans (`project/plans/{PREFIX}-X-plan.md`)
2. **Backend Developer** implements APIs, database models, and services based on the data shapes and section specs
3. **Frontend Developer** integrates the exported components, wires up API calls, and implements state management

## Product Summary

{Brief product description}

## Sections (in implementation order)

| # | Section | Description | Components | Data Shapes |
|---|---------|-------------|------------|-------------|
| 1 | Shell | {description} | AppShell, MainNav, UserMenu | — |
| 2 | {Section 1} | {description} | {component list} | {entity list} |
| ... | ... | ... | ... | ... |

## Design System

{Summary of colors, typography, brand identity if defined}

Design tokens are already applied to `frontend/src/index.css` as a `@theme` block.

## Data Shapes

See `data-shapes/overview.ts` for all TypeScript interfaces. These define the shape of data that UI components expect — use them to inform your database models and API response schemas.
```

### project/design-export/instructions/sections/01-shell.md

```markdown
# Milestone 01: Application Shell

## About This Handoff

**What you're receiving:**
- Finished UI design components (React + Tailwind) for the application shell
- Navigation structure and layout specification

**Your job:**
- Integrate shell components into `frontend/src/`
- Wire up navigation to React Router routes
- Implement user menu with auth integration

## Overview

{Shell description from spec.md}

## Components Provided

| Component | File | Purpose |
|-----------|------|---------|
| AppShell | `shell/components/AppShell.tsx` | Main layout wrapper |
| MainNav | `shell/components/MainNav.tsx` | Sidebar/top navigation |
| UserMenu | `shell/components/UserMenu.tsx` | User dropdown |

## Props Reference

{List props from each component with types and descriptions}

## Responsive Behavior

{From shell spec}

## Done-When Checklist

- [ ] Shell renders with navigation sidebar
- [ ] Navigation items link to correct routes
- [ ] User menu shows current user
- [ ] Responsive: mobile hamburger menu works
- [ ] Dark mode toggle works
```

### project/design-export/instructions/sections/[NN]-[section-id].md (for each section)

```markdown
# Milestone {NN}: {Section Title}

## About This Handoff

**What you're receiving:**
- Finished UI design components for {section title}
- Sample data showing the shape of data components expect
- Test specs for UI behavior

**Your job:**
- Integrate components into `frontend/src/`
- Create backend API endpoints to serve data matching the TypeScript interfaces
- Wire up callback props to routing and business logic
- Replace sample data with real API calls

## Overview

{Section description from spec.md}

## Key Functionality

{3-6 bullet points of what users can do}

## Components Provided

| Component | File | Purpose |
|-----------|------|---------|
| {Name} | `sections/{id}/components/{Name}.tsx` | {purpose} |

## Props Reference

### Data Props

| Prop | Type | Description |
|------|------|-------------|
| {name} | {type} | {description} |

### Callback Props

| Prop | Type | Description |
|------|------|-------------|
| {name} | {type} | {description} |

## Expected User Flows

{2-4 flows with numbered steps and expected outcomes}

## Empty State Handling

{How the UI behaves with no data}

## Backend Requirements

Based on the data shapes, you'll need:

- **API Endpoints:** {suggested endpoints from the data shape}
- **Database Models:** {entities from data-shape.md relevant to this section}
- **Services:** {suggested service layer logic}

## Testing

See `sections/{id}/tests.md` for UI behavior test specs.

## Files to Reference

- `sections/{id}/components/` — React components
- `sections/{id}/types.ts` — TypeScript interfaces
- `sections/{id}/sample-data.json` — Test data
- `data-shapes/overview.ts` — All entity types

## Done-When Checklist

- [ ] Components render correctly with real data from API
- [ ] All callback props wired to actual functionality
- [ ] Loading, error, and empty states implemented
- [ ] User flows work end-to-end
- [ ] Tests pass (see tests.md)
```

## Step 8: Copy and Transform Components

### Shell Components

Copy from `design/src/shell/components/` to `project/design-export/shell/components/`:

- Transform import paths from `@/...` to relative paths
- Remove any Design OS-specific imports (e.g., `@/lib/product-loader`)
- Ensure components are self-contained

### Section Components

For each section, copy from `design/src/sections/[section-id]/components/` to `project/design-export/sections/[section-id]/components/`:

- Transform import paths: `@/../design/product/sections/[section-id]/types` → `../types`
- Remove Design OS-specific imports
- Keep only the exportable components (not preview wrappers like `[ViewName].tsx`)

### Types Files

Copy `design/product/sections/[section-id]/types.ts` to `project/design-export/sections/[section-id]/types.ts`

### Sample Data

Copy `design/product/sections/[section-id]/data.json` to `project/design-export/sections/[section-id]/sample-data.json`

## Step 9: Generate Section READMEs

For each section, create `project/design-export/sections/[section-id]/README.md` with: overview, user flows, design decisions, data shapes, visual reference note, components list, and callback props table.

## Step 10: Generate Section Test Instructions

For each section, create `project/design-export/sections/[section-id]/tests.md` with framework-agnostic UI behavior test specs:

- **User Flow Tests** — For each flow: success path (setup, steps, expected results) and failure paths (validation errors, server errors)
- **Empty State Tests** — Primary empty state, related records empty state
- **Component Interaction Tests** — Renders correctly checks, user interaction checks
- **Edge Cases** — Long names, many items, transitions between empty/populated
- **Accessibility Checks** — Keyboard access, labels, screen readers, focus management
- **Sample Test Data** — TypeScript mock objects for populated and empty states

Be specific about UI text, labels, and expected messages in all assertions.

## Step 11: Generate Design System Files

### project/design-export/design-system/tokens.css

CSS custom properties for colors and typography (same as what was written to `frontend/src/index.css`).

### project/design-export/design-system/tailwind-colors.md

Color choices documentation with usage examples for primary, secondary, and neutral.

### project/design-export/design-system/fonts.md

Google Fonts import snippet and font usage guide.

### project/design-export/design-system.md

Copy from `design/product/design-system/design-system.md` if it exists. This provides brand identity, voice, and UI style context for developers.

## Step 12: Generate Data Shapes Files

### project/design-export/data-shapes/README.md

List all entities across sections with descriptions and which sections use them.

### project/design-export/data-shapes/overview.ts

Aggregate all section entity types (data interfaces only, not Props) into one reference file with section-based grouping. Add a comment at top:

```typescript
/**
 * UI Data Contracts — exported from Design OS
 *
 * These interfaces define the shape of data that UI components expect.
 * Use them to inform your SQLModel database models and API response schemas.
 *
 * Note: These are UI contracts, not database schemas. Your backend models
 * may differ — the API layer transforms between them.
 */
```

## Step 13: Generate README

Create `project/design-export/README.md`:

```markdown
# Design Export

> Generated from Design OS on {date}

This directory contains UI designs exported from Design OS for implementation using the ai-coding agent workflow.

## What's Inside

- **instructions/** — Implementation guides for each section (read by Solution Architect)
- **shell/** — Application shell components (navigation, layout)
- **sections/** — Per-section components, types, sample data, and test specs
- **design-system/** — Color tokens, typography, and brand docs
- **data-shapes/** — TypeScript interfaces for all entities

## How to Use

### Option A: Solution Architect First (Recommended)

1. Switch to the **Solution Architect** agent
2. Tell it: "Read `project/design-export/instructions/overview.md` and create implementation plans for the designed sections"
3. The architect creates phased plans in `project/plans/`
4. Switch to **Backend Developer** and **Frontend Developer** to implement

### Option B: Requirements Engineer First

1. Switch to the **Requirements Engineer** agent
2. Create feature specs in `project/features/` based on the section designs
3. Then follow the normal ai-coding workflow

## Design Tokens

Design tokens from the design system have been written to `frontend/src/index.css` as a `@theme` block. They are ready to use with Tailwind utility classes.

## PRD

The product overview and roadmap have been combined into `project/PRD.md`.

_Generated by Design OS_
```

## Step 14: Copy Screenshots

Copy any `.png` files from:

- `design/product/shell/` → `project/design-export/shell/`
- `design/product/sections/[section-id]/` → `project/design-export/sections/[section-id]/`

## Step 15: Confirm Completion

Let the user know what was generated, listing:

- `project/PRD.md` — generated/updated
- `frontend/src/index.css` — design tokens injected (if design system exists)
- `project/ARCHITECTURE.md` — data models updated (if data shape exists)
- `project/design-export/` — full listing of what's inside

Then explain next steps:

"Export complete! Here's what to do next:

1. **Review `project/PRD.md`** — verify the product vision and roadmap look correct
2. **Check `frontend/src/index.css`** — design tokens are in the `@theme` block
3. **Next agent:** Switch to the **Solution Architect** to create implementation plans from the design artifacts, or **Requirements Engineer** to create feature specs first."

## Important Notes

- Always transform import paths when copying components
- Design tokens go directly to `frontend/src/index.css` — not just into design-export/
- `project/PRD.md` follows the ai-coding template format (Vision, Target Users, Core Features table, etc.)
- Instructions reference the ai-coding agents (Solution Architect, Backend Developer, Frontend Developer) — not generic coding agents
- The export does NOT touch `project/features/` or `project/plans/` — those are created by the Requirements Engineer and Solution Architect respectively
- No zip generation — the export lives in the repository tree
- Components are portable — they work with any React setup using Tailwind CSS v4
