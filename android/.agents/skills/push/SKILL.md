---
name: push
description: >-
  Use this skill when the user asks to push changes to GitHub, commit and push code,
  sync local changes with GitHub, or triggers the /push command. This skill handles inspecting
  local changes, running pre-commit checks/validations, scanning for secrets, generating
  conventional commit messages, committing, pushing via GitHub MCP (or local git fallback),
  and verifying push success.
---

# GitHub Push & Commit Agent Skill

You are a **git & workflow automation agent**. Your job is to safely inspect, validate, commit, and push local workspace changes to a GitHub repository with high precision, clear semantic commit messages, and zero secret leaks.

## Activation

This skill activates when the user:
- Types `/push`
- Asks to "push", "commit and push", "push to github", "ship code to repo", "sync with remote", or makes a similar git commit/push request.

## Required & Optional Integrations

1. **GitHub MCP** (*Preferred*) — For remote repository operations (`github.push_files`, `github.get_file_contents`, `github.list_commits`)
2. **Git CLI** (*Fallback*) — Direct local git commands (`git status`, `git add`, `git commit`, `git push`) via `run_command` if GitHub MCP is not active.

---

## State Machine

Execute the commit and push procedure as a predictable state machine:

```
DISCOVER → INSPECT → VALIDATE → SECRET_SCAN → COMMIT → PUSH → SUCCESS
```

### State Definitions

| State | Description |
|-------|-------------|
| `DISCOVER` | Identify GitHub repository owner, name, and target branch |
| `INSPECT` | Detect local workspace changes (modified, added, deleted files) |
| `VALIDATE` | Run pre-commit checks (typecheck, lint, build checks) |
| `SECRET_SCAN` | Audit changed files for hardcoded secrets, keys, and tokens |
| `COMMIT` | Generate conventional commit message describing exact changes |
| `PUSH` | Push files via GitHub MCP (`push_files`) or local git fallback |
| `SUCCESS` | Present detailed push summary (branch, commit SHA, files summary) |

---

## Execution Phases

Follow these phases in strict order. Reference linked workflow files for detailed instructions.

### Phase 1 — Project & Repo Discovery
**Reference**: [push.md → Phase 1](./workflows/push.md#phase-1--project--repo-discovery)

1. Detect remote repository `owner/repo` from git config (`git remote get-url origin`) or `package.json`.
2. Detect target branch (`git branch --show-current`).
3. Display target profile to user.

### Phase 2 — Change Detection
**Reference**: [push.md → Phase 2](./workflows/push.md#phase-2--change-detection)

1. Read local file state and compare against HEAD or GitHub repository state.
2. Filter out `.gitignore` files (`node_modules/`, `.next/`, `dist/`, `.env`, etc.).
3. Categorize changes: Modified, Added, Deleted.
4. If no changes exist: inform user and exit gracefully.

### Phase 3 — Pre-Push Validation
**Reference**: [validate.md](./workflows/validate.md)

1. Inspect `package.json` for validation scripts (`typecheck`, `lint`, `build`).
2. Run lightweight checks to ensure code health before pushing.
3. If validation fails: report error to user and pause.

### Phase 4 — Secret & Sensitive File Scanning
**Reference**: [safety.md](./rules/safety.md)

1. Audit content of all modified/added files for credentials, private keys, or API tokens.
2. If secrets detected: **ABORT IMMEDIATELY** and inform user which file contains sensitive data.

### Phase 5 — Conventional Commit Generation
**Reference**: [commit-generator.md](./prompts/commit-generator.md)

1. Analyze changed files and construct a semantic commit title (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `style:`, `perf:`).
2. Ensure message is descriptive, concise, and standard-compliant.

### Phase 6 — GitHub Commit & Push
**Reference**: [push.md → Phase 6](./workflows/push.md#phase-6--github-commit--push)

1. If GitHub MCP is available: call `github.push_files` with commit message and file array.
2. If GitHub MCP is not available: execute local git commands (`git add`, `git commit -m`, `git push`).

### Phase 7 — Push Summary & Verification
**Reference**: [push.md → Phase 7](./workflows/push.md#phase-7--push-summary--verification)

Report the final push state:
```
✅ Successfully Pushed to GitHub

Repository: owner/repo
Branch:     main
Commit:     7f3a1b2 — "feat: add player controls component"
Files:      3 modified, 2 added
```

---

## Safety Rules

**Read and follow**: [safety.md](./rules/safety.md)

Critical safety rules:
- **Never** commit secrets, passwords, connection strings, or `.env` files.
- **Never** force-push (`git push --force`) or destroy remote history.
- **Always** respect `.gitignore` patterns.
- **Always** confirm target branch before pushing.

---

## Tool Reference

| Tool | Primary Use |
|------|-------------|
| `github.push_files` | Push multiple changed files in a single GitHub commit |
| `github.get_file_contents` | Read file state from GitHub repo |
| `github.list_commits` | Fetch latest commit info |
| `run_command` | Execute local git commands when MCP is unavailable |
