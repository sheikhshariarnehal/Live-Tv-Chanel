# Conventional Commit Generator Prompt & Rules

Guidelines for generating precise, semantic Conventional Commit messages.

---

## 1. Commit Message Structure

Follow standard Conventional Commits 1.0.0 syntax:

```
<type>[optional scope]: <description>

[optional body]
```

---

## 2. Commit Types

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature added to application | `feat: add push skill workflow` |
| `fix` | Bug fix or issue resolution | `fix: resolve null check in auth header` |
| `chore` | Maintenance, dependencies, tooling update | `chore: update dependencies` |
| `docs` | Documentation update only | `docs: update deployment instructions` |
| `style` | Formatting, white-space, missing semi-colons | `style: format button component CSS` |
| `refactor` | Code change that neither fixes a bug nor adds a feature | `refactor: simplify user state handler` |
| `perf` | Code change that improves performance | `perf: memoize expensive computation` |
| `test` | Adding or updating tests | `test: add unit tests for validator` |

---

## 3. Formatting Rules

1. **Imperative Present Tense**: Use "add", "fix", "change", not "added", "fixing", "changed".
2. **Lowercase Title**: Do not capitalize the first letter after the colon.
3. **No Trailing Period**: Do not end the title line with a dot `.`.
4. **Max Length**: Keep title under 72 characters.
5. **No Generic Messages**: Avoid `update`, `fixed`, `changes`, `commit`, `work in progress`, `test`.

---

## 4. Examples

### Good Commit Messages
- `feat(push): add github push skill and workflows`
- `fix(auth): handle expired refresh token gracefully`
- `chore(deps): upgrade next to v14.2.0`
- `refactor(ui): extract navbar into separate component`

### Bad Commit Messages (Avoid)
- `updated files`
- `fix bug`
- `commit changes`
- `WIP`
