# Pre-Push Code Validation

Guidelines and procedures for verifying code quality and build safety before committing and pushing to GitHub.

---

## 1. Validation Discovery

Read `package.json` to discover available scripts in `scripts` object:

| Script Name | Purpose | Command |
|-------------|---------|---------|
| `typecheck` / `tsc` | TypeScript type validation | `npm run typecheck` |
| `lint` | Code formatting & static analysis | `npm run lint` |
| `test` | Automated test suite | `npm test` |
| `build` | Production bundle validation | `npm run build` |

---

## 2. Execution Order

Execute available validations in order:

1. **Type Checking** (if TypeScript project)
   - Command: `npx tsc --noEmit` or `npm run typecheck`
   - Purpose: Ensure zero TypeScript type errors.

2. **Linting**
   - Command: `npm run lint`
   - Purpose: Catch syntax, styling, and rule violations.

3. **Build Check** (*Optional / Recommended for core changes*)
   - Command: `npx tsc --noEmit` or `npm run build`
   - Purpose: Validate project builds without compilation errors.

---

## 3. Handling Failure

If any validation step fails:

1. Capture full error output.
2. Display clear failure message to the user:
   ```
   ❌ Pre-Push Validation Failed during 'typecheck'
   
   Error details:
   src/components/Header.tsx:14:5 - error TS2322: Type 'string' is not assignable to type 'number'.
   
   Options:
   1. Fix the error automatically
   2. Ignore and push anyway (not recommended)
   3. Cancel push
   ```
3. Do **NOT** commit broken code without explicit user instruction.
