# Validation Workflow

Pre-deployment validation covering dependency analysis and build verification.

---

## Phase 3 — Dependency Analysis

### Step 3.1: Read Dependency Configuration

Read `package.json` to extract:
- `dependencies`
- `devDependencies`
- `peerDependencies`
- `engines` (Node.js version requirements)
- `packageManager` (if specified)

### Step 3.2: Check Lockfile Consistency

Verify the lockfile matches the package manager:

| Package Manager | Expected Lockfile | Issue if Missing |
|----------------|-------------------|-----------------|
| pnpm | `pnpm-lock.yaml` | Run `pnpm install` to regenerate |
| npm | `package-lock.json` | Run `npm install` to regenerate |
| yarn | `yarn.lock` | Run `yarn install` to regenerate |
| bun | `bun.lock` / `bun.lockb` | Run `bun install` to regenerate |

If the lockfile is missing or appears stale:
- **Auto-fix**: Run the appropriate install command to regenerate
- Include the regenerated lockfile in the commit

### Step 3.3: Detect Dependency Changes

Compare local `package.json` against the GitHub version to detect:

| Change Type | Detection |
|-------------|-----------|
| Added dependency | In local but not in GitHub `package.json` |
| Removed dependency | In GitHub but not in local `package.json` |
| Version changed | Same package, different version string |
| Lockfile changed | Lockfile content differs |

### Step 3.4: Check for Peer Dependency Conflicts

Look for patterns that indicate peer conflicts:
- Package A requires `react@^17` but `react@18` is installed
- Multiple packages require incompatible versions of the same dependency

### Step 3.5: Auto-Fixable Dependency Issues

The following can be fixed automatically **without asking the user**:

| Issue | Fix |
|-------|-----|
| Missing lockfile | Run install command to regenerate |
| Missing `@types/*` package | Add the corresponding type package |
| Import references renamed package | Update import path |
| Obvious missing package (imported but not in `package.json`) | Add to dependencies |
| Lockfile out of sync with `package.json` | Regenerate lockfile |

### Step 3.6: User-Decision-Required Issues

The following **must be escalated** to the user:

| Issue | Why |
|-------|-----|
| Major version upgrade of a framework | Breaking API changes |
| Peer dependency conflict with multiple valid resolutions | Multiple correct answers |
| Deprecated package with multiple alternatives | User preference needed |
| Node.js engine version mismatch | Infrastructure decision |
| Removing a dependency used in production code | Risk of breaking changes |

**User interaction format**:

```
⚠️ Deployment blocked by dependency issue.

Package: react-player
  Current version: 4.2.1
  Required by component-a: ^3.x
  Required by component-b: ^4.x

Recommended options:
  1. (Recommended) Upgrade component-a to v5 which supports react-player 4.x
     Risk: Low — component-a v5 is a minor API change
  2. Downgrade react-player to 3.x
     Risk: Medium — may lose features used in current code
  3. Add dependency resolution override in package.json
     Risk: High — forces version, may cause runtime errors

Choose an option:
```

Use the `ask_question` tool to present options.

---

## Phase 4 — Build Validation

### Step 4.1: Discover Available Scripts

Read `package.json` → `scripts` to determine which validation steps are available:

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "lint": "next lint",
    "typecheck": "tsc --noEmit",
    "test": "jest"
  }
}
```

### Step 4.2: Run Validations in Order

Execute available scripts in this order. **Skip any step that doesn't have a matching script**.

| Order | Script Names to Check | Purpose | Required? |
|-------|----------------------|---------|-----------|
| 1 | `install` (use package manager command) | Install dependencies | Yes — always run |
| 2 | `typecheck`, `type-check`, `tsc` | TypeScript compilation | No — skip if not available |
| 3 | `lint`, `eslint` | Code quality | No — skip if not available |
| 4 | `test`, `test:unit` | Unit tests | No — skip if not available |
| 5 | `build` | **Production build** | **Yes — mandatory** |

### Step 4.3: Execute Each Step

Use `run_command` to execute each validation:

```bash
# Example for pnpm + Next.js
pnpm install
pnpm typecheck    # if available
pnpm lint         # if available
pnpm test         # if available
pnpm build        # MANDATORY
```

### Step 4.4: Handle Validation Failures

On any validation failure:

1. **Capture the error output** — read the full error message
2. **Classify the error** — reference [errors.md](../rules/errors.md)
3. **Determine if auto-fixable**:
   - TypeScript error with clear fix → auto-fix
   - Lint error with `--fix` available → run auto-fix
   - Build error with obvious cause → auto-fix
   - Ambiguous or multiple possible fixes → ask user
4. **Apply fix** if auto-fixable
5. **Re-run the failed validation** to confirm the fix works
6. **If fix fails**: escalate to user

### Step 4.5: Validation Success

After all validations pass:

```
Pre-deployment validation:
✓ Dependencies installed
✓ TypeScript: no errors
✓ Lint: passed
✓ Tests: 42 passed, 0 failed
✓ Build: successful

Proceeding to commit...
```

### Step 4.6: Build Failure — Critical Path

If `build` fails, this is a **blocker**. Do NOT proceed to commit.

1. Read the complete build error output
2. Attempt to classify and auto-fix (max 3 attempts)
3. If auto-fix works, re-run build to confirm
4. If auto-fix fails after 3 attempts, stop and present the error:

```
❌ Build failed after 3 automatic fix attempts.

Error:
  Type error: Property 'name' does not exist on type 'Player'.
  File: components/Player.tsx:42

I was unable to automatically resolve this error.
Please fix the issue manually and try /deploy again.
```
