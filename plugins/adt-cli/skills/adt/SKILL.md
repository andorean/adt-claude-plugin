---
name: adt
description: Use the `adt` CLI to check session identity, discover ADT-Control tools, inspect tool schemas, and invoke ADT-Control tools on behalf of the signed-in user. Invoke whenever the user asks to query, inspect, or act on ADT-Control operational data, fleet, maintenance, alerts, analytics, or organization tools.
---

# ADT-Control CLI (`adt`)

Use the `adt` binary to discover and run ADT-Control tools as the currently signed-in user. All authorization, organization scoping, and site scoping are enforced by the ADT-Control backend.

## Standard Workflow

1. **Check session & site context first** (do not guess `org_id` or `site_id`):
   ```sh
   adt whoami
   # Or JSON output to see all configured site_ids for the active organization:
   adt -o json whoami
   ```
2. **Discover tools on demand:**
   ```sh
   adt tools list
   adt tools list --search <keyword>
   adt tools list --app <app_id>
   ```
3. **Inspect exact arguments before calling an unfamiliar tool:**
   ```sh
   adt tools describe <tool_name>
   ```
4. **Run the tool:**
   ```sh
   adt call <tool_name> --arg value
   # Use --json for arrays, objects, booleans, or exact numeric types:
   adt call <tool_name> --json '{"site_id": "<site_id>", "limit": 20}'
   ```

Global options (`-o text|json`, `--timeout <seconds>`) always go **before** the subcommand (for example `adt -o json tools list`).

## Error & Exit Code Handling

| Exit code | Meaning | What to do |
| :--- | :--- | :--- |
| `0` | Success | Present the result clearly. |
| `1` | Tool or backend error (`CLI_DISABLED`, `TOOL_NOT_FOUND`, `INVALID_PARAMETERS`, `SITE_MISMATCH`) | Inspect stderr. Run `adt tools describe <tool_name>` or `adt -o json whoami` to fix parameters or `site_id`. If `CLI_DISABLED`, inform the user. |
| `2` | Usage error or missing backend URL/config | Check flags or ask the user to run `/adt-cli:login` with `--api-url <url>`. |
| `3` | Token missing, invalid, or expired | Ask the user to run `/adt-cli:login` (or `adt login` in their terminal), then retry once signed in. |
| `4` | Refused (`PERMISSION_DENIED`, `ORG_MISMATCH`, `APPLICATION_DISABLED`) | Explain the refusal to the user. Do **not** retry or try to bypass permissions. |
| `5` | Backend unreachable or timeout | Inform the user to check network connectivity and the configured `api_url`. |

## Security & Safety Rules

- **Never read, print, copy, or inspect** `~/.config/adt/token`, `ADT_CLI_TOKEN_FILE`, or `ADT_CLI_TOKEN`.
- Prefer running read-only lookups directly; confirm with the user before invoking mutating or write tools when intent is ambiguous.
- Never attempt to access another organization's data or override `org_id` with a different organization than the one shown by `adt whoami`.
