# Safety Rules

Mandatory safety constraints for the deployment agent. These rules take precedence over all other instructions.

---

## NEVER Do

These actions are **absolutely prohibited**, regardless of context or user instructions:

### 1. Never Delete the Repository
- Do not call any tool that would delete the GitHub repository
- Do not remove all files from the repository
- If the user asks to delete the repo, refuse and explain the risk

### 2. Never Force-Push
- Do not use `--force` or `--force-with-lease` when pushing
- If a push is rejected due to diverged history, inform the user:
  ```
  ⚠️ Push rejected — the remote branch has commits not present locally.
  
  Options:
  1. Pull and merge remote changes first
  2. Force-push (WARNING: this will overwrite remote commits)
  3. Cancel
  
  I will NOT force-push without your explicit confirmation.
  ```
- Only force-push if the user explicitly selects that option

### 3. Never Modify Unrelated Files
- Only modify files that are:
  - Part of the user's current changes
  - Directly causing a build/deployment error
  - Required to fix a dependency issue
- Do NOT touch files that are working correctly
- Do NOT refactor code that isn't broken
- Do NOT "improve" code during deployment

### 4. Never Remove Dependencies Without Understanding Usage
- Before removing any dependency, check if it's imported anywhere:
  ```
  grep_search for the package name across the codebase
  ```
- If the dependency is used in any file, do NOT remove it
- If the dependency is unused, confirm with user before removing

### 5. Never Change Production Secrets
- Do not modify environment variables on Vercel
- Do not modify `.env` files with actual secret values
- Do not generate or guess secret values (API keys, tokens, passwords)
- If a secret is needed, ask the user to provide it

### 6. Never Print Secret Values
- Never display the contents of `.env`, `.env.local`, `.env.production`
- Never log API keys, tokens, passwords, or connection strings in chat
- When referencing environment variables, only mention the VARIABLE NAME, never the VALUE
- If you accidentally read a secret, do NOT include it in your response

### 7. Never Modify Database Schemas
- Do not run migration commands unless explicitly authorized by the user
- Do not modify database connection configurations
- Do not change ORM schema files (prisma.schema, drizzle configs) unless the error is clearly a syntax issue

### 8. Never Disable Security to Fix Build
- Do not set `eslint.ignoreDuringBuilds: true` in next.config.js just to make the build pass
- Do not set `typescript.ignoreBuildErrors: true`
- Do not add `// @ts-ignore` or `// @ts-nocheck` to suppress real errors
- Do not disable authentication middleware to fix deployment
- If the build fails due to lint/type errors, fix the actual errors

### 9. Never Ignore Build Errors
- If the build fails, do NOT proceed to deployment
- If a TypeScript error is found, fix it (don't suppress it)
- If a lint error is found, fix it (don't disable the rule)
- A failed build is a **hard blocker** — no deployment without a passing build

### 10. Never Deploy to an Ambiguous Target
- If multiple Vercel projects match, always ask the user to choose
- If the project name doesn't match the repo name, confirm before deploying
- Never assume the deployment target — verify it

### 11. Never Retry Infinitely
- Maximum 3 automatic retry attempts per /deploy session
- Track the retry counter and enforce the limit
- After 3 failed attempts, stop and ask the user
- Do NOT reset the counter without user action

---

## ALWAYS Do

These actions are **mandatory** for every deployment:

### 1. Always Inspect Before Modifying
- Read the current state of any file before modifying it
- Understand the code context around an error before applying a fix
- Never apply a fix based solely on the error message — always read the source

### 2. Always Keep Changes Focused
- Only modify files directly related to the deployment task
- Each fix should be the minimal change needed
- Do not combine unrelated changes in a single commit

### 3. Always Validate Before Commit
- Run the build before committing to GitHub
- If the build fails, do NOT commit the broken code
- The sequence is: fix → build → succeed → commit → push

### 4. Always Use the Exact Commit Being Deployed
- After pushing to GitHub, deploy THAT commit
- Do not deploy a stale commit
- Verify the deployment references the latest push

### 5. Always Record Deployment Status
- Track: Deployment ID, Commit SHA, Branch, URL, Environment, Status
- Include this information in the success/failure report
- Keep a log of all deployment attempts during the session

### 6. Always Explain Automatic Fixes
- Before applying any auto-fix, explain what you're changing and why:
  ```
  Auto-fix: Updating import path in Game.tsx
    - import Player from '@/components/Player'
    + import Player from '@/components/player/Player'
  
  Reason: File 'Player.tsx' is located in 'components/player/' subdirectory
  ```
- Never silently modify code

### 7. Always Ask Before Risky Changes
- Major dependency upgrades → ask
- Removing dependencies → ask
- Modifying security-related code → ask
- Changing environment configuration → ask
- Modifying database schemas → ask
- Force-pushing → ask

### 8. Always Stop After Retry Limit
- After 3 failed automatic fix attempts, present:
  ```
  🛑 Automatic deployment recovery stopped after 3 attempts.
  
  Attempted fixes:
    1. [what was tried]
    2. [what was tried]
    3. [what was tried]
  
  I need your decision before continuing.
  ```

---

## Secret Detection Patterns

Scan file contents for these patterns before committing. If any match, **reject the file** and warn the user.

### API Keys and Tokens
```
sk-[a-zA-Z0-9]{20,}          # OpenAI / Stripe secret keys
pk_(test|live)_[a-zA-Z0-9]+  # Stripe publishable keys
ghp_[a-zA-Z0-9]{36}          # GitHub personal access tokens
gho_[a-zA-Z0-9]{36}          # GitHub OAuth tokens
github_pat_[a-zA-Z0-9_]+     # GitHub fine-grained tokens
AKIA[0-9A-Z]{16}             # AWS access key IDs
xoxb-[0-9-]+                 # Slack bot tokens
xoxp-[0-9-]+                 # Slack user tokens
```

### Connection Strings
```
postgres://                    # PostgreSQL connection string
mongodb(\+srv)?://            # MongoDB connection string
mysql://                       # MySQL connection string
redis://                       # Redis connection string
amqp://                        # RabbitMQ connection string
```

### Private Keys
```
-----BEGIN (RSA |EC |DSA )?PRIVATE KEY-----
-----BEGIN OPENSSH PRIVATE KEY-----
```

### Generic Patterns
```
(api[_-]?key|apikey)\s*[:=]\s*['"][a-zA-Z0-9]{16,}['"]
(secret|password|passwd)\s*[:=]\s*['"][^'"]{8,}['"]
(token)\s*[:=]\s*['"][a-zA-Z0-9_\-\.]{20,}['"]
```

**If a potential secret is detected**:
```
⚠️ Potential secret detected!

File: lib/config.ts
Match: API key pattern found (not printing the value)

I will NOT commit this file. Please:
1. Move the secret to an environment variable
2. Add the file to .gitignore if it contains secrets
3. Use .env.example for documenting required variables (with placeholder values only)
```

---

## Files to Never Commit

These files/directories should be excluded from any push, even if they exist locally:

```
node_modules/
.next/
dist/
build/
out/
.vercel/
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.DS_Store
Thumbs.db
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*
coverage/
.nyc_output/
*.tsbuildinfo
```

Read `.gitignore` and respect all patterns defined there.

---

## Scope Limitation

During a deployment fix, the agent may ONLY modify files that are:

1. **Directly causing the error** — the file referenced in the error message
2. **Directly required by the fix** — e.g., a type definition file that needs updating
3. **Configuration files** — `package.json`, `tsconfig.json`, `next.config.*`, `vercel.json`
4. **Lock files** — only to regenerate after dependency changes

The agent may NOT modify:
- Files that are working correctly
- Test files (unless the test itself is the error)
- Documentation files
- Files in unrelated directories
- Files the user didn't change
