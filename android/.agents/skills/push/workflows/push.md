# Push Workflow

Detailed step-by-step instructions for executing a safe commit and push to a GitHub repository.

---

## Phase 1 — Project & Repo Discovery

### Step 1.1: Detect GitHub Repository

Determine the target GitHub `owner/repo`:

1. **Git Remote URL**: Run `git remote get-url origin` via `run_command`
   - Parse HTTPS: `https://github.com/owner/repo.git` → `owner/repo`
   - Parse SSH: `git@github.com:owner/repo.git` → `owner/repo`
2. **`package.json` Repository Field**: Check `repository.url` in `package.json`
3. **Ask User**: If automatic detection fails, prompt the user for the repository in `owner/repo` format.

### Step 1.2: Identify Target Branch

```bash
git branch --show-current
```

If branch detection fails, default to `main` and confirm with the user.

### Step 1.3: Display Discovery Result

```
🔍 GitHub Push Pre-flight
✓ Repository: owner/repo
✓ Branch: main
```

---

## Phase 2 — Change Detection

### Step 2.1: Inspect Local Changes

Check for modified, added, and untracked files in the workspace:

```bash
git status --porcelain
```

Or read local workspace state using file tools.

### Step 2.2: Apply `.gitignore` Filters

Do **NOT** track or stage files matching `.gitignore` patterns, including:
- `node_modules/`
- `.next/`, `dist/`, `build/`, `out/`
- `.env`, `.env.local`, `.env.*.local`
- `.DS_Store`, `Thumbs.db`
- Local logs or cache directories

### Step 2.3: Categorize Changes

Group all valid files into:
- **Modified**: Existed in repository, content modified locally
- **Added**: New files created locally
- **Deleted**: Removed locally

### Step 2.4: Handle No Changes

If no changes are detected:
```
ℹ️ No new code changes detected in workspace. Everything is up to date with remote.
```
Terminate process cleanly.

### Step 2.5: Display Change Summary

```
Detected changes:
  Modified (3):
    - src/components/Header.tsx
    - src/styles/globals.css
    - package.json
  Added (1):
    - src/components/Button.tsx
```

---

## Phase 3 — Pre-Push Validation

See [validate.md](./validate.md) for full pre-push validation workflow (linting, typechecking, build sanity).

---

## Phase 4 — Secret & Sensitive Data Audit

See [safety.md](../rules/safety.md) for full secret scanning requirements and blocked file patterns.

---

## Phase 5 — Generate Conventional Commit

See [commit-generator.md](../prompts/commit-generator.md) for commit message rules and formatting logic.

---

## Phase 6 — GitHub Commit & Push

### Primary Strategy: GitHub MCP (`github.push_files`)

If GitHub MCP server is active:

1. Read the exact string content of each modified and added file.
2. Invoke `github.push_files`:

```json
{
  "owner": "<owner>",
  "repo": "<repo>",
  "branch": "<branch>",
  "message": "<commit-message>",
  "files": [
    { "path": "src/components/Header.tsx", "content": "..." },
    { "path": "src/components/Button.tsx", "content": "..." }
  ]
}
```

### Fallback Strategy: Local Git CLI

If GitHub MCP is unconfigured or fails:

1. Stage changed files: `git add <file1> <file2> ...`
2. Commit with generated message: `git commit -m "<commit-message>"`
3. Push to remote: `git push origin <branch>`

> ⚠️ **Warning**: Never use `git push --force` or `--force-with-lease` unless explicitly commanded by user.

---

## Phase 7 — Push Summary & Verification

After push completes, fetch commit info and display summary:

```
✅ Successfully Pushed to GitHub

Repository: owner/repo
Branch:     main
Commit:     a1b2c3d — "feat: add button component and update header"
Files:      3 modified, 1 added
Timestamp:  2026-08-18 22:30:00
```
