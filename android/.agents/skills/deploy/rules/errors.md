# Error Classification Taxonomy

Comprehensive rules for classifying deployment errors and determining the appropriate response.

---

## Error Categories

### Category A — Code Errors

**Auto-fixable**: ✅ Yes (in most cases)

**Patterns**:

| Error Pattern | Example | Fix Strategy |
|--------------|---------|-------------|
| Missing import | `Module not found: '@/components/Player'` | Find correct file path, update import |
| Wrong import path | `Cannot find module './player'` (actual: `./Player`) | Fix case sensitivity or path |
| TypeScript type error | `Property 'x' does not exist on type 'Y'` | Add property to type, or fix usage |
| Undefined variable | `'player' is not defined` | Add import or declaration |
| Unused import/variable | `'X' is defined but never used` | Remove unused code |
| Syntax error | `SyntaxError: Unexpected token '}'` | Fix syntax at the indicated line |
| JSX error | `JSX element type does not have construct signatures` | Fix component type/import |
| Missing return | `Not all code paths return a value` | Add return statement |
| Invalid JSX | `Adjacent JSX elements must be wrapped` | Wrap in fragment or container |

**Fix procedure**:
1. Extract file path and line number from the error
2. Read the file content
3. Understand the surrounding code context
4. Apply the minimal targeted fix
5. Verify the fix doesn't introduce new issues

**When to escalate (even for code errors)**:
- The fix would require restructuring multiple files
- The error is in generated/third-party code
- The fix changes business logic or behavior
- Multiple valid fixes exist with different behavior implications

---

### Category B — Configuration Errors

**Auto-fixable**: ✅ Often yes

**Patterns**:

| Error Pattern | Example | Fix Strategy |
|--------------|---------|-------------|
| Invalid next.config | `Invalid configuration option` | Fix the specific option |
| Wrong build command | `Command "build" not found` | Update to correct build script |
| Wrong output directory | `Output directory not found` | Set correct output path |
| Invalid vercel.json | `Invalid JSON` / `Unknown property` | Fix JSON syntax or remove invalid key |
| Missing framework detection | `Unable to detect framework` | Set framework in vercel.json |
| Invalid tsconfig | `tsconfig.json: error` | Fix the TypeScript configuration |
| ESLint config error | `ESLint configuration invalid` | Fix ESLint config file |

**Framework-specific output directories**:

| Framework | Output Directory |
|-----------|-----------------|
| Next.js | `.next` |
| Vite/React | `dist` |
| Astro | `dist` |
| SvelteKit | `.svelte-kit` |
| Nuxt | `.output` |
| Angular | `dist/<project-name>` |
| Static | `.` or `public` |

---

### Category C — Dependency Errors

**Auto-fixable**: ⚠️ Sometimes

**Patterns**:

| Error Pattern | Auto-fixable? | Fix Strategy |
|--------------|--------------|-------------|
| `Cannot find module 'X'` (npm package) | ✅ If single obvious package | Add to `package.json`, install |
| `peer dep conflict` (single resolution) | ✅ | Install the compatible version |
| `peer dep conflict` (multiple resolutions) | ❌ Ask user | Present options with risk |
| `Lockfile out of date` | ✅ | Regenerate lockfile |
| `Unsupported engine node@X` | ❌ Ask user | Present version options |
| `ERESOLVE unable to resolve` | ❌ Ask user | Present resolution strategies |
| `Module build failed: X loader` | ✅ If missing loader | Install the required loader |
| `PostCSS plugin X not found` | ✅ | Install the PostCSS plugin |

---

### Category D — Environment Variable Errors

**Auto-fixable**: ❌ Never — always ask user

**Patterns**:

| Error Pattern | Indicator |
|--------------|-----------|
| `NEXT_PUBLIC_X is not defined` | Missing public env var |
| `process.env.X is undefined` | Missing server env var |
| `Error: Missing required env` | Custom env validation |
| `DATABASE_URL` / `SUPABASE_URL` | Database connection |
| `API_KEY` / `SECRET_KEY` | Authentication credential |
| `NEXT_AUTH_SECRET` | Auth configuration |

**Response template**:
```
⚠️ Deployment requires environment variable(s):

  Missing:
  - DATABASE_URL (referenced in lib/db.ts)
  - NEXT_AUTH_SECRET (referenced in auth.config.ts)

  I cannot safely determine or guess these values.

  Please:
  1. Set these variables in Vercel Dashboard → Project Settings → Environment Variables
  2. Or provide them and I'll guide you through configuration

  I will NEVER print or log existing secret values.
```

**Rules**:
- NEVER guess or fabricate environment variable values
- NEVER print existing secret values found in `.env` files
- ONLY read `.env.example` for variable NAMES (not values)
- List the files where the variables are referenced for context

---

### Category E — External Service Errors

**Auto-fixable**: ❌ Never — report only

**Patterns**:

| Error Pattern | Likely Cause |
|--------------|-------------|
| `ECONNREFUSED` | Service is down |
| `ETIMEDOUT` | Service is slow/unreachable |
| `fetch failed` (during build) | External API unavailable |
| `DNS resolution failed` | DNS issue |
| `429 Too Many Requests` | Rate limiting |
| `SSL certificate error` | Certificate issue |
| `CORS error` (at build time) | Misconfigured API |

**Response template**:
```
⚠️ Deployment failed due to an external service issue.

  Error: Connection to api.example.com timed out
  Phase: During build (next build)
  File: lib/api.ts:42

  This is NOT a code error. The external service may be:
  - Temporarily unavailable
  - Rate limiting your requests
  - Blocking requests from Vercel's build servers

  Recommended actions:
  1. Wait 5-10 minutes and retry
  2. Check if the API requires whitelisting Vercel's IP ranges
  3. Consider making the API call at runtime instead of build time
```

**Rules**:
- Do NOT modify application code to work around an external service failure
- Do NOT retry the deployment immediately (the service may still be down)
- Suggest waiting or checking the external service status

---

### Category F — Ambiguous / High-Risk Errors

**Auto-fixable**: ❌ Never — always ask user

**When to classify as Category F**:
- The error message is unclear or could indicate multiple root causes
- Multiple valid fixes exist with different trade-offs
- The fix would require significant code restructuring
- The fix could change application behavior
- The error is in a critical path (authentication, payments, data handling)

**Response template**:
```
⚠️ Deployment failed. I found the error but there are multiple possible fixes.

  Error:
    [exact error message]

  Analysis:
    [explanation of root cause]

  Possible fixes:
  1. (Recommended) [Fix description]
     Risk: [Low/Medium/High] — [reasoning]
  2. [Alternative fix]
     Risk: [Low/Medium/High] — [reasoning]
  3. [Another alternative]
     Risk: [Low/Medium/High] — [reasoning]

  Choose an option before I modify the project.
```

---

## Classification Decision Tree

Use this tree to classify any error:

```
1. Does the error mention a missing environment variable or secret?
   → Yes: Category D

2. Does the error involve network connectivity, DNS, timeout, or external API?
   → Yes: Category E

3. Is the error a TypeScript, syntax, import, or JSX error?
   → Yes: Category A
   → Sub-check: Is the fix obvious and single-solution?
     → Yes: Auto-fix
     → No: Category F

4. Is the error about project configuration (next.config, vercel.json, tsconfig)?
   → Yes: Category B
   → Sub-check: Is the correct configuration obvious?
     → Yes: Auto-fix
     → No: Category F

5. Is the error about a missing module or dependency?
   → Yes: Category C
   → Sub-check: Is there exactly one valid resolution?
     → Yes: Auto-fix
     → No: Ask user (present as Category C with options)

6. None of the above match?
   → Category F (Ambiguous)
```

---

## Error Severity Levels

| Severity | Description | Action |
|----------|-------------|--------|
| **Critical** | Build fails completely, no deployment possible | Must fix before proceeding |
| **Warning** | Build succeeds with warnings | Log warning, proceed with deployment |
| **Info** | Informational message, not an error | Ignore, proceed |

Only **Critical** errors block deployment. Warnings should be reported but don't stop the process.
