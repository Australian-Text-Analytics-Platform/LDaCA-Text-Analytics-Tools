# Getting Started (Platform Overview)

**Scope statement:** This guide helps you choose the right LDaCA component for your goal. It does not teach the DocFrame API or the web app UI in detail.

## 1) Choose your path

**Question:** *I want a UI. Where do I go?*

**Answer:** Start with the frontend docs and follow the app tour:
`ldaca_web_app/frontend/docs/index.md`.

**Question:** *I want a Python library for text analysis. Where do I go?*

**Answer:** Start with DocFrame’s quickstart:
`docframe/docs/index.md`.

**Question:** *I want to integrate via API. Where do I go?*

**Answer:** Start with the backend docs:
`ldaca_web_app/backend/docs/index.md`.

## 2) Understand the building blocks

**Question:** *Why is the platform split into multiple projects?*

**Answer:** Each component is optimized for a different job:

- **DocFrame** → text processing APIs on top of Polars.
- **Backend** → REST API that manages workspaces and analysis tasks.
- **Frontend** → React UI for interactive workflows.

## 3) What should I install?

**Question:** *Do I need to install everything?*

**Answer:** Not necessarily. Install only the component you plan to use. Each project doc set lists its own prerequisites and setup steps.

## 4) How do I learn the workflow?

**Question:** *Is there a tutorial?*

**Answer:** Yes. Each project has a tutorial page under its `tutorials/` folder. Start with the tutorial closest to your goal, then move to the reference pages when you need details.
