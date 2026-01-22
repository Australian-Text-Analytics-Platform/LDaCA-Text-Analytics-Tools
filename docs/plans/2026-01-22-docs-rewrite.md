# Docs Rewrite (Root + DocFrame + Backend + Frontend) Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Rewrite and consolidate documentation into per-project `/docs` structures for the root repo, DocFrame, backend, and frontend while deleting legacy docs and keeping READMEs as short entry points.

**Architecture:** Create a consistent docs information architecture in each target project (`index.md`, `user-guide/`, `developer-guide/`, `reference/`, `tutorials/`), then update READMEs to link to the new entry points. Migrate content from existing docs into the new structure, avoid cross-project overlap, and delete replaced legacy files.

**Tech Stack:** Markdown (GitHub-flavored), repo conventions, tutorial-style pages for walkthroughs, concise reference pages.

---

## Task 1: Inventory existing documentation

**Files:**

- Modify: `docs/plans/2026-01-22-docs-rewrite.md`
- Reference: `README.md`, `docframe/README.md`, `docframe/docs/ARCHITECTURE.md`, `docframe/tests/README.md`, `ldaca_web_app/**.md`

### Step 1: List all existing doc files

- Scan root, docframe, backend, and frontend markdown files.

### Step 2: Map legacy docs to new structure

- Decide target pages for each legacy topic.

### Step 3: Commit notes

- Record the mapping in the plan (this section).

## Task 2: Create new docs structure (root)

**Files:**

- Create: `docs/index.md`
- Create: `docs/user-guide/getting-started.md`
- Create: `docs/developer-guide/repo-overview.md`
- Create: `docs/reference/commands.md`
- Create: `docs/tutorials/first-steps.md`

### Step 1: Write root docs entry point

- Include scope statement and links to project docs.

### Step 2: Add user/developer/reference/tutorial pages

- Keep root docs high-level and non-overlapping.

### Step 3: Run quick link check

- Ensure intra-doc links are valid.

## Task 3: Create new docs structure (DocFrame)

**Files:**

- Create: `docframe/docs/index.md`
- Create: `docframe/docs/user-guide/quickstart.md`
- Create: `docframe/docs/user-guide/text-operations.md`
- Create: `docframe/docs/developer-guide/architecture.md`
- Create: `docframe/docs/reference/api-overview.md`
- Create: `docframe/docs/tutorials/first-analysis.md`

### Step 1 (DocFrame): Draft user guide pages

- Use DocFrame examples and concepts.

### Step 2 (DocFrame): Draft developer/reference pages

- Summarize architecture and APIs.

### Step 3 (DocFrame): Add tutorial page

- Guided walkthrough with Q/A checkpoints.

## Task 4: Create new docs structure (Backend)

**Files:**

- Create: `ldaca_web_app/backend/docs/index.md`
- Create: `ldaca_web_app/backend/docs/user-guide/running-locally.md`
- Create: `ldaca_web_app/backend/docs/developer-guide/architecture.md`
- Create: `ldaca_web_app/backend/docs/reference/configuration.md`
- Create: `ldaca_web_app/backend/docs/reference/background-tasks.md`
- Create: `ldaca_web_app/backend/docs/tutorials/first-api-call.md`

### Step 1 (Backend): Draft user guide

- Start/run commands and environment setup.

### Step 2 (Backend): Draft developer/reference pages

- Architecture summary, task system, env vars.

### Step 3 (Backend): Add tutorial page

- Simple API walkthrough.

## Task 5: Create new docs structure (Frontend)

**Files:**

- Create: `ldaca_web_app/frontend/docs/index.md`
- Create: `ldaca_web_app/frontend/docs/user-guide/running-ui.md`
- Create: `ldaca_web_app/frontend/docs/user-guide/app-tour.md`
- Create: `ldaca_web_app/frontend/docs/developer-guide/architecture.md`
- Create: `ldaca_web_app/frontend/docs/reference/configuration.md`
- Create: `ldaca_web_app/frontend/docs/tutorials/first-feature.md`

### Step 1 (Frontend): Draft user guide pages

- Dev server, environment variables, UI tour.

### Step 2 (Frontend): Draft developer/reference pages

- State management, hooks, build scripts.

### Step 3 (Frontend): Add tutorial page

- Create a small feature walkthrough.

## Task 6: Update READMEs and remove legacy docs

**Files:**

- Modify: `README.md`, `docframe/README.md`, `ldaca_web_app/backend/README.md`, `ldaca_web_app/frontend/README.md`, `ldaca_web_app/README.md`
- Delete: legacy docs listed in mapping

### Step 1: Update READMEs to short entry points

- Link to new docs entry points.

### Step 2: Delete replaced legacy docs

- Remove old markdown files now superseded.

## Task 7: Update repo instruction file

**Files:**

- Modify: `.github/copilot-instructions.md`

### Step 1: Add documentation structure notes

- Record new docs locations and conventions.

## Task 8: Verification

**Files:**

- N/A

### Step 1: Scan for broken links

- Ensure README links and intra-doc references work.

### Step 2: Summarize changes

- Provide list of new docs and removed files.

