---
description: Sign in to ADT-Control so the `adt-mcp` server can authenticate requests
argument-hint: "[--api-url <url>] [--org <org_id>] [--site <site_id>] [--flow auto|browser|device|token|none]"
---

Sign in to ADT-Control for `adt-mcp` using `adt login`.

1. Verify `adt` is installed (`command -v adt`). If missing, ask the user to run `/adt-mcp:install` first.
2. Check if the user provided flags in `$ARGUMENTS` (`--api-url`, `--org`, `--site`, `--flow`, `--keycloak-token-file`).
   - If neither `--api-url`, `ADT_API_URL`, nor `~/.config/adt/config.json` provides a backend URL, ask the user for their ADT-Control URL (for example `https://adt.example.com`).
3. Run `adt login` with the provided arguments (use `--flow device` in headless SSH sessions).
4. Verify the session by calling `adt_whoami` (or running `adt whoami`). No Claude restart is needed — `adt mcp` picks up the refreshed token automatically.
5. **Never** read, display, or log `~/.config/adt/token`.
