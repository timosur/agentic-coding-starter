---
name: product-hub
description: Access and manage product data (PRD, features, plans) via the Product Hub MCP server. Use when agents need to read or write product requirements, feature specs, or implementation plans. Also trigger for "sync", "product hub", "PRD", "feature spec", or "implementation plan".
---

# Product Hub

## What Is Product Hub

Product Hub is an external service for centralized product management. It stores and serves:

- **PRD** (Product Requirements Document) — product vision, target users, roadmap
- **Feature specs** — user stories, acceptance criteria, edge cases
- **Implementation plans** — phased task checklists with verification checkpoints

Product data does **not** live in the repo. It is accessed exclusively through Product Hub MCP tools.

The only product-related documentation that stays in the repo is **technical architecture** at `docs/ARCHITECTURE.md` — because it changes with code and is needed for writing code.

## When to Use

Use Product Hub MCP tools whenever you need to:
- Read the PRD to understand product context
- List features and their statuses
- Read a feature spec for acceptance criteria
- Create or update a feature spec
- Read or create implementation plans
- Update plan progress (check off tasks)

## Available MCP Tools

### Reading

| Tool | Purpose | Parameters |
|------|---------|------------|
| `product_hub_get_prd` | Fetch PRD content (markdown) | `project_id?` |
| `product_hub_list_features` | List all features (id, name, status) | `project_id?` |
| `product_hub_get_feature` | Get full feature spec by ID | `feature_id`, `project_id?` |
| `product_hub_list_plans` | List all implementation plans | `project_id?` |
| `product_hub_get_plan` | Get full plan by ID | `plan_id`, `project_id?` |

### Writing

| Tool | Purpose | Parameters |
|------|---------|------------|
| `product_hub_update_prd` | Update PRD content | `content` (markdown), `project_id?` |
| `product_hub_create_feature` | Create new feature spec | `name`, `content` (markdown), `status?`, `project_id?` |
| `product_hub_update_feature` | Update feature content/status | `feature_id`, `content?`, `status?`, `project_id?` |
| `product_hub_create_plan` | Create new implementation plan | `feature_id`, `name`, `content` (markdown), `project_id?` |
| `product_hub_update_plan` | Update existing plan | `plan_id`, `content?`, `project_id?` |

All tools accept an optional `project_id` parameter. If omitted, the default project configured in the MCP server is used.

## Data Formats

### PRD Structure

```markdown
# {Product Name} — PRD

## Vision
{2-3 sentence product description}

## Target Users
{Who uses it and their needs}

## Core Features (Roadmap)
| Priority | Feature | Description | Status |
|----------|---------|-------------|--------|
| P0       | ...     | ...         | Planned |

## Success Metrics
{Measurable outcomes}

## Constraints
{Technical and resource limitations}

## Non-Goals
{What is explicitly NOT being built}
```

### Feature Spec Structure

Use the template at `.github/agents/templates/feature-spec.md`:

```markdown
# {PREFIX}-X: Feature Name

| Field | Value |
|---|---|
| **ID** | {PREFIX}-X |
| **Created** | YYYY-MM-DD |
| **Dependencies** | None / {PREFIX}-Y |

## Description
## Scope
## User Stories
## Acceptance Criteria
## Edge Cases
## Tech Design (appended by Solution Architect)
## Implementation Plan (link to plan in Product Hub)
```

### Implementation Plan Structure

```markdown
# {PREFIX}-X: Feature Name — Implementation Plan

> Status: Not Started | In Progress | Complete
> Created: YYYY-MM-DD

## Overview
## Phase 1: ...
- [ ] Task 1
- [ ] **Checkpoint:** Verify ...
## Phase 2: ...
## Verification
```

## Feature Lifecycle

| Status | Meaning |
|--------|---------|
| **Planned** | Spec written, not yet started |
| **In Progress** | Active development |
| **In Review** | Implementation done, QA in progress |
| **Deployed** | Live in production |

## Feature ID Conventions

- Sequential IDs: `{PREFIX}-1`, `{PREFIX}-2`, etc.
- Use `product_hub_list_features` to find the next available number
- Commits: `feat({PREFIX}-X): description` / `fix({PREFIX}-X): description`

## Feature Granularity

Each feature = ONE testable, deployable unit. Never combine:
- Multiple independent functionalities
- CRUD operations for different entities
- User functions + admin functions

Document dependencies between features in the spec.

## Architecture Documentation

Technical architecture lives locally at `docs/ARCHITECTURE.md` — not in Product Hub. Update it after making non-trivial code changes (new endpoints, models, services).

## Setup

The Product Hub MCP server is configured in `.vscode/mcp.json`. It requires:
- Product Hub MCP URL
- API key for authentication

If the MCP server is not configured, `product_hub_*` tools will not be available. In that case, product data cannot be accessed — configure the Product Hub connection first.
