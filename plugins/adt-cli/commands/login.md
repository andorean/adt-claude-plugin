---
description: Sign in to ADT-Control and save a short-lived local CLI token
argument-hint: "[--api-url <url>] [--org <org_id>] [--site <site_id>] [--flow auto|browser|device|token|none]"
---

Sign in to ADT-Control using `adt login`.

1. Verify `adt` is installed (`command -v adt`). If missing, ask the user to run `/adt-cli:install` first.
2. Check if the user provided flags in `$ARGUMENTS` (such as `--api-url`, `--org`, `--site`, `--flow`, `--keycloak-token-file`).
   - If neither `--api-url`, `ADT_API_URL`, nor `~/.config/adt/config.json` provides a backend URL, ask the user for their ADT-Control URL (for example `https://adt.example.com`).
3. Run `adt login` with the provided arguments (defaulting to `--flow auto`, which opens the browser SSO login on workstations; suggest `--flow device` if the user is in a headless SSH session).
4. After login succeeds, run `adt whoami` to confirm the signed-in user, organization, active site, roles, and token expiry.
5. **Never** read, display, or log `~/.config/adt/token`.
