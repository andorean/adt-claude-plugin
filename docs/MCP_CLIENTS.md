# Using `adt mcp` in MCP Clients

> **Not available yet.** The `adt` builds published today do not include the `mcp` subcommand, and the `adt-mcp` plugin is not listed in the marketplace. Use the `adt-cli` plugin (see the [README](../README.md)) until a release with `adt mcp` ships. You can check your build with `adt mcp --help`.

The `adt` binary can run as a local stdio Model Context Protocol (MCP) server (`adt mcp`), allowing MCP-compatible clients to call ADT-Control tools natively using your existing `adt login` session.

> **Prerequisite:** Requires an `adt` build that includes the `mcp` subcommand (`adt mcp --help`). Install `adt` and run `adt login` first (see [CLI_SETUP.md](./CLI_SETUP.md)).

## Modes

- **Default (`adt mcp` / `--mode meta`):** Exposes 4 compact tools (`adt_whoami`, `adt_tools_list`, `adt_tools_describe`, `adt_call`) to keep prompt token usage low even when many tools are enabled.
- **Direct (`adt mcp --mode direct [--app <app_id>]`):** Exposes each permitted ADT-Control tool directly as an MCP tool with its full JSON Schema.

Because `adt mcp` re-reads `~/.config/adt/config.json` and `~/.config/adt/token` on every request, running `adt login` in a terminal refreshes credentials immediately without restarting your MCP client.

---

## Claude Code

**Recommended (via marketplace plugin):**

```text
/plugin marketplace add andorean/adt-claude-plugin
/plugin install adt-mcp@andorean-adt
```

**Manual CLI registration (without the plugin):**

```sh
claude mcp add adt -- adt mcp
# Or direct mode filtered to one app:
claude mcp add adt -- adt mcp --mode direct --app <app_id>
```

---

## Claude Desktop

GUI applications on macOS often do not inherit `~/.local/bin` in `PATH`. Use the full path returned by `which adt` (for example `/Users/<you>/.local/bin/adt` or `/usr/local/bin/adt`).

Edit your Claude Desktop config file:
- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Linux:** `~/.config/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "adt": {
      "command": "/usr/local/bin/adt",
      "args": ["mcp"]
    }
  }
}
```

Restart Claude Desktop after saving the file.

---

## Cursor

Add to `.cursor/mcp.json` (project) or `~/.cursor/mcp.json` (global):

```json
{
  "mcpServers": {
    "adt": {
      "command": "adt",
      "args": ["mcp"]
    }
  }
}
```

---

## Windsurf

Add to `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "adt": {
      "command": "adt",
      "args": ["mcp"]
    }
  }
}
```

---

## Security Notes

- Never put a token inside `.mcp.json`, `claude_desktop_config.json`, or any version-controlled file.
- `adt mcp` reads `~/.config/adt/token` (`0600`) at runtime and never logs tokens to stdout or stderr.
- If a tool call reports `TOKEN_EXPIRED` or `TOKEN_MISSING`, run `adt login` in your terminal and retry.
