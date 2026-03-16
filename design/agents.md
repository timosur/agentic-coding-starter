# Agent Directives for Design OS

Design OS is a **product planning and design tool** that helps users define their product vision, sketch out their data shape, design their UI, and prepare export packages for implementation in a separate codebase.

> **Important**: Design OS is a planning tool, not the end product codebase. The screen designs and components generated here are meant to be exported and integrated into your actual product's codebase.

---

## Critical: Stay Focused on Your Task

**Each agent has ONE job. Do that job and nothing else.**

- Only produce the outputs described in your agent's instructions. Do not generate files or content that belong to a different agent or a later phase.
- If the user's request is ambiguous, ask a clarifying question — do not assume they want you to do more than what your agent covers.
- Never jump ahead in the planning flow. For example, the `@product-vision` agent must NOT create design tokens, shell specs, or section designs. It creates the product overview — that's it.
- If the user asks for something outside your scope, tell them which agent to use instead (e.g., "That's handled by the `@design-system` agent").
- Completing your task well is more valuable than doing many things poorly.

## Critical: Always Ask Before Generating

**Never generate or create files without first having a conversation with the user.**

- Always ask clarifying questions before creating any output files. Use the `ask_questions` tool for interactive multiple-choice questions.
- Do not auto-generate content based solely on reading other files — the user must be involved in shaping every output.
- The user's input and confirmation should drive what gets created, not your assumptions from existing files.
- After generating, always ask if the user wants adjustments.

---

## Understanding Design OS Context

When working in Design OS, be aware of two distinct contexts:

### 1. Design OS Application

The React application that displays and manages planning files. When modifying the Design OS UI itself:

- Files live in `design/src/` (components, pages, utilities)
- Uses the Design OS design system (stone palette, DM Sans, etc.)
- Provides the interface for viewing specs, screen designs, exports, etc.

### 2. Product Design (Screen Designs & Exports)

The product you're planning and designing. When creating screen designs and exports:

- Screen design components live in `design/src/sections/[section-name]/` and `design/src/shell/`
- Product definition files live in `design/product/`
- Exports are packaged to `project/design-export/` for integration into a separate codebase
- Follow the design requirements specified in each section's spec

---

## Getting Started — The Planning Flow

Design OS follows a structured planning sequence. Each step has a dedicated Copilot agent. Use one agent at a time — complete each step before moving to the next.

### 1. Product Overview (`@product-vision`)

Define your product name, description, problems/solutions, and key features.
**Output:** `design/product/product-overview.md`

### 2. Product Roadmap (`@product-roadmap`)

Define the main sections (features/areas) of the product.
**Output:** `design/product/product-roadmap.md`

### 3. Data Shape (`@data-shape`)

Sketch out the core entities and their relationships.
**Output:** `design/product/data-shape/data-shape.md`

### 4. Design System (`@design-system`)

Define your visual identity: colors (from Tailwind), typography (from Google Fonts), and optionally brand personality, voice, and UI style preferences. You can import brand resources (logos, style guides) for analysis.
**Input (optional):** Place brand assets in `design/product/design-system/resources/`
**Output:** `design/product/design-system/design-system.json`, `design/product/design-system/design-system.md`

### 5. Application Shell (`@design-shell`)

Design the persistent navigation and layout that wraps all sections. Uses design system personality and UI style preferences if available.
**Output:** `design/product/shell/spec.md`, `design/src/shell/components/`

### 6. For Each Section

- `@shape-section` — Define the specification and generate sample data + types
- `@sample-data` — Update sample data and types (if already created)
- `@design-screen` — Create screen designs (applies design system voice and UI style)
- `@screenshot-design` — Capture screenshots

### 7. Clickdummy (`@clickdummy`)

Assemble a fully navigable clickdummy from all designed sections. Wraps screen designs in the application shell with working inter-section navigation at `/clickdummy/preview`. Use this to demo to stakeholders and gather feedback before exporting.
**Output:** `design/src/clickdummy/ClickdummyApp.tsx`, route at `/clickdummy/preview`

### 8. Export (`@export-product`)

Generate the complete export package with all components, types, and handoff documentation.
**Output:** `project/design-export/`

---

## File Structure

```
product/                           # Product definition (portable)
├── product-overview.md            # Product description, problems/solutions, features
├── product-roadmap.md             # List of sections with titles and descriptions
│
├── data-shape/                    # Product data shape
│   └── data-shape.md              # Entity names, descriptions, and relationships
│
├── design-system/                 # Design system (colors, typography, brand identity)
│   ├── resources/                 # User-imported brand assets (logos, style guides, etc.)
│   ├── design-system.json         # Structured design system data for agents
│   └── design-system.md           # Human-readable design system documentation
│
├── shell/                         # Application shell
│   └── spec.md                    # Shell specification
│
└── sections/
    └── [section-name]/
        ├── spec.md                # Section specification
        ├── data.json              # Sample data for screen designs
        ├── types.ts               # TypeScript interfaces
        └── *.png                  # Screenshots

src/
├── shell/                         # Shell design components
│   ├── components/
│   │   ├── AppShell.tsx
│   │   ├── MainNav.tsx
│   │   ├── UserMenu.tsx
│   │   └── index.ts
│   └── ShellPreview.tsx
│
└── sections/
    └── [section-name]/
        ├── components/            # Exportable components
        │   ├── [Component].tsx
        │   └── index.ts
        └── [ViewName].tsx         # Preview wrapper

project/design-export/                      # Export package (generated)
├── README.md                      # Quick start guide
├── product-overview.md            # Product summary
├── design-system.md               # Design system documentation (colors, fonts, brand identity)
├── prompts/                       # Ready-to-use prompts for coding agents
│   ├── one-shot-prompt.md         # Prompt for full implementation
│   └── section-prompt.md          # Prompt template for incremental
├── instructions/                  # Implementation instructions
│   ├── one-shot-instructions.md   # All milestones combined
│   └── incremental/               # Milestone-by-milestone instructions
│       ├── 01-shell.md
│       └── [NN]-[section-id].md   # Section-specific instructions
├── design-system/                 # Tokens, colors, fonts
├── data-shapes/                   # UI data contracts (types components expect)
├── shell/                         # Shell components
└── sections/                      # Section components (with tests.md each)
```

---

## Design Requirements

When creating screen designs, follow these guidelines:

- **Mobile Responsive**: Use Tailwind's responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`) to ensure layouts adapt properly across screen sizes.

- **Light & Dark Mode**: Use `dark:` variants for all colors. Test that all UI elements are visible and readable in both modes.

- **Use Design Tokens**: When design tokens are defined, apply the product's color palette and typography. Otherwise, fall back to `stone` for neutrals and `lime` for accents.

- **Props-Based Components**: All screen design components must accept data and callbacks via props. Never import data directly in exportable components.

- **No Navigation in Section Screen Designs**: Section screen designs should not include navigation chrome. The shell handles all navigation.

---

## Tailwind CSS Directives

These rules apply to both the Design OS application and all screen designs/components it generates:

- **Tailwind CSS v4**: We always use Tailwind CSS v4 (not v3). Do not reference or create v3 patterns.

- **No tailwind.config.js**: Tailwind CSS v4 does not use a `tailwind.config.js` file. Never reference, create, or modify one.

- **Use Built-in Utility Classes**: Avoid writing custom CSS. Stick to using Tailwind's built-in utility classes for all styling.

- **Use Built-in Colors**: Avoid defining custom colors. Use Tailwind's built-in color utility classes (e.g., `stone-500`, `lime-400`, `red-600`).

---

## The Four Pillars

Design OS is organized around four main areas:

1. **Product Overview** — The "what" and "why"
   - Product name and description
   - Problems and solutions
   - Key features
   - Sections/roadmap

2. **Data Shape** — The "nouns" of the system
   - Core entity names and descriptions
   - Conceptual relationships between entities
   - Shared vocabulary for consistent naming across sections

3. **Design System** — The "look and feel"
   - Color palette (Tailwind colors)
   - Typography (Google Fonts)
   - Brand personality and voice (optional)
   - UI style preferences (optional)

4. **Application Shell** — The persistent chrome
   - Global navigation structure
   - User menu
   - Layout pattern

Plus **Sections** — The individual features, each with spec, data, screen designs.

---

## Design System Scope

Design OS separates concerns between its own UI and the product being designed:

- **Design OS UI**: Always uses the stone/lime palette and DM Sans typography
- **Product Screen Designs**: Use the design tokens defined for the product (when available)
- **Shell**: Uses product design tokens to preview the full app experience

---

## Export & Handoff (ai-coding Integration)

The `@export-product` agent bridges Design OS output into the ai-coding workflow:

- **PRD generation**: Combines `product-overview.md` + `product-roadmap.md` into `project/PRD.md` (ai-coding format)
- **Design tokens**: Writes Tailwind `@theme` block into `frontend/src/index.css`
- **ARCHITECTURE.md**: Updates data models section from `data-shape.md`
- **Implementation instructions**: Adapted for the Solution Architect, Backend Developer, and Frontend Developer agents
- **Test specs**: Each section includes `tests.md` with UI behavior specs
- **Portable components**: Props-based, ready for the `frontend/` React app
- **Data shapes**: TypeScript interfaces defining what data the components expect

Export output goes to `project/design-export/`. After exporting:
1. Switch to **Solution Architect** to create implementation plans from the design artifacts
2. Or switch to **Requirements Engineer** to create feature specs from sections
3. Then **Backend Developer** / **Frontend Developer** to implement

---

## Design System (Design OS Application)

The Design OS application itself uses a "Refined Utility" aesthetic:

- **Typography**: DM Sans for headings and body, IBM Plex Mono for code
- **Colors**: Stone palette for neutrals (warm grays), lime for accents
- **Layout**: Maximum 800px content width, generous whitespace
- **Cards**: Minimal borders (1px), subtle shadows, generous padding
- **Motion**: Subtle fade-ins (200ms), no bouncy animations
