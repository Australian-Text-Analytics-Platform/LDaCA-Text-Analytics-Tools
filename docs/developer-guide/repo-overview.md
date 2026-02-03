# Repository Overview (High‑Level)

**Scope statement:** This page explains the repository layout and how the major projects relate. It avoids deep implementation details, which live in each project’s docs.

## 1) What lives in this repo?

**Question:** *Which projects are in the monorepo?*

**Answer:**

- **DocFrame** (`ldaca_web_app/backend/docframe/`) — Python library for document‑aware data frames.
- **Web app backend** (`ldaca_web_app/backend/`) — FastAPI service + workspace orchestration.
- **Web app frontend** (`ldaca_web_app/frontend/`) — React UI + state management.
- **DocWorkspace** (`ldaca_web_app/backend/docworkspace/`) — graph‑based workspace layer used by the backend.

## 2) How do the projects interact?

**Question:** *How do data and APIs flow across the system?*

**Answer:** The backend uses DocWorkspace and DocFrame to build lazy pipelines, then serializes results into JSON for the frontend UI. The frontend never accesses files directly; it always calls `/api/...` endpoints.

## 3) Where are the detailed docs?

**Question:** *Where do I find project‑level instructions?*

**Answer:**

- DocFrame: `docframe/docs/index.md`
- Backend: `ldaca_web_app/backend/docs/index.md`
- Frontend: `ldaca_web_app/frontend/docs/index.md`

## 4) What should I avoid changing from the root?

**Question:** *Can I edit project behavior from root docs?*

**Answer:** Avoid adding deep project details here. Use each project’s docs to document its APIs, architecture, and setup steps so the information stays local and maintainable.
