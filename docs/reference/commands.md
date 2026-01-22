# Command Reference (Platform‑Level)

**Scope statement:** This page lists high‑level command categories and points to the project docs for exact commands. It intentionally avoids component‑specific detail.

## 1) Common command categories

**Question:** *What kinds of commands exist in this repo?*

**Answer:**

- **Python package workflows** (install, tests, builds)
- **Frontend workflows** (dev server, build, lint)
- **Backend workflows** (serve API, tests, packaging)
- **Desktop app workflows** (Tauri build pipeline)

## 2) Where do I find exact commands?

**Question:** *Where are the real command lists?*

**Answer:** Use the project entry points:

- DocFrame: `docframe/docs/index.md`
- Backend: `ldaca_web_app/backend/docs/index.md`
- Frontend: `ldaca_web_app/frontend/docs/index.md`

## 3) How should I document new commands?

**Question:** *Where do I add new command documentation?*

**Answer:** Add it to the project that owns the command, then link it from that project’s `reference/` section. Keep this page as a high‑level directory only.
