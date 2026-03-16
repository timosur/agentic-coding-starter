# Feature Tracking

All features are tracked using feature specs in this directory.

## Feature IDs

Features use sequential IDs: `{PREFIX}-1`, `{PREFIX}-2`, etc. Check this directory for the next available number before creating a new feature.

## Statuses

| Status          | Meaning                             |
| --------------- | ----------------------------------- |
| **Planned**     | Spec written, not yet started       |
| **In Progress** | Active development                  |
| **In Review**   | Implementation done, QA in progress |
| **Deployed**    | Live in production                  |

## Feature Spec Format

Each feature spec file follows the template in `.github/agents/templates/feature-spec.md` and contains:

1. **Header** — ID, status, created date, dependencies
2. **Description** — What this feature does and why
3. **Scope** — Which sub-features and files it covers
4. **User Stories** — As a [role], I want [action], so that [benefit]
5. **Acceptance Criteria** — Testable conditions for completion
6. **Edge Cases** — Boundary conditions and error scenarios
7. **Tech Design** _(appended by Solution Architect agent)_ — Component design, data model, API
8. **Implementation Plan** — Link to `project/plans/{PREFIX}-X-plan.md` (phased task checklist with verification checkpoints, created by Solution Architect agent)
9. **QA Results** _(appended by QA Engineer agent)_ — Test results, bugs found, security audit

## Workflow

1. **New feature idea** → switch to the **Requirements Engineer** agent to create a spec
2. **Design** → switch to the **Solution Architect** agent to append tech design and create implementation plan
3. **Build** → switch to the **Frontend Developer** and/or **Backend Developer** agents to implement (follows `project/plans/{PREFIX}-X-plan.md`)
4. **Test** → switch to the **QA Engineer** agent to test against acceptance criteria
5. **Ship** → mark status as Deployed

Agents are selected from the dropdown in the Copilot Chat window. Skills are invoked via `/` slash commands. Every agent reads `project/features/INDEX.md` at the start and updates it when done.

## Naming Convention

- File: `project/features/{PREFIX}-X-short-name.md`
- Commit: `feat({PREFIX}-X): description` / `fix({PREFIX}-X): description`
