# Deploy Workflow

Complete end-to-end deployment workflow from project discovery to success report.

---

## Phase 1 — Project Discovery

### Step 1.1: Identify GitHub Repository

Determine the GitHub owner and repository name. Try these methods in order:

1. **Workspace context**: Check if the current workspace has git remote information
   - Run: `git remote get-url origin` via `run_command`
   - Parse the URL to extract `owner/repo` (handles both HTTPS and SSH formats)
   - HTTPS: `https://github.com/owner/repo.git` → `owner/repo`
   - SSH: `git@github.com:owner/repo.git` → `owner/repo`

2. **package.json repository field**: Read `package.json` and check `repository.url`
   ```json
   { "repository": { "url": "https://github.com/owner/repo" } }
   ```

3. **Ask the user**: If neither method works, ask:
   ```
   I couldn't detect your GitHub repository automatically.
   Please provide the repository in owner/repo format (e.g., username/my-project):
   ```

### Step 1.2: Identify Current Branch

```bash
git branch --show-current
```

If this fails, default to `main` and confirm with user:
```
Could not detect current branch. Using 'main'. Is this correct?
```

### Step 1.3: Detect Framework

Read `package.json` and check `dependencies` + `devDependencies`:

| Package | Framework |
|---------|-----------|
| `next` | Next.js |
| `react` (without next) | React (Vite/CRA) |
| `vue` | Vue.js |
| `@sveltejs/kit` | SvelteKit |
| `svelte` (without kit) | Svelte |
| `astro` | Astro |
| `nuxt` | Nuxt |
| `@angular/core` | Angular |
| None of the above | Static site |

### Step 1.4: Detect Package Manager

Check for lockfile in project root:

| Lockfile | Package Manager | Install Command | Build Command |
|----------|----------------|-----------------|---------------|
| `pnpm-lock.yaml` | pnpm | `pnpm install` | `pnpm build` |
| `package-lock.json` | npm | `npm install` | `npm run build` |
| `yarn.lock` | yarn | `yarn install` | `yarn build` |
| `bun.lock` or `bun.lockb` | bun | `bun install` | `bun run build` |
| None found | npm (default) | `npm install` | `npm run build` |

### Step 1.5: Discover Vercel Team

Try in order:

1. **`.vercel/project.json`**: Read locally, extract `orgId`
   ```json
   { "orgId": "team_abc123", "projectId": "prj_xyz789" }
   ```

2. **`vercel.list_teams`**: Call with no arguments, present teams if multiple:
   ```
   Multiple Vercel teams found:
   1. my-personal-team
   2. my-company-team
   
   Select a team:
   ```

### Step 1.6: Discover Vercel Project

Try in order:

1. **`.vercel/project.json`**: Extract `projectId` → verify with `vercel.get_project`
2. **`vercel.list_projects`**: List all projects for the team, match by:
   - Git repository link (if project is linked to the same GitHub repo)
   - Project name matching repo name
3. **User selection**: If no match or multiple matches found

### Step 1.7: Display Project Profile

```
Analyzing project...
✓ GitHub: owner/repo (branch: main)
✓ Framework: Next.js
✓ Package Manager: pnpm
✓ Vercel Project: my-app (team: my-team)
✓ Build Command: pnpm build
✓ Output: .next
```

---

## Phase 2 — Change Detection

### Step 2.1: Get Local File State

Use `view_file` and `list_dir` to read the current state of all project files in the workspace.

**Important**: Respect `.gitignore`. Do NOT include:
- `node_modules/`
- `.next/`
- `dist/`
- `build/`
- `.env`, `.env.local`, `.env.production.local`
- `.vercel/`
- Any other patterns in `.gitignore`

### Step 2.2: Get GitHub File State

Use `github.get_file_contents` to read the repository root directory listing, then compare against local files.

```
github.get_file_contents({
  owner: "<owner>",
  repo: "<repo>",
  path: "",
  branch: "<branch>"
})
```

Then read individual files that differ to confirm the content delta.

### Step 2.3: Compare and Classify Changes

Classify each file as:
- **Modified**: File exists both locally and on GitHub with different content
- **Added**: File exists locally but not on GitHub
- **Deleted**: File exists on GitHub but not locally

### Step 2.4: Handle "No Changes" State

If no files differ between local and GitHub:

```
No new code changes detected.

Would you like me to:
1. Redeploy the current commit
2. Cancel

Select an option:
```

If the user selects "Redeploy", skip to Phase 7 (Trigger Deployment).

### Step 2.5: Display Change Summary

```
Detected changes:

Modified:
  - app/page.tsx
  - components/Player.tsx
  - styles/globals.css

Added:
  - components/PlayerControls.tsx
  - lib/playerUtils.ts

Deleted:
  - old/player.tsx

Total: 4 modified, 2 added, 1 deleted
```

---

## Phase 5 — GitHub Commit & Push

> Phases 3 and 4 (Dependency Analysis and Validation) are in [validate.md](./validate.md)

### Step 5.1: Pre-Commit Checks

Before committing, verify:

1. **Correct repository**: Confirm `owner/repo` matches the intended target
2. **Correct branch**: Confirm the branch name
3. **No secrets**: Scan file contents for patterns that indicate secrets:
   - API keys: `sk-`, `pk_`, `api_key`, `apiKey`
   - Tokens: `token`, `secret`, `password`, `credential`
   - Connection strings: `postgres://`, `mongodb://`, `mysql://`, `redis://`
   - AWS: `AKIA`, `aws_secret`
   - Private keys: `-----BEGIN`
   
   If a secret is detected:
   ```
   ⚠️ Potential secret detected in file: lib/config.ts
   
   I found what appears to be a secret value. I will NOT commit this file.
   
   Please:
   1. Move the secret to an environment variable
   2. Add the file to .gitignore
   3. Try /deploy again
   ```

4. **No generated files**: Ensure these directories/files are excluded:
   - `node_modules/`
   - `.next/`, `dist/`, `build/`, `out/`
   - `.env`, `.env.local`, `.env.*.local`
   - `.DS_Store`, `Thumbs.db`

### Step 5.2: Generate Commit Message

Create a conventional commit message based on the actual changes:

**Format**: `<type>: <description>`

| Type | When |
|------|------|
| `feat` | New feature or functionality added |
| `fix` | Bug fix or error correction |
| `chore` | Dependency updates, config changes |
| `style` | Formatting, CSS, styling changes |
| `refactor` | Code restructuring without behavior change |
| `docs` | Documentation changes |
| `perf` | Performance improvements |

**Rules**:
- Analyze the changed files to determine the most appropriate type
- Description should be specific and meaningful
- Examples: `feat: add player controls component`, `fix: resolve hydration mismatch in layout`
- **Never use**: `update`, `changes`, `deploy`, `fixed`, `test`, `misc`

### Step 5.3: Push Files via GitHub MCP

Use `github.push_files` to push all changed files in a single commit:

```
github.push_files({
  owner: "<owner>",
  repo: "<repo>",
  branch: "<branch>",
  message: "<commit-message>",
  files: [
    { path: "app/page.tsx", content: "<file-content>" },
    { path: "components/Player.tsx", content: "<file-content>" },
    ...
  ]
})
```

**Important notes**:
- Read each local file's content via `view_file` before pushing
- Include ALL changed files (modified + added) in a single `push_files` call
- For deleted files: these cannot be handled by `push_files` alone — note this limitation
- File paths must be relative to the repository root (no leading `/`)

### Step 5.4: Confirm Push Success

After pushing, display:
```
✓ Committed: "feat: add player controls"
✓ Pushed to GitHub (branch: main)
✓ Files: 6 modified, 2 added
```

---

## Phase 6 — Vercel Project Detection

### Step 6.1: Verify Vercel Project

If a Vercel project was found in Phase 1, verify it's still the correct target:

```
vercel.get_project({
  projectId: "<project-id>",
  teamId: "<team-id>"
})
```

Check that the project is linked to the correct GitHub repository.

### Step 6.2: Handle Multiple Matches

If multiple Vercel projects are linked to the same repo:

```
Multiple Vercel projects found for owner/repo:

1. (Recommended) my-app-production — Last deployed: 2h ago, Environment: production
2. my-app-preview — Last deployed: 1d ago, Environment: preview
3. my-app-staging — Last deployed: 5d ago, Environment: staging

Select a project:
```

### Step 6.3: Handle No Match

If no Vercel project matches:

```
No Vercel project found linked to owner/repo.

Options:
1. (Recommended) Create a new Vercel project linked to this repo
2. Select from existing Vercel projects
3. Cancel deployment

Select an option:
```

If option 1: Use `vercel.create_git_project` to create and link.

---

## Phase 7 — Trigger Deployment

### Strategy A: Git-Linked Deployment (Preferred)

If the Vercel project is linked to the GitHub repo, use:

```
vercel.create_git_project({
  repo: "<owner>/<repo>",
  teamId: "<team-id>",
  projectName: "<project-name>",
  deploy: true
})
```

This triggers a deployment from the latest commit on the linked branch.

### Strategy B: Direct File Deployment (Fallback)

If the project is not git-linked, collect all project files and deploy directly:

```
vercel.deploy_to_vercel({
  name: "<project-name>",
  target: "production",
  teamId: "<team-id>",
  files: [
    { file: "app/page.tsx", data: "<content>" },
    { file: "package.json", data: "<content>" },
    ...
  ],
  projectSettings: {
    framework: "nextjs",
    buildCommand: "pnpm build",
    installCommand: "pnpm install",
    outputDirectory: ".next"
  }
})
```

### Step 7.1: Record Deployment Details

After triggering, record:
- Deployment ID
- Commit SHA
- Branch
- Target environment (production/preview)
- Deployment URL (if immediately available)
- Timestamp

---

## Phase 8 — Monitor Deployment

### Step 8.1: Poll Deployment Status

Use `vercel.get_deployment` to check status:

```
vercel.get_deployment({
  idOrUrl: "<deployment-id>",
  teamId: "<team-id>"
})
```

### Step 8.2: Status Handling

| Status | Action |
|--------|--------|
| `QUEUED` | Wait 15 seconds, poll again |
| `BUILDING` | Wait 15 seconds, poll again. Optionally show progress |
| `READY` | ✅ Deployment succeeded → Phase 9 |
| `ERROR` | ❌ Deployment failed → Phase 8b (Error Recovery) |
| `CANCELED` | ⚠️ Report cancellation to user |

Use the `schedule` tool to set a timer for polling intervals. Do not poll in a tight loop.

### Step 8.3: Show Progress

During monitoring:
```
⏳ Deployment in progress...
   Status: BUILDING
   Duration: 32s
```

---

## Phase 8b — Error Recovery

See [repair.md](./repair.md) for the complete error recovery workflow.

---

## Phase 9 — Success Report

### Step 9.1: Gather Final Details

```
vercel.get_deployment({
  idOrUrl: "<deployment-id>",
  teamId: "<team-id>"
})
```

Extract:
- Production URL
- Deployment status
- Build duration
- Deployment aliases/domains

### Step 9.2: Display Success Report

```
✅ Deployment Successful

Production URL: https://my-app.vercel.app
Deployment ID:  dpl_abc123
Commit:         abc1234 — "feat: add player controls"
Branch:         main
Environment:    production
Duration:       45s
```

### Step 9.3: Optional Verification

If possible, use `vercel.web_fetch_vercel_url` to verify the URL returns a successful response:

```
vercel.web_fetch_vercel_url({
  url: "https://my-app.vercel.app"
})
```

If the URL returns an error, warn the user:
```
⚠️ Deployment completed but the URL returned an error.
This may indicate a runtime issue. Check the Vercel dashboard for details.
```
