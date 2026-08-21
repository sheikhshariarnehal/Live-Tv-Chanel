# MCP Setup Workflow

Guide the user through installing and configuring the GitHub and/or Vercel MCP servers
when they are not already available. After setup completes, resume the deployment workflow.

---

## Phase 0 — MCP Availability Check

Before doing anything else, verify both MCP servers are reachable.

### Step 0.1: Test GitHub MCP

Try calling `github.get_file_contents` with a minimal probe:
```
github.get_file_contents({ owner: "octocat", repo: "hello-world", path: "" })
```

- If the call **succeeds or returns an auth error** → GitHub MCP is **configured** ✅
- If the call **fails with "tool not found" / "MCP not available"** → GitHub MCP is **missing** ❌

### Step 0.2: Test Vercel MCP

Try calling `vercel.list_teams` with no arguments:
```
vercel.list_teams({})
```

- If the call **succeeds or returns an auth error** → Vercel MCP is **configured** ✅
- If the call **fails with "tool not found" / "MCP not available"** → Vercel MCP is **missing** ❌

### Step 0.3: Route Based on Results

| GitHub MCP | Vercel MCP | Action |
|------------|------------|--------|
| ✅ | ✅ | Proceed to deployment (Phase 1 in deploy.md) |
| ❌ | ✅ | Run GitHub MCP setup only |
| ✅ | ❌ | Run Vercel MCP setup only |
| ❌ | ❌ | Run both setups in order (GitHub first, then Vercel) |

---

## GitHub MCP Setup

### Announce the Issue

```
⚠️ GitHub MCP is not configured.

I need the GitHub MCP to commit and push your code.
Let me guide you through a quick setup — it takes about 2 minutes.
```

### Step G1: Check Node.js Prerequisite

Run: `node --version` and `npx --version`

If Node.js is NOT installed:
```
⚠️ Node.js is required for the MCP servers but is not installed.

Please install Node.js first:
→ https://nodejs.org/en/download  (choose the LTS version — v20.x or later)

After installing, restart Antigravity IDE and run /deploy again.
```
STOP — do not continue until the user confirms Node.js is installed.

### Step G2: Get a GitHub Personal Access Token

Display these instructions to the user:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 How to create your GitHub Personal Access Token
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Open this URL in your browser:
   → https://github.com/settings/tokens?type=beta
   (Fine-grained tokens — more secure than classic tokens)

2. Sign in to GitHub if prompted.

3. Click "Generate new token"

4. Fill in the form:
   Token name:   antigravity-deploy
   Expiration:   90 days (or longer if preferred)
   Repository access: "All repositories"
      OR select only the repos you want to deploy

5. Scroll to "Permissions" and grant:
   ✅ Contents      → Access: Read and Write
      (This lets the MCP push code to your repos)
   ✅ Metadata      → Access: Read-only
      (Required by GitHub — enabled automatically)
   ✅ Pull requests → Access: Read and Write  (optional)

6. Scroll to the bottom and click "Generate token"

7. ⚠️ COPY the token NOW — GitHub only shows it once!
   It will look like: github_pat_xxxxxxxxxxxxxxxx...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔒 SECURITY NOTE:
   Your token is like a password. Never share it.
   I will write it only to your local config file —
   it will NOT appear in any chat message or log.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Use `ask_question` to collect the token via a write-in response.
Do NOT echo the token back in any response.

### Step G3: Read Existing MCP Config

Locate the global MCP config file:

| Platform | Path |
|----------|------|
| Windows  | `C:\Users\<username>\.gemini\config\mcp_config.json` |
| macOS    | `~/.gemini/config/mcp_config.json` |
| Linux    | `~/.gemini/config/mcp_config.json` |

Use `run_command` to check if it exists and read its current contents.
If it does not exist, start with the structure: `{ "mcpServers": {} }`

### Step G4: Write GitHub MCP Entry

Merge the GitHub MCP entry into the existing config and write the file:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<TOKEN>"
      }
    }
  }
}
```

Replace `<TOKEN>` with the value provided by the user.
Write the file using `run_command` with PowerShell `Set-Content` or shell redirection.
Do NOT include the token in any chat message — write it directly to the file only.

### Step G5: Confirm and Prompt Restart

```
✅ GitHub MCP configuration saved!

Location: C:\Users\<username>\.gemini\config\mcp_config.json

⚡ Action required: Please restart Antigravity IDE to activate the MCP.
   After restarting, run /deploy again and I will continue from here.

Once restarted, let me know and I will verify the connection.
```

---

## Vercel MCP Setup

### Announce the Issue

```
⚠️ Vercel MCP is not configured.

I need the Vercel MCP to deploy your project.
Let me guide you through setup — it takes about 2 minutes.
```

### Step V1: Get a Vercel API Token

Display these instructions to the user:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 How to create your Vercel API Token
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Open this URL in your browser:
   → https://vercel.com/account/tokens
   (Make sure you are logged into your Vercel account)

2. Click "Create Token"

3. Fill in:
   Name:        antigravity-deploy
   Scope:       Full Account
                (or select a specific Team if you use a team account)
   Expiration:  No Expiration  (or set a date you prefer)

4. Click "Create"

5. ⚠️ COPY the token NOW — Vercel shows it only once!
   It will be a long random string like: abc123xyz...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Don't have a Vercel account yet?
   → Sign up free at: https://vercel.com/signup
     (You can sign up with GitHub in one click)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔒 SECURITY NOTE:
   Your token is like a password. Never share it.
   I will write it only to your local config file.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Use `ask_question` to collect the token via a write-in response.
Do NOT echo the token back.

### Step V2: Ask for Vercel Team ID (Optional)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Do you use a Vercel Team? (Optional)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If you work under a Vercel Team (not a personal account),
I need your Team ID.

How to find it:
1. Go to: https://vercel.com/dashboard
2. Click your team name in the top-left dropdown
3. Go to Settings → General
4. Copy the "Team ID" (looks like: team_xxxxxxxxxxxxxxxx)

If you use a personal Vercel account, skip this step.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Use `ask_question` with options:
1. "I use a personal account (skip)"
2. "I'll enter my Team ID"

If they provide a Team ID, note it for use in all subsequent Vercel MCP calls.

### Step V3: Write Vercel MCP Entry

Merge the Vercel MCP entry into the config:

```json
{
  "mcpServers": {
    "vercel": {
      "command": "npx",
      "args": ["-y", "@vercel/mcp-adapter"],
      "env": {
        "VERCEL_API_TOKEN": "<TOKEN>"
      }
    }
  }
}
```

Replace `<TOKEN>` with the value the user provided.
Write the file — do NOT echo the token in chat.

### Step V4: Confirm and Prompt Restart

```
✅ Vercel MCP configuration saved!

Location: C:\Users\<username>\.gemini\config\mcp_config.json

⚡ Action required: Please restart Antigravity IDE to activate the MCP.
   After restarting, run /deploy again and I will continue from here.
```

---

## Both MCPs Missing — Combined Flow

When both are missing, announce them together:

```
⚠️ GitHub MCP and Vercel MCP are both not configured.

To deploy your project, I need to set up both integrations.
This takes about 5 minutes — I'll guide you step by step.

Setup plan:
  Step 1 of 2: Configure GitHub MCP  (for pushing code)
  Step 2 of 2: Configure Vercel MCP  (for deploying)

Let's get started with GitHub first!
```

Run GitHub setup (G1–G5), then Vercel setup (V1–V4) in sequence.
Only prompt for one restart at the end, after both are written.

---

## Post-Restart Verification

When the user returns after restarting, verify the MCPs:

```
🔄 Verifying MCP connections...
```

Re-run Step 0.1 and Step 0.2 probes.

**If both pass:**
```
✅ GitHub MCP — Connected
✅ Vercel MCP — Connected

All integrations verified! Resuming your deployment now...
```
→ Proceed to deploy.md Phase 1.

**If one or both still fail after restart:**
```
❌ MCP verification failed.

The MCP may not have loaded yet. Let's troubleshoot:

1. Make sure Antigravity IDE was fully closed and reopened
   (not just the window — the process must restart)

2. Check that Node.js is installed:
   → Open a terminal and run: node --version
   → You should see v18 or higher

3. Check if the MCP package can be downloaded:
   → Run in terminal: npx -y @modelcontextprotocol/server-github
   → If it errors, check your internet connection

4. Check the config file was written correctly at:
   C:\Users\<username>\.gemini\config\mcp_config.json

Common issues:
- Token has wrong permissions → recreate with correct scopes
- Node.js not in PATH → reinstall Node.js and restart terminal
- Firewall blocking npm → check corporate proxy settings

If you're still stuck, I can show you the config file to verify it manually.
```

---

## Manual Config Reference

Always offer this as a fallback for users who prefer manual setup:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "github_pat_YOUR_TOKEN_HERE"
      }
    },
    "vercel": {
      "command": "npx",
      "args": ["-y", "@vercel/mcp-adapter"],
      "env": {
        "VERCEL_API_TOKEN": "YOUR_VERCEL_TOKEN_HERE"
      }
    }
  }
}
```

Save this to: `C:\Users\<username>\.gemini\config\mcp_config.json`
(Replace `<username>` with your Windows username)
