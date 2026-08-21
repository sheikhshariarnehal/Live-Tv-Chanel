# GitHub MCP Rules

Rules and patterns for using the GitHub MCP tools during deployment.

---

## Available Tools

### `get_file_contents`
**Purpose**: Read files or directory listings from a GitHub repository.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `owner` | Yes | Repository owner (username or organization) |
| `repo` | Yes | Repository name |
| `path` | Yes | Path to file or directory (use `""` for root) |
| `branch` | No | Branch to read from (defaults to default branch) |

**Usage patterns**:

```
# Read root directory listing
get_file_contents({ owner: "user", repo: "project", path: "" })

# Read a specific file
get_file_contents({ owner: "user", repo: "project", path: "package.json" })

# Read from a specific branch
get_file_contents({ owner: "user", repo: "project", path: "app/page.tsx", branch: "develop" })
```

**Important**: When reading a directory, the response returns an array of file/directory entries, not their contents. You must make a separate call for each file you want to read.

---

### `list_commits`
**Purpose**: Get commit history for a repository/branch.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `owner` | Yes | Repository owner |
| `repo` | Yes | Repository name |
| `sha` | No | Branch name or commit SHA to start from |
| `page` | No | Page number for pagination |
| `perPage` | No | Results per page |

**Usage patterns**:

```
# Get latest commits on default branch
list_commits({ owner: "user", repo: "project" })

# Get latest commit on a specific branch
list_commits({ owner: "user", repo: "project", sha: "main", perPage: 1 })
```

---

### `push_files`
**Purpose**: Push multiple files to a GitHub repository in a single commit. This is the **primary tool for committing changes**.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `owner` | Yes | Repository owner |
| `repo` | Yes | Repository name |
| `branch` | Yes | Branch to push to |
| `files` | Yes | Array of `{ path, content }` objects |
| `message` | Yes | Commit message |

**Usage patterns**:

```
push_files({
  owner: "user",
  repo: "project",
  branch: "main",
  message: "feat: add player controls",
  files: [
    { path: "components/Player.tsx", content: "..." },
    { path: "app/page.tsx", content: "..." }
  ]
})
```

**Rules**:
- File paths must be relative to the repository root (no leading `/`)
- Include ALL changed files in a single call (don't make multiple push_files calls)
- The `content` field must be the complete file content (not a diff)
- This tool creates a new commit — it does NOT merge or rebase
- **Limitation**: This tool can only add/update files. It cannot delete files.

---

### `create_or_update_file`
**Purpose**: Create or update a single file in a repository. Use this when updating an existing file that requires a SHA for conflict detection.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `owner` | Yes | Repository owner |
| `repo` | Yes | Repository name |
| `path` | Yes | File path |
| `content` | Yes | File content |
| `message` | Yes | Commit message |
| `branch` | Yes | Target branch |
| `sha` | No* | SHA of the file being replaced (**required when updating**) |

**When to use**: Prefer `push_files` for batch operations. Use `create_or_update_file` only when:
- You need to update a single file with SHA tracking
- You're making a targeted fix to one file

**To get the SHA**: First read the file with `get_file_contents` — the response includes the `sha` field.

---

### `search_code`
**Purpose**: Search for code patterns across a repository.

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `q` | Yes | Search query (GitHub code search syntax) |

**Usage patterns**:
```
# Find all files importing a specific module
search_code({ q: "import Player repo:user/project" })
```

---

## Commit Message Rules

### Format
Use conventional commits: `<type>: <description>`

### Types

| Type | When to Use |
|------|-------------|
| `feat` | New feature, component, or page |
| `fix` | Bug fix, error correction, import fix |
| `chore` | Dependency update, config change, cleanup |
| `style` | CSS changes, formatting, styling |
| `refactor` | Code restructure without behavior change |
| `docs` | Documentation changes only |
| `perf` | Performance improvements |

### Rules
- Description must be specific and meaningful
- Use lowercase for the description
- No period at the end
- Maximum 72 characters
- Must describe the ACTUAL change, not the action of deploying

### Good Examples
```
feat: add tournament registration form
fix: resolve hydration mismatch in player layout
chore: update next.js to v15.1.0
style: improve mobile navigation responsive design
fix: correct import path for PlayerControls component
```

### Bad Examples (NEVER use these)
```
update                    ← too vague
changes                   ← meaningless
deploy                    ← describes action, not change
fixed                     ← no context
test                      ← no context
misc changes              ← meaningless
updated files             ← meaningless
```

---

## Branch Handling

- Always push to the detected current branch
- Never create new branches unless the user specifically requests it
- Never force-push (`--force`) without explicit user confirmation
- If the branch is `main` or `master`, confirm with the user before pushing:
  ```
  Pushing directly to 'main'. Proceed?
  ```

---

## File Content Rules

- Always read the complete file content before pushing (use `view_file`)
- Never push partial file contents
- Ensure file encoding is UTF-8
- Handle binary files by skipping them (images, fonts, etc.)
- Never push empty files unless the file is intentionally empty
