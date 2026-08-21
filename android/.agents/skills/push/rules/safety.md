# Security & Safety Rules

Mandatory security guardrails for commit and push operations.

---

## 1. Secret & Credentials Scanning

Before committing or pushing any file, audit file content for potential secrets.

### Blacklisted Patterns & Keywords

| Category | Regex / Patterns |
|----------|------------------|
| **API Keys** | `sk-[a-zA-Z0-9]{20,}`, `pk_live_`, `api_key`, `apiKey`, `secret_key` |
| **Tokens** | `ghp_`, `gho_`, `github_pat_`, `vercel_`, `bearer `, `access_token` |
| **Connection Strings** | `postgres://`, `mongodb://`, `mysql://`, `redis://`, `amqp://` |
| **AWS / Cloud Keys** | `AKIA[0-9A-Z]{16}`, `aws_secret_access_key` |
| **Private Keys** | `-----BEGIN RSA PRIVATE KEY-----`, `-----BEGIN PRIVATE KEY-----` |

### Action on Detection

If any match is detected:
1. **HALT Execution Immediately**.
2. Alert the user with the filename and matching line number (masking the secret value).
3. Do **NOT** stage, commit, or push the file.
4. Instruct user to use environment variables (`.env`) and list `.env` in `.gitignore`.

---

## 2. Blocked File Types & Paths

Never commit or push the following files:

- `.env`, `.env.local`, `.env.development.local`, `.env.production.local`
- `node_modules/`
- `.next/`, `dist/`, `build/`, `out/`, `target/`
- `.DS_Store`, `Thumbs.db`, `desktop.ini`
- `.vercel/`, `.idea/`, `.vscode/` (unless explicitly requested)
- Log files (`*.log`, `npm-debug.log*`, `yarn-error.log*`)

---

## 3. Destructive Command Restrictions

- **`git push --force` / `-f`**: **STRICTLY FORBIDDEN**.
- **`git reset --hard`**: **STRICTLY FORBIDDEN** without explicit user confirmation.
- **`git clean -fd`**: **STRICTLY FORBIDDEN** without user review.
