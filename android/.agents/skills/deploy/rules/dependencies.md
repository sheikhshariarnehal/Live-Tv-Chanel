# Dependency Analysis Rules

Rules for detecting, analyzing, and resolving dependency issues during deployment.

---

## Package Manager Detection

### Detection Logic

Check for lockfiles in the project root, in this priority order:

| Priority | Lockfile | Package Manager | Install Command |
|----------|----------|----------------|-----------------|
| 1 | `pnpm-lock.yaml` | pnpm | `pnpm install` |
| 2 | `bun.lock` or `bun.lockb` | bun | `bun install` |
| 3 | `yarn.lock` | yarn | `yarn install` |
| 4 | `package-lock.json` | npm | `npm install` |
| 5 | None found | npm (default) | `npm install` |

Also check `package.json` → `packageManager` field:
```json
{ "packageManager": "pnpm@9.1.0" }
```

If `packageManager` field conflicts with detected lockfile, warn:
```
⚠️ package.json specifies pnpm but yarn.lock was found.
Using pnpm as specified in package.json.
```

---

## Dependency Change Detection

Compare local `package.json` against the GitHub version.

### Change Categories

| Category | Detection | Risk |
|----------|-----------|------|
| New dependency added | In local, not in GitHub | Low |
| Dependency removed | In GitHub, not in local | Medium |
| Version bump (patch) | `1.0.0` → `1.0.1` | Low |
| Version bump (minor) | `1.0.0` → `1.1.0` | Low |
| Version bump (major) | `1.0.0` → `2.0.0` | High |
| Range change | `^1.0.0` → `~1.0.0` | Low |
| Lockfile changed | Different lockfile content | Low |
| Lockfile missing | No lockfile present | Medium |

---

## Auto-Fixable Issues

These issues can be fixed automatically **without asking the user**:

### 1. Missing Lockfile

**Detection**: No lockfile found but `package.json` exists.
**Fix**: Run `<package-manager> install` to generate the lockfile.
**Risk**: Low — normal workflow step.

### 2. Lockfile Out of Sync

**Detection**: `package.json` has been modified but lockfile hasn't been updated.
**Fix**: Run `<package-manager> install` to update the lockfile.
**Risk**: Low — expected after dependency changes.

### 3. Missing Type Package

**Detection**: A package like `express` is installed but `@types/express` is missing, and TypeScript errors reference missing types.
**Fix**: Add the `@types/` package to `devDependencies`.
**Risk**: Low — no runtime impact.

### 4. Missing Package Referenced in Code

**Detection**: An import statement references a package not in `package.json`.
**Validation**: The package exists on npm and is clearly the intended package.
**Fix**: Add to `dependencies` and install.
**Risk**: Low — the code already depends on it.

### 5. Import Path Changed Due to Package Rename

**Detection**: Build error references an old import path, and the package has an updated export path.
**Fix**: Update the import path in the source file.
**Risk**: Low — following the package's documented migration.

---

## User-Decision-Required Issues

These issues **must be escalated** to the user:

### 1. Major Version Upgrade

**Why**: Major versions may have breaking API changes.
**Presentation**:
```
Package: next
  Current: 14.2.0
  Available: 15.0.0

This is a major version upgrade with potential breaking changes.

Options:
1. (Recommended) Upgrade to v15 — follow migration guide
   Risk: Medium
2. Stay on v14
   Risk: None — no change
3. Show v15 changelog

Choose an option:
```

### 2. Peer Dependency Conflict

**Why**: Multiple valid resolution paths exist.
**Presentation**:
```
Peer dependency conflict:

  react-component-x@2.0 requires react@^17.0
  Your project uses react@18.3.1

Options:
1. (Recommended) Install react-component-x@3.0 (supports React 18)
   Risk: Low — v3 is a compatibility release
2. Use --legacy-peer-deps to ignore the conflict
   Risk: Medium — may cause runtime issues
3. Downgrade react to v17
   Risk: High — significant regression

Choose an option:
```

### 3. Deprecated Package

**Why**: User needs to choose a replacement.
**Presentation**:
```
Deprecated package detected: request

This package has been deprecated. Alternatives:
1. (Recommended) Replace with node-fetch — lightweight, similar API
2. Replace with axios — popular, feature-rich
3. Replace with undici — Node.js native, high performance
4. Keep using request (not recommended)

Choose an option:
```

### 4. Node.js Version Mismatch

**Why**: Infrastructure decision that affects the build environment.
**Presentation**:
```
Node.js version conflict:

  package.json engines: { "node": ">=20" }
  Vercel default: Node.js 18.x

Options:
1. (Recommended) Set Vercel to use Node.js 20.x
2. Update package.json to support Node.js 18.x
3. Keep current settings (may cause build failure)

Choose an option:
```

### 5. Removing a Used Dependency

**Why**: May break existing functionality.
**Presentation**:
```
Dependency removed: lodash

This package is imported in 3 files:
  - utils/helpers.ts (line 1)
  - lib/transform.ts (line 3)
  - components/DataTable.tsx (line 7)

Removing it will cause build failures.

Options:
1. Keep lodash in dependencies
2. Remove lodash and replace with native JavaScript
3. Show all usage locations

Choose an option:
```

---

## Risk Assessment Framework

Use this framework when presenting options to users:

| Risk Level | Criteria | Color |
|------------|----------|-------|
| **Low** | No behavior change, no API changes, widely tested | 🟢 |
| **Medium** | Minor API changes, some code updates needed, well-documented | 🟡 |
| **High** | Major API changes, significant refactoring needed, potential data loss | 🔴 |

---

## Framework Compatibility Matrix

When checking framework dependencies, validate compatibility:

### Next.js
| Next.js | React | Node.js |
|---------|-------|---------|
| 15.x | 18.x or 19.x | ≥ 18.18.0 |
| 14.x | 18.x | ≥ 18.17.0 |
| 13.x | 18.x | ≥ 16.14.0 |

### Vite
| Vite | Node.js |
|------|---------|
| 6.x | ≥ 18.0.0 |
| 5.x | ≥ 18.0.0 |
| 4.x | ≥ 14.18.0 |

### Astro
| Astro | Node.js |
|-------|---------|
| 5.x | ≥ 18.17.1 |
| 4.x | ≥ 18.14.1 |

If a framework/runtime version combination is known to be incompatible, flag it immediately:
```
⚠️ Incompatible versions detected:
  Next.js 15 requires React 18.x or 19.x
  Your project has React 17.0.2

This will cause build failures. Upgrade React before deploying.
```
