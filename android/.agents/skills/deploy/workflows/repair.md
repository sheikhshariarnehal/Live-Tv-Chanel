# Repair Workflow

Error recovery workflow for handling deployment failures.

---

## Overview

This workflow activates when a Vercel deployment enters the `ERROR` state. It reads the build logs, classifies the error, applies safe fixes, and retries — or escalates to the user.

---

## Step 1: Read Build Logs

Retrieve the error logs from the failed deployment:

```
vercel.get_deployment_build_logs({
  idOrUrl: "<deployment-id>",
  teamId: "<team-id>",
  errorsOnly: true,
  direction: "tail",
  limit: 100
})
```

If `errorsOnly` returns nothing useful, widen the search:

```
vercel.get_deployment_build_logs({
  idOrUrl: "<deployment-id>",
  teamId: "<team-id>",
  direction: "tail",
  limit: 200
})
```

---

## Step 2: Classify the Error

Use the error classification taxonomy from [errors.md](../rules/errors.md) and the classification prompt from [error-classifier.md](../prompts/error-classifier.md).

### Classification Decision Tree

```
Is the error about a missing environment variable?
├── Yes → Category D (Environment Variable) → ASK USER
│
Is the error about an external service failure (API timeout, DNS, etc.)?
├── Yes → Category E (External Service) → REPORT ONLY
│
Is the error a TypeScript/syntax/import error?
├── Yes → Category A (Code Error) → ATTEMPT AUTO-FIX
│
Is the error about build configuration (next.config, vercel.json, build command)?
├── Yes → Category B (Config Error) → ATTEMPT AUTO-FIX
│
Is the error about a missing module or dependency conflict?
├── Yes → Category C (Dependency Error)
│   ├── Is the fix obvious and low-risk? → ATTEMPT AUTO-FIX
│   └── Multiple valid fixes? → ASK USER
│
Otherwise → Category F (Ambiguous) → ASK USER
```

---

## Step 3: Execute Auto-Fix

### Category A — Code Error Fix

**Common patterns and fixes**:

| Error Pattern | Fix Strategy |
|--------------|-------------|
| `Module not found: '@/components/X'` | Search for the correct file path, update import |
| `Type error: Property 'x' does not exist on type 'Y'` | Add the missing property to the type, or fix the access |
| `SyntaxError: Unexpected token` | Fix the syntax error at the indicated line |
| `Cannot find module 'X'` (third-party) | Add the package to `package.json`, install |
| `'X' is defined but never used` | Remove unused import/variable |
| `JSX element type 'X' does not have any construct or call signatures` | Fix the component type or import |

**Fix procedure**:
1. Locate the source file using the error's file path and line number
2. Read the file via `view_file`
3. Understand the root cause
4. Apply the minimal fix using `replace_file_content` or `multi_replace_file_content`
5. Log the fix: `"Auto-fix: [description of change]"`

### Category B — Config Error Fix

**Common patterns and fixes**:

| Error Pattern | Fix Strategy |
|--------------|-------------|
| `Invalid next.config.js` | Fix the configuration syntax/structure |
| `Build command failed` | Update `vercel.json` or project settings |
| `Output directory not found` | Set correct output directory for the framework |
| `Invalid vercel.json` | Fix JSON syntax or invalid settings |

**Fix procedure**:
1. Read the configuration file
2. Identify the misconfiguration
3. Apply the fix
4. Verify the fix makes sense for the framework

### Category C — Dependency Error Fix (Auto-fixable cases only)

**Auto-fixable cases**:

| Error Pattern | Fix Strategy |
|--------------|-------------|
| `Module not found: 'package-x'` (clearly used in code) | Add to `package.json`, regenerate lockfile |
| `Lockfile out of date` | Regenerate lockfile |
| `Missing peer dependency` (single valid resolution) | Add the peer dependency |

**Non-auto-fixable cases** (escalate to user):
- Multiple valid version resolutions
- Major version incompatibility
- Node.js version mismatch

---

## Step 4: Re-Validate After Fix

After applying any auto-fix, re-run the full validation workflow:

1. Run the build locally: `<package-manager> build`
2. If build succeeds: proceed to re-commit
3. If build fails: check if this is a new error or the same one
   - New error: classify and attempt fix (counts toward retry limit)
   - Same error: the fix didn't work → escalate to user

---

## Step 5: Re-Commit and Re-Deploy

After a successful auto-fix + validation:

1. **Commit the fix**:
   - Message format: `fix: <description of what was fixed>`
   - Example: `fix: correct Player component import path`
   - Include only the files that were modified as part of the fix

2. **Push to GitHub**:
   ```
   github.push_files({
     owner: "<owner>",
     repo: "<repo>",
     branch: "<branch>",
     message: "fix: <description>",
     files: [{ path: "<file>", content: "<content>" }]
   })
   ```

3. **Trigger redeployment**:
   - Use the same deployment strategy as the original attempt
   - Record the new deployment ID

4. **Monitor**:
   - Poll `vercel.get_deployment` until terminal state
   - Increment the retry counter

---

## Step 6: User Escalation

### Category D — Environment Variable Missing

```
⚠️ Deployment requires an environment variable.

Variable: DATABASE_URL
Context: Referenced in lib/db.ts, required at build time

I cannot safely determine or guess this value.

Please either:
1. Set DATABASE_URL in the Vercel dashboard → Project Settings → Environment Variables
2. Provide the value and I'll guide you through setting it up

Note: I will never print or log secret values.
```

### Category E — External Service Failure

```
⚠️ Deployment failed due to an external service issue.

Error: Connection to api.example.com timed out during build

This is not a code issue. The external service may be temporarily unavailable.

Recommended actions:
1. Wait 5-10 minutes and try deploying again
2. Check the status of api.example.com
3. Review if the API endpoint is correct in your configuration
```

Do NOT repeatedly modify application code when the failure is external.

### Category F — Ambiguous Error

```
⚠️ Deployment failed. I found the error but there are multiple possible fixes.

Error:
  Cannot resolve dependency tree for 'react-something@4.x'

Possible fixes:
1. (Recommended) Upgrade react to v19 (compatible with react-something@4.x)
   Risk: Medium — React 19 has some breaking changes
2. Downgrade react-something to 3.x
   Risk: Low — v3 is stable but older
3. Use --legacy-peer-deps flag
   Risk: High — may mask other dependency issues

Choose an option before I modify the project.
```

---

## Step 7: Retry Limit Enforcement

### Retry Counter Rules

- The retry counter starts at 0
- Each automatic fix → re-validate → re-deploy cycle increments by 1
- Maximum allowed: **3 automatic retries**
- User-initiated fixes do NOT count toward the limit (reset is acceptable after user action)

### After Maximum Retries

```
🛑 Automatic deployment recovery stopped after 3 attempts.

Attempted fixes:
  Attempt 1: Fixed missing import in Player.tsx → Build error: type mismatch
  Attempt 2: Fixed type in PlayerProps → Build error: missing module
  Attempt 3: Added missing package → Build error: version conflict

The deployment has a cascading issue that requires manual review.

I need your decision before continuing. You can:
1. Review the errors and provide guidance
2. Fix the issues manually and run /deploy again
3. Cancel the deployment
```

---

## Recovery Log

Throughout the repair process, maintain a log of all actions taken:

```
Deployment Recovery Log:
─────────────────────────
Attempt 1 (auto-fix):
  Error: Module not found '@/components/Player'
  Fix: Updated import path in Game.tsx
  Result: New error emerged

Attempt 2 (auto-fix):
  Error: Type 'string' not assignable to 'PlayerProps'
  Fix: Updated PlayerProps interface
  Result: New error emerged

Attempt 3 (auto-fix):
  Error: Module 'react-player' not found
  Fix: Added react-player to dependencies
  Result: Build succeeded ✓
```

This log helps the user understand what happened and provides context for debugging if manual intervention is needed.
