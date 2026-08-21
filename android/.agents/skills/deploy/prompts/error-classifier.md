# Error Classifier Prompt

Structured prompt template for classifying Vercel deployment errors.

---

## Input Format

When you receive a deployment error, extract these fields from the Vercel build logs:

```
ERROR_MESSAGE: [The exact error text from the build log]
FILE_PATH: [The file path referenced in the error, if any]
LINE_NUMBER: [The line number referenced in the error, if any]
BUILD_PHASE: [install | build | deploy]
FRAMEWORK: [next.js | react | vue | svelte | astro | other]
```

---

## Classification Procedure

Follow this exact sequence to classify the error:

### Step 1: Check for Environment Variable Issues

**Match if** the error mentions:
- `process.env.VARIABLE_NAME is undefined`
- `Missing required environment variable`
- `NEXT_PUBLIC_` prefix in error
- `DATABASE_URL`, `API_KEY`, `SECRET`, `TOKEN` in the error context
- `Error: Configuration validation failed` with env var references

**If matched** → **Category D** → Ask user → STOP

---

### Step 2: Check for External Service Issues

**Match if** the error mentions:
- `ECONNREFUSED`, `ETIMEDOUT`, `ENOTFOUND`
- `fetch failed`, `network error`
- `DNS resolution failed`
- `SSL`, `TLS`, `certificate`
- `429`, `503`, `502` status codes
- Connection to a specific external hostname

**If matched** → **Category E** → Report only → STOP

---

### Step 3: Check for Code Errors

**Match if** the error is:
- `TS[0-9]+:` — TypeScript error with error code
- `SyntaxError:`
- `Module not found: Can't resolve` + internal path (`@/`, `./`, `../`)
- `is not defined`
- `is defined but never used`
- `Property '...' does not exist on type`
- `Type '...' is not assignable to type`
- `JSX element`
- `Cannot find name`
- `Unexpected token`

**If matched** → **Category A**

**Sub-classification**:
- Is the fix a single, obvious change (wrong path, missing import, syntax fix)?
  - → **Auto-fix**
- Does the fix require understanding complex business logic?
  - → **Category F** → Ask user
- Would the fix change program behavior?
  - → **Category F** → Ask user

---

### Step 4: Check for Configuration Errors

**Match if** the error mentions:
- `next.config` — Invalid Next.js configuration
- `vercel.json` — Invalid Vercel configuration
- `tsconfig.json` — TypeScript configuration error
- `Invalid configuration`
- `Unknown option`
- `Build command` or `Output directory`

**If matched** → **Category B**

**Sub-classification**:
- Is the correct configuration value obvious from the framework?
  - → **Auto-fix**
- Multiple valid configurations possible?
  - → **Category F** → Ask user

---

### Step 5: Check for Dependency Errors

**Match if** the error mentions:
- `Module not found: Can't resolve` + npm package name (no `@/`, `./`, `../` prefix)
- `Cannot find module` + package name
- `ERESOLVE unable to resolve dependency tree`
- `peer dep`
- `Lockfile`
- `engine` / `node` version
- `Could not resolve` + package specifier

**If matched** → **Category C**

**Sub-classification**:
- Missing package that's clearly needed? → Auto-fix (add to dependencies)
- Lockfile regeneration needed? → Auto-fix (run install)
- Version conflict with one clear resolution? → Auto-fix
- Version conflict with multiple valid resolutions? → Ask user
- Node.js version mismatch? → Ask user

---

### Step 6: Default — Ambiguous

If none of the above steps produced a match:

→ **Category F** → Ask user

---

## Output Format

After classification, produce this structured output (internally, for the repair workflow):

```
CATEGORY: [A | B | C | D | E | F]
CATEGORY_NAME: [Code Error | Config Error | Dependency Error | Environment Variable | External Service | Ambiguous]
AUTO_FIXABLE: [true | false]
CONFIDENCE: [high | medium | low]

ERROR_SUMMARY: [One-line description of the error]
ROOT_CAUSE: [What is causing this error]
SOURCE_FILE: [File path if applicable]
SOURCE_LINE: [Line number if applicable]

FIX_DESCRIPTION: [What the fix would be, if auto-fixable]
FIX_RISK: [low | medium | high]
FIX_SCOPE: [Which files would be modified]

ESCALATION_REASON: [Why user input is needed, if not auto-fixable]
```

---

## Example Classifications

### Example 1: Missing Import (Category A, Auto-fix)
```
Error: Module not found: Can't resolve '@/components/PlayerControls'
File: app/game/page.tsx:5

CATEGORY: A
CATEGORY_NAME: Code Error
AUTO_FIXABLE: true
CONFIDENCE: high

ERROR_SUMMARY: Import references non-existent path '@/components/PlayerControls'
ROOT_CAUSE: File PlayerControls.tsx exists at components/player/PlayerControls.tsx
SOURCE_FILE: app/game/page.tsx
SOURCE_LINE: 5

FIX_DESCRIPTION: Update import from '@/components/PlayerControls' to '@/components/player/PlayerControls'
FIX_RISK: low
FIX_SCOPE: app/game/page.tsx
```

### Example 2: Missing Env Var (Category D, Ask User)
```
Error: Error: Missing required environment variable: DATABASE_URL
File: lib/prisma.ts:3

CATEGORY: D
CATEGORY_NAME: Environment Variable
AUTO_FIXABLE: false
CONFIDENCE: high

ERROR_SUMMARY: DATABASE_URL environment variable is not set
ROOT_CAUSE: Prisma client requires DATABASE_URL to connect to the database
SOURCE_FILE: lib/prisma.ts
SOURCE_LINE: 3

ESCALATION_REASON: Cannot guess or generate database connection strings. User must provide the value.
```

### Example 3: Peer Dependency Conflict (Category C, Ask User)
```
Error: ERESOLVE unable to resolve dependency tree
  react-player@3.0.0 requires react@^17.0
  project requires react@^18.0

CATEGORY: C
CATEGORY_NAME: Dependency Error
AUTO_FIXABLE: false
CONFIDENCE: high

ERROR_SUMMARY: react-player@3.0.0 is incompatible with react@18
ROOT_CAUSE: Peer dependency version conflict between react-player and project's React version

ESCALATION_REASON: Multiple valid resolutions exist:
  1. Upgrade react-player to v4 (supports React 18)
  2. Use --legacy-peer-deps
  3. Downgrade React
  User must choose based on their requirements.
```

### Example 4: External API Timeout (Category E, Report)
```
Error: FetchError: request to https://api.contentful.com/spaces/xxx failed
  reason: connect ETIMEDOUT

CATEGORY: E
CATEGORY_NAME: External Service
AUTO_FIXABLE: false
CONFIDENCE: high

ERROR_SUMMARY: Contentful API is unreachable during build
ROOT_CAUSE: External API (api.contentful.com) timed out during the build phase

ESCALATION_REASON: External service issue — not a code problem. Recommend waiting and retrying.
```
