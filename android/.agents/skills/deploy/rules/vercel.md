# Vercel MCP Rules

Rules and patterns for using the Vercel MCP tools during deployment.

---

## Team and Project Discovery

Almost every Vercel MCP call requires `teamId`. Discover it before doing anything else.

### Team Discovery Flow

```
1. Check .vercel/project.json → extract orgId
2. If not found → call vercel.list_teams
3. If multiple teams → ask user to select
4. Cache the teamId for the rest of the session
```

### Project Discovery Flow

```
1. Check .vercel/project.json → extract projectId
2. If not found → call vercel.list_projects with teamId
3. Match by: git repo link > project name > user selection
4. Cache the projectId for the rest of the session
```

---

## Available Tools

### `list_teams`
**Purpose**: Discover the user's Vercel team ID(s).

**Parameters**: None required.

**Usage**:
```
list_teams({})
```

**Returns**: Array of teams with IDs (format: `team_xxx`) and names.

**Rules**:
- Call this first if `.vercel/project.json` is not available
- If multiple teams: present to user and ask for selection
- Cache the selected team ID

---

### `list_projects`
**Purpose**: List all Vercel projects for a team (max 50).

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `teamId` | Yes | Team ID (`team_xxx`) or team slug |

**Usage**:
```
list_projects({ teamId: "team_abc123" })
```

**Rules**:
- Use to find the Vercel project matching the current GitHub repo
- Match by git repository URL, then by project name
- If no match: offer to create a new project

---

### `get_project`
**Purpose**: Get details of a specific Vercel project.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `projectId` | Yes | Project ID (`prj_xxx`) or project slug |
| `teamId` | Yes | Team ID (`team_xxx`) or team slug |

**Usage**:
```
get_project({ projectId: "prj_xyz789", teamId: "team_abc123" })
```

**Returns**: Project details including framework, build settings, git link, domains.

---

### `create_git_project`
**Purpose**: Create a Vercel project linked to a Git repository, or reuse existing. **This is the preferred deployment method.**

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `repo` | Yes | Repository as `owner/name` or URL |
| `teamId` | Yes | Team ID |
| `projectName` | No | Vercel project name (defaults to lowercase repo name) |
| `provider` | No | Git provider: `github`, `gitlab`, `bitbucket` (default: `github`) |
| `deploy` | No | Whether to trigger a deployment (default: `true`) |
| `rootDirectory` | No | Root directory for monorepo builds |

**Usage**:
```
create_git_project({
  repo: "owner/project",
  teamId: "team_abc123",
  projectName: "my-project",
  deploy: true
})
```

**Rules**:
- This is the **preferred deployment method** — use it when the project has a GitHub repo
- It automatically creates a preview deployment by default
- If the project already exists and is linked, it reuses it
- New projects have Vercel Authentication disabled by default
- Do not ask for deployment confirmation (the tool docs say to deploy by default)

---

### `deploy_to_vercel`
**Purpose**: Deploy files directly to Vercel without a Git repo. **Use as a fallback only.**

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `target` | Yes | `"production"` or `"preview"` |
| `name` | Yes | Project name (creates project if it doesn't exist) |
| `files` | Yes | Array of `{ file, data, encoding? }` objects |
| `teamId` | No | Team ID |
| `projectSettings` | No | Build settings (framework, buildCommand, installCommand, outputDirectory, rootDirectory) |

**Usage**:
```
deploy_to_vercel({
  target: "production",
  name: "my-project",
  teamId: "team_abc123",
  files: [
    { file: "package.json", data: "{...}" },
    { file: "app/page.tsx", data: "..." }
  ],
  projectSettings: {
    framework: "nextjs",
    buildCommand: "pnpm build",
    installCommand: "pnpm install"
  }
})
```

**Rules**:
- Only use when `create_git_project` is not applicable
- File paths are root-relative POSIX paths (e.g., `app/page.tsx`)
- Use `encoding: "base64"` for binary files
- Source files only — Vercel installs deps and builds
- Do NOT include `node_modules`, `.next`, `dist`, or other build artifacts

---

### `get_deployment`
**Purpose**: Get deployment status and details.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `idOrUrl` | Yes | Deployment ID or hostname |
| `teamId` | Yes | Team ID |

**Usage**:
```
get_deployment({ idOrUrl: "dpl_abc123", teamId: "team_abc123" })
```

**Returns**: Deployment status (`QUEUED`, `BUILDING`, `READY`, `ERROR`, `CANCELED`), URL, commit info.

**Rules**:
- Use for polling deployment status
- Poll at 15-30 second intervals using the `schedule` tool
- Do NOT poll in a tight loop
- Stop polling once status is terminal (`READY`, `ERROR`, `CANCELED`)

---

### `get_deployment_build_logs`
**Purpose**: Read build logs for error diagnosis.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `idOrUrl` | Yes | Deployment ID or hostname |
| `teamId` | Yes | Team ID |
| `errorsOnly` | No | Return only error events (default: `false`) |
| `direction` | No | `"tail"` (default, most recent) or `"head"` (earliest) |
| `limit` | No | Max log lines (default: 100) |
| `buildId` | No | Filter to specific build ID for multi-build deployments |
| `since` | No | Start of time window (ISO date or relative like `"1h"`) |
| `until` | No | End of time window |

**Usage**:
```
# Get only errors (most common use)
get_deployment_build_logs({
  idOrUrl: "dpl_abc123",
  teamId: "team_abc123",
  errorsOnly: true
})

# Get more context around errors
get_deployment_build_logs({
  idOrUrl: "dpl_abc123",
  teamId: "team_abc123",
  direction: "tail",
  limit: 200
})
```

**Rules**:
- Always try `errorsOnly: true` first for quick diagnosis
- If `errorsOnly` returns nothing useful, widen with `limit: 200` and `direction: "tail"`
- Parse the log lines to extract: error type, file path, line number, error message

---

### `list_deployments`
**Purpose**: List deployment history for a project.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `projectId` | Yes | Project ID |
| `teamId` | Yes | Team ID |
| `since` | No | Get deployments after this timestamp |
| `until` | No | Get deployments before this timestamp |

**Usage**:
```
list_deployments({ projectId: "prj_xyz789", teamId: "team_abc123" })
```

**Rules**:
- Use to find the previous successful deployment (for rollback comparison)
- Use to compare the last deployed commit against the current GitHub HEAD

---

### `get_runtime_errors`
**Purpose**: Get aggregated runtime error clusters for a project.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `projectId` | Yes | Project ID |
| `teamId` | Yes | Team ID |
| `since` | No | Lookback window (e.g., `"1h"`, `"24h"`, `"7d"`, max 7d) |
| `until` | No | End of window |
| `routes` | No | Filter by route paths |

**Usage**:
```
get_runtime_errors({
  projectId: "prj_xyz789",
  teamId: "team_abc123",
  since: "1h"
})
```

**Rules**:
- Use to check for runtime errors AFTER a deployment is live
- Returns error name, count, affected routes, sample messages
- Prefer this over `get_runtime_logs` for a quick error overview

---

### `get_runtime_logs`
**Purpose**: Get runtime application logs (console.log, errors, etc.).

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `projectId` | Yes | Project ID |
| `teamId` | Yes | Team ID |
| `deploymentId` | No | Filter to specific deployment |
| `environment` | No | `"production"` or `"preview"` |
| `level` | No | Array of log levels: `["error", "warning", "info", "fatal"]` |
| `limit` | No | Max entries (default 50, max 100) |
| `query` | No | Full-text search query |
| `since` | No | Start of window |
| `source` | No | Array of sources: `["serverless", "edge-function", "edge-middleware", "static"]` |
| `statusCode` | No | Filter by HTTP status code |
| `group_by` | No | Group results: `"statusCode"`, `"requestPath"`, `"route"`, `"level"`, etc. |

**Usage**:
```
# Get recent errors for a specific deployment
get_runtime_logs({
  projectId: "prj_xyz789",
  teamId: "team_abc123",
  deploymentId: "dpl_abc123",
  level: ["error", "fatal"],
  since: "30m"
})
```

---

### `web_fetch_vercel_url`
**Purpose**: Fetch content from a Vercel deployment URL to verify it's working.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `url` | Yes | The Vercel URL to fetch |

**Usage**:
```
web_fetch_vercel_url({ url: "https://my-app.vercel.app" })
```

**Rules**:
- Use as an optional final verification step after deployment
- Check for HTTP 200 status
- If the response indicates an error, warn the user

---

## Deployment Target Rules

| Target | When to Use |
|--------|-------------|
| `production` | Default for solo developers, direct pushes to main/master |
| `preview` | When deploying from feature branches, or when the user requests a preview |

Default to `production` unless:
- The branch is not `main` or `master`
- The user explicitly requests a preview deployment
- The project has deployment protection rules that require preview first
