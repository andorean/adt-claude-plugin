---
description: Sign in to ADT-Control and save a short-lived local CLI token
argument-hint: "[--api-url <url>] [--org <org_id>] [--site <site_id>] [--flow auto|browser|device|token|none]"
---

Sign in to ADT-Control using `adt login`.

1. Verify `adt` is installed (`command -v adt`, then `~/.local/bin/adt`). If missing, ask the user to run `/adt-cli:install` first.
2. Pass through any flags the user gave in `$ARGUMENTS` (`--api-url`, `--org`, `--site`, `--flow`, `--keycloak-token-file`).
   - If none of `--api-url`, `ADT_API_URL`, or `api_url` in `~/.config/adt/config.json` gives a backend URL, use `--api-url https://adt.andorean.com` and tell the user which URL you used.
   - `--org` and `--site` are optional; without them the user's active organization is used.
3. Run `adt login` with those arguments. The default flow opens the browser for SSO and waits for the sign-in to finish, so run it in the background (or with a long timeout) and tell the user to complete the sign-in in the browser tab that opens. Suggest `--flow device` only in headless or SSH sessions.
4. If login fails, explain the likely cause:
   - `browser login timed out waiting for callback`: the user did not finish signing in, or the sign-in page showed `Invalid parameter: redirect_uri`. The second case is a server setting: the ADT-Control administrator must add `http://127.0.0.1/*` to the Keycloak client's valid redirect URIs.
   - `unauthorized_client` with `--flow device`: device login is not enabled on the server. Use the browser flow instead.
5. After login succeeds, run `adt whoami` to confirm the signed-in user, organization, active site, and token expiry.
6. **Never** read, display, or log `~/.config/adt/token`.
