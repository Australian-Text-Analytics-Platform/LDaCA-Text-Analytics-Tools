# LDaCA Platform Documentation

**Scope statement:** This doc set explains the overall LDaCA ecosystem and how to navigate its components. It intentionally avoids deep details about DocFrame or the web app; those live in their own project docs.

## What is LDaCA?

**Question:** *What problem does LDaCA solve?*

**Answer:** LDaCA is a modular text‑analytics ecosystem that lets you analyze large document collections with reproducible pipelines. It combines Python libraries for document processing with a web/desktop application for interactive exploration.

## Where should I start?

**Question:** *Which docs should I read first?*

**Answer:** Pick the path that matches your goal:

- **DocFrame library** → `docframe/docs/index.md` for Python‑first text pipelines.
- **Backend API** → `ldaca_web_app/backend/docs/index.md` for FastAPI and workspace orchestration.
- **Frontend UI** → `ldaca_web_app/frontend/docs/index.md` for React UI and state flow.

## Ecosystem map (high‑level)

**Question:** *How do the pieces connect?*

**Answer:**

1. **DocFrame** provides document‑aware data frames and text operations.
2. **DocWorkspace** manages lineage across nodes (graph of transformations).
3. **Web app** wraps those layers for interactive analysis.

## Terminology (quick glossary)

**Question:** *What does “workspace” mean in this context?*

**Answer:** A workspace is a project container that stores datasets, analysis steps, and results together so they can be reproduced later.

**Question:** *What is a “node”?*

**Answer:** A node represents a dataset or derived result inside a workspace graph.

## Documentation layout

**Question:** *How are these docs organized?*

**Answer:**

- `docs/` (this folder) → high‑level platform guidance.
- `docframe/docs/` → library‑specific docs.
- `ldaca_web_app/backend/docs/` → backend API and services.
- `ldaca_web_app/frontend/docs/` → UI and frontend architecture.

## Next steps

**Question:** *What’s the most efficient next step?*

**Answer:** Choose one of the project entry points above and follow its quickstart or tutorial page. Each project keeps its own user guide, developer guide, and reference pages.
