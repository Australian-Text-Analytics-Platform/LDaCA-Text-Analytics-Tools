---
applyTo: '**/*ldaca*/**'
---

# LDaCA Development Guide (AI-Oriented)

## 1. Purpose
Single authoritative machine-readable reference for cross-layer development (docframe, docworkspace, web app). Minimize ambiguity. Prefer composition, lazy evaluation, and API purity.

## 2. Layers & Data Flow
Raw Text → docframe (DocDataFrame/DocLazyFrame) → docworkspace (Workspace/Node graph) → FastAPI (JSON) → React (UI). No alternate paths.

## 3. Core Principles
- Single Source of Truth (workspace + underlying Polars)
- Composition over inheritance
- API-first (backend = thin adapter over docworkspace)
- Lazy-by-default (defer collect())
- Transparent Node proxying
- Aggressive refactoring; no backward guarantees
- Deterministic JSON for frontend

## 4. Critical Commands
```bash
bash run.sh                         # Full stack quick start
cd docframe && uv run pytest .
cd docworkspace && uv run pytest .
cd ldaca_web_app/backend && uv run pytest .
cd ldaca_web_app/frontend && npm test
cd ldaca_web_app/backend && uv run fastapi dev main.py --port 8001 # check if there's already a fastapi process running, because usually user will have it running in the background in dev mode with reload
cd ldaca_web_app/frontend && npm start # check if there's already a npm process running, because usually user will have it running in the background in dev mode with reload
uv run python -c "..." # run python commands
```

## 5. Architectural Patterns
- Node methods mirror underlying Polars; produce new Nodes.
- DocDataFrame wraps Polars object, never inherits.
- Workspace serialization consumed directly by React Flow (`to_api_graph`).
- Layout chosen via `layout_algorithm` param only.

## 6. Integration Contracts
Backend must:
- Import `docframe` before using namespace ops.
- Expose workspace graph via `to_api_graph(layout_algorithm=...)`.
- Return JSON: { nodes: [...], edges: [...], workspace_info: {...} } (no Polars objects).
Frontend must:
- Use React Query with standardized keys.
- Never mutate server state locally.

## 7. Environment / Dependencies
Bootstrap:
```bash
uv sync
(cd ldaca_web_app/frontend && npm ci)
bash run.sh
```
Enforce: `uv sync --frozen` in CI; use `.nvmrc`.

## 8. (Test-Driven Development) TDD Workflow
1. Plan (Sequential Thinking MCP).
2. Write/modify tests (unit → integration → API → E2E).
3. Implement minimal code.
4. Verify lazy preservation.
5. Update instructions + changelog.
6. Remove temp tests.

## 9. API Endpoint Checklist
For every new/changed endpoint:
1. Pydantic models defined.
2. Delegates only to docworkspace (no custom graph logic).
3. Auth enforced (Bearer) unless explicit local dev flag.
4. Tests: 401, happy path, empty, large payload.
5. Output free of Polars objects (convert to Python types).
6. Query key invalidation aligned.
7. Document shape change here.

## 10. Workspace Lifecycle
Unload: POST `/api/workspaces/{id}/unload?save=true`
- save=true → serialize then drop from memory.
- Next access lazy-loads.
- 404 only if neither memory nor disk.
Use for memory relief or forced reload.

## 11. React Query Key Convention
Factory pattern only. Canonical shapes:
- ['workspace', wid, 'graph']
- ['workspace', wid, 'node', nid]
Invalidate with identical arrays. Batch invalidations post-mutation.

## 12. Text Namespace (docframe)
Registration requires `import docframe`. Usage: `df.text.tokenize("col")`. Missing import = silent failure.

## 13. Extending Text Operations
1. Implement pure utility (no side effects).
2. Register in `text_namespace.py`.
3. Prefer lazy expressions (avoid early `collect()`).
4. Tests: utility + namespace integration (lazy form).
5. Document public ops here.

## 14. Extending Layout Algorithms
Add in `Workspace.to_api_graph(layout_algorithm=...)`.
Rules:
- Deterministic (or seeded).
- Tests: schema (x,y), id stability, count.
- Frontend remains passive consumer (no layout logic duplication).

## 15. Performance & Lazy
- Chain lazy ops; single `collect()` at API edge.
- Inspect plan: `df.lazy().describe_optimized_plan()`.
- Avoid accidental materialization (`len`, `head`) in core code.
- Wrap diagnostic collections behind DEBUG.

## 16. Logging & Observability
- Levels: DEBUG (dev), INFO (lifecycle), WARNING (recoverable), ERROR (client-surfaced).
- Correlation id: use `X-Request-ID` or generate.
- Do not log raw user text—hash or summarize.
- Time hotspots (DEBUG only).

## 17. Security & Auth
- Tokens stored server-side (SQLite); never ship to client bundle.
- Local dev bypass flag must log WARNING.
- Validate workspace ownership for mutations.
- Rate limiting: placeholder (add when implemented).

## 18. Memory Management
Use unload endpoint for large graphs. Avoid keeping large intermediate DataFrames referenced by lingering Nodes.

## 19. Testing Strategy
Order:
1. Pure logic (fast)
2. Cross-lib integration (docframe ↔ docworkspace)
3. API serialization
4. E2E (Playwright)
Conventions:
- `test_*.py` unit, `itest_*.py` integration, `e2e_*.spec.ts` frontend.
- Structural assertions over snapshots.
- Mark slow cases.

## 20. Frontend State Rules
- React Query only; no ad-hoc global mutation.
- Invalidate specific keys after mutation; no blanket clear.
- Use helper factories for query keys.

## 21. Update Checklist (Run After Change)
If change touches:
- API shape → update Sections 9/13/14
- Query keys → update Section 11
- New text op → Section 13
- New layout algorithm → Section 14
- Auth/security change → Section 17
- Performance lesson → Section 15
Then append Changelog entry.

## 22. Common Failure Modes
- Missing `import docframe` → text namespace absent.
- Inconsistent query key arrays → stale UI.
- Eager collection inside core pipeline → performance regression.
- Custom Node/Workspace subclassing → reject; refactor to composition.

## 23. Tooling (MCP)
- Sequential Thinking MCP: planning.
- Memory MCP: long task context.
- Playwright MCP: E2E + console logs.
- Context7 MCP: React Flow, Zustand, TanStack Query docs.

## 24. Enforcement Heuristics (For Automated QA)
Reject PR if:
- Direct Polars object returned via API.
- Layout logic duplicated in frontend.
- Query key literal strings differ from factory.
- New endpoint lacks 401 test.
- Text op collects eagerly without justification.

## 25. Changelog (Newest First)
- [YYYY-MM-DD] Reorganized instructions into concise AI-structured format (sections 1–25).