# GitHub Integration Rules

Rules and best practices for interacting with GitHub repositories via GitHub MCP and local Git CLI.

---

## 1. GitHub MCP Tool Usage

When using GitHub MCP, strictly adhere to tool requirements:

### `github.push_files`
- **Purpose**: Commit and push multiple files in a single atomic commit.
- **Arguments**:
  - `owner` (string, required): GitHub repository owner / org
  - `repo` (string, required): Repository name
  - `branch` (string, required): Target branch
  - `message` (string, required): Semantic commit message
  - `files` (array, required): Array of `{ path: "...", content: "..." }`
- **Rules**:
  - All file paths must be relative to repository root (no leading `/` or `./`).
  - Read local file content fully before passing to `content`.
  - Include all modified and added files in a single call for atomicity.

### `github.get_file_contents`
- **Purpose**: Fetch file or directory content from GitHub HEAD.
- **Use case**: Compare remote state vs local workspace state to identify file deltas.

---

## 2. Git CLI Fallback Rules

If GitHub MCP server is not installed or available:

1. Use `run_command` to run standard git commands.
2. Never execute `git push --force` or `git push -f`.
3. Check status with `git status --porcelain` before staging.
4. Stage only relevant files with explicit `git add <file>` rather than `git add .` if unintended files exist.
5. Provide detailed commit messages via `git commit -m "<message>"`.

---

## 3. Branch Safety Rules

1. Always check current branch before committing.
2. Avoid pushing directly to `main` or `master` if working on a feature branch.
3. If branch is detached HEAD or unknown, prompt user to specify target branch.
