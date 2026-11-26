---
name: adt-mcp
description: Use the connected `adt` MCP tools (`adt_whoami`, `adt_tools_list`, `adt_tools_describe`, `adt_call`, or direct ADT MCP tools) to query and operate on ADT-Control data as the signed-in user. Invoke whenever the user asks about ADT-Control operational data, fleet, maintenance, alerts, analytics, or organization tools.
---

# ADT-Control MCP (`adt-mcp`)

This plugin connects Claude to ADT-Control through the local `adt mcp` server. All authentication, organization scoping, site scoping, and role permissions are enforced by the ADT-Control backend.

> **Prerequisite:** `adt-mcp` requires a version of the `adt` binary that includes the `mcp` subcommand (`adt mcp --help`). If your `adt` build does not include `mcp` yet, use the `adt-cli` plugin instead.

## Standard Workflow

1. **Check session & available sites first** (never guess `org_id` or `site_id`):
   - Call `adt_whoami` to see `user_id`, `org_id`, active `site_id`, available `site_ids`, `roles`, and token expiry.
2. **Discover available tools:**
   - Call `adt_tools_list` with optional `search` or `app` filters.
3. **Inspect tool arguments before calling:**
   - Call `adt_tools_describe` with `tool` to verify required parameters and types.
4. **Execute a tool:**
   - Call `adt_call` with `tool` and a typed `arguments` object (or invoke the tool directly if running `adt mcp --mode direct`).

## Handling Auth & Errors

- **`TOKEN_MISSING` / `TOKEN_INVALID` / `TOKEN_EXPIRED`:** Ask the user to run `/adt-mcp:login` (or `adt login` in their terminal). Because `adt mcp` re-reads the local token file on each request, **no Claude restart is required** — simply retry once the user finishes signing in.
- **`PERMISSION_DENIED` / `ORG_MISMATCH` / `APPLICATION_DISABLED`:** Explain the backend refusal to the user and do not retry.
- **`SITE_MISMATCH` / `INVALID_PARAMETERS`:** Call `adt_whoami` or `adt_tools_describe` to check valid `site_ids` and parameter types.
- **`CLI_DISABLED`:** Inform the user that the ADT CLI/MCP integration is switched off on the backend.

## Security & Safety Rules

- **Never read, print, or copy** `~/.config/adt/token`, `ADT_CLI_TOKEN_FILE`, or `ADT_CLI_TOKEN`.
- Prefer running read-only lookups directly; confirm with the user before mutating or write actions when intent is ambiguous.
