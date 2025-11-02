applyTo: '**'
---

# LDaCA Repository Instructions

## Project overview
- LDaCA is a text analytics ecosystem: docframe (Polars-based text library) → docworkspace (graph of Nodes/Workspaces) → FastAPI backend → React frontend. The LDaCA-Text-Analytics-Tools is a git repo containing all components, docframe and ldaca_web_app are both git submodules.
- Goal: scalable, lazy-by-default text processing with a clean API boundary; frontend consumes JSON only.

## Folder structure (top-level)
- `docframe/` – Text analysis library (Polars backend, text namespace, DTM utilities).
  - `docs/ARCHITECTURE.md` – **Comprehensive architecture documentation** covering design philosophy, component breakdown, data flow patterns, function dependencies.
- `docworkspace/` – Workspace graph, Node operations, serialization, FastAPI adapters.
- `ldaca_web_app/backend/` – FastAPI app exposing workspace, files, text endpoints.
- `ldaca_web_app/docs/ARCHITECTURE.md` – **Complete backend architecture documentation** covering all three components (docworkspace, backend, frontend), background task system, current-request/result persistence, complete file/function reference.
- `ldaca_web_app/frontend/` – React app (TanStack Query, XYFlow) consuming backend JSON.
- `run.sh` – Dev bootstrap: installs deps (uv/npm), starts backend:8001 and frontend:3000.
- `data/` – Local runtime data (ignored). Avoid hard-coding paths; use backend helpers.

## Key libraries and tooling
- Python: Polars, pandas, spaCy, NLTK, scikit-learn, BERTopic (docframe); FastAPI, SQLAlchemy (async), aiosqlite, pydantic-settings (backend).
- Frontend: React 19, TypeScript, TanStack Query v5, XYFlow, Zustand, axios, CRA.
- Package/runtime: uv (Astral) for Python; npm for frontend; pytest for tests. Prefer `uv run` over plain `python`.

## Coding standards and conventions
- Lazy-by-default: chain lazy ops and materialize at API edge only; avoid accidental `collect()` in core paths.
- API-first: backend is a thin adapter over docworkspace; never return Polars objects—serialize to plain Python/JSON.
- Text namespace: always `import docframe` before using `df/series/pl.col().text.*` methods.
- Workspace graph: expose via `Workspace.to_api_graph(layout_algorithm=...)` returning `{nodes, edges, workspace_info}`.
- Frontend state: use TanStack Query keys from `src/lib/queryKeys.ts`; don’t mutate server state locally; invalidate with identical key arrays.
- Composition over subclassing: Node methods delegate to underlying docframe/Polars and produce new Nodes.

## Versions and environments
- Python ≥ 3.10 recommended (subpackages require ≥3.10). Manage env with `uv`; pin via `uv.lock`.
- Frontend uses Node/npm; install with `npm ci` or `npm install` inside `ldaca_web_app/frontend`.

## Development workflow (short)
- Start stack: `bash run.sh` (checks ports, env, runs backend+frontend).
- Tests: `uv run pytest` in each package (`docframe/`, `docworkspace/`, `ldaca_web_app/backend/`).
- Backend dev: `uv run fastapi dev src/ldaca_web_app_backend/main.py --port 8001`.
- Frontend dev: `npm start` in `ldaca_web_app/frontend`.

## API and UI contracts (essentials)
- Backend graph API: provide React Flow–ready JSON; frontend performs layout/edges rendering (no duplicated layout logic).
- Query keys: use factory in `src/lib/queryKeys.ts` (e.g., `workspaceGraph(wid)`, `nodeData(wid,nid,...)`). Keep arrays consistent across fetch/invalidate.

## Extending text operations (docframe)
- Implement pure utilities, prefer expression-based lazy ops; register under the text namespace; add unit+integration tests.

## Common pitfalls
- Missing `import docframe` → text namespace unavailable.
- Eager materialization in core code → performance regressions.
- Inconsistent React Query keys → stale UI or cache misses.

## When adding endpoints
- Define Pydantic models; enforce auth (or explicit dev bypass); delegate to docworkspace; add tests (401 + happy path); ensure outputs are JSON-serializable.

## Architecture documentation maintenance
- **Before making changes**: Review relevant architecture documentation:
  - `docframe/docs/ARCHITECTURE.md` – For docframe library changes (text namespace, utilities, core functions)
  - `ldaca_web_app/docs/ARCHITECTURE.md` – For backend, frontend, or workspace changes
- **After making changes**: Update architecture documentation to reflect:
  - New functions/classes: Add to appropriate section with implementation details and external dependencies
  - Modified APIs: Update endpoint descriptions, parameters, return types
  - New patterns: Document data flow patterns with step-by-step explanations
  - Background tasks: Update task system documentation if adding new task types
  - Analysis endpoints: Update current-request/result pattern documentation
  - File additions/removals: Update Complete Backend File Reference section
- **Documentation style**: Follow existing patterns:
  - Explain HOW implementations work (e.g., "calls X, wraps in Y, returns Z")
  - Document WHAT external functions are called (e.g., "delegates to text_utils.tokenize()")
  - Include code examples with clear comments
  - Add architecture diagrams for complex flows
  - Use "Example" headers (not "AI Tool Reuse Pattern") for code blocks