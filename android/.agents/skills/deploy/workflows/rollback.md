# Rollback Workflow

Procedure for rolling back a deployment to a previous version.

> **Note**: Automated rollback is informational in v1. The agent guides the user through the rollback process rather than executing it automatically.

---

## When to Use

Use this workflow when:
- A deployment was successful but the live site is broken
- A runtime error is discovered after deployment
- The user explicitly requests a rollback

---

## Step 1: Identify Previous Successful Deployment

Use `vercel.list_deployments` to find the last successful deployment:

```
vercel.list_deployments({
  projectId: "<project-id>",
  teamId: "<team-id>"
})
```

Look for the most recent deployment with status `READY` that is NOT the current failed/problematic deployment.

---

## Step 2: Gather Previous Deployment Details

Use `vercel.get_deployment` to get details:

```
vercel.get_deployment({
  idOrUrl: "<previous-deployment-id>",
  teamId: "<team-id>"
})
```

Extract:
- Deployment ID
- Commit SHA
- Deployment URL
- Created timestamp
- Environment

---

## Step 3: Check Runtime Errors

Before recommending rollback, check if there are actual runtime errors:

```
vercel.get_runtime_errors({
  projectId: "<project-id>",
  teamId: "<team-id>",
  since: "1h"
})
```

If runtime errors are found, include them in the rollback recommendation:

```
Runtime errors detected in the current deployment:

Error: TypeError: Cannot read property 'name' of undefined
  Route: /api/players
  Occurrences: 47 in the last hour
  First seen: 10 minutes ago

Previous stable deployment:
  ID: dpl_xyz789
  Commit: def5678 — "feat: update player list"
  Deployed: 3 hours ago
  Status: READY (no runtime errors)
```

---

## Step 4: Present Rollback Options

```
⚠️ Current deployment has issues.

Options:
1. (Recommended) Rollback via Vercel Dashboard
   → Go to vercel.com → Project → Deployments → Select previous deployment → Promote
   
2. Redeploy the previous commit
   → I'll push the previous commit's code and trigger a new deployment
   
3. Fix the current issue and redeploy
   → I'll analyze the runtime error and attempt a fix

4. Do nothing
   → Keep the current deployment

Select an option:
```

---

## Step 5: Execute Rollback

### Option 1: Vercel Dashboard Rollback (Recommended)

Guide the user:
```
To rollback via the Vercel Dashboard:

1. Go to https://vercel.com/dashboard
2. Select your project: <project-name>
3. Click on "Deployments"
4. Find deployment: dpl_xyz789 (from 3 hours ago)
5. Click the "..." menu → "Promote to Production"
6. Confirm the promotion

This will instantly point your production URL to the previous deployment.
```

### Option 2: Redeploy Previous Commit

1. Get the previous commit's code from GitHub:
   ```
   github.get_file_contents({
     owner: "<owner>",
     repo: "<repo>",
     path: "",
     branch: "<branch>"
   })
   ```

2. Trigger a deployment of that specific commit via `vercel.create_git_project`

### Option 3: Fix and Redeploy

Transition to the [repair workflow](./repair.md), using the runtime error information from Step 3 as input.

---

## Important Considerations

- **Rollback does NOT revert the Git history** — the code on GitHub remains at the latest commit
- **Database migrations are NOT rolled back** — if the deployment included schema changes, rollback may cause data issues
- **Environment variable changes are NOT rolled back** — verify env vars are compatible with the previous deployment
- Always warn the user about these limitations before executing a rollback
