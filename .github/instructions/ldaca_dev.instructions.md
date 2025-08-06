---
applyTo: '**'
---

# LDaCA Ecosystem Development Guide

## Architecture Overview

LDaCA is a **three-layer text analysis ecosystem**:
- **docframe**: Text processing library extending Polars (`df.text.tokenize()`)
- **docworkspace**: Data management as a graph structure (`Node`/`Workspace` classes)  
- **ldaca_web_app**: Full-stack platform (FastAPI backend + React frontend)

**Data Flow**: Raw Text → docframe (DocDataFrame/DocLazyFrame) → docworkspace (Node/Workspace) → FastAPI (JSON) → React (UI)

## Design Principles

- **Single Source of Truth**: Eliminates data synchronization issues across all layers
- **Composition Over Inheritance**: Use composition for better flexibility in docframe (Polars doesn't support inheritance)
- **API-First Design**: Clean separation between backend and frontend with structured JSON
- **Lazy Evaluation**: Preserve Polars lazy evaluation throughout the stack for performance
- **Transparent Proxies**: Nodes delegate to underlying data structures seamlessly
- **Aggressive Refactoring**: Focus on improving code quality, don't worry about backward compatibility

## Critical Development Commands

```bash
# Start the full ecosystem
bash run.sh

# Individual component testing (each has different patterns)
cd docframe && pytest                    # Custom test runner, no pytest required
cd docworkspace && pytest               # Standard pytest + FastAPI integration tests  
cd ldaca_web_app/backend && pytest      # Backend tests
cd ldaca_web_app/frontend && npm test   # Frontend tests

# Running full stack (separate terminals)
cd backend && python main.py            # Backend (port 8001)
cd frontend && npm start                 # Frontend (port 3000)

# Running python commands
uv run python -c "XXX" # Use uv for python commands
```

## Key Architectural Patterns

### Single Source of Truth
All workspace data flows through `docworkspace` library methods. The web app's `workspace.py` delegates directly to `docworkspace.Workspace` - never custom implementations.

### Node Delegation Pattern
```python
# Nodes act as transparent proxies - all DataFrame methods work directly
node = workspace.add_node(Node(data=df, name="data"))
filtered = node.filter(pl.col("age") > 30)  # Creates new Node automatically
```

### Composition Over Inheritance (docframe)
```python
class DocDataFrame:
    def __init__(self, data):
        self._df = pl.DataFrame(data)  # Wraps, doesn't inherit (unlike GeoPandas)
```

### API-First Design (Web App)
```python
# Backend uses actual docworkspace, not custom logic
workspace = Workspace(name)
graph = workspace.to_api_graph()  # React Flow compatible JSON
```

## Development Workflows

### Test-Driven Development Process
1. **Plan with Sequential Thinking MCP**: Break down complex tasks
2. **Create/Modify Tests First**: Always write tests before implementing
3. **Follow Single Source of Truth**: All workspace data goes through proper channels
4. **Test Integration Points**: Verify cross-library compatibility
5. **Update API Endpoints**: Ensure FastAPI uses proper Pydantic models
6. **Update Instructions**: Document new patterns after implementation

### Cross-Library Integration Testing
1. Test docframe → docworkspace compatibility
2. Test docworkspace → FastAPI JSON serialization  
3. Test full React Flow integration with browser automation

### Available Development Tools
- **Playwright MCP**: End-to-end browser testing and user interaction simulation, you can use it to see the frontend as well as the console logs.
- **Context7 MCP**: Latest documentation for React Flow, Zustand, TanStack Query
- **Memory MCP**: Context management for long/complicated tasks
- **Sequential Thinking MCP**: Structured problem-solving approach
- **Backend/Frontend logs**: Check `backend/backend.log` and `frontend/frontend.log` for debugging

## Critical Integration Points

### Text Namespace Registration
```python
import polars as pl
import docframe  # Required for df.text.* to work across all libraries
df.text.tokenize("content")  # Now works
```

### FastAPI Models & React Flow Compatibility
```python
# In workspace.py - critical method for frontend
def to_api_graph(self, layout_algorithm="grid"):
    return {
        "nodes": [...],  # React Flow nodes with positioning
        "edges": [...],  # Parent-child relationships  
        "workspace_info": {...}
    }
```

### Authentication Flow
All API calls (except local mode) need `Authorization: Bearer <token>` from SQLite sessions:
```bash
# Get token for API testing
sqlite3 data/users.db "SELECT access_token FROM user_sessions WHERE expires_at > datetime('now') LIMIT 1;"

# Test API with curl
curl -H "Authorization: Bearer <token>" http://localhost:8001/api/workspaces/
```

### Frontend State Management
Never mutate server state directly. Use React Query mutations with proper cache invalidation:
```typescript
const mutation = useMutation({
  mutationFn: deleteNode,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: queryKeys.workspaceGraph(id) });
  }
});
```

## Common Integration Pitfalls

### CORS Issues
Frontend (`127.0.0.1:3000`) vs backend (`localhost:8001`) - add both to `cors_allowed_origins_str` in config

### Missing docframe Import
Text namespace breaks silently without explicit import

### Custom Workspace Logic
Always use docworkspace methods, not custom implementations:
```python
# ✅ Correct - uses library
workspace = Workspace(name)
node = workspace.add_node(Node(data=df, name="data"))

# ❌ Wrong - custom implementation
# Don't create custom node/workspace classes
```

### React Query Cache Management
Use consistent query keys for proper invalidation - keys must match exactly between queries and invalidation calls.

## File Structure Conventions

- **docframe**: `core/` (main classes), `text_namespace.py` (Polars extensions)
- **docworkspace**: `api_models.py`/`api_utils.py` (FastAPI integration), main classes in root
- **Web App**: `backend/core/workspace.py` (uses docworkspace directly), `frontend/hooks/useWorkspace.ts` (consolidates operations)

## Testing Strategy

Each layer has distinct testing approaches:
- **docframe**: Composition patterns, text processing pipelines
- **docworkspace**: Graph operations, serialization, lazy evaluation
- **Web App**: FastAPI integration, React Flow compatibility, Google OAuth flow

Always test integration points between layers to catch JSON serialization and cross-library compatibility issues. Delete temporary test files after validation, keep only necessary tests in the suite.

Update this instructions as new changes are made to the architecture or development patterns. Document new patterns and workflows immediately after implementation to ensure clarity for all developers.